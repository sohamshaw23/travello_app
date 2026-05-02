from pydantic import BaseModel


class Destination(BaseModel):
    id: str
    name: str
    image_url: str
    price: str
    rating: float
