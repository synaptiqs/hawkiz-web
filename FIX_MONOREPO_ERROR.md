# Fix: "Nixpacks was unable to generate a build plan" Error

## The Problem

Railway can't detect which directory to build because this is a monorepo (multiple services in one repo).

## The Solution: Set Root Directory

You need to configure the **Root Directory** for each service in Railway.

### Step 1: Configure Backend Service

1. In Railway dashboard, click on your **Backend Service**
2. Click **Settings** (gear icon) → **Service**
3. Scroll down to **Root Directory**
4. Set it to: `backend`
5. Click **Save**
6. Railway will automatically redeploy

### Step 2: Configure Frontend Service

1. In Railway dashboard, click on your **Frontend Service**
2. Click **Settings** (gear icon) → **Service**
3. Scroll down to **Root Directory**
4. Set it to: `frontend`
5. Click **Save**
6. Railway will automatically redeploy

## Alternative: Use "Configure root directory" Button

If you see the error screen:
1. Click the **"Configure root directory"** button (purple button on the right)
2. For Backend: Enter `backend`
3. For Frontend: Enter `frontend`
4. Save and redeploy

## Important Notes

- **Root Directory** must be exactly `backend` or `frontend` (lowercase, no leading slash)
- Each service (backend and frontend) needs its own Root Directory setting
- After setting Root Directory, Railway will automatically trigger a new deployment

## Verification

After setting Root Directory:
1. Go to **Deployments** tab
2. You should see a new deployment starting
3. Check **Build Logs** - it should now detect Python (backend) or Node.js (frontend)
4. The build should proceed successfully

## If It Still Fails

1. **Check file structure** - Make sure these files exist:
   - `backend/main.py`
   - `backend/requirements.txt`
   - `frontend/package.json`

2. **Check Root Directory spelling** - Must be exactly:
   - `backend` (not `Backend`, not `/backend`, not `./backend`)
   - `frontend` (not `Frontend`, not `/frontend`, not `./frontend`)

3. **Delete and recreate service** (last resort):
   - Delete the service
   - Create new service
   - **Immediately set Root Directory** before first deployment
   - Then configure other settings

## Quick Checklist

- [ ] Backend service has Root Directory = `backend`
- [ ] Frontend service has Root Directory = `frontend`
- [ ] Both services saved and redeployed
- [ ] Build logs show correct detection (Python/Node.js)
- [ ] Deployment succeeds

---

**This is the #1 cause of Railway deployment failures in monorepos!**

