# Frontend startup script
Write-Host "Starting Frontend Development Server..." -ForegroundColor Cyan
Write-Host ""

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
}

Write-Host "Frontend will be available at: http://localhost:5173" -ForegroundColor Green
Write-Host ""

npm run dev

