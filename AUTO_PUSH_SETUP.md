# Auto-Push Setup Guide

This repository includes an automatic push script that commits and pushes changes to GitHub every 20 minutes.

## Setup Instructions

### Option 1: Automated Setup (Recommended)

1. **Run the setup script as Administrator:**
   ```powershell
   # Right-click PowerShell and select "Run as Administrator"
   .\setup_auto_push.ps1
   ```

2. The script will:
   - Create a Windows Scheduled Task
   - Configure it to run every 20 minutes
   - Start running immediately

### Option 2: Manual Setup

If you prefer to set up the scheduled task manually:

1. Open **Task Scheduler** (search for it in Windows)
2. Click **Create Basic Task**
3. Name it: `HawkizWeb-AutoPush`
4. Set trigger: **Daily** (we'll modify it)
5. Set action: **Start a program**
   - Program: `PowerShell.exe`
   - Arguments: `-NoProfile -ExecutionPolicy Bypass -File "C:\hawkiz-web\auto_push.ps1"`
6. After creation, right-click the task → **Properties**
7. Go to **Triggers** tab → Edit
8. Set to repeat every **20 minutes** indefinitely

## How It Works

The `auto_push.ps1` script:
1. Checks for uncommitted changes
2. Stages all changes (`git add -A`)
3. Creates a commit with timestamp
4. Pushes to `origin/main`
5. Logs all operations to `auto_push.log`

## Managing the Auto-Push Task

### View Task Status
```powershell
Get-ScheduledTask -TaskName "HawkizWeb-AutoPush"
```

### View Task History
Open **Task Scheduler** → Find `HawkizWeb-AutoPush` → View **History**

### Disable the Task
```powershell
Disable-ScheduledTask -TaskName "HawkizWeb-AutoPush"
```

### Enable the Task
```powershell
Enable-ScheduledTask -TaskName "HawkizWeb-AutoPush"
```

### Remove the Task
```powershell
Unregister-ScheduledTask -TaskName "HawkizWeb-AutoPush" -Confirm:$false
```

## Logs

All auto-push operations are logged to `auto_push.log` in the repository root. Check this file to see:
- When commits were made
- What changes were committed
- Any errors that occurred

## Notes

- The script only commits if there are actual changes
- Commits are made with the message: "Auto-commit: [timestamp]"
- The task runs even when you're not logged in (if configured)
- Network connection is required for pushes to succeed

## Troubleshooting

### Task Not Running
1. Check if the task is enabled: `Get-ScheduledTask -TaskName "HawkizWeb-AutoPush"`
2. Check Task Scheduler history for errors
3. Verify PowerShell execution policy allows script execution

### Push Failures
1. Check `auto_push.log` for error messages
2. Verify GitHub credentials are configured (SSH key or credential manager)
3. Ensure you have push permissions to the repository

### Permission Issues
- Make sure you ran `setup_auto_push.ps1` as Administrator
- The task runs as your user account, so it has access to your git credentials

