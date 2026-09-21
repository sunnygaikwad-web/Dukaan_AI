"""Product service — business logic for product operations."""
import uuid
from datetime import datetime
from typing import Optional
from app.database.firebase import db
from app.ai.ai_provider import ai_provider
import logging

logger = logging.getLogger(__name__)


class ProductService:

    async def generate_catalog(self, transcript: str, artisan_location: str,
                               language: str = "en") -> dict:
        """Call AI to generate multilingual product catalog."""
        try:
            result = await ai_provider.generate_catalog(
                transcript=transcript,
                artisan_location=artisan_location,
                language=language,
            )
            return {"success": True, "message": "Catalog generated successfully", "data": result}
        except Exception as e:
            logger.error(f"Catalog generation error: {e}")
            return {"success": False, "message": "Unable to generate catalog",
                    "error_code": "AI_SERVICE_ERROR"}

    async def recommend_price(self, category: str, material: str,
                              craft_type: str, production_cost: float,
                              labor_hours: float = 0,
                              desired_margin: float = 0.4) -> dict:
        """Get AI price recommendation."""
        try:
            result = await ai_provider.recommend_price(
                category=category, material=material,
                craft_type=craft_type, production_cost=production_cost,
                labor_hours=labor_hours, desired_margin=desired_margin
            )
            return {"success": True, "message": "Price recommended", "data": result}
        except Exception as e:
            logger.error(f"Pricing error: {e}")
            return {"success": False, "message": "Unable to recommend price",
                    "error_code": "PRICING_ERROR"}

    async def generate_heritage_story(self, product_name: str,
                                       craft_type: str, origin: str) -> dict:
        """Generate heritage story for a product."""
        try:
            story = await ai_provider.generate_heritage_story(
                product_name=product_name, craft_type=craft_type, origin=origin
            )
            return {"success": True, "message": "Heritage story generated",
                    "data": {"heritage_story": story}}
        except Exception as e:
            logger.error(f"Heritage story error: {e}")
            return {"success": False, "message": "Unable to generate heritage story",
                    "error_code": "AI_SERVICE_ERROR"}

    async def transcribe_voice(self, audio_bytes: bytes, language: str = "mr",
                               craft_type: Optional[str] = None) -> dict:
        """Transcribe spoken audio from artisan."""
        try:
            transcript = await ai_provider.transcribe_voice(
                audio_bytes=audio_bytes,
                language=language,
                craft_type=craft_type,
            )
            return {
                "success": True,
                "message": "Voice transcribed successfully",
                "data": {"transcript": transcript, "language": language}
            }
        except Exception as e:
            logger.error(f"Voice transcription error: {e}")
            return {
                "success": False,
                "message": "Unable to transcribe voice",
                "error_code": "VOICE_TRANSCRIBE_ERROR"
            }

    async def create_product(self, artisan_id: str, product_data: dict) -> dict:
        """Save a product to Firestore (or mock DB)."""
        try:
            product_id = str(uuid.uuid4())
            product = {
                **product_data,
                "artisan_id": artisan_id,
                "created_at": datetime.utcnow().isoformat(),
                "status": product_data.get("status", "draft"),
            }
            db.collection("products").document(product_id).set(product)
            return {"success": True, "message": "Product created",
                    "data": {"id": product_id, **product}}
        except Exception as e:
            logger.error(f"Product create error: {e}")
            return {"success": False, "message": "Unable to create product",
                    "error_code": "DATABASE_ERROR"}

    async def list_products(self, artisan_id: Optional[str] = None,
                            status: Optional[str] = None) -> dict:
        """List products with optional filters."""
        try:
            docs = db.collection("products").stream()
            products = []
            for doc in docs:
                data = doc.to_dict()
                if artisan_id and data.get("artisan_id") != artisan_id:
                    continue
                if status and data.get("status") != status:
                    continue
                products.append({"id": doc.id, **data})
            return {"success": True, "message": "Products fetched",
                    "data": {"products": products}}
        except Exception as e:
            logger.error(f"Product list error: {e}")
            return {"success": False, "message": "Unable to fetch products",
                    "error_code": "DATABASE_ERROR"}

    async def get_product(self, product_id: str) -> dict:
        """Get a single product by ID."""
        try:
            doc = db.collection("products").document(product_id).get()
            if doc.exists:
                return {"success": True, "message": "Product found",
                        "data": {"id": doc.id, **doc.to_dict()}}
            return {"success": False, "message": "Product not found",
                    "error_code": "NOT_FOUND"}
        except Exception as e:
            logger.error(f"Product get error: {e}")
            return {"success": False, "message": "Unable to fetch product",
                    "error_code": "DATABASE_ERROR"}


product_service = ProductService()
