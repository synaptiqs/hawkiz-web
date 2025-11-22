# PowerShell script to update requirements.txt
# Run this periodically: .\update_requirements.ps1

Write-Host "Updating requirements.txt..." -ForegroundColor Cyan

# Activate virtual environment and run update script
& .\venv\Scripts\python.exe .\update_requirements.py

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nRequirements update complete!" -ForegroundColor Green
} else {
    Write-Host "`nError updating requirements." -ForegroundColor Red
}

