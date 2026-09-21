"""API routes for buyers."""
from fastapi import APIRouter
from app.models.schemas import BulkOrderRequest, BuyerMatchRequest
from app.services.buyer_matching_service import buyer_matching_service
from app.database.firebase import db
import uuid
from datetime import datetime

router = APIRouter(prefix="/api/buyers", tags=["Buyers"])


@router.post("/match")
async def match_buyers(request: BuyerMatchRequest):
    metadata = {
        "product_id": request.product_id,
        "category": request.product_category,
        "craft_type": request.craft_type,
        "material": request.material,
        "origin": request.origin,
    }
    return await buyer_matching_service.match_buyers(metadata)


@router.get("/recommended")
async def get_recommended_buyers():
    return await buyer_matching_service.get_all_buyers()


@router.post("/bulk-order-request")
async def submit_bulk_order(request: BulkOrderRequest):
    try:
        request_id = str(uuid.uuid4())
        data = {
            **request.model_dump(),
            "status": "pending",
            "created_at": datetime.utcnow().isoformat(),
        }
        db.collection("buyer_requests").document(request_id).set(data)
        return {
            "success": True,
            "message": "Bulk order request submitted successfully",
            "data": {"request_id": request_id, **data}
        }
    except Exception as e:
        return {"success": False, "message": "Unable to submit request",
                "error_code": "DATABASE_ERROR"}
