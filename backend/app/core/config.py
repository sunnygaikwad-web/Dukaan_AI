from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import Optional

class Settings(BaseSettings):
    ai_mode: str = "demo"
    ai_provider: str = "gemini"
    ai_api_key: Optional[str] = None
    
    firebase_credentials_path: Optional[str] = "service_account.json"
    firebase_project_id: Optional[str] = "shilpsetu-2"
    firebase_client_email: Optional[str] = None
    firebase_private_key: Optional[str] = None
    firebase_storage_bucket: Optional[str] = None

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

settings = Settings()
