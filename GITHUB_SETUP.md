# GitHub Setup Instructions

## Initial Setup

### 1. Create a GitHub Repository

1. Go to [GitHub](https://github.com) and sign in
2. Click the "+" icon in the top right
3. Select "New repository"
4. Name it (e.g., `hawkiz-web`)
5. **Don't** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

### 2. Connect Local Repository to GitHub

Run these commands in PowerShell:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` and `YOUR_REPO` with your actual GitHub username and repository name.

## Saving Changes to GitHub

### Option 1: Use the Save Script (Recommended)

```powershell
.\save_to_github.ps1 "Your commit message here"
```

Or without a message (uses timestamp):
```powershell
.\save_to_github.ps1
```

### Option 2: Manual Git Commands

```powershell
git add .
git commit -m "Your commit message"
git push origin main
```

## Periodic Saves

You can set up a scheduled task in Windows to automatically save periodically:

1. Open Task Scheduler
2. Create Basic Task
3. Set trigger (e.g., daily at specific time)
4. Set action: Start a program
5. Program: `powershell.exe`
6. Arguments: `-File "C:\hawkiz-web\save_to_github.ps1"`

## Configure Git User (Optional)

If you want to set your GitHub identity for this repository:

```powershell
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

Or globally for all repositories:

```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

