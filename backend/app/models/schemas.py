"""Pydantic models for ShilpSetu AI backend."""
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class ArtisanCreate(BaseModel):
    name: str
    location: str
    state: str
    craft_type: str
    experience_years: int
    phone: str
    language_preference: str = "en"
    craft_story: Optional[str] = None


class ArtisanResponse(ArtisanCreate):
    id: str
    created_at: Optional[str] = None


class CatalogContent(BaseModel):
    title: str
    short_desc: str
    description: str
    heritage_story: str
    keywords: List[str] = []
    seo_title: Optional[str] = None
    meta_description: Optional[str] = None


class PricingInfo(BaseModel):
    recommended: float
    minimum: float
    market_low: float
    market_high: float
    confidence_score: float
    production_cost: float
    factors: List[str] = []


class ProductMetadata(BaseModel):
    category: str
    subcategory: str
    craft_type: str
    material: str
    color: str = ""
    origin: str = ""
    region: str = ""


class ProductCreate(BaseModel):
    artisan_id: str
    status: str = "draft"
    original_image_url: Optional[str] = None
    enhanced_image_url: Optional[str] = None
    catalog: Optional[dict] = None
    pricing: Optional[dict] = None
    metadata: Optional[dict] = None


class ProductResponse(ProductCreate):
    id: str
    created_at: Optional[str] = None


class GenerateCatalogRequest(BaseModel):
    transcript: str
    artisan_location: str = ""
    language: str = "en"
    product_category: Optional[str] = None


class PriceRecommendRequest(BaseModel):
    category: str
    material: str
    craft_type: str
    production_cost: float
    labor_hours: Optional[float] = None
    desired_margin: Optional[float] = 0.4


class BuyerMatchRequest(BaseModel):
    product_id: str
    product_category: Optional[str] = None
    craft_type: Optional[str] = None
    material: Optional[str] = None
    origin: Optional[str] = None


class BulkOrderRequest(BaseModel):
    buyer_name: str
    organization: str
    product_id: str
    artisan_id: str
    required_quantity: int
    expected_delivery_date: Optional[str] = None
    message: Optional[str] = None


class ApiResponse(BaseModel):
    success: bool
    message: str
    data: Optional[dict] = None
    error_code: Optional[str] = None
