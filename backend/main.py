"""
Main entry point for Hawkiz Options Backtesting API.
This file imports the app from app.main to include all Phase 1 routes.
Works with both local development and Railway deployment.
"""
from app.main import app

# Re-export the app for uvicorn (Railway uses: uvicorn main:app)
__all__ = ["app"]
