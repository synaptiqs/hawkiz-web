# Railway Auto-Configuration Script
# This script attempts to configure Railway services automatically via CLI

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Railway Auto-Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Railway CLI is installed
$railwayInstalled = Get-Command railway -ErrorAction SilentlyContinue
if (-not $railwayInstalled) {
    Write-Host "[ERROR] Railway CLI not found!" -ForegroundColor Red
    Write-Host "Installing Railway CLI..." -ForegroundColor Yellow
    npm install -g @railway/cli
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to install Railway CLI" -ForegroundColor Red
        Write-Host "Please install manually: npm install -g @railway/cli" -ForegroundColor Yellow
        exit 1
    }
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
Write-Host "Checking project status..." -ForegroundColor Yellow
$projectStatus = railway status 2>&1
if ($LASTEXITCODE -ne 0 -or $projectStatus -match "No project linked") {
    Write-Host "No Railway project linked." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Linking to project..." -ForegroundColor Cyan
    railway link
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to link project" -ForegroundColor Red
        Write-Host "Please link manually: railway link" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "[OK] Project linked" -ForegroundColor Green
Write-Host ""

# Configure Backend Service
Write-Host "========================================" -ForegroundColor Green
Write-Host "Configuring Backend Service" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Set working directory to backend
Set-Location backend

# Create or update backend service
Write-Host "Setting up backend service..." -ForegroundColor Cyan
railway service create backend 2>&1 | Out-Null

# Set root directory (this is done via service settings in Railway)
Write-Host "Note: Root directory must be set in Railway dashboard:" -ForegroundColor Yellow
Write-Host "  Service → Settings → Service → Root Directory = 'backend'" -ForegroundColor White
Write-Host ""

# Set environment variables
Write-Host "Setting environment variables..." -ForegroundColor Cyan
railway variables set CORS_ORIGINS="*" 2>&1 | Out-Null
Write-Host "[OK] CORS_ORIGINS set (temporary - update after frontend deploys)" -ForegroundColor Green

# Deploy backend
Write-Host ""
Write-Host "Deploying backend..." -ForegroundColor Cyan
railway up

if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] Backend deployed!" -ForegroundColor Green
    $backendUrl = railway domain 2>&1
    if ($backendUrl) {
        Write-Host "Backend URL: $backendUrl" -ForegroundColor Cyan
        $backendUrl = $backendUrl.Trim()
    }
} else {
    Write-Host "[ERROR] Backend deployment failed" -ForegroundColor Red
    Write-Host "Check logs: railway logs" -ForegroundColor Yellow
}

Set-Location ..

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Configuring Frontend Service" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Set working directory to frontend
Set-Location frontend

# Create or update frontend service
Write-Host "Setting up frontend service..." -ForegroundColor Cyan
railway service create frontend 2>&1 | Out-Null

# Set root directory (this is done via service settings in Railway)
Write-Host "Note: Root directory must be set in Railway dashboard:" -ForegroundColor Yellow
Write-Host "  Service → Settings → Service → Root Directory = 'frontend'" -ForegroundColor White
Write-Host ""

# Set environment variables
if ($backendUrl) {
    Write-Host "Setting VITE_API_URL to: $backendUrl" -ForegroundColor Cyan
    railway variables set VITE_API_URL=$backendUrl 2>&1 | Out-Null
    Write-Host "[OK] VITE_API_URL set" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Backend URL not found. Set VITE_API_URL manually:" -ForegroundColor Yellow
    Write-Host "  railway variables set VITE_API_URL=https://your-backend-url.railway.app" -ForegroundColor White
}

# Deploy frontend
Write-Host ""
Write-Host "Deploying frontend..." -ForegroundColor Cyan
railway up

if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] Frontend deployed!" -ForegroundColor Green
    $frontendUrl = railway domain 2>&1
    if ($frontendUrl) {
        Write-Host "Frontend URL: $frontendUrl" -ForegroundColor Cyan
        $frontendUrl = $frontendUrl.Trim()
    }
} else {
    Write-Host "[ERROR] Frontend deployment failed" -ForegroundColor Red
    Write-Host "Check logs: railway logs" -ForegroundColor Yellow
}

Set-Location ..

Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Manual Steps Required" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Railway CLI cannot set Root Directory automatically." -ForegroundColor White
Write-Host "You must set it in the Railway dashboard:" -ForegroundColor White
Write-Host ""
Write-Host "1. Go to railway.app" -ForegroundColor Cyan
Write-Host "2. Click on Backend Service → Settings → Service" -ForegroundColor White
Write-Host "3. Set Root Directory to: backend" -ForegroundColor White
Write-Host "4. Click on Frontend Service → Settings → Service" -ForegroundColor White
Write-Host "5. Set Root Directory to: frontend" -ForegroundColor White
Write-Host ""
if ($frontendUrl -and $backendUrl) {
    Write-Host "6. Update Backend CORS_ORIGINS:" -ForegroundColor White
    Write-Host "   railway variables set CORS_ORIGINS=$frontendUrl" -ForegroundColor Gray
    Write-Host "   (Run this from backend directory)" -ForegroundColor Gray
}
Write-Host ""
Write-Host "After setting Root Directory, services will auto-redeploy." -ForegroundColor Green
Write-Host ""

