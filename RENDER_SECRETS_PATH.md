# 📁 Using Render Secrets Path for credentials.json

## Your Setup

You've uploaded `credentials.json` to `/etc/secrets/credentials.json` on Render. The app will now automatically find it there!

## How It Works

The code now checks multiple locations for `credentials.json`:

1. **Environment variable** (`CREDENTIALS_FILE_PATH`) - if set
2. **`/etc/secrets/credentials.json`** - Render secrets path ✅ **Your location**
3. **`credentials.json`** - Project root (default)
4. **Other common locations**

## No Changes Needed!

The app will automatically find your file at `/etc/secrets/credentials.json`. You don't need to change anything!

## Optional: Set Environment Variable

If you want to be explicit, you can set an environment variable in Render:

1. Go to Render Dashboard → Your Service → Environment
2. Add environment variable:
   - **Key:** `CREDENTIALS_FILE_PATH`
   - **Value:** `/etc/secrets/credentials.json`
3. Save

This tells the app exactly where to look.

## Verification

Check your Render logs to see:
```
✅ Found credentials at: /etc/secrets/credentials.json
```

If you see this, it's working correctly!

## Alternative Locations

If you want to move the file, the app will check these locations automatically:

- `/etc/secrets/credentials.json` ✅ (your current location)
- `credentials.json` (project root)
- `/opt/render/project/src/credentials.json` (Render project path)

Just make sure the file exists and is readable!

---

**That's it!** Your credentials file at `/etc/secrets/credentials.json` will be automatically detected. 🎉


