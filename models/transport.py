from pydantic import BaseModel, Field


class RoutePoint(BaseModel):
    lat: float
    lng: float


class TransportSegment(BaseModel):
    mode: str
    distance_km: float
    duration_minutes: int
    cost: int
    description: str
    path: list[RoutePoint] = []


class TransportOption(BaseModel):
    mode: str
    total_cost: int
    total_time: str
    total_distance_km: float
    optimization: str
    segments: list[TransportSegment]
    explanation: str
    route_path: list[RoutePoint] = []


class CheapestRouteRequest(BaseModel):
    source: str = Field(min_length=1)
    destination: str = Field(min_length=1)


class CheapestRouteResponse(BaseModel):
    options: list[TransportOption]
    best_option: str
