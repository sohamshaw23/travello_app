from fastapi import APIRouter

from models.discovery import Destination
from services.discovery_service import list_destinations


router = APIRouter()


@router.get("/destinations", response_model=list[Destination])
async def get_destinations() -> list[Destination]:
    return await list_destinations()
