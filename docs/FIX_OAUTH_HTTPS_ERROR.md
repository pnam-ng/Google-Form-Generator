# 🔒 Fix OAuth HTTPS Error

## Error Message

```
{"error":"OAuth callback failed: (insecure_transport) OAuth 2 MUST utilize https.","success":false}
```

## Problem

Google's OAuth library requires HTTPS for security. By default, it blocks HTTP connections.

## Solutions

### ✅ Solution 1: Development Mode (Local Testing)

For **local development only**, the app now automatically enables insecure transport (HTTP) when:
- `FLASK_ENV=development` OR
- `DEBUG=True`

**This is already configured in the code!** Just make sure your `.env` file has:

```env
FLASK_ENV=development
# OR
DEBUG=True
```

**⚠️ WARNING:** Never enable `OAUTHLIB_INSECURE_TRANSPORT` in production!

---

### ✅ Solution 2: Production (HTTPS Required)

For production deployments (Render, Railway, etc.), you **MUST** use HTTPS:

1. **Set environment variable:**
   ```env
   FLASK_ENV=production
   ```

2. **Configure OAuth redirect URI in Google Cloud Console:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Navigate to **APIs & Services** → **Credentials**
   - Edit your OAuth 2.0 Client ID (Web application)
   - Add **Authorized redirect URIs**:
     - `https://your-app.onrender.com/auth/callback`
     - `https://your-app.railway.app/auth/callback`
     - (Replace with your actual domain)

3. **Ensure your deployment platform provides HTTPS:**
   - ✅ Render.com: HTTPS enabled by default
   - ✅ Railway.app: HTTPS enabled by default
   - ✅ Heroku: HTTPS enabled by default

---

### ✅ Solution 3: Local HTTPS with ngrok (Advanced)

If you need HTTPS for local testing:

1. **Install ngrok:**
   ```bash
   # Windows (chocolatey)
   choco install ngrok
   
   # macOS (homebrew)
   brew install ngrok
   
   # Or download from https://ngrok.com/
   ```

2. **Start your Flask app:**
   ```bash
   python app.py
   ```

3. **In another terminal, start ngrok:**
   ```bash
   ngrok http 5000
   ```

4. **Copy the HTTPS URL** (e.g., `https://abc123.ngrok.io`)

5. **Update Google Cloud Console:**
   - Add `https://abc123.ngrok.io/auth/callback` to authorized redirect URIs

6. **Set environment variable:**
   ```env
   FLASK_ENV=production
   ```

7. **Access your app via the ngrok URL**

---

## Quick Fix for Local Development

**If you're running locally and seeing this error:**

1. **Check your `.env` file:**
   ```env
   FLASK_ENV=development
   ```

2. **Or set environment variable:**
   ```bash
   # Windows PowerShell
   $env:FLASK_ENV="development"
   
   # Windows CMD
   set FLASK_ENV=development
   
   # macOS/Linux
   export FLASK_ENV=development
   ```

3. **Restart your Flask app**

The app will automatically allow HTTP in development mode.

---

## Verification

After fixing, you should see in your console:
```
⚠️  Development mode: OAuth insecure transport enabled (HTTP allowed)
   ⚠️  WARNING: This should NEVER be enabled in production!
```

If you see this, HTTP is enabled for local development.

---

## Security Notes

1. **Never set `OAUTHLIB_INSECURE_TRANSPORT=1` in production**
2. **Always use HTTPS in production**
3. **Keep your OAuth credentials secure**
4. **Use environment variables for sensitive configuration**

---

## Still Having Issues?

1. **Check your environment variables:**
   ```bash
   echo $FLASK_ENV  # macOS/Linux
   echo %FLASK_ENV%  # Windows CMD
   ```

2. **Verify OAuth redirect URI matches:**
   - Local: `http://localhost:5000/auth/callback`
   - Production: `https://your-domain.com/auth/callback`

3. **Check Google Cloud Console credentials:**
   - Ensure redirect URI is added
   - Ensure OAuth client is "Web application" type (not Desktop)

4. **Clear browser cache and cookies** - sometimes OAuth state gets cached


