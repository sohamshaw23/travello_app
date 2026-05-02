from fastapi import HTTPException, status

from models.transport import (
    CheapestRouteRequest,
    CheapestRouteResponse,
    RoutePoint,
    TransportOption,
    TransportSegment,
)
from services.cache_service import TTLCache
from services.maps_service import (
    ExternalRoutingError,
    LocationResolutionError,
    MapsRoutingService,
    RouteLeg,
)
from services.pricing_service import PricingService
from services.reasoning_service import RouteReasoningService


_TRANSPORT_CACHE = TTLCache(ttl_seconds=900)
_maps_service = MapsRoutingService()
_pricing_service = PricingService()
_reasoning_service = RouteReasoningService()


async def find_cheapest_route(payload: CheapestRouteRequest) -> CheapestRouteResponse:
    cache_key = (payload.source.lower(), payload.destination.lower())
    cached = _TRANSPORT_CACHE.get(cache_key)
    if cached is not None:
        return cached  # type: ignore[return-value]

    try:
        profiles = {
            "Cheapest": await _maps_service.get_route(payload.source, payload.destination, "cheapest"),
            "Fastest": await _maps_service.get_route(payload.source, payload.destination, "fastest"),
            "Balanced": await _maps_service.get_route(payload.source, payload.destination, "balanced"),
        }
    except LocationResolutionError as error:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=str(error),
        ) from error
    except ExternalRoutingError as error:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Routing provider failed to build a route",
        ) from error

    options = [
        _build_option(payload.source, payload.destination, optimization, legs)
        for optimization, legs in profiles.items()
    ]
    options.sort(key=lambda option: option.total_cost)

    cheapest_cost = options[0].total_cost
    fastest_minutes = min(_extract_minutes(option.total_time) for option in options)
    enriched_options = [
        option.model_copy(
            update={"explanation": _reasoning_service.explain(option, cheapest_cost, fastest_minutes)}
        )
        for option in options
    ]

    response = CheapestRouteResponse(
        options=enriched_options,
        best_option=enriched_options[0].mode,
    )
    _TRANSPORT_CACHE.set(cache_key, response)
    return response


def _build_option(
    source: str,
    destination: str,
    optimization: str,
    legs: list[RouteLeg],
) -> TransportOption:
    total_cost, segment_costs = _pricing_service.price_route(source, destination, legs)
    segments = [
        TransportSegment(
            mode=leg.mode,
            distance_km=round(leg.distance_km, 2),
            duration_minutes=leg.duration_minutes,
            cost=segment_costs[index],
            description=leg.description,
            path=[RoutePoint(lat=point.lat, lng=point.lng) for point in leg.path],
        )
        for index, leg in enumerate(legs)
    ]
    total_minutes = sum(segment.duration_minutes for segment in segments)
    total_distance = round(sum(segment.distance_km for segment in segments), 2)
    route_path = [
        RoutePoint(lat=point.lat, lng=point.lng)
        for leg in legs
        for point in leg.path
    ]

    return TransportOption(
        mode=" + ".join(segment.mode for segment in segments),
        total_cost=total_cost,
        total_time=f"{total_minutes} mins",
        total_distance_km=total_distance,
        optimization=optimization,
        segments=segments,
        explanation="",
        route_path=route_path,
    )


def _extract_minutes(total_time: str) -> int:
    return int(total_time.split()[0])
