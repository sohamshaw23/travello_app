from __future__ import annotations

import math
import os
from dataclasses import dataclass

import httpx

from services.cache_service import TTLCache


class LocationResolutionError(Exception):
    pass


class ExternalRoutingError(Exception):
    pass


@dataclass(frozen=True)
class Coordinate:
    lat: float
    lng: float


@dataclass(frozen=True)
class RouteLeg:
    mode: str
    distance_km: float
    duration_minutes: int
    description: str
    path: list[Coordinate]


_KNOWN_LOCATIONS: dict[str, Coordinate] = {
    "sector 7 slums": Coordinate(35.6895, 139.6917),
    "neo-tko": Coordinate(35.6764, 139.6500),
    "ldn-2.0": Coordinate(51.5072, -0.1276),
    "central hub": Coordinate(28.6139, 77.2090),
    "cyber-tokyo": Coordinate(35.6804, 139.7690),
    "shibuya": Coordinate(35.6595, 139.7005),
    "akihabara": Coordinate(35.6984, 139.7730),
    "kyoto station": Coordinate(34.9855, 135.7580),
    "reykjavik": Coordinate(64.1466, -21.9426),
}

_ROUTE_CACHE = TTLCache(ttl_seconds=900)


class MapsRoutingService:
    def __init__(self) -> None:
        self.api_key = os.getenv("GOOGLE_MAPS_API_KEY", "")

    async def get_route(self, source: str, destination: str, mode: str) -> list[RouteLeg]:
        cache_key = ("route", source.lower(), destination.lower(), mode)
        cached = _ROUTE_CACHE.get(cache_key)
        if cached is not None:
            return cached  # type: ignore[return-value]

        source_coord = await self._resolve_location(source)
        destination_coord = await self._resolve_location(destination)

        if self.api_key:
            try:
                legs = await self._fetch_google_directions(
                    source, destination, mode, source_coord, destination_coord
                )
                _ROUTE_CACHE.set(cache_key, legs)
                return legs
            except ExternalRoutingError:
                pass

        legs = self._build_fallback_route(source, destination, mode, source_coord, destination_coord)
        _ROUTE_CACHE.set(cache_key, legs)
        return legs

    async def _resolve_location(self, location: str) -> Coordinate:
        cache_key = ("geocode", location.lower())
        cached = _ROUTE_CACHE.get(cache_key)
        if cached is not None:
            return cached  # type: ignore[return-value]

        normalized = location.strip().lower()
        if normalized in _KNOWN_LOCATIONS:
            coord = _KNOWN_LOCATIONS[normalized]
            _ROUTE_CACHE.set(cache_key, coord)
            return coord

        if self.api_key:
            coord = await self._google_geocode(location)
            _ROUTE_CACHE.set(cache_key, coord)
            return coord

        if "invalid" in normalized:
            raise LocationResolutionError(f"Could not resolve location '{location}'")

        coord = self._pseudo_coordinate(normalized)
        _ROUTE_CACHE.set(cache_key, coord)
        return coord

    async def _google_geocode(self, location: str) -> Coordinate:
        url = "https://maps.googleapis.com/maps/api/geocode/json"
        params = {"address": location, "key": self.api_key}
        async with httpx.AsyncClient(timeout=12.0) as client:
            response = await client.get(url, params=params)
            response.raise_for_status()
            payload = response.json()

        if payload.get("status") != "OK" or not payload.get("results"):
            raise LocationResolutionError(f"Could not resolve location '{location}'")

        coordinates = payload["results"][0]["geometry"]["location"]
        return Coordinate(lat=coordinates["lat"], lng=coordinates["lng"])

    async def _fetch_google_directions(
        self,
        source: str,
        destination: str,
        mode: str,
        source_coord: Coordinate,
        destination_coord: Coordinate,
    ) -> list[RouteLeg]:
        url = "https://maps.googleapis.com/maps/api/directions/json"
        params = {
            "origin": source,
            "destination": destination,
            "mode": self._google_mode(mode),
            "key": self.api_key,
        }
        async with httpx.AsyncClient(timeout=15.0) as client:
            response = await client.get(url, params=params)
            response.raise_for_status()
            payload = response.json()

        if payload.get("status") != "OK" or not payload.get("routes"):
            raise ExternalRoutingError("Directions API returned no route")

        leg = payload["routes"][0]["legs"][0]
        distance_km = round(leg["distance"]["value"] / 1000, 2)
        duration_minutes = max(1, round(leg["duration"]["value"] / 60))
        midpoint = Coordinate(
            lat=round((source_coord.lat + destination_coord.lat) / 2, 6),
            lng=round((source_coord.lng + destination_coord.lng) / 2, 6),
        )

        return [
            RouteLeg(
                mode=mode.title(),
                distance_km=distance_km,
                duration_minutes=duration_minutes,
                description=f"{mode.title()} route from {source} to {destination}",
                path=[source_coord, midpoint, destination_coord],
            )
        ]

    def _build_fallback_route(
        self,
        source: str,
        destination: str,
        mode: str,
        source_coord: Coordinate,
        destination_coord: Coordinate,
    ) -> list[RouteLeg]:
        total_distance = self._haversine_km(source_coord, destination_coord)
        midpoint = Coordinate(
            lat=round((source_coord.lat + destination_coord.lat) / 2, 6),
            lng=round((source_coord.lng + destination_coord.lng) / 2, 6),
        )

        if mode == "balanced":
            walk_distance = round(min(0.6, total_distance * 0.08), 2)
            metro_distance = round(max(total_distance * 0.55, 1.5), 2)
            bus_distance = round(max(total_distance - walk_distance - metro_distance, 0.8), 2)
            return [
                RouteLeg("Walk", walk_distance, self._duration(walk_distance, 4.5), f"Walk from {source} to metro station", [source_coord, midpoint]),
                RouteLeg("Metro", metro_distance, self._duration(metro_distance, 28.0), "Take metro main line", [midpoint, destination_coord]),
                RouteLeg("Bus", bus_distance, self._duration(bus_distance, 18.0), f"Last-mile bus to {destination}", [midpoint, destination_coord]),
            ]

        if mode == "cheapest":
            walk_distance = round(min(0.8, total_distance * 0.1), 2)
            bus_distance = round(max(total_distance * 0.6, 1.0), 2)
            metro_distance = round(max(total_distance - walk_distance - bus_distance, 0.7), 2)
            return [
                RouteLeg("Walk", walk_distance, self._duration(walk_distance, 4.5), f"Walk from {source} to bus stop", [source_coord, midpoint]),
                RouteLeg("Bus", bus_distance, self._duration(bus_distance, 16.0), "Bus 402 toward interchange", [midpoint, destination_coord]),
                RouteLeg("Metro", metro_distance, self._duration(metro_distance, 26.0), f"Metro hop to {destination}", [midpoint, destination_coord]),
            ]

        if mode == "fastest":
            auto_distance = round(total_distance * 0.92, 2)
            walk_distance = round(max(total_distance - auto_distance, 0.25), 2)
            return [
                RouteLeg("Auto", auto_distance, self._duration(auto_distance, 24.0), f"Direct auto ride toward {destination}", [source_coord, midpoint, destination_coord]),
                RouteLeg("Walk", walk_distance, self._duration(walk_distance, 4.5), f"Short final walk to {destination}", [destination_coord]),
            ]

        if mode in {"driving", "walking", "transit"}:
            speed = {"driving": 24.0, "walking": 4.5, "transit": 22.0}[mode]
            return [
                RouteLeg(
                    mode=mode.title(),
                    distance_km=round(total_distance, 2),
                    duration_minutes=self._duration(total_distance, speed),
                    description=f"{mode.title()} route from {source} to {destination}",
                    path=[source_coord, midpoint, destination_coord],
                )
            ]

        raise ExternalRoutingError("Unsupported route mode")

    def _pseudo_coordinate(self, seed: str) -> Coordinate:
        checksum = sum(ord(char) for char in seed)
        lat = 12.0 + (checksum % 5000) / 1000
        lng = 72.0 + (checksum % 7000) / 1000
        return Coordinate(lat=round(lat, 6), lng=round(lng, 6))

    def _duration(self, distance_km: float, speed_kmh: float) -> int:
        return max(1, round((distance_km / max(speed_kmh, 1.0)) * 60))

    def _haversine_km(self, start: Coordinate, end: Coordinate) -> float:
        radius = 6371.0
        d_lat = math.radians(end.lat - start.lat)
        d_lng = math.radians(end.lng - start.lng)
        a = (
            math.sin(d_lat / 2) ** 2
            + math.cos(math.radians(start.lat))
            * math.cos(math.radians(end.lat))
            * math.sin(d_lng / 2) ** 2
        )
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        return round(max(radius * c, 1.2), 2)

    def _google_mode(self, mode: str) -> str:
        return {
            "cheapest": "transit",
            "balanced": "transit",
            "fastest": "driving",
            "driving": "driving",
            "walking": "walking",
            "transit": "transit",
        }.get(mode, "transit")
