# Database setup script for Hawkiz Options Backtesting
# This script helps set up PostgreSQL database and run migrations

Write-Host "Hawkiz Database Setup" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host ""

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "WARNING: .env file not found!" -ForegroundColor Yellow
    Write-Host "Please create .env file from .env.example and configure your database settings." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit 1
    }
}

# Check if PostgreSQL is running (basic check)
Write-Host "Checking PostgreSQL connection..." -ForegroundColor Yellow
try {
    $env:PGPASSWORD = "postgres"  # Update if different
    psql -h localhost -U postgres -d postgres -c "SELECT 1" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Cannot connect to PostgreSQL!" -ForegroundColor Red
        Write-Host "Please ensure PostgreSQL is running and credentials are correct." -ForegroundColor Yellow
        exit 1
    }
    Write-Host "PostgreSQL connection successful!" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Could not verify PostgreSQL connection." -ForegroundColor Yellow
    Write-Host "Please ensure PostgreSQL is installed and running." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Creating database (if not exists)..." -ForegroundColor Yellow
Write-Host "You may need to run this manually:" -ForegroundColor Yellow
Write-Host "  CREATE DATABASE hawkiz_db;" -ForegroundColor Gray
Write-Host "  \c hawkiz_db" -ForegroundColor Gray
Write-Host "  CREATE EXTENSION IF NOT EXISTS timescaledb;" -ForegroundColor Gray
Write-Host ""

# Check if Alembic is initialized
if (-not (Test-Path "alembic")) {
    Write-Host "Initializing Alembic..." -ForegroundColor Yellow
    alembic init alembic
    Write-Host "Alembic initialized!" -ForegroundColor Green
} else {
    Write-Host "Alembic already initialized." -ForegroundColor Green
}

Write-Host ""
Write-Host "Creating initial migration..." -ForegroundColor Yellow
alembic revision --autogenerate -m "Initial schema"

Write-Host ""
Write-Host "Applying migrations..." -ForegroundColor Yellow
alembic upgrade head

Write-Host ""
Write-Host "Database setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Verify database connection in .env file" -ForegroundColor Gray
Write-Host "2. Run migrations: alembic upgrade head" -ForegroundColor Gray
Write-Host "3. Start the server: uvicorn app.main:app --reload" -ForegroundColor Gray

