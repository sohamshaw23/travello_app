from models.discovery import Destination


_DESTINATIONS = [
    Destination(
        id="dest_neo_tokyo",
        name="Neo Tokyo",
        image_url="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80",
        price="₹1,840",
        rating=4.8,
    ),
    Destination(
        id="dest_paris",
        name="City of Lights",
        image_url="https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=1200&q=80",
        price="₹980",
        rating=4.7,
    ),
    Destination(
        id="dest_pixel_isles",
        name="Pixel Isles",
        image_url="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80",
        price="₹760",
        rating=4.9,
    ),
    Destination(
        id="dest_reykjavik",
        name="Glacier Peak",
        image_url="https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80",
        price="₹1,420",
        rating=4.6,
    ),
    Destination(
        id="dest_kyoto",
        name="Kyoto Quest",
        image_url="https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80",
        price="₹1,150",
        rating=4.8,
    ),
    Destination(
        id="dest_bali",
        name="Sunset Bali",
        image_url="https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=80",
        price="₹890",
        rating=4.5,
    ),
]


async def list_destinations() -> list[Destination]:
    return _DESTINATIONS
