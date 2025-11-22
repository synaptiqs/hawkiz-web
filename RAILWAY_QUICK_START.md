# Railway Quick Start Guide

## 🚀 Quick Deployment Steps

### 1. Sign Up / Login to Railway
- Go to [railway.app](https://railway.app)
- Sign in with GitHub

### 2. Create New Project
1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Choose: `synaptiqs/hawkiz-web`

### 3. Deploy Backend (First Service)

1. Click **"New Service"** → **"GitHub Repo"** → Select your repo
2. Configure:
   - **Name**: `backend` (or `hawkiz-backend`)
   - **Root Directory**: `backend`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`

3. Add Environment Variable:
   - Go to **Variables** tab
   - Add: `CORS_ORIGINS` = `*` (temporary, update after frontend deploys)

4. Wait for deployment to complete
5. **Copy the generated URL** (e.g., `https://hawkiz-backend.railway.app`)

### 4. Deploy Frontend (Second Service)

1. Click **"New Service"** → **"GitHub Repo"** → Select your repo
2. Configure:
   - **Name**: `frontend` (or `hawkiz-frontend`)
   - **Root Directory**: `frontend`
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `npm run preview -- --host 0.0.0.0 --port $PORT`

3. Add Environment Variable:
   - Go to **Variables** tab
   - Add: `VITE_API_URL` = `https://your-backend-url.railway.app`
     (Use the URL you copied from Step 3)

4. Wait for deployment to complete
5. **Copy the generated URL** (e.g., `https://hawkiz-frontend.railway.app`)

### 5. Update Backend CORS

1. Go back to **Backend Service** → **Variables**
2. Update `CORS_ORIGINS`:
   ```
   https://your-frontend-url.railway.app
   ```
   (Use the frontend URL from Step 4)

3. Railway will automatically redeploy

### 6. Test Your Deployment

- **Frontend**: Open `https://your-frontend-url.railway.app`
- **Backend Health**: `https://your-backend-url.railway.app/health`
- **API Docs**: `https://your-backend-url.railway.app/docs`

## ✅ That's It!

Your application is now live on Railway!

## 📝 Important Notes

- Railway automatically sets the `$PORT` environment variable
- Always use `0.0.0.0` as the host, not `localhost`
- Update `CORS_ORIGINS` after both services are deployed
- Changes pushed to GitHub will auto-deploy

## 🔧 Troubleshooting

**Backend won't start?**
- Check logs in Railway dashboard
- Verify `requirements.txt` exists in `backend/` directory

**Frontend can't connect?**
- Verify `VITE_API_URL` matches your backend URL exactly
- Check backend CORS settings include frontend URL

**Build fails?**
- Check build logs for specific errors
- Verify all dependencies are in `package.json` or `requirements.txt`

---

For detailed instructions, see [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md)

