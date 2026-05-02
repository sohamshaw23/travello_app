from __future__ import annotations

from math import ceil

from services.maps_service import RouteLeg


class PricingService:
    _BASE_RULES: dict[str, tuple[int, int]] = {
        "Bus": (5, 10),
        "Metro": (8, 12),
        "Auto": (15, 20),
        "Bike": (0, 5),
        "Walk": (0, 0),
        "Driving": (15, 20),
        "Walking": (0, 0),
        "Transit": (7, 11),
    }

    _CITY_MULTIPLIERS: dict[str, float] = {
        "tokyo": 1.15,
        "delhi": 0.95,
        "london": 1.20,
        "reykjavik": 1.30,
    }

    def price_route(self, source: str, destination: str, legs: list[RouteLeg]) -> tuple[int, list[int]]:
        multiplier = self._city_multiplier(source, destination)
        segment_costs = [self._segment_cost(leg, multiplier) for leg in legs]
        return sum(segment_costs), segment_costs

    def _segment_cost(self, leg: RouteLeg, multiplier: float) -> int:
        floor, ceiling = self._BASE_RULES.get(leg.mode, (8, 12))
        if floor == ceiling == 0:
            return 0

        per_km = (floor + ceiling) / 2
        raw_cost = leg.distance_km * per_km * multiplier

        if leg.mode == "Auto":
            raw_cost += 12
        elif leg.mode == "Bus":
            raw_cost += 5
        elif leg.mode == "Metro":
            raw_cost += 8

        return max(0, ceil(raw_cost))

    def _city_multiplier(self, source: str, destination: str) -> float:
        cities = f"{source} {destination}".lower()
        for city, multiplier in self._CITY_MULTIPLIERS.items():
            if city in cities:
                return multiplier
        return 1.0
