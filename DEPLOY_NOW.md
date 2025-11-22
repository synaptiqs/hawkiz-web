# Deploy to Railway - Quick Guide

## Option 1: Web Dashboard (Easiest - Recommended)

### Step 1: Go to Railway
1. Open [railway.app](https://railway.app) in your browser
2. Sign in with GitHub

### Step 2: Create Project
1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Choose: `synaptiqs/hawkiz-web`
4. Click **"Deploy Now"**

### Step 3: Add Backend Service
1. In your project, click **"New Service"**
2. Select **"GitHub Repo"** → Choose `synaptiqs/hawkiz-web`
3. Configure:
   - **Name**: `backend`
   - **Root Directory**: `backend`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
4. Go to **Variables** tab → Add:
   - `CORS_ORIGINS` = `*` (temporary)
5. Wait for deployment
6. **Copy the generated URL** (e.g., `https://backend-production-xxxx.up.railway.app`)

### Step 4: Add Frontend Service
1. Click **"New Service"** again
2. Select **"GitHub Repo"** → Choose `synaptiqs/hawkiz-web`
3. **IMPORTANT**: If you see "Nixpacks was unable to generate a build plan" error
4. Click **"Configure root directory"** button (or go to Settings → Service)
5. Set **Root Directory** to: `frontend` (exactly, lowercase, no slashes)
6. Configure:
   - **Name**: `frontend`
   - **Root Directory**: `frontend` (must be set!)
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `vite preview --host 0.0.0.0 --port $PORT`
4. Go to **Variables** tab → Add:
   - `VITE_API_URL` = `https://your-backend-url.railway.app` (use URL from Step 3)
5. Wait for deployment
6. **Copy the generated URL** (e.g., `https://frontend-production-xxxx.up.railway.app`)

### Step 5: Update CORS
1. Go to **Backend Service** → **Variables**
2. Update `CORS_ORIGINS`:
   ```
   https://your-frontend-url.railway.app
   ```
3. Railway will auto-redeploy

### Done! 🎉
Your app is live at your frontend URL!

---

## Option 2: Railway CLI

### Step 1: Install & Login
```powershell
npm install -g @railway/cli
railway login
```

### Step 2: Deploy
```powershell
# Create/link project
railway init

# Deploy backend
cd backend
railway up --service backend

# Get backend URL
railway domain --service backend

# Deploy frontend (in new terminal or after backend)
cd frontend
railway variables set VITE_API_URL=https://your-backend-url.railway.app
railway up --service frontend

# Get frontend URL
railway domain --service frontend
```

### Step 3: Update CORS
```powershell
cd backend
railway variables set CORS_ORIGINS=https://your-frontend-url.railway.app
```

---

## Option 3: Use Deployment Script

After logging into Railway CLI:
```powershell
.\deploy_to_railway.ps1
```

---

## 🚀 Quick Start (Web Dashboard - Fastest)

1. Go to [railway.app](https://railway.app) → Sign in
2. **New Project** → **Deploy from GitHub** → Select `synaptiqs/hawkiz-web`
3. Add **Backend Service** (Root: `backend`)
4. Add **Frontend Service** (Root: `frontend`)
5. Set environment variables
6. Done!

**Total time: ~5-10 minutes**

---

## Need Help?

- See `RAILWAY_QUICK_START.md` for detailed steps
- See `RAILWAY_DEPLOYMENT.md` for troubleshooting
- Railway Docs: https://docs.railway.app

