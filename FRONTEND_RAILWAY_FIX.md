# Frontend Railway Build Fix

## ✅ What I Fixed

1. **Updated `frontend/railway.json`**:
   - Added explicit `buildCommand`: `npm install && npm run build`
   - Changed start command to use `npx vite preview` (works even if vite is in devDependencies)

2. **Updated `frontend/railway.toml`**:
   - Same configuration in TOML format
   - Uses `npx vite preview`

3. **Updated `frontend/Procfile`**:
   - Uses `npx vite preview` with PORT fallback

---

## 🎯 Railway Dashboard Settings

In Railway, set your **Frontend Service** to:

### Service Configuration:
- **Root Directory**: `frontend` ✅
- **Build Command**: `npm install && npm run build` ✅
- **Start Command**: `npx vite preview --host 0.0.0.0 --port $PORT` ✅

---

## 🔍 Why `npx`?

- `npx` will find `vite` even if it's in `devDependencies`
- Works in production environments where devDependencies might not be installed
- More reliable than assuming `vite` is in PATH

---

## 🧪 Test Before Deploying

Test the build locally:

```powershell
cd frontend
npm install
npm run build
npx vite preview --host 0.0.0.0 --port 3000
```

If this works locally, Railway should work too!

---

## 🚨 If Build Still Fails

### Check Railway Build Logs For:

1. **TypeScript Errors**:
   - Fix any TypeScript compilation errors
   - Check `tsconfig.json` is valid

2. **Missing Dependencies**:
   - Verify all dependencies are in `package.json`
   - Check for peer dependency warnings

3. **Build Output**:
   - Make sure `dist/` folder is created
   - Check for build warnings

4. **Port Issues**:
   - Railway sets `$PORT` automatically
   - Don't hardcode port numbers

---

## 📋 Alternative: Express Server (If Vite Preview Fails)

If `vite preview` still doesn't work, use Express:

### 1. Add Express to dependencies:
```json
"dependencies": {
  "express": "^4.18.2"
}
```

### 2. Create `frontend/server.js`:
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

### 3. Update Railway Start Command:
```
node server.js
```

---

## ✅ Verification

After deploying:
- [ ] Build completes successfully
- [ ] Service starts without errors  
- [ ] Frontend URL loads
- [ ] No console errors in browser
- [ ] API calls work

---

## 💡 Pro Tip

Railway installs both `dependencies` and `devDependencies` by default, so `npx vite preview` should work. If it doesn't, the Express server option is more reliable.

