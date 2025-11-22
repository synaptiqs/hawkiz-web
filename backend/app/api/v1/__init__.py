"""API v1 routes."""
from fastapi import APIRouter
from app.api.v1 import market_data

api_router = APIRouter()

api_router.include_router(market_data.router, prefix="/market-data", tags=["market-data"])

