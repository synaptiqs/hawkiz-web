# Railway Root Directory Configuration

## 🎯 Root Directory Settings

For Railway deployment, you need to set **two separate services** with different root directories:

### Backend Service
- **Root Directory**: `backend`
- **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
- **Build Command**: (auto-detected from `requirements.txt`)

### Frontend Service  
- **Root Directory**: `frontend`
- **Build Command**: `npm install && npm run build`
- **Start Command**: `vite preview --host 0.0.0.0 --port $PORT`

---

## 📋 Step-by-Step Configuration

### In Railway Dashboard:

#### 1. Backend Service Setup
1. Go to your Railway project
2. Click **"New Service"** → **"GitHub Repo"**
3. Select your repository: `synaptiqs/hawkiz-web`
4. **Service Settings**:
   - **Name**: `backend` (or `api`)
   - **Root Directory**: `backend` ⬅️ **IMPORTANT!**
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
5. **Environment Variables**:
   - `CORS_ORIGINS` = `*` (temporary, update after frontend is deployed)
   - `DATABASE_URL` = (if using PostgreSQL)
6. Click **"Deploy"**

#### 2. Frontend Service Setup
1. In the same Railway project, click **"New Service"** again
2. Select **"GitHub Repo"** → Choose `synaptiqs/hawkiz-web`
3. **Service Settings**:
   - **Name**: `frontend` (or `web`)
   - **Root Directory**: `frontend` ⬅️ **IMPORTANT!**
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `vite preview --host 0.0.0.0 --port $PORT`
4. **Environment Variables**:
   - `VITE_API_URL` = `https://your-backend-url.railway.app` (get from backend service)
5. Click **"Deploy"**

---

## 🔍 How to Set Root Directory in Railway

### Option 1: During Service Creation
1. When creating a new service from GitHub
2. Click **"Configure"** or **"Settings"** button
3. Find **"Root Directory"** field
4. Enter: `backend` or `frontend` (no leading slash, lowercase)

### Option 2: After Service Creation
1. Go to your service in Railway dashboard
2. Click **"Settings"** tab
3. Scroll to **"Root Directory"** section
4. Enter: `backend` or `frontend`
5. Click **"Save"**
6. Railway will automatically redeploy

---

## ✅ Verification

### Backend Service Should:
- ✅ Find `requirements.txt` in the `backend/` directory
- ✅ Find `main.py` in the `backend/` directory
- ✅ Successfully install Python dependencies
- ✅ Start with `uvicorn main:app`

### Frontend Service Should:
- ✅ Find `package.json` in the `frontend/` directory
- ✅ Successfully run `npm install`
- ✅ Successfully run `npm run build`
- ✅ Start with `vite preview`

---

## 🚨 Common Mistakes

### ❌ Wrong Root Directory
- **Backend**: Root = `/` or empty → Won't find `requirements.txt`
- **Frontend**: Root = `/` or empty → Won't find `package.json`

### ✅ Correct Root Directory
- **Backend**: Root = `backend` → Finds `backend/requirements.txt` ✅
- **Frontend**: Root = `frontend` → Finds `frontend/package.json` ✅

---

## 📁 File Structure Reference

```
hawkiz-web/                    ← Repository root
├── backend/                   ← Backend root directory
│   ├── main.py               ← Entry point (uvicorn main:app)
│   ├── requirements.txt      ← Python dependencies
│   ├── app/                   ← Application code
│   │   ├── main.py          ← Full app with routes
│   │   └── ...
│   └── railway.json          ← Railway config (optional)
│
└── frontend/                  ← Frontend root directory
    ├── package.json          ← Node dependencies
    ├── vite.config.ts        ← Vite config
    └── src/                  ← Source code
```

---

## 🔧 Railway Configuration Files

Railway will automatically detect these files if they exist in the root directory:

### Backend (`backend/` root):
- `railway.json` or `railway.toml` - Service configuration
- `Procfile` - Start command
- `requirements.txt` - Python dependencies
- `runtime.txt` - Python version (optional)

### Frontend (`frontend/` root):
- `railway.json` or `railway.toml` - Service configuration
- `Procfile` - Start command
- `package.json` - Node dependencies
- `vite.config.ts` - Build configuration

---

## 💡 Pro Tips

1. **Always set root directory** - Railway won't auto-detect for monorepos
2. **Use lowercase** - `backend` not `Backend` or `BACKEND`
3. **No leading slash** - `backend` not `/backend`
4. **Check build logs** - If build fails, verify root directory is correct
5. **Test locally first** - Make sure it works locally before deploying

---

## 🆘 Troubleshooting

### Build fails with "file not found"
- ✅ Check root directory is set correctly
- ✅ Verify file exists in that directory
- ✅ Check for typos (case-sensitive)

### "No build plan detected"
- ✅ Set root directory explicitly
- ✅ Verify `package.json` or `requirements.txt` exists in root directory

### Service starts but returns 404
- ✅ Check start command uses correct file path
- ✅ Verify `main.py` exists in backend root directory

---

## 📝 Quick Reference

| Service | Root Directory | Start Command |
|---------|---------------|---------------|
| Backend | `backend` | `uvicorn main:app --host 0.0.0.0 --port $PORT` |
| Frontend | `frontend` | `vite preview --host 0.0.0.0 --port $PORT` |

