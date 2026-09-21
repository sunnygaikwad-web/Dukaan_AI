"""API routes for artisans."""
from fastapi import APIRouter
from app.models.schemas import ArtisanCreate
from app.database.firebase import db
import uuid
from datetime import datetime

router = APIRouter(prefix="/api/artisans", tags=["Artisans"])

DEMO_ARTISANS = [
    {
        "id": "artisan_001",
        "name": "Savita Patil",
        "location": "Paithan, Aurangabad",
        "state": "Maharashtra",
        "craft_type": "Paithani",
        "experience_years": 18,
        "phone": "+919876543210",
        "language_preference": "mr",
        "craft_story": "I learned Paithani weaving from my mother at age 10. Each saree takes 2-3 months to complete by hand.",
        "created_at": "2026-01-01T00:00:00",
    },
]


@router.post("")
async def create_artisan(artisan: ArtisanCreate):
    try:
        artisan_id = str(uuid.uuid4())
        data = {**artisan.model_dump(), "created_at": datetime.utcnow().isoformat()}
        db.collection("artisans").document(artisan_id).set(data)
        return {"success": True, "message": "Artisan created",
                "data": {"id": artisan_id, **data}}
    except Exception as e:
        return {"success": False, "message": "Unable to create artisan",
                "error_code": "DATABASE_ERROR"}


@router.get("/{artisan_id}")
async def get_artisan(artisan_id: str):
    # Try real DB first, fallback to demo data
    try:
        doc = db.collection("artisans").document(artisan_id).get()
        if doc.exists:
            return {"success": True, "message": "Artisan found",
                    "data": {"id": doc.id, **doc.to_dict()}}
    except Exception:
        pass
    # Demo fallback
    for artisan in DEMO_ARTISANS:
        if artisan["id"] == artisan_id:
            return {"success": True, "message": "Artisan found (demo)", "data": artisan}
    return {"success": False, "message": "Artisan not found", "error_code": "NOT_FOUND"}
