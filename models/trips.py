from pydantic import BaseModel, Field


class TripDetails(BaseModel):
    trip_name: str
    duration_days: int
    difficulty: str
    xp_reward: int
    mission_briefing: str
    required_items: list[str]


class BookingRequest(BaseModel):
    trip_id: str = Field(min_length=1)
    user_id: str = Field(min_length=1)


class Ticket(BaseModel):
    origin: str
    destination: str
    departure_time: str
    seat: str
    travel_class: str = Field(serialization_alias="class")


class BookingResponse(BaseModel):
    status: str
    ticket: Ticket
