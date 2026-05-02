from fastapi import APIRouter

from models.transport import CheapestRouteRequest, CheapestRouteResponse
from services.transport_service import find_cheapest_route


router = APIRouter()


@router.post("/get-cheapest-route", response_model=CheapestRouteResponse)
async def get_cheapest_route(
    payload: CheapestRouteRequest,
) -> CheapestRouteResponse:
    return await find_cheapest_route(payload)
