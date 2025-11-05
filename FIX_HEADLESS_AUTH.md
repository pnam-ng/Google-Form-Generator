# 🔧 Fix: "could not locate runnable browser" on Render

## Error Message

```
❌ Error initializing AI Creator: could not locate runnable browser
```

## Problem

On Render (headless server), OAuth can't open a browser for authentication. The code now uses console-based authentication instead.

## Solution Applied

The code now:
1. ✅ Tries browser-based auth first (for local development)
2. ✅ Falls back to console-based auth if browser unavailable (for Render)
3. ✅ Provides clear instructions for manual authorization

## How It Works Now

### On Render (First Time):

1. **First request** will trigger authentication
2. **Check Render logs** - you'll see:
   ```
   ⚠️  Browser-based authentication not available (headless server).
   Using console-based authentication...
   You'll need to manually authorize the application.
   
   Please visit this URL to authorize this application:
   https://accounts.google.com/o/oauth2/auth?...
   
   Enter the authorization code:
   ```

3. **Copy the authorization URL** from logs
4. **Visit the URL** in your browser
5. **Authorize** the application
6. **Copy the authorization code** from the success page
7. **The app will use the code** automatically (from logs)

### After First Auth:

- Token is saved to `token.pickle`
- Future requests use the saved token
- No manual authentication needed

## Alternative: Upload token.pickle

If you already have a `token.pickle` file from local development:

1. **Upload to Render:**
   - Same location as credentials.json
   - `/etc/secrets/token.pickle` (if using secrets path)

2. **The app will use it automatically**

## Quick Fix

The code change will automatically handle this. Just:
1. Deploy the updated code
2. On first request, check Render logs for authorization URL
3. Visit URL and authorize
4. Done!

---

**Note:** The updated code now uses `run_console()` instead of `run_local_server()` when browser is unavailable, which works perfectly on Render! 🎉


