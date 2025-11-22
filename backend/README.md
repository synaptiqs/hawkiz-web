# Hawkiz Options Backtesting - Backend

FastAPI backend for the options strategy backtesting platform.

## Setup

### 1. Install Dependencies

```powershell
# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt
```

### 2. Database Setup

1. Install PostgreSQL with TimescaleDB extension
2. Create database:
   ```sql
   CREATE DATABASE hawkiz_db;
   ```
3. Enable TimescaleDB extension:
   ```sql
   \c hawkiz_db
   CREATE EXTENSION IF NOT EXISTS timescaledb;
   ```

### 3. Environment Configuration

Copy `.env.example` to `.env` and update with your database credentials:

```powershell
Copy-Item .env.example .env
```

Edit `.env` with your settings.

### 4. Run Database Migrations

```powershell
# Initialize Alembic (if not already done)
alembic init alembic

# Create initial migration
alembic revision --autogenerate -m "Initial schema"

# Apply migrations
alembic upgrade head
```

### 5. Run the Server

```powershell
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Or use the start script:
```powershell
.\start.ps1
```

## API Documentation

Once the server is running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app
│   ├── config.py            # Configuration settings
│   ├── database.py          # Database connection
│   ├── models/              # SQLAlchemy models
│   │   ├── stock_prices.py
│   │   ├── options_chains.py
│   │   └── market_events.py
│   ├── schemas/             # Pydantic schemas
│   │   └── market_data.py
│   ├── services/            # Business logic
│   │   └── market_data_service.py
│   └── api/                 # API routes
│       └── v1/
│           └── market_data.py
├── alembic/                 # Database migrations
├── requirements.txt
└── .env                     # Environment variables
```

## API Endpoints

### Market Data

- `GET /api/v1/market-data/stocks/{symbol}` - Get stock prices
- `POST /api/v1/market-data/stocks/{symbol}/fetch` - Fetch and store stock data
- `GET /api/v1/market-data/options/{underlying_symbol}` - Get options chain
- `GET /api/v1/market-data/available-dates` - Get available dates

## Development

### Running Tests

```powershell
pytest
```

### Creating Migrations

```powershell
alembic revision --autogenerate -m "Description of changes"
alembic upgrade head
```
