from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os
from typing import List

app = FastAPI()

# Get CORS origins from environment variable or use defaults
cors_origins_env = os.getenv("CORS_ORIGINS", "")
if cors_origins_env:
    # Split comma-separated origins from environment variable
    allow_origins: List[str] = [origin.strip() for origin in cors_origins_env.split(",")]
else:
    # Default origins for local development
    allow_origins = [
        "http://localhost:5173",
        "http://localhost:3000",
        "http://127.0.0.1:5173",
        "http://127.0.0.1:8001",
    ]

# Configure CORS to allow frontend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=allow_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/health")
async def health():
    return {"status": "healthy"}


@app.get("/api/test")
async def test():
    return {"message": "Backend API is working!"}

