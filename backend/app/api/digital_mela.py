"""API routes for Digital Mela."""
from fastapi import APIRouter

router = APIRouter(prefix="/api/digital-mela", tags=["Digital Mela"])

DEMO_MELAS = [
    {
        "id": "mela_001",
        "title": "Diwali Artisan Collection 2026",
        "description": "Celebrate Diwali with authentic handcrafted products from artisans across India.",
        "category": "Festival",
        "status": "active",
        "cover_image_url": None,
        "featured_products": 24,
        "artisan_count": 12,
    },
    {
        "id": "mela_002",
        "title": "Maharashtra Crafts Showcase",
        "description": "Paithani, Warli, Bidriware and more from Maharashtra's finest artisans.",
        "category": "Regional",
        "status": "upcoming",
        "cover_image_url": None,
        "featured_products": 18,
        "artisan_count": 8,
    },
    {
        "id": "mela_003",
        "title": "Women's Artisan Collection",
        "description": "Empowering women artisans — celebrating their craftsmanship and resilience.",
        "category": "Thematic",
        "status": "active",
        "cover_image_url": None,
        "featured_products": 32,
        "artisan_count": 20,
    },
]


@router.get("")
async def get_digital_melas(status: str = None):
    melas = DEMO_MELAS
    if status:
        melas = [m for m in melas if m["status"] == status]
    return {
        "success": True,
        "message": "Digital Melas fetched",
        "data": {"melas": melas}
    }


@router.get("/{mela_id}")
async def get_mela(mela_id: str):
    for mela in DEMO_MELAS:
        if mela["id"] == mela_id:
            return {"success": True, "message": "Mela found", "data": mela}
    return {"success": False, "message": "Mela not found", "error_code": "NOT_FOUND"}
