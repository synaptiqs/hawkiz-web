# Quick GitHub Setup - 3 Steps

## Step 1: Authenticate with GitHub

Open PowerShell and run:
```powershell
gh auth login
```

Follow the prompts:
- Choose "GitHub.com"
- Choose "HTTPS" 
- Authenticate via web browser (recommended) or token
- Follow the browser instructions

## Step 2: Create and Push Repository

Run this command (it will create the repo and push your code):
```powershell
gh repo create hawkiz-web --source=. --private --remote=origin --push
```

Or for a public repository:
```powershell
gh repo create hawkiz-web --source=. --public --remote=origin --push
```

## Step 3: Verify

Check your repository:
```powershell
gh repo view --web
```

That's it! Your code is now on GitHub.

## Future Saves

To save changes in the future, just run:
```powershell
.\save_to_github.ps1 "Your commit message"
```

