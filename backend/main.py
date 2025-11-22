"""
Main entry point for Hawkiz Options Backtesting API.
This file imports the app from app.main to maintain backward compatibility.
"""
from app.main import app

# Re-export the app for uvicorn
__all__ = ["app"]

