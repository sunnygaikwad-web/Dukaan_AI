"""ShilpSetu AI — FastAPI Backend Entry Point."""
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.database.firebase import init_firebase
from app.api import products, buyers, artisans, digital_mela

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info(f"🚀 ShilpSetu AI starting — AI_MODE={settings.ai_mode}")
    init_firebase()
    yield
    logger.info("ShilpSetu AI shutting down.")


app = FastAPI(
    title="ShilpSetu AI API",
    description=(
        "AI-powered virtual business manager for marginalized artisans. "
        "Transforms physical handicrafts into professional digital product listings."
    ),
    version="1.0.0",
    lifespan=lifespan,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register all routers
app.include_router(products.router)
app.include_router(buyers.router)
app.include_router(artisans.router)
app.include_router(digital_mela.router)


@app.get("/")
def read_root():
    return {
        "message": "Welcome to ShilpSetu AI API",
        "tagline": "From Artisan Hands to Digital Markets.",
        "mode": settings.ai_mode,
        "ai_provider": settings.ai_provider,
        "version": "1.0.0",
    }


@app.get("/health")
def health_check():
    return {"status": "healthy", "mode": settings.ai_mode}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
