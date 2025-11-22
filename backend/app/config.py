"""Application configuration settings."""
from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # Database
    DATABASE_URL: str = "postgresql://postgres:postgres@localhost:5432/hawkiz_db"
    
    # API
    API_V1_PREFIX: str = "/api/v1"
    
    # CORS
    CORS_ORIGINS: list[str] = [
        "http://localhost:5173",
        "http://localhost:3000",
        "http://127.0.0.1:5173",
    ]
    
    # Market Data Provider
    DATA_PROVIDER: str = "yfinance"  # Options: yfinance, alpha_vantage, polygon
    
    # Alpha Vantage (if using)
    ALPHA_VANTAGE_API_KEY: Optional[str] = None
    
    # Polygon.io (if using)
    POLYGON_API_KEY: Optional[str] = None
    
    # Redis (optional)
    REDIS_URL: Optional[str] = None
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()

