# ✅ Render Deployment - Current Setup

## Files in Root (Required by Render)

The following files are in the project root for Render deployment:

- ✅ `render.yaml` - Render service configuration
- ✅ `Procfile` - Process file (alternative to render.yaml)
- ✅ `gunicorn_config.py` - Gunicorn server configuration
- ✅ `requirements.txt` - Python dependencies
- ✅ `app.py` - Main Flask application
- ✅ All core Python modules (in root)

## Project Structure

```
GoogleFormGenerate/
├── app.py                      # ✅ Main Flask app (Render will use this)
├── gunicorn_config.py          # ✅ Gunicorn config (referenced in Procfile)
├── render.yaml                 # ✅ Render config (in root for Render)
├── Procfile                    # ✅ Process file (in root for Render)
├── requirements.txt            # ✅ Dependencies
│
├── deployment/                 # Organized deployment files
│   ├── render.yaml             # (backup copy)
│   ├── Procfile                # (backup copy)
│   └── ...                     # Other platform configs
│
├── static/                     # ✅ Web UI assets
├── templates/                  # ✅ Web UI templates
└── uploads/                    # ✅ User uploads (created automatically)
```

## Render Configuration

### Build Command
```bash
pip install --upgrade pip && pip install -r requirements.txt
```

### Start Command
```bash
python -m gunicorn --config gunicorn_config.py app:app
```

### Required Environment Variables

Set these in Render Dashboard → Environment tab:

1. **GEMINI_API_KEY** - Your Gemini API key
   - Get from: https://aistudio.google.com/app/apikey

2. **SECRET_KEY** - Flask session secret
   - Generate: `python -c "import secrets; print(secrets.token_hex(32))"`

3. **FLASK_ENV** = `production`

4. **DEBUG** = `False`

5. **PORT** = `5000` (Render sets this automatically, but include for safety)

### Optional: OAuth Credentials

You can set these as environment variables (recommended):

- **GOOGLE_CLIENT_ID** - OAuth client ID
- **GOOGLE_CLIENT_SECRET** - OAuth client secret  
- **GOOGLE_PROJECT_ID** - Google Cloud project ID

Or upload `credentials.json` to `/etc/secrets/credentials.json` on Render.

## Verification Checklist

Before deploying, ensure:

- [x] `render.yaml` is in root directory
- [x] `Procfile` is in root directory
- [x] `gunicorn_config.py` is in root directory
- [x] `app.py` is in root directory
- [x] `requirements.txt` includes `gunicorn>=21.2.0`
- [x] All environment variables are set in Render Dashboard
- [x] `static/` and `templates/` folders are present
- [x] `uploads/` directory will be created automatically

## Deployment Steps

1. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Ready for Render deployment"
   git push origin main
   ```

2. **Deploy on Render:**
   - Go to https://render.com
   - New → Web Service
   - Connect GitHub repository
   - Render will auto-detect `render.yaml`
   - Or manually configure using `Procfile`

3. **Set Environment Variables:**
   - Go to Render Dashboard → Environment tab
   - Add all required variables (see above)

4. **Deploy:**
   - Click "Create Web Service"
   - Wait for build to complete
   - Check logs for any errors

## Troubleshooting

### If deployment fails:

1. **Check build logs** for missing dependencies
2. **Verify start command** uses `python -m gunicorn`
3. **Check environment variables** are all set
4. **Verify file paths** - all core files should be in root

### Common Issues:

- **"gunicorn: command not found"** → Use `python -m gunicorn` (already configured)
- **"Module not found"** → Check `requirements.txt` includes all dependencies
- **"Credentials not found"** → Set OAuth env vars or upload credentials.json

## Notes

- The `deployment/` folder contains organized copies of config files
- Files in root are the active ones used by Render
- Both `render.yaml` and `Procfile` are present (Render can use either)
- The project structure is organized while maintaining Render compatibility

