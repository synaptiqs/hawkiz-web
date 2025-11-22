# Quick Test Guide - Phase 1

## ✅ Pre-flight Check Complete!

All dependencies are installed and the app is ready to test.

## Step 1: Start the Server

Open a PowerShell terminal and run:

```powershell
cd C:\hawkiz-web\backend
.\start.ps1
```

You should see:
```
Starting FastAPI server on http://127.0.0.1:8001
API Documentation: http://127.0.0.1:8001/docs
```

## Step 2: Test Basic Endpoints

### Option A: Use the Test Script (Easiest)

Open a **NEW** PowerShell window (keep the server running) and run:

```powershell
cd C:\hawkiz-web\backend
.\venv\Scripts\Activate.ps1
python test_phase1.py
```

This will automatically test all endpoints!

### Option B: Manual Testing

#### 1. Health Check
Open in browser: http://127.0.0.1:8001/health

Expected: `{"status": "healthy"}`

#### 2. Root Endpoint
Open in browser: http://127.0.0.1:8001/

Expected: API information

#### 3. API Documentation (Swagger UI)
Open in browser: http://127.0.0.1:8001/docs

This shows all available endpoints with interactive testing!

#### 4. Test Fetching Stock Data
In PowerShell:
```powershell
$response = Invoke-RestMethod -Uri "http://127.0.0.1:8001/api/v1/market-data/stocks/SPY/fetch?start_date=2024-01-01" -Method Post
$response | ConvertTo-Json
```

#### 5. Test Options Chain
In PowerShell:
```powershell
$response = Invoke-RestMethod -Uri "http://127.0.0.1:8001/api/v1/market-data/options/SPY"
$response | ConvertTo-Json
```

## Expected Results

✅ **Success**: All endpoints return 200 OK
✅ **Health**: Returns `{"status": "healthy"}`
✅ **Fetch Stock**: Returns success message with record count
✅ **Options Chain**: Returns options data (may take a few seconds)

## Troubleshooting

### Server won't start:
- Check if port 8001 is in use
- Make sure you're in the `backend` directory
- Verify virtual environment is activated

### Import errors:
- All dependencies are installed ✅
- If you see errors, try: `pip install -r requirements.txt`

### No data from endpoints:
- **Fetch endpoints**: Need internet connection (yfinance fetches live data)
- **Database endpoints**: Will work even without database (they fetch live data)

## Next Steps

Once testing is successful:
1. ✅ Phase 1 is complete!
2. Set up PostgreSQL database (optional, for storing historical data)
3. Move to Phase 2: Strategy Builder

## Quick Commands Reference

```powershell
# Start server
cd backend
.\start.ps1

# Run tests (in new terminal)
cd backend
.\venv\Scripts\Activate.ps1
python test_phase1.py

# Check server status
curl http://127.0.0.1:8001/health
```

