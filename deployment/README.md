# Deployment Configuration Files

This directory contains deployment configuration files for various platforms.

## Important Note

**For most deployment platforms, these files need to be in the project root directory.**

### Quick Setup

Before deploying, copy the relevant files to the project root:

```bash
# For Render.com
cp deployment/render.yaml .
cp deployment/Procfile .

# For Railway.app
cp deployment/railway.toml .
cp deployment/railway.json .

# For Fly.io
cp deployment/fly.toml .

# For Docker
cp deployment/Dockerfile .
cp deployment/docker-compose.yml .
```

### Platform-Specific Notes

- **Render.com**: Uses `render.yaml` and `Procfile` (both should be in root)
- **Railway.app**: Uses `railway.toml` or `railway.json` (should be in root)
- **Fly.io**: Uses `fly.toml` (should be in root)
- **Heroku**: Uses `Procfile` (should be in root)
- **Docker**: Uses `Dockerfile` and `docker-compose.yml` (can be in root or specified with `-f`)

### Alternative: Keep in Root

If you prefer to keep deployment files in the root for easier deployment, you can:

1. Copy files from `deployment/` to root when needed
2. Or keep them in root and ignore this directory

The files are organized here for better project structure, but deployment platforms typically expect them in the root directory.

