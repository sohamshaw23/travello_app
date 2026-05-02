from fastapi import APIRouter

from models.profile import UserProfileResponse
from services.profile_service import get_profile


router = APIRouter()


@router.get("/profile/{user_id}", response_model=UserProfileResponse)
async def fetch_profile(user_id: str) -> UserProfileResponse:
    return await get_profile(user_id)
