# Script to save changes to GitHub
# Usage: .\save_to_github.ps1 "Your commit message"

param(
    [string]$Message = "Update: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

Write-Host "Saving to GitHub..." -ForegroundColor Cyan
Write-Host ""

# Check if there are changes
$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes to commit." -ForegroundColor Yellow
    exit 0
}

# Show what will be committed
Write-Host "Changes to be committed:" -ForegroundColor Green
git status --short
Write-Host ""

# Add all changes
Write-Host "Adding files..." -ForegroundColor Cyan
git add .

# Commit
Write-Host "Committing changes..." -ForegroundColor Cyan
git commit -m $Message

# Check if remote exists
$remote = git remote get-url origin -q 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
    git push origin master
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "Successfully saved to GitHub!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "Warning: Could not push to GitHub. Make sure remote is configured." -ForegroundColor Yellow
        Write-Host "To set up GitHub remote, run:" -ForegroundColor Yellow
        Write-Host "  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git" -ForegroundColor Gray
    }
} else {
    Write-Host ""
    Write-Host "No GitHub remote configured." -ForegroundColor Yellow
    Write-Host "To set up GitHub remote, run:" -ForegroundColor Yellow
    Write-Host "  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git" -ForegroundColor Gray
    Write-Host "  git push -u origin master" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Commit completed locally." -ForegroundColor Green

