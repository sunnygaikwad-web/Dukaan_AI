"""API routes for products."""
from fastapi import APIRouter, UploadFile, File, Form
from app.models.schemas import (
    GenerateCatalogRequest, PriceRecommendRequest,
    ProductCreate, ApiResponse
)
from app.services.product_service import product_service

router = APIRouter(prefix="/api/products", tags=["Products"])


@router.post("/generate-catalog")
async def generate_catalog(request: GenerateCatalogRequest):
    return await product_service.generate_catalog(
        transcript=request.transcript,
        artisan_location=request.artisan_location,
        language=request.language,
    )


@router.post("/recommend-price")
async def recommend_price(request: PriceRecommendRequest):
    return await product_service.recommend_price(
        category=request.category,
        material=request.material,
        craft_type=request.craft_type,
        production_cost=request.production_cost,
        labor_hours=request.labor_hours or 0,
        desired_margin=request.desired_margin or 0.4,
    )


@router.post("/generate-heritage-story")
async def generate_heritage_story(
    product_name: str = Form(...),
    craft_type: str = Form(...),
    origin: str = Form(...),
):
    return await product_service.generate_heritage_story(
        product_name=product_name,
        craft_type=craft_type,
        origin=origin,
    )


@router.post("/enhance-image")
async def enhance_image(file: UploadFile = File(...)):
    """Mock image enhancement endpoint."""
    return {
        "success": True,
        "message": "Image enhanced successfully (demo mode)",
        "data": {
            "enhanced_image_url": "https://placeholder.shilpsetu.ai/enhanced.jpg",
            "original_image_url": "https://placeholder.shilpsetu.ai/original.jpg",
            "enhancements": ["background_removed", "lighting_improved", "composition_optimized"],
        }
    }


@router.post("/transcribe-voice")
async def transcribe_voice(
    audio: UploadFile = File(...),
    language: str = Form("mr"),
    craft_type: str = Form(None),
):
    """Transcribe spoken artisan voice audio."""
    audio_bytes = await audio.read()
    return await product_service.transcribe_voice(
        audio_bytes=audio_bytes,
        language=language,
        craft_type=craft_type,
    )


@router.post("")
async def create_product(product: ProductCreate):
    return await product_service.create_product(
        artisan_id=product.artisan_id,
        product_data=product.model_dump(),
    )


@router.get("")
async def list_products(artisan_id: str = None, status: str = None):
    return await product_service.list_products(artisan_id=artisan_id, status=status)


@router.get("/{product_id}")
async def get_product(product_id: str):
    return await product_service.get_product(product_id)
