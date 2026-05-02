from fastapi import FastAPI

from routes.discovery import router as discovery_router
from routes.profile import router as profile_router
from routes.transport import router as transport_router
from routes.trips import router as trips_router


app = FastAPI(
    title="Travelo API",
    version="1.0.0",
    description="FastAPI backend for the Travelo SwiftUI app.",
)


@app.get("/")
async def root() -> dict[str, str]:
    return {
        "name": "Travelo API",
        "base_url": "http://localhost:8000",
        "docs": "http://localhost:8000/docs",
    }

app.include_router(discovery_router, tags=["discovery"])
app.include_router(transport_router, tags=["transport"])
app.include_router(trips_router, tags=["trips"])
app.include_router(profile_router, tags=["profile"])
