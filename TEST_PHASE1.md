# Phase 1 Testing Guide

This guide will help you test Phase 1 of the Hawkiz Options Backtesting platform.

## Prerequisites

1. **Python dependencies installed**:
   ```powershell
   cd backend
   .\venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

2. **Database (Optional for basic testing)**:
   - The API can work without a database for fetching live data
   - Database is needed for storing and retrieving historical data
   - If you don't have PostgreSQL set up, you can still test the fetch endpoints

## Step 1: Start the Backend Server

```powershell
cd backend
.\start.ps1
```

You should see:
```
Starting FastAPI server on http://127.0.0.1:8001
API Documentation: http://127.0.0.1:8001/docs
```

## Step 2: Test Basic Endpoints

### Health Check
Open your browser or use curl:
```
http://127.0.0.1:8001/health
```

Expected response:
```json
{"status": "healthy"}
```

### Root Endpoint
```
http://127.0.0.1:8001/
```

Expected response:
```json
{
  "message": "Hawkiz Options Backtesting API",
  "version": "0.1.0",
  "docs": "/docs"
}
```

### API Documentation
Open in browser:
```
http://127.0.0.1:8001/docs
```

This will show the Swagger UI with all available endpoints.

## Step 3: Test Market Data Endpoints

### Option A: Using the Test Script (Recommended)

```powershell
cd backend
.\venv\Scripts\Activate.ps1
python test_phase1.py
```

This will run all tests automatically.

### Option B: Manual Testing

#### 1. Fetch Stock Data (No database required)
```powershell
# Using PowerShell
$response = Invoke-RestMethod -Uri "http://127.0.0.1:8001/api/v1/market-data/stocks/SPY/fetch?start_date=2024-01-01" -Method Post
$response | ConvertTo-Json
```

Or using curl:
```bash
curl -X POST "http://127.0.0.1:8001/api/v1/market-data/stocks/SPY/fetch?start_date=2024-01-01"
```

#### 2. Get Stock Prices (Requires database)
```powershell
$response = Invoke-RestMethod -Uri "http://127.0.0.1:8001/api/v1/market-data/stocks/SPY?start_date=2024-01-01&limit=10"
$response | ConvertTo-Json
```

#### 3. Get Options Chain (No database required)
```powershell
$response = Invoke-RestMethod -Uri "http://127.0.0.1:8001/api/v1/market-data/options/SPY"
$response | ConvertTo-Json
```

#### 4. Get Available Dates (Requires database)
```powershell
$response = Invoke-RestMethod -Uri "http://127.0.0.1:8001/api/v1/market-data/available-dates"
$response | ConvertTo-Json
```

## Step 4: Test Using Swagger UI

1. Open http://127.0.0.1:8001/docs in your browser
2. Click on an endpoint (e.g., "GET /api/v1/market-data/stocks/{symbol}")
3. Click "Try it out"
4. Enter parameters (e.g., symbol: "SPY")
5. Click "Execute"
6. View the response

## Expected Results

### ✅ Success Indicators:
- Health endpoint returns 200 OK
- Root endpoint shows API information
- Swagger UI loads and shows all endpoints
- Fetch stock data returns success message
- Options chain returns data (may take a few seconds)

### ⚠️ Common Issues:

1. **Connection Error**:
   - Make sure the server is running
   - Check the port (should be 8001)

2. **Import Errors**:
   - Make sure all dependencies are installed: `pip install -r requirements.txt`
   - Activate virtual environment

3. **Database Errors** (if testing database features):
   - Database endpoints will fail if PostgreSQL is not set up
   - This is OK for initial testing - you can test fetch endpoints without a database

4. **Options Data Not Available**:
   - yfinance sometimes has rate limits or data availability issues
   - Try a different symbol (SPY, AAPL, MSFT)
   - Wait a few seconds and try again

## Next Steps

Once Phase 1 is working:
1. Set up PostgreSQL database (if not done)
2. Run database migrations
3. Test storing and retrieving data
4. Move to Phase 2: Strategy Builder

## Troubleshooting

### Server won't start:
- Check if port 8001 is already in use
- Verify Python and dependencies are installed
- Check for syntax errors in the code

### Endpoints return 500 errors:
- Check server logs for error messages
- Verify all dependencies are installed
- Check database connection (if using database endpoints)

### No data returned:
- For fetch endpoints: Check internet connection (yfinance needs internet)
- For database endpoints: Make sure data has been fetched and stored first

