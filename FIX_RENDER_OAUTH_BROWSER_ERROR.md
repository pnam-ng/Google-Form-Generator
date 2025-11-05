# 🔧 Fix: "could not locate runnable browser" on Render

## Error Message

```
✅ Using Gemini model: gemini-2.0-flash-exp
✅ Found credentials at: credentials.json
❌ Error initializing AI Creator: could not locate runnable browser
```

## What This Means

This is **NOT** a Gemini API error! It's an **OAuth authentication error** that happens on first startup on Render (headless server).

The app needs to authenticate with Google on first startup, but Render can't open a browser. The code now automatically uses console-based authentication.

## Quick Fix (Automatic)

The code has been updated to automatically handle this. After deploying:

1. **First request** will trigger authentication
2. **Check Render logs** - you'll see:
   ```
   ⚠️  Browser-based authentication not available (headless server)
   Using console-based authentication...
   Please check the logs below for the authorization URL.
   ```

3. **Look for the authorization URL** in the logs:
   ```
   Please visit this URL to authorize this application:
   https://accounts.google.com/o/oauth2/auth?...
   ```

4. **Copy and visit the URL** in your browser
5. **Authorize** the application
6. **Copy the authorization code** from the success page
7. **The app will complete authentication** automatically

## Alternative: Upload token.pickle

If you already have a `token.pickle` file from local development:

### Option 1: Upload via Render Shell

1. **Go to Render Dashboard** → Your Service → **Shell** tab
2. **Upload token.pickle**:
   ```bash
   nano token.pickle
   # Paste binary content (or use file upload if available)
   ```

### Option 2: Use Environment Variables

Set these in Render Dashboard → Environment tab:

```
GOOGLE_CLIENT_ID=your_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_client_secret
GOOGLE_PROJECT_ID=your_project_id
```

The app will create `credentials.json` automatically, but you still need to authenticate once.

## After First Authentication

Once authenticated:
- Token is saved to `token.pickle`
- Future requests use the saved token
- No manual authentication needed
- The error will not appear again

## Verify It's Working

After authentication, check Render logs:
- Should see: `✅ Authentication successful!`
- Should see: `✅ Using Gemini model: gemini-2.0-flash-exp`
- No more "could not locate runnable browser" errors

## Still Having Issues?

### Issue 1: Can't find authorization URL in logs

**Solution:**
- Scroll through all Render logs
- Look for "Please visit this URL"
- The URL might be in a previous log entry

### Issue 2: Authorization code doesn't work

**Solution:**
- Make sure you copy the entire code
- No extra spaces
- Paste it exactly as shown

### Issue 3: Token expires

**Solution:**
- Re-authenticate using the same process
- Or upload a fresh `token.pickle`

## Prevention

To avoid this on future deployments:

1. **Keep token.pickle** in your deployment
2. **Or** set up OAuth to use per-user authentication (login button)
3. **Or** use service account credentials (more complex)

---

**Quick Answer:** This is normal on first startup. Check Render logs for the authorization URL, visit it, authorize, and you're done! 🎉

