# Railway Deployment Guide

This guide will walk you through deploying the Hawkiz Web application to Railway.

## Prerequisites

1. A Railway account (sign up at [railway.app](https://railway.app))
2. GitHub account (your code is already on GitHub)
3. Railway CLI (optional, but recommended)

## Project Structure

Railway will deploy two separate services:
- **Backend**: FastAPI application (Python)
- **Frontend**: React + Vite application (Node.js)

## Deployment Steps

### Step 1: Install Railway CLI (Optional)

```powershell
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login
```

### Step 2: Create Railway Project

#### Option A: Using Railway Web Dashboard (Recommended)

1. Go to [railway.app](https://railway.app) and sign in
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose your repository: `synaptiqs/hawkiz-web`
5. Railway will detect the project structure

#### Option B: Using Railway CLI

```powershell
# Initialize Railway project
railway init

# Link to existing project or create new one
railway link
```

### Step 3: Deploy Backend Service

1. In Railway dashboard, click **"New Service"**
2. Select **"GitHub Repo"** and choose your repository
3. Railway will auto-detect it's a Python project
4. Configure the service:
   - **Root Directory**: `backend`
   - **Build Command**: (auto-detected)
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`

5. **Set Environment Variables**:
   - Click on the service → **Variables** tab
   - Add the following:
     ```
     CORS_ORIGINS=https://your-frontend-domain.railway.app,https://your-custom-domain.com
     ```
     (You'll update this after deploying the frontend)

6. **Deploy**: Railway will automatically build and deploy

7. **Get Backend URL**: 
   - After deployment, Railway will provide a URL like: `https://your-backend.railway.app`
   - Copy this URL - you'll need it for the frontend

### Step 4: Deploy Frontend Service

1. In Railway dashboard, click **"New Service"** again
2. Select **"GitHub Repo"** and choose the same repository
3. Configure the service:
   - **Root Directory**: `frontend`
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `npm run preview -- --host 0.0.0.0 --port $PORT`

4. **Set Environment Variables**:
   - Click on the service → **Variables** tab
   - Add the following:
     ```
     VITE_API_URL=https://your-backend.railway.app
     PORT=3000
     ```
     Replace `https://your-backend.railway.app` with your actual backend URL from Step 3

5. **Deploy**: Railway will build and deploy the frontend

6. **Get Frontend URL**: 
   - Railway will provide a URL like: `https://your-frontend.railway.app`

### Step 5: Update CORS Settings

1. Go back to your **Backend Service** → **Variables**
2. Update `CORS_ORIGINS` to include your frontend URL:
   ```
   CORS_ORIGINS=https://your-frontend.railway.app,https://your-custom-domain.com
   ```
3. Railway will automatically redeploy with the new settings

### Step 6: Custom Domains (Optional)

1. In Railway dashboard, select your service
2. Go to **Settings** → **Domains**
3. Click **"Generate Domain"** or **"Custom Domain"**
4. Follow the instructions to configure your domain

## Environment Variables Reference

### Backend Service

| Variable | Description | Example |
|----------|-------------|---------|
| `CORS_ORIGINS` | Comma-separated list of allowed origins | `https://app.example.com,https://www.example.com` |
| `PORT` | Server port (auto-set by Railway) | `8000` |

### Frontend Service

| Variable | Description | Example |
|----------|-------------|---------|
| `VITE_API_URL` | Backend API URL | `https://api.example.com` |
| `PORT` | Server port (auto-set by Railway) | `3000` |

## Verification

After deployment, test your application:

1. **Backend Health Check**:
   ```
   https://your-backend.railway.app/health
   ```
   Should return: `{"status":"healthy"}`

2. **Backend API Docs**:
   ```
   https://your-backend.railway.app/docs
   ```

3. **Frontend**:
   ```
   https://your-frontend.railway.app
   ```
   Should load your React application

## Troubleshooting

### Backend Issues

**Problem**: Backend not starting
- **Solution**: Check logs in Railway dashboard
- Verify `requirements.txt` is in the `backend` directory
- Ensure `main.py` exists in the `backend` directory

**Problem**: CORS errors
- **Solution**: Update `CORS_ORIGINS` environment variable to include your frontend URL
- Make sure there are no trailing slashes in the URLs

### Frontend Issues

**Problem**: Frontend can't connect to backend
- **Solution**: Verify `VITE_API_URL` is set correctly in frontend environment variables
- Check that the backend URL is accessible (try opening it in a browser)

**Problem**: Build fails
- **Solution**: Check build logs in Railway
- Ensure `package.json` is in the `frontend` directory
- Verify all dependencies are listed in `package.json`

### General Issues

**Problem**: Service not deploying
- **Solution**: 
  - Check Railway logs for errors
  - Verify root directory is set correctly (`backend` or `frontend`)
  - Ensure start command is correct

**Problem**: Port binding errors
- **Solution**: Railway automatically sets `$PORT` - don't hardcode port numbers
- Use `0.0.0.0` as host, not `localhost` or `127.0.0.1`

## Continuous Deployment

Railway automatically deploys when you push to your GitHub repository:

1. Push changes to GitHub:
   ```powershell
   git add .
   git commit -m "Your changes"
   git push
   ```

2. Railway will automatically:
   - Detect the changes
   - Build the services
   - Deploy the updates

## Monitoring

- **Logs**: View real-time logs in Railway dashboard
- **Metrics**: Monitor CPU, memory, and network usage
- **Alerts**: Set up alerts for service failures

## Cost Optimization

- Railway offers a free tier with $5 credit
- Monitor usage in the dashboard
- Consider using Railway's sleep feature for development environments

## Additional Resources

- [Railway Documentation](https://docs.railway.app)
- [Railway Discord](https://discord.gg/railway)
- [FastAPI Deployment Guide](https://fastapi.tiangolo.com/deployment/)

## Quick Deploy Commands (CLI)

If using Railway CLI:

```powershell
# Deploy backend
cd backend
railway up

# Deploy frontend
cd frontend
railway up

# View logs
railway logs

# Open in browser
railway open
```

---

**Need Help?** Check Railway's documentation or reach out on their Discord server.

