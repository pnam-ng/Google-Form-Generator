# Setting Up Credentials Path

## Default Location: `/etc/secrets/credentials.json`

The application now uses `/etc/secrets/credentials.json` as the primary location for credentials on both local and Render deployments.

## For Render.com

The credentials file should be at: `/etc/secrets/credentials.json`

This path is automatically checked and used. If you upload `credentials.json` to Render, place it in `/etc/secrets/` directory.

## For Local Development

### Windows

On Windows, creating `/etc/secrets/` may require administrator privileges. The application will:

1. Try to create `/etc/secrets/` directory automatically
2. If that fails (permission denied), it will fall back to `credentials.json` in the project root
3. You can manually create the directory with admin rights if needed

**To create manually (requires admin):**
1. Open Command Prompt as Administrator
2. Run: `mkdir C:\etc\secrets`
3. Place your `credentials.json` file there

**Or use project root (no admin needed):**
- Place `credentials.json` in the project root directory
- The app will use it as a fallback

### Linux/macOS

The `/etc/secrets/` directory can be created automatically. If it doesn't exist, the app will create it.

**To create manually:**
```bash
sudo mkdir -p /etc/secrets
sudo chmod 755 /etc/secrets
# Place your credentials.json there
sudo cp credentials.json /etc/secrets/
```

## Alternative: Use Environment Variables

Instead of uploading a file, you can set environment variables:

- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GOOGLE_PROJECT_ID`

The app will automatically create `/etc/secrets/credentials.json` from these variables.

## Verification

Check if credentials are configured:
- Visit: `http://localhost:5000/api/check-credentials` (local)
- Visit: `https://your-app.onrender.com/api/check-credentials` (Render)

This will show:
- Whether credentials file exists
- Which environment variables are set
- The path being used

