# Railway Deployment Troubleshooting

## Common Issues and Fixes

### Issue 1: Backend Fails to Start

**Symptoms:**
- Build succeeds but service crashes
- "Module not found" errors
- Port binding errors

**Fixes:**
1. **Verify Root Directory**: Must be set to `backend` in Railway service settings
2. **Check Start Command**: Should be `uvicorn main:app --host 0.0.0.0 --port $PORT`
3. **Verify requirements.txt**: Must be in `backend/` directory
4. **Check main.py**: Must be in `backend/` directory (not `backend/app/`)

### Issue 2: Frontend Build Fails

**Symptoms:**
- Build timeout
- npm install errors
- TypeScript compilation errors

**Fixes:**
1. **Verify Root Directory**: Must be set to `frontend` in Railway service settings
2. **Check Build Command**: Should be `npm install && npm run build`
3. **Verify package.json**: Must be in `frontend/` directory
4. **Check Node Version**: Railway should auto-detect, but can set in nixpacks.toml

### Issue 3: Frontend Preview Fails

**Symptoms:**
- Service starts but immediately crashes
- Port binding errors
- "dist folder not found" errors

**Fixes:**
1. **Build must complete first**: Frontend needs `dist/` folder from build
2. **Check Start Command**: Should be `vite preview --host 0.0.0.0 --port $PORT`
3. **Verify PORT variable**: Railway sets this automatically

### Issue 4: CORS Errors

**Symptoms:**
- Frontend can't connect to backend
- CORS policy errors in browser console

**Fixes:**
1. **Set CORS_ORIGINS**: In backend service variables, add:
   ```
   CORS_ORIGINS=https://your-frontend-url.railway.app
   ```
2. **No trailing slashes**: Don't include trailing `/` in URLs
3. **Include protocol**: Must include `https://`

### Issue 5: Environment Variables Not Working

**Symptoms:**
- Frontend can't find backend
- API calls fail

**Fixes:**
1. **Set VITE_API_URL**: In frontend service variables:
   ```
   VITE_API_URL=https://your-backend-url.railway.app
   ```
2. **Rebuild required**: Vite env vars are baked into build, so rebuild after changing
3. **No quotes needed**: Don't wrap values in quotes

## Step-by-Step Debugging

### 1. Check Railway Logs

In Railway dashboard:
1. Go to your service
2. Click **"Deployments"** tab
3. Click on latest deployment
4. Check **"Build Logs"** and **"Deploy Logs"**

### 2. Verify Service Configuration

**Backend Service:**
- Root Directory: `backend`
- Build Command: (leave empty, auto-detected)
- Start Command: `uvicorn main:app --host 0.0.0.0 --port $PORT`

**Frontend Service:**
- Root Directory: `frontend`
- Build Command: `npm install && npm run build`
- Start Command: `vite preview --host 0.0.0.0 --port $PORT`

### 3. Test Locally First

Before deploying, test the build commands locally:

**Backend:**
```powershell
cd backend
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8001
```

**Frontend:**
```powershell
cd frontend
npm install
npm run build
npm run preview -- --host 0.0.0.0 --port 3000
```

### 4. Common Error Messages

**"ModuleNotFoundError: No module named 'fastapi'"**
- Solution: Verify `requirements.txt` is in `backend/` directory
- Check that Railway is using correct root directory

**"Error: Cannot find module"**
- Solution: Verify `package.json` is in `frontend/` directory
- Check that all dependencies are listed

**"Port already in use"**
- Solution: Railway sets `$PORT` automatically, don't hardcode ports
- Use `0.0.0.0` as host, not `localhost`

**"dist folder not found"**
- Solution: Build command must run before start command
- Check that build completed successfully

## Quick Fixes

### Fix 1: Simplify Configuration

Remove nixpacks.toml files and let Railway auto-detect:
- Railway's Nixpacks is usually smart enough
- Only add custom config if needed

### Fix 2: Use Procfile Only

Railway prefers Procfile over other configs:
- Keep Procfile simple
- Use `$PORT` variable (Railway sets this)

### Fix 3: Check File Locations

Ensure files are in correct directories:
```
backend/
  ├── main.py          ← Must be here
  ├── requirements.txt ← Must be here
  └── Procfile        ← Optional but helpful

frontend/
  ├── package.json    ← Must be here
  ├── vite.config.ts  ← Must be here
  └── Procfile        ← Optional but helpful
```

## Still Having Issues?

1. **Check Railway Status**: [status.railway.app](https://status.railway.app)
2. **Railway Discord**: Join for community support
3. **Railway Docs**: [docs.railway.app](https://docs.railway.app)
4. **View Logs**: Always check deployment logs first

