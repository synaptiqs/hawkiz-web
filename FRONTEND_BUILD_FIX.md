# Frontend Build Fix for Railway

## ✅ Fixed Configuration

I've updated the Railway configuration files. Here's what changed:

### 1. Updated `frontend/railway.json`
- Added explicit `buildCommand`: `npm install && npm run build`
- This ensures Railway knows to build before starting

### 2. Created `frontend/railway.toml`
- Alternative configuration format
- Same settings as railway.json

### 3. Updated `frontend/Procfile`
- Added PORT fallback: `${PORT:-3000}`

---

## 🔧 Railway Dashboard Settings

In Railway dashboard, make sure your **Frontend Service** has:

### Service Settings:
- **Root Directory**: `frontend` ✅
- **Build Command**: `npm install && npm run build` ✅
- **Start Command**: `vite preview --host 0.0.0.0 --port $PORT` ✅

### Environment Variables:
- `VITE_API_URL` = `https://your-backend-url.railway.app`
- `NODE_ENV` = `production` (optional)

---

## 🚨 Common Build Issues & Fixes

### Issue 1: "No build plan detected"
**Fix**: 
- Set **Root Directory** to `frontend` explicitly
- Add build command: `npm install && npm run build`

### Issue 2: TypeScript compilation errors
**Fix**: 
- Check `tsconfig.json` is valid
- Try: `npm run build` locally first
- If errors, fix TypeScript issues before deploying

### Issue 3: "vite preview" not found
**Fix**:
- Make sure `vite` is in `dependencies` (not just devDependencies)
- Or use: `npx vite preview --host 0.0.0.0 --port $PORT`

### Issue 4: Build succeeds but service crashes
**Fix**:
- Check PORT variable is set
- Verify `dist/` folder is created after build
- Check build logs for warnings

---

## 🧪 Test Locally First

Before deploying, test the build locally:

```powershell
cd frontend
npm install
npm run build
vite preview --host 0.0.0.0 --port 3000
```

If this works locally, it should work on Railway!

---

## 📋 Alternative: Use Node.js Server

If `vite preview` doesn't work, you can use a simple Node.js server:

### Create `frontend/server.js`:
```javascript
import express from 'express';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
const port = process.env.PORT || 3000;

app.use(express.static(join(__dirname, 'dist')));

app.get('*', (req, res) => {
  res.sendFile(join(__dirname, 'dist', 'index.html'));
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
});
```

### Update `package.json`:
```json
{
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

### Update Railway Start Command:
```
node server.js
```

---

## ✅ Verification Checklist

After deploying, check:

- [ ] Build completes successfully (check build logs)
- [ ] Service starts without errors
- [ ] Frontend URL loads in browser
- [ ] API calls work (check browser console)
- [ ] No 404 errors for static assets

---

## 🆘 Still Having Issues?

1. **Check Railway build logs** - Look for specific error messages
2. **Test build locally** - `npm run build` should work
3. **Verify root directory** - Must be exactly `frontend` (lowercase)
4. **Check Node version** - Railway should auto-detect from package.json

If you share the specific error from Railway logs, I can help debug further!

