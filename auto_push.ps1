# Auto-push script for GitHub repository
# This script automatically commits and pushes changes every 20 minutes

$ErrorActionPreference = "Stop"

# Get the repository root directory
$repoRoot = git rev-parse --show-toplevel
Set-Location $repoRoot

# Log file for tracking auto-push operations
$logFile = Join-Path $repoRoot "auto_push.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

function Write-Log {
    param([string]$Message)
    $logEntry = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host $logEntry
}

try {
    Write-Log "Starting auto-push check..."
    
    # Check if there are any changes
    $status = git status --porcelain
    
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Log "No changes detected. Skipping commit."
        exit 0
    }
    
    Write-Log "Changes detected. Staging files..."
    
    # Stage all changes
    git add -A
    
    # Create commit with timestamp
    $commitMessage = "Auto-commit: $timestamp"
    git commit -m $commitMessage
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "Commit successful. Pushing to origin..."
        
        # Push to origin/main
        git push origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Push successful!"
        } else {
            Write-Log "ERROR: Push failed with exit code $LASTEXITCODE"
            exit 1
        }
    } else {
        Write-Log "ERROR: Commit failed with exit code $LASTEXITCODE"
        exit 1
    }
    
} catch {
    Write-Log "ERROR: Exception occurred - $($_.Exception.Message)"
    exit 1
}

