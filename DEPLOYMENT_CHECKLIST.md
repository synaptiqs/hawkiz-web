# Railway Deployment Checklist

Use this checklist to ensure successful deployment.

## Pre-Deployment

- [ ] Code is pushed to GitHub
- [ ] All configuration files are committed
- [ ] Tested locally (backend and frontend work)

## Backend Service Setup

- [ ] Created new service in Railway
- [ ] Set **Root Directory** to: `backend`
- [ ] **Build Command**: (leave empty or auto-detect)
- [ ] **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
- [ ] Verified `main.py` exists in `backend/` directory
- [ ] Verified `requirements.txt` exists in `backend/` directory
- [ ] Added environment variable: `CORS_ORIGINS` = `*` (temporary)
- [ ] Deployment succeeds (check logs)
- [ ] Health check works: `https://your-backend.railway.app/health`
- [ ] **Copied backend URL** for frontend configuration

## Frontend Service Setup

- [ ] Created new service in Railway
- [ ] Set **Root Directory** to: `frontend`
- [ ] **Build Command**: `npm install && npm run build`
- [ ] **Start Command**: `vite preview --host 0.0.0.0 --port $PORT`
- [ ] Verified `package.json` exists in `frontend/` directory
- [ ] Added environment variable: `VITE_API_URL` = `https://your-backend-url.railway.app`
- [ ] Build completes successfully (check logs)
- [ ] Deployment succeeds (check logs)
- [ ] **Copied frontend URL** for CORS update

## Post-Deployment

- [ ] Updated backend `CORS_ORIGINS` with frontend URL
- [ ] Backend redeployed with new CORS settings
- [ ] Frontend loads in browser
- [ ] Frontend can connect to backend (check network tab)
- [ ] Health check endpoint works
- [ ] API endpoints respond correctly

## Troubleshooting

If deployment fails:

1. **Check Build Logs**
   - Look for error messages
   - Verify file paths are correct
   - Check for missing dependencies

2. **Check Deploy Logs**
   - Look for startup errors
   - Verify port binding
   - Check for module import errors

3. **Verify Configuration**
   - Root directory is correct
   - Start command is correct
   - Environment variables are set

4. **Common Issues**
   - Wrong root directory → Service can't find files
   - Missing dependencies → Build fails
   - Port issues → Use `$PORT` variable, not hardcoded
   - CORS errors → Update `CORS_ORIGINS` with frontend URL

## Quick Commands Reference

**Backend Start Command:**
```
uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Frontend Build Command:**
```
npm install && npm run build
```

**Frontend Start Command:**
```
vite preview --host 0.0.0.0 --port $PORT
```

## Environment Variables

**Backend:**
- `CORS_ORIGINS` = `https://your-frontend-url.railway.app`

**Frontend:**
- `VITE_API_URL` = `https://your-backend-url.railway.app`

---

**Remember**: Railway sets `$PORT` automatically - never hardcode port numbers!

