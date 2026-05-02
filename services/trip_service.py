from models.trips import BookingRequest, BookingResponse, Ticket, TripDetails


_TRIPS: dict[str, TripDetails] = {
    "trip_cyber_tokyo": TripDetails(
        trip_name="Quest: Cyber-Tokyo",
        duration_days=5,
        difficulty="Easy",
        xp_reward=2500,
        mission_briefing=(
            "Infiltrate the neon-soaked labyrinth of Neo-Shinjuku, navigate MagLev "
            "networks, decode hidden side quests, and secure safe passage through the city grid."
        ),
        required_items=[
            "Universal Power Cell",
            "Suica Meta-Card",
            "Neural Translator",
        ],
    ),
    "trip_glacier_peak": TripDetails(
        trip_name="Glacier Peak Raid",
        duration_days=7,
        difficulty="Hard",
        xp_reward=3200,
        mission_briefing=(
            "Cross frozen ridge lines, manage low-visibility weather, and recover intel from a remote summit outpost."
        ),
        required_items=[
            "Thermal Jacket",
            "Ice Grip Boots",
            "Emergency Beacon",
        ],
    ),
}


async def get_trip_details(trip_id: str) -> TripDetails | None:
    return _TRIPS.get(trip_id)


async def book_trip(payload: BookingRequest) -> BookingResponse:
    return BookingResponse(
        status="confirmed",
        ticket=Ticket(
            origin="NEO-TKO",
            destination="LDN-2.0",
            departure_time="08:45 AM",
            seat="12F",
            travel_class="Elite Explorer",
        ),
    )
