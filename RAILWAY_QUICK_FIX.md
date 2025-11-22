# Railway Deployment Quick Fix Guide

## Most Common Issues & Immediate Fixes

### Issue: "Module not found" or "File not found"

**Fix:**
1. In Railway dashboard, go to your service
2. Click **Settings** → **Service**
3. **VERIFY Root Directory:**
   - Backend: Must be `backend` (not empty, not `/backend`)
   - Frontend: Must be `frontend` (not empty, not `/frontend`)
4. Save and redeploy

### Issue: Build fails or times out

**Fix:**
1. Check **Build Command** in service settings:
   - Backend: Leave **EMPTY** (Railway auto-detects Python)
   - Frontend: Set to `npm install && npm run build`
2. Check **Start Command**:
   - Backend: `uvicorn main:app --host 0.0.0.0 --port $PORT`
   - Frontend: `vite preview --host 0.0.0.0 --port $PORT`

### Issue: Service starts then immediately crashes

**Fix:**
1. Check **Deploy Logs** in Railway dashboard
2. Common causes:
   - Wrong start command
   - Missing environment variables
   - Port binding error (use `$PORT`, not hardcoded)

### Issue: Frontend can't connect to backend

**Fix:**
1. In **Frontend Service** → **Variables**:
   - Add: `VITE_API_URL` = `https://your-backend-url.railway.app`
   - **Important**: No quotes, no trailing slash
2. In **Backend Service** → **Variables**:
   - Add: `CORS_ORIGINS` = `https://your-frontend-url.railway.app`
   - **Important**: No quotes, no trailing slash
3. **Rebuild frontend** after setting VITE_API_URL (Vite bakes env vars into build)

## Step-by-Step: Fix Your Deployment

### Step 1: Verify Service Configuration

**Backend Service:**
```
Root Directory: backend
Build Command: (empty - auto-detect)
Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Frontend Service:**
```
Root Directory: frontend
Build Command: npm install && npm run build
Start Command: vite preview --host 0.0.0.0 --port $PORT
```

### Step 2: Check File Structure

Your repo should have:
```
hawkiz-web/
├── backend/
│   ├── main.py          ← Must exist
│   ├── requirements.txt ← Must exist
│   └── Procfile        ← Optional
└── frontend/
    ├── package.json     ← Must exist
    ├── vite.config.ts   ← Must exist
    └── Procfile        ← Optional
```

### Step 3: Set Environment Variables

**Backend Variables:**
- `CORS_ORIGINS` = `https://your-frontend.railway.app`

**Frontend Variables:**
- `VITE_API_URL` = `https://your-backend.railway.app`

### Step 4: Deploy Order

1. **Deploy Backend first**
   - Wait for it to be healthy
   - Copy the URL

2. **Deploy Frontend**
   - Set `VITE_API_URL` to backend URL
   - Deploy (will rebuild with new env var)
   - Copy the URL

3. **Update Backend CORS**
   - Set `CORS_ORIGINS` to frontend URL
   - Backend will auto-redeploy

## Still Failing? Check Logs

1. Go to Railway dashboard
2. Click on your service
3. Click **Deployments** tab
4. Click on the failed deployment
5. Check **Build Logs** and **Deploy Logs**
6. Look for specific error messages

## Common Error Messages

**"uvicorn: command not found"**
- Solution: Check that `requirements.txt` includes `uvicorn[standard]`
- Verify Railway detected Python correctly

**"npm: command not found"**
- Solution: Check that Railway detected Node.js
- Verify `package.json` exists in frontend directory

**"Cannot find module 'main'"**
- Solution: Root directory must be `backend` (not empty)
- Verify `main.py` is in `backend/` directory

**"dist folder not found"**
- Solution: Build command must run before start command
- Frontend build must complete successfully

**"Port X is already in use"**
- Solution: Use `$PORT` variable, Railway sets this automatically
- Never hardcode port numbers

## Emergency Fix: Simplify Everything

If nothing works, try this minimal setup:

**Backend:**
- Root: `backend`
- Start: `uvicorn main:app --host 0.0.0.0 --port $PORT`
- Remove all custom config files (railway.json, nixpacks.toml)
- Keep only Procfile: `web: uvicorn main:app --host 0.0.0.0 --port $PORT`

**Frontend:**
- Root: `frontend`
- Build: `npm install && npm run build`
- Start: `vite preview --host 0.0.0.0 --port $PORT`
- Remove all custom config files
- Keep only Procfile: `web: vite preview --host 0.0.0.0 --port $PORT`

## Need More Help?

1. Check `RAILWAY_TROUBLESHOOTING.md` for detailed solutions
2. Check `DEPLOYMENT_CHECKLIST.md` for step-by-step verification
3. Railway Discord: https://discord.gg/railway
4. Railway Docs: https://docs.railway.app

