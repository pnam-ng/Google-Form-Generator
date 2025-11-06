# Quick OAuth Setup Guide

## For Render.com Deployment

### Step 1: Get Your OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project (or create a new one)
3. Navigate to **APIs & Services** → **Credentials**
4. Click **Create Credentials** → **OAuth client ID**
5. If prompted, configure the OAuth consent screen first
6. Choose **Web application** as the application type
7. Add authorized redirect URIs:
   - `https://your-app-name.onrender.com/auth/callback`
   - `http://localhost:5000/auth/callback` (for local testing)
8. Click **Create**
9. Copy the **Client ID** and **Client Secret**

### Step 2: Set Environment Variables in Render

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Select your web service
3. Go to **Environment** tab
4. Click **Add Environment Variable** for each:

   **GOOGLE_CLIENT_ID**
   - Value: Your OAuth Client ID (e.g., `123456789-abc.apps.googleusercontent.com`)

   **GOOGLE_CLIENT_SECRET**
   - Value: Your OAuth Client Secret (e.g., `GOCSPX-abc123...`)

   **GOOGLE_PROJECT_ID**
   - Value: Your Google Cloud Project ID (found at the top of Google Cloud Console)

5. Click **Save Changes**
6. Render will automatically redeploy

### Step 3: Verify Setup

1. After deployment, visit your app
2. Click **Sign in** button
3. You should be redirected to Google OAuth
4. After authorization, you'll be redirected back

## For Local Development

### Option 1: Use Environment Variables (Recommended)

Create a `.env` file in the project root:

```env
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_PROJECT_ID=your-project-id
```

### Option 2: Use credentials.json File

1. Download `credentials.json` from Google Cloud Console
2. Place it in the project root directory
3. The app will automatically detect it

## Troubleshooting

### Error: "Credentials file not found"

**Solution:** Set the environment variables in Render Dashboard (see Step 2 above)

### Error: "Invalid OAuth state"

**Solution:** Clear your browser cookies and try again

### Error: "Redirect URI mismatch"

**Solution:** Make sure you added the correct redirect URI in Google Cloud Console:
- Production: `https://your-app-name.onrender.com/auth/callback`
- Local: `http://localhost:5000/auth/callback`

## Check Credentials Status

Visit: `https://your-app.onrender.com/api/check-credentials`

This will show:
- Whether credentials file exists
- Which environment variables are set
- Overall configuration status

