# GitHub Repository Setup Script
# This script helps you connect your local repository to GitHub

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Repository Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if GitHub CLI is installed
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

if ($ghInstalled) {
    Write-Host "[OK] GitHub CLI (gh) is installed" -ForegroundColor Green
    Write-Host ""
    
    # Check if user is logged in
    $ghAuth = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] GitHub CLI is authenticated" -ForegroundColor Green
        Write-Host ""
        
        $createRepo = Read-Host "Would you like to create a new GitHub repository? (y/n)"
        if ($createRepo -eq "y" -or $createRepo -eq "Y") {
            $repoName = Read-Host "Enter repository name (default: hawkiz-web)"
            if ([string]::IsNullOrWhiteSpace($repoName)) {
                $repoName = "hawkiz-web"
            }
            
            $repoDescription = Read-Host "Enter repository description (optional)"
            $isPrivate = Read-Host "Make repository private? (y/n, default: n)"
            
            $privateFlag = ""
            if ($isPrivate -eq "y" -or $isPrivate -eq "Y") {
                $privateFlag = "--private"
            }
            
            Write-Host ""
            Write-Host "Creating GitHub repository..." -ForegroundColor Cyan
            
            if ([string]::IsNullOrWhiteSpace($repoDescription)) {
                gh repo create $repoName --source=. --remote=origin --push $privateFlag
            } else {
                gh repo create $repoName --source=. --remote=origin --push --description $repoDescription $privateFlag
            }
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "[SUCCESS] Repository created and connected!" -ForegroundColor Green
                Write-Host "Your code has been pushed to GitHub." -ForegroundColor Green
            } else {
                Write-Host ""
                Write-Host "[ERROR] Failed to create repository" -ForegroundColor Red
                Write-Host "You may need to create it manually on GitHub.com" -ForegroundColor Yellow
            }
        } else {
            Write-Host ""
            Write-Host "Skipping repository creation." -ForegroundColor Yellow
            Write-Host "To connect manually, see GITHUB_SETUP.md" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[INFO] GitHub CLI is not authenticated" -ForegroundColor Yellow
        Write-Host ""
        $login = Read-Host "Would you like to log in to GitHub CLI? (y/n)"
        if ($login -eq "y" -or $login -eq "Y") {
            Write-Host ""
            Write-Host "Opening GitHub authentication..." -ForegroundColor Cyan
            gh auth login
        }
    }
} else {
    Write-Host "[INFO] GitHub CLI (gh) is not installed" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You have two options:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Option 1: Install GitHub CLI (Recommended)" -ForegroundColor Green
    Write-Host "  1. Download from: https://cli.github.com/" -ForegroundColor Gray
    Write-Host "  2. Or install via winget: winget install --id GitHub.cli" -ForegroundColor Gray
    Write-Host "  3. Run this script again" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Option 2: Manual Setup" -ForegroundColor Green
    Write-Host "  1. Go to https://github.com/new" -ForegroundColor Gray
    Write-Host "  2. Create a new repository (don't initialize it)" -ForegroundColor Gray
    Write-Host "  3. Run these commands:" -ForegroundColor Gray
    Write-Host ""
    Write-Host "     git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git" -ForegroundColor White
    Write-Host "     git branch -M main" -ForegroundColor White
    Write-Host "     git push -u origin main" -ForegroundColor White
    Write-Host ""
    
    $continue = Read-Host "Would you like to set up manually now? (y/n)"
    if ($continue -eq "y" -or $continue -eq "Y") {
        Write-Host ""
        Write-Host "Please create a repository on GitHub first, then:" -ForegroundColor Yellow
        Write-Host "1. Go to: https://github.com/new" -ForegroundColor Cyan
        Write-Host "2. Name your repository (e.g., 'hawkiz-web')" -ForegroundColor Cyan
        Write-Host "3. Don't initialize with README, .gitignore, or license" -ForegroundColor Cyan
        Write-Host "4. Click 'Create repository'" -ForegroundColor Cyan
        Write-Host ""
        
        $repoUrl = Read-Host "Enter your repository URL (e.g., https://github.com/username/repo.git)"
        
        if ($repoUrl) {
            Write-Host ""
            Write-Host "Setting up remote..." -ForegroundColor Cyan
            git remote add origin $repoUrl
            
            Write-Host "Renaming branch to main..." -ForegroundColor Cyan
            git branch -M main
            
            Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
            git push -u origin main
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "[SUCCESS] Repository connected and pushed to GitHub!" -ForegroundColor Green
            } else {
                Write-Host ""
                Write-Host "[ERROR] Failed to push. You may need to authenticate." -ForegroundColor Red
                Write-Host "Try: git push -u origin main" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To save changes in the future, run:" -ForegroundColor Green
Write-Host "  .\save_to_github.ps1" -ForegroundColor White
Write-Host ""

