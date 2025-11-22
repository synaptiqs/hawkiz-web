# Nixpacks Build Failure - Common Issues & Fixes

## Common Nixpacks Build Failures

### Issue 1: Nixpacks Can't Detect Project Type

**Symptoms:**
- "Nixpacks was unable to generate a build plan"
- Build fails immediately

**Fix:**
1. **Set Root Directory** in Railway dashboard:
   - Backend: `backend`
   - Frontend: `frontend`
2. **Remove conflicting configs** - Railway might be confused by multiple config files

### Issue 2: Python Version Mismatch

**Symptoms:**
- "Python version not found"
- Package installation fails

**Fix:**
- Ensure `runtime.txt` specifies correct Python version
- Or let Nixpacks auto-detect (remove nixpacks.toml)

### Issue 3: Missing Dependencies

**Symptoms:**
- "Module not found" errors
- Import errors during build

**Fix:**
- Verify `requirements.txt` is in `backend/` directory
- Check all dependencies are listed

### Issue 4: Build Command Fails

**Symptoms:**
- Build phase fails
- TypeScript compilation errors

**Fix:**
- Verify `package.json` build script is correct
- Check TypeScript configuration

## Recommended Fix: Simplify Configuration

Railway's Nixpacks is usually smart enough to auto-detect. Sometimes custom configs cause issues.

### Option 1: Remove Custom Nixpacks Configs (Let Railway Auto-Detect)

1. Delete or rename `backend/nixpacks.toml`
2. Delete or rename `frontend/nixpacks.toml`
3. Let Railway auto-detect based on:
   - `requirements.txt` (Python)
   - `package.json` (Node.js)

### Option 2: Fix Nixpacks Configs

Ensure configs are minimal and correct.

## Quick Diagnostic Steps

1. **Check Railway Logs:**
   - Go to Railway dashboard
   - Click on failed deployment
   - Check "Build Logs" for specific error

2. **Verify Root Directory:**
   - Service → Settings → Service
   - Root Directory must be set correctly

3. **Check File Locations:**
   - `backend/main.py` must exist
   - `backend/requirements.txt` must exist
   - `frontend/package.json` must exist

4. **Test Locally:**
   - Try building locally to catch errors early

