# Railway Frontend Build Configuration

## ✅ Current Setup

The frontend is configured with:
- **Root Directory**: `frontend`
- **Build Command**: `npm install && npm run build`
- **Start Command**: `vite preview --host 0.0.0.0 --port $PORT`

## 🔧 Railway Dashboard Settings

When setting up the frontend service in Railway:

1. **Service Name**: `frontend`
2. **Root Directory**: `frontend` (lowercase, no slash)
3. **Build Command**: `npm install && npm run build`
4. **Start Command**: `vite preview --host 0.0.0.0 --port $PORT`

## ⚠️ Important Notes

- Vite must be in `dependencies` (not just `devDependencies`) for `vite preview` to work
- The build creates a `dist/` folder that `vite preview` serves
- Make sure TypeScript compilation succeeds (`tsc` in build script)

## 🚨 If Build Still Fails

### Option 1: Use npx (if vite not in dependencies)
Change start command to:
```
npx vite preview --host 0.0.0.0 --port $PORT
```

### Option 2: Move vite to dependencies
In `package.json`, move `vite` from `devDependencies` to `dependencies`

### Option 3: Use Express server (most reliable)
See `FRONTEND_BUILD_FIX.md` for Express server setup

