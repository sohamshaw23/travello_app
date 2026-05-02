from fastapi import APIRouter, HTTPException, status

from models.trips import BookingRequest, BookingResponse, TripDetails
from services.trip_service import book_trip, get_trip_details


router = APIRouter()


@router.get("/trip/{trip_id}", response_model=TripDetails)
async def get_trip_by_id(trip_id: str) -> TripDetails:
    trip = await get_trip_details(trip_id)
    if trip is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trip not found")
    return trip


@router.post("/book-trip", response_model=BookingResponse, status_code=status.HTTP_201_CREATED)
async def post_book_trip(payload: BookingRequest) -> BookingResponse:
    return await book_trip(payload)
