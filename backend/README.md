# Backend Setup

## Initial Setup

1. Create and activate virtual environment:
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

2. Install dependencies:
```powershell
pip install -r requirements.txt
```

3. Run the server:
```powershell
uvicorn main:app --reload
```

## Updating Requirements

To periodically check and update `requirements.txt` with the latest package versions:

### Option 1: Using the update script
```powershell
.\venv\Scripts\Activate.ps1
python update_requirements.py
```

Or use the PowerShell wrapper:
```powershell
.\update_requirements.ps1
```

### Option 2: Using pip-tools (recommended)
```powershell
pip install pip-tools
pip-compile --upgrade requirements.txt
```

### Option 3: Using pur
```powershell
pip install pur
pur -r requirements.txt
```

### Option 4: Manual update
```powershell
pip list --outdated  # Check outdated packages
pip install --upgrade <package_name>  # Update specific package
pip freeze > requirements.txt  # Update requirements file
```

## Automated Updates

You can set up a scheduled task in Windows to run the update script periodically:

1. Open Task Scheduler
2. Create a new task
3. Set trigger (e.g., weekly)
4. Set action to run: `powershell.exe -File "C:\hawkiz-web\backend\update_requirements.ps1"`

