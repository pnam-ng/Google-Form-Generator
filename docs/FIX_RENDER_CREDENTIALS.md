# 🔧 Fix: credentials.json Not Found on Render

## Error Message

```
Error initializing AI Creator: Credentials file 'credentials.json' not found. 
Please download it from Google Cloud Console and place it in the project root.
```

## Problem

The `credentials.json` file is required for Google OAuth authentication but is not present on Render. This file contains your OAuth 2.0 credentials from Google Cloud Console.

## Solution: Upload credentials.json to Render

### Method 1: Using Render Shell (Recommended)

#### Step 1: Get Your credentials.json
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Go to **"APIs & Services"** → **"Credentials"**
4. Find your OAuth 2.0 Client ID
5. Click the download icon (⬇️) to download JSON
6. Save it as `credentials.json` on your local computer

#### Step 2: Upload to Render via Shell

1. **Go to Render Dashboard:**
   - Visit: https://dashboard.render.com/
   - Click on your service

2. **Open Render Shell:**
   - Click **"Shell"** tab in the left sidebar
   - Or click **"Connect"** button to open a terminal

3. **Upload credentials.json:**
   ```bash
   # Create the file
   nano credentials.json
   ```
   
4. **Paste your credentials.json content:**
   - Copy the entire contents of your local `credentials.json` file
   - Paste into the nano editor (right-click or Ctrl+Shift+V)
   - Press `Ctrl+O` to save
   - Press `Enter` to confirm filename
   - Press `Ctrl+X` to exit

5. **Verify it's there:**
   ```bash
   ls -la credentials.json
   cat credentials.json  # Should show your credentials
   ```

### Method 2: Using Render's File System (If Available)

Some Render plans support file uploads:

1. Go to your service dashboard
2. Look for **"Files"** or **"File Manager"** tab
3. Upload `credentials.json` directly
4. Make sure it's in the root directory (`/opt/render/project/src/`)

### Method 3: Add to Git Repository (NOT RECOMMENDED)

⚠️ **Security Warning:** This is NOT recommended for production, but works for testing.

1. **Add to .gitignore first** (to avoid committing):
   ```bash
   echo "credentials.json" >> .gitignore
   ```

2. **If you must commit it** (for testing only):
   ```bash
   git add credentials.json
   git commit -m "Add credentials.json for Render"
   git push
   ```

3. **Render will automatically deploy** with the file

**⚠️ IMPORTANT:** Never commit `credentials.json` to public repositories! Only use this method for private repos or testing.

## Verify credentials.json is in the Right Location

After uploading, verify:

```bash
# In Render Shell
pwd  # Should show: /opt/render/project/src
ls -la credentials.json  # Should show the file
```

## Alternative: Use Environment Variables (Advanced)

If you want to avoid uploading files, you can convert credentials.json to environment variables:

1. **Extract values from credentials.json:**
   ```json
   {
     "web": {
       "client_id": "YOUR_CLIENT_ID",
       "project_id": "YOUR_PROJECT_ID",
       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
       "token_uri": "https://oauth2.googleapis.com/token",
       "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
       "client_secret": "YOUR_CLIENT_SECRET",
       "redirect_uris": ["http://localhost"]
     }
   }
   ```

2. **Set as environment variables in Render:**
   - `GOOGLE_CLIENT_ID` = your client_id
   - `GOOGLE_CLIENT_SECRET` = your client_secret
   - `GOOGLE_PROJECT_ID` = your project_id

3. **Modify code to read from environment variables** (requires code changes)

**Note:** This method requires modifying `google_form_generator.py` to construct credentials from environment variables instead of loading from file.

## Complete Setup Checklist

- [ ] Downloaded `credentials.json` from Google Cloud Console
- [ ] Opened Render Shell
- [ ] Created `credentials.json` in Render Shell
- [ ] Pasted credentials content
- [ ] Saved and verified file exists
- [ ] Redeployed (or wait for auto-deploy)
- [ ] Tested form creation

## Troubleshooting

### File Not Found After Upload

1. **Check location:**
   ```bash
   pwd
   ls -la credentials.json
   ```

2. **Check file permissions:**
   ```bash
   chmod 644 credentials.json
   ```

3. **Verify file content:**
   ```bash
   cat credentials.json | head -5
   ```
   Should show valid JSON starting with `{`

### Permission Denied

```bash
# Make sure file is readable
chmod 644 credentials.json
```

### Still Getting Error

1. **Check file path in code:**
   - The code looks for `credentials.json` in the current working directory
   - On Render, this is `/opt/render/project/src/`

2. **Check deployment logs:**
   - Go to "Logs" tab
   - Look for file path errors

3. **Force redeploy:**
   - Go to "Events" tab
   - Click "Manual Deploy" → "Deploy latest commit"

### File Gets Deleted After Deployment

If the file disappears after each deployment:

1. **Use Persistent Disk (Paid Plans):**
   - Render's free tier doesn't persist files between deployments
   - You'll need to re-upload after each deployment

2. **Use Environment Variables Instead:**
   - Convert credentials to environment variables (Method 3 above)
   - This persists across deployments

3. **Add to Git Repository:**
   - Only for private repos or testing
   - Commit the file (not recommended for security)

## Security Best Practices

✅ **DO:**
- Keep `credentials.json` private
- Add to `.gitignore` if using git
- Use environment variables for production
- Rotate credentials if exposed

❌ **DON'T:**
- Commit `credentials.json` to public repositories
- Share credentials publicly
- Hardcode credentials in code
- Use the same credentials for dev and prod

## Quick Reference

**File Location on Render:**
```
/opt/render/project/src/credentials.json
```

**Render Shell Commands:**
```bash
# Create file
nano credentials.json

# Check if exists
ls -la credentials.json

# View content (first few lines)
head credentials.json

# Verify JSON is valid
python -m json.tool credentials.json
```

---

**That's it!** Once you upload `credentials.json` to Render, the error should be resolved. 🎉


