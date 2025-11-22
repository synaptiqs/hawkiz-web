# Simple script to finish GitHub setup
# Run this after authenticating with: gh auth login

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Finishing GitHub Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check authentication
Write-Host "Checking GitHub authentication..." -ForegroundColor Yellow
$authCheck = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Not authenticated with GitHub" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please run this command first:" -ForegroundColor Yellow
    Write-Host "  gh auth login" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run this script again." -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Authenticated with GitHub" -ForegroundColor Green
Write-Host ""

# Check if remote already exists
$remoteExists = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Remote 'origin' already exists: $remoteExists" -ForegroundColor Yellow
    $overwrite = Read-Host "Do you want to remove it and create a new one? (y/n)"
    if ($overwrite -eq "y" -or $overwrite -eq "Y") {
        git remote remove origin
    } else {
        Write-Host "Keeping existing remote." -ForegroundColor Yellow
        Write-Host "To push, run: git push -u origin main" -ForegroundColor Cyan
        exit 0
    }
}

# Get repository name
$repoName = Read-Host "Enter repository name (default: hawkiz-web)"
if ([string]::IsNullOrWhiteSpace($repoName)) {
    $repoName = "hawkiz-web"
}

# Get privacy preference
$isPrivate = Read-Host "Make repository private? (y/n, default: n)"
$privateFlag = ""
if ($isPrivate -eq "y" -or $isPrivate -eq "Y") {
    $privateFlag = "--private"
} else {
    $privateFlag = "--public"
}

# Get description
$description = Read-Host "Enter repository description (optional, press Enter to skip)"

Write-Host ""
Write-Host "Creating repository and pushing code..." -ForegroundColor Cyan
Write-Host ""

if ([string]::IsNullOrWhiteSpace($description)) {
    gh repo create $repoName --source=. --remote=origin --push $privateFlag
} else {
    gh repo create $repoName --source=. --remote=origin --push --description $description $privateFlag
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "[SUCCESS] Repository created and pushed!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    
    $repoUrl = gh repo view --json url -q .url
    Write-Host "Repository URL: $repoUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To view in browser, run:" -ForegroundColor Yellow
    Write-Host "  gh repo view --web" -ForegroundColor White
    Write-Host ""
    Write-Host "To save future changes, run:" -ForegroundColor Yellow
    Write-Host "  .\save_to_github.ps1" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[ERROR] Failed to create repository" -ForegroundColor Red
    Write-Host "You may need to:" -ForegroundColor Yellow
    Write-Host "  1. Check your GitHub authentication: gh auth status" -ForegroundColor Gray
    Write-Host "  2. Create the repository manually on GitHub.com" -ForegroundColor Gray
    Write-Host "  3. Then run: git remote add origin <url>" -ForegroundColor Gray
}

