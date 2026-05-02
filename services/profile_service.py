from fastapi import HTTPException, status

from models.profile import PreviousTrip, UserProfileResponse, UserStats


_PROFILES: dict[str, UserProfileResponse] = {
    "user_hero_99": UserProfileResponse(
        username="hero_explorer_99",
        rank="Master Voyager",
        level=12,
        xp=14250,
        badges=["Forest Dweller", "Frequent Flyer", "Wave Rider", "Hidden Gem"],
        stats=UserStats(
            continents_visited=4,
            flight_hours=214,
            streak=12,
        ),
        previous_trips=[
            PreviousTrip(
                trip_id="trip_cyber_tokyo",
                trip_name="Quest: Cyber-Tokyo",
                status="Completed",
                date="Oct 2023",
            ),
            PreviousTrip(
                trip_id="trip_glacier_peak",
                trip_name="Glacier Peak Raid",
                status="Completed",
                date="Jun 2023",
            ),
        ],
    )
}

async def get_profile(user_id: str) -> UserProfileResponse:
    profile = _PROFILES.get(user_id)
    if profile is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User profile not found",
        )
    return profile
