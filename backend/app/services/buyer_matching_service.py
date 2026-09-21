"""Buyer matching service."""
import logging
from app.ai.ai_provider import ai_provider

logger = logging.getLogger(__name__)


DEMO_BUYERS_DB = [
    {
        "id": "buyer_001",
        "name": "Priya Mehta",
        "organization": "Premium Handloom Boutique",
        "business_category": "Luxury Textile Retail",
        "location": "Mumbai, Maharashtra",
        "required_categories": ["Textiles", "Saree", "Silk"],
        "contact_email": "priya@premiumhandloom.com",
    },
    {
        "id": "buyer_002",
        "name": "Amit Sharma",
        "organization": "Urban Handicrafts",
        "business_category": "Handicraft Export",
        "location": "Delhi",
        "required_categories": ["Textiles", "Home Decor", "Jewellery"],
        "contact_email": "amit@urbanhandicrafts.com",
    },
    {
        "id": "buyer_003",
        "name": "Ramesh Iyer",
        "organization": "Hotel Heritage Group",
        "business_category": "Hospitality & Decor",
        "location": "Pune, Maharashtra",
        "required_categories": ["Textiles", "Home Decor", "Paintings"],
        "contact_email": "ramesh@hotelheritage.com",
    },
    {
        "id": "buyer_004",
        "name": "Deepa Nair",
        "organization": "Corporate Gifts India",
        "business_category": "Corporate Gifting",
        "location": "Bangalore, Karnataka",
        "required_categories": ["Textiles", "Home Decor", "Jewellery", "Pottery"],
        "contact_email": "deepa@corporategiftsindia.com",
    },
]


class BuyerMatchingService:

    async def match_buyers(self, product_metadata: dict) -> dict:
        """Match product with suitable buyers using AI."""
        try:
            matches = await ai_provider.match_buyers(
                product_metadata=product_metadata,
                buyers=DEMO_BUYERS_DB
            )
            return {
                "success": True,
                "message": f"Found {len(matches)} buyer matches",
                "data": {"matches": matches}
            }
        except Exception as e:
            logger.error(f"Buyer matching error: {e}")
            return {"success": False, "message": "Unable to match buyers",
                    "error_code": "MATCHING_ERROR"}

    async def get_all_buyers(self) -> dict:
        """Return all buyers (demo data)."""
        return {
            "success": True,
            "message": "Buyers fetched",
            "data": {"buyers": DEMO_BUYERS_DB}
        }


buyer_matching_service = BuyerMatchingService()
