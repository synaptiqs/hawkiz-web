# Backend startup script
Write-Host "Starting Backend Server..." -ForegroundColor Cyan
Write-Host ""

# Check if port 8000 is in use
$portInUse = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "WARNING: Port 8000 is already in use!" -ForegroundColor Yellow
    Write-Host "Please stop the process using port 8000 or use a different port." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To find what's using port 8000, run:" -ForegroundColor Yellow
    Write-Host "  netstat -ano | findstr :8000" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To kill the process, run:" -ForegroundColor Yellow
    Write-Host "  Stop-Process -Id <PID> -Force" -ForegroundColor Gray
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit
    }
}

# Activate virtual environment
if (Test-Path ".\venv\Scripts\Activate.ps1") {
    & .\venv\Scripts\Activate.ps1
} else {
    Write-Host "ERROR: Virtual environment not found!" -ForegroundColor Red
    Write-Host "Please run: python -m venv venv" -ForegroundColor Yellow
    exit 1
}

# Check if main.py exists
if (-not (Test-Path "main.py")) {
    Write-Host "ERROR: main.py not found!" -ForegroundColor Red
    exit 1
}

# Run uvicorn
Write-Host ""
Write-Host "Backend will be available at: http://127.0.0.1:8001" -ForegroundColor Green
Write-Host "API Docs will be available at: http://127.0.0.1:8001/docs" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host ""

try {
    uvicorn main:app --reload --host 127.0.0.1 --port 8001
} catch {
    Write-Host ""
    Write-Host "ERROR starting server: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Make sure all dependencies are installed: pip install -r requirements.txt" -ForegroundColor Gray
    Write-Host "2. Check if port 8000 is available" -ForegroundColor Gray
    Write-Host "3. Verify Python and uvicorn are installed correctly" -ForegroundColor Gray
    exit 1
}
