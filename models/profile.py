from pydantic import BaseModel


class UserStats(BaseModel):
    continents_visited: int
    flight_hours: int
    streak: int


class PreviousTrip(BaseModel):
    trip_id: str
    trip_name: str
    status: str
    date: str


class UserProfileResponse(BaseModel):
    username: str
    rank: str
    level: int
    xp: int
    badges: list[str]
    stats: UserStats
    previous_trips: list[PreviousTrip]
