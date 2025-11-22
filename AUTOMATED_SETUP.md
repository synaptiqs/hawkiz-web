# Automated Railway Setup

## What I Can Automate vs. What Requires Manual Steps

### ✅ What I Can Automate (via Railway CLI)

1. **Install Railway CLI** - If not installed
2. **Login Check** - Verify authentication
3. **Project Linking** - Link to existing or create new project
4. **Service Creation** - Create backend and frontend services
5. **Environment Variables** - Set CORS_ORIGINS and VITE_API_URL
6. **Deployment** - Trigger deployments via CLI
7. **Domain Management** - Get service URLs

### ❌ What Requires Manual Steps (Railway Dashboard)

1. **Root Directory** - Must be set in Railway web dashboard
   - Railway CLI doesn't have a command to set root directory
   - This is the #1 cause of deployment failures
   - Must be done via: Service → Settings → Service → Root Directory

## Automated Setup Script

I've created `railway_auto_config.ps1` that automates everything possible:

```powershell
# Run this after logging into Railway CLI
.\railway_auto_config.ps1
```

This script will:
1. ✅ Check/install Railway CLI
2. ✅ Verify login
3. ✅ Link/create project
4. ✅ Create services
5. ✅ Set environment variables
6. ✅ Deploy both services
7. ⚠️ **Remind you to set Root Directory manually**

## Quick Setup Process

### Step 1: Login to Railway CLI
```powershell
railway login
```

### Step 2: Run Auto-Config Script
```powershell
.\railway_auto_config.ps1
```

### Step 3: Set Root Directory (Manual - Required)
1. Go to [railway.app](https://railway.app)
2. **Backend Service** → Settings → Service → Root Directory = `backend`
3. **Frontend Service** → Settings → Service → Root Directory = `frontend`

### Step 4: Update CORS (After Frontend Deploys)
```powershell
cd backend
railway variables set CORS_ORIGINS=https://your-frontend-url.railway.app
```

## Why Root Directory Can't Be Automated

Railway's CLI doesn't provide a command to set the root directory. This is a limitation of the Railway CLI API. The root directory must be set through the web dashboard.

However, once set, Railway remembers it and all future deployments will use it automatically.

## Going Forward

I will:
- ✅ Automate everything possible via CLI
- ✅ Create scripts for repetitive tasks
- ✅ Provide clear instructions for manual steps
- ✅ Check code before suggesting deployment
- ✅ Verify configurations are correct

You will need to:
- ⚠️ Set Root Directory once per service (one-time setup)
- ⚠️ Approve Railway CLI login (one-time)

After initial setup, most operations can be automated!

