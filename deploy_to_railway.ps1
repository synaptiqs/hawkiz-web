# Railway Deployment Script
# Run this after logging into Railway CLI: railway login

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Railway Deployment Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Railway CLI is installed
$railwayInstalled = Get-Command railway -ErrorAction SilentlyContinue
if (-not $railwayInstalled) {
    Write-Host "[ERROR] Railway CLI not found!" -ForegroundColor Red
    Write-Host "Installing Railway CLI..." -ForegroundColor Yellow
    npm install -g @railway/cli
    Write-Host ""
}

# Check if logged in
Write-Host "Checking Railway authentication..." -ForegroundColor Yellow
$whoami = railway whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ACTION REQUIRED] Please login to Railway first:" -ForegroundColor Yellow
    Write-Host "  railway login" -ForegroundColor White
    Write-Host ""
    Write-Host "This will open a browser for authentication." -ForegroundColor Gray
    Write-Host "After logging in, run this script again." -ForegroundColor Gray
    exit 1
}

Write-Host "[OK] Logged in as: $whoami" -ForegroundColor Green
Write-Host ""

# Check if project is linked
$project = railway status 2>&1
if ($LASTEXITCODE -ne 0 -or $project -match "No project linked") {
    Write-Host "No Railway project linked." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  1. Create new project: railway init" -ForegroundColor White
    Write-Host "  2. Link existing project: railway link" -ForegroundColor White
    Write-Host ""
    $choice = Read-Host "Create new project? (y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        Write-Host "Creating new Railway project..." -ForegroundColor Cyan
        railway init
    } else {
        Write-Host "Linking to existing project..." -ForegroundColor Cyan
        railway link
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "Deploying Backend Service" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Deploy backend
Write-Host "Setting up backend service..." -ForegroundColor Cyan
Set-Location backend

# Set service name
railway service create backend 2>&1 | Out-Null

# Set root directory
railway variables set RAILWAY_SERVICE_NAME=backend 2>&1 | Out-Null

# Deploy
Write-Host "Deploying backend..." -ForegroundColor Yellow
railway up --service backend

if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] Backend deployed!" -ForegroundColor Green
    $backendUrl = railway domain --service backend 2>&1
    Write-Host "Backend URL: $backendUrl" -ForegroundColor Cyan
} else {
    Write-Host "[ERROR] Backend deployment failed" -ForegroundColor Red
}

Write-Host ""
Set-Location ..

Write-Host "========================================" -ForegroundColor Green
Write-Host "Deploying Frontend Service" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Deploy frontend
Write-Host "Setting up frontend service..." -ForegroundColor Cyan
Set-Location frontend

# Set service name
railway service create frontend 2>&1 | Out-Null

# Get backend URL for environment variable
$backendUrl = railway domain --service backend 2>&1
if ($backendUrl) {
    Write-Host "Setting VITE_API_URL to: $backendUrl" -ForegroundColor Yellow
    railway variables set VITE_API_URL=$backendUrl --service frontend
}

# Deploy
Write-Host "Deploying frontend..." -ForegroundColor Yellow
railway up --service frontend

if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] Frontend deployed!" -ForegroundColor Green
    $frontendUrl = railway domain --service frontend 2>&1
    Write-Host "Frontend URL: $frontendUrl" -ForegroundColor Cyan
} else {
    Write-Host "[ERROR] Frontend deployment failed" -ForegroundColor Red
}

Set-Location ..

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Update CORS_ORIGINS in backend service with frontend URL" -ForegroundColor White
Write-Host "  2. Test your deployed application" -ForegroundColor White
Write-Host ""
Write-Host "View services:" -ForegroundColor Cyan
Write-Host "  railway status" -ForegroundColor Gray
Write-Host "  railway open" -ForegroundColor Gray
Write-Host ""

