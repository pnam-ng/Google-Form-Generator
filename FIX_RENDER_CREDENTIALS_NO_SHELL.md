# 🔧 Upload credentials.json to Render WITHOUT Shell Access

## Problem

Render's free tier doesn't include shell access. You need alternative ways to upload `credentials.json`.

## Solution Options (Choose One)

### ✅ **Option 1: Add to Git Repository (Easiest - Testing Only)**

**⚠️ SECURITY WARNING:** Only use this for private repositories or testing!

#### Step 1: Temporarily Remove from .gitignore

Edit `.gitignore` and comment out or remove the line:
```
# credentials.json  # Temporarily allow this file
```

#### Step 2: Add to Git

```bash
git add credentials.json
git commit -m "Add credentials.json for Render deployment"
git push
```

#### Step 3: Remove from .gitignore Again

After pushing, uncomment the line in `.gitignore`:
```
credentials.json  # Back in gitignore
```

#### Step 4: Render Auto-Deploys

Render will automatically detect the new file and redeploy.

**⚠️ IMPORTANT:** 
- Only do this if your repository is **PRIVATE**
- Remove from git after deployment if possible
- Consider rotating credentials after deployment

---

### ✅ **Option 2: Use Build Script (Recommended for Production)**

Create a build script that downloads credentials from a secure location.

#### Step 1: Store Credentials Securely

Store your `credentials.json` in a secure location:
- Private S3 bucket
- Secure secret manager
- Encrypted storage service
- Private GitHub Gist (if you trust GitHub)

#### Step 2: Create Build Script

Create `build.sh` in your project root:

```bash
#!/bin/bash
# Download credentials.json from secure location
# Replace URL with your secure storage location
curl -o credentials.json https://your-secure-storage-url/credentials.json

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt
```

#### Step 3: Update render.yaml

```yaml
services:
  - type: web
    name: google-form-generator
    env: python
    buildCommand: bash build.sh
    startCommand: python -m gunicorn --config gunicorn_config.py app:app
    # ... rest of config
```

#### Step 4: Set Environment Variable for Credentials URL

In Render Dashboard → Environment:
- Add: `CREDENTIALS_URL` = your secure URL

Then update `build.sh`:
```bash
curl -o credentials.json $CREDENTIALS_URL
```

---

### ✅ **Option 3: Convert to Environment Variables (Advanced)**

Convert credentials.json to environment variables and modify code to read from them.

#### Step 1: Extract Values from credentials.json

Your `credentials.json` looks like:
```json
{
  "installed": {
    "client_id": "YOUR_CLIENT_ID",
    "project_id": "YOUR_PROJECT_ID",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "client_secret": "YOUR_CLIENT_SECRET",
    "redirect_uris": ["http://localhost"]
  }
}
```

#### Step 2: Set Environment Variables in Render

In Render Dashboard → Environment, add:
- `GOOGLE_CLIENT_ID` = your client_id
- `GOOGLE_CLIENT_SECRET` = your client_secret  
- `GOOGLE_PROJECT_ID` = your project_id

#### Step 3: Modify Code to Read from Environment

Update `google_form_generator.py` to create credentials from environment variables:

```python
import os
import json

def _get_credentials_from_env():
    """Create credentials.json content from environment variables."""
    client_id = os.getenv('GOOGLE_CLIENT_ID')
    client_secret = os.getenv('GOOGLE_CLIENT_SECRET')
    project_id = os.getenv('GOOGLE_PROJECT_ID')
    
    if not all([client_id, client_secret, project_id]):
        raise ValueError("Missing Google OAuth environment variables")
    
    credentials_data = {
        "installed": {
            "client_id": client_id,
            "project_id": project_id,
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "client_secret": client_secret,
            "redirect_uris": ["http://localhost"]
        }
    }
    
    # Write to file
    with open('credentials.json', 'w') as f:
        json.dump(credentials_data, f)
    
    return 'credentials.json'
```

Then call this in `__init__` before authentication.

---

### ✅ **Option 4: Use Render's Persistent Disk (Paid Plans)**

If you upgrade to a paid plan:
1. Go to your service settings
2. Add a persistent disk volume
3. Mount it to `/opt/render/project/src`
4. Upload files via Render's file manager (if available)

---

### ✅ **Option 5: Use GitHub Secrets + GitHub Actions (Advanced)**

1. Store credentials in GitHub Secrets
2. Use GitHub Actions to deploy
3. GitHub Actions can create the file during deployment

---

## Recommended Approach for Free Tier

**For quick testing:** Use Option 1 (add to private git repo)

**For production:** Use Option 3 (environment variables) - Most secure and free

## Step-by-Step: Environment Variables Method (Recommended)

### Step 1: Extract Credentials

Open your local `credentials.json` and note:
- `client_id`
- `client_secret`
- `project_id`

### Step 2: Set in Render Dashboard

1. Go to Render Dashboard → Your Service
2. Click **"Environment"** tab
3. Add these environment variables:
   ```
   GOOGLE_CLIENT_ID = your_client_id_here
   GOOGLE_CLIENT_SECRET = your_client_secret_here
   GOOGLE_PROJECT_ID = your_project_id_here
   ```

### Step 3: Update Code

I'll help you modify the code to read from environment variables. Let me know if you want this approach!

---

## Quick Decision Guide

- **Need it working NOW?** → Option 1 (add to private git)
- **Want it secure?** → Option 3 (environment variables)
- **Have secure storage?** → Option 2 (build script)
- **Want to pay?** → Option 4 (upgrade + persistent disk)

---

## Which Option Should I Use?

**Tell me which option you prefer, and I'll help you implement it!**

For most users, I recommend **Option 3 (Environment Variables)** as it's:
- ✅ Free
- ✅ Secure
- ✅ Works on free tier
- ✅ No shell access needed


