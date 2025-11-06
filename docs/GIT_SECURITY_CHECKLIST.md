# 🔒 Git Security Checklist

## ✅ Files Protected by .gitignore

The following sensitive files are **automatically ignored** by git and will **NOT** be pushed to the repository:

### Environment Variables (Contains API Keys)
- ✅ `.env` - Main environment file with API keys
- ✅ `.env.local` - Local environment overrides
- ✅ `.env.production` - Production environment variables
- ✅ `.env.*` - Any other .env variant files
- ✅ **Note:** `env.example` is **NOT** ignored (template file, safe to commit)

### OAuth Credentials
- ✅ `credentials.json` - Google OAuth credentials
- ✅ `newcredentials.json` - Any renamed credentials file
- ✅ `**/credentials.json` - Credentials in any subdirectory

### Authentication Tokens
- ✅ `token.pickle` - OAuth token cache
- ✅ `**/token.pickle` - Tokens in any subdirectory

### Other Sensitive Files
- ✅ `*.pem` - Private key files
- ✅ `*.key` - Key files

---

## 🔍 Verify Files Are Ignored

Before pushing, verify sensitive files are ignored:

```bash
# Check if files are ignored
git check-ignore -v .env credentials.json token.pickle

# Check if any sensitive files are tracked
git ls-files | grep -E "\.env$|credentials\.json|token\.pickle"

# View all ignored files
git status --ignored
```

**Expected output:**
- `git check-ignore` should show the files are ignored
- `git ls-files` should return **nothing** (no sensitive files tracked)
- `git status --ignored` should list the files as ignored

---

## 🚨 If You Accidentally Committed Sensitive Files

If you've already committed sensitive files, follow these steps:

### Step 1: Remove from Git (but keep local file)
```bash
git rm --cached .env
git rm --cached credentials.json
git rm --cached token.pickle
```

### Step 2: Commit the removal
```bash
git commit -m "Remove sensitive files from git tracking"
```

### Step 3: Verify .gitignore is working
```bash
git status
# Files should show as "deleted" but not be tracked
```

### Step 4: Push (files will not be included)
```bash
git push
```

### Step 5: If already pushed to remote
**⚠️ IMPORTANT:** If you've already pushed sensitive files:
1. **Immediately rotate your API keys** in Google Cloud Console
2. **Regenerate OAuth credentials** if credentials.json was exposed
3. **Change SECRET_KEY** in your environment
4. Consider using `git filter-branch` or BFG Repo-Cleaner to remove from history

---

## 📋 Pre-Push Checklist

Before pushing to GitHub/remote repository:

- [ ] Run `git status` and verify no `.env`, `credentials.json`, or `token.pickle` files appear
- [ ] Run `git check-ignore -v .env` to confirm files are ignored
- [ ] Check that `env.example` exists (template file, safe to commit)
- [ ] Verify no API keys or secrets are in code comments
- [ ] Ensure `SECRET_KEY` is not hardcoded in source files
- [ ] Review `git diff` before committing

---

## ✅ Safe to Commit

These files are **safe** to commit (templates/examples):

- ✅ `env.example` - Template file (no real secrets)
- ✅ `requirements.txt` - Python dependencies
- ✅ `*.py` files - Source code (no hardcoded secrets)
- ✅ `templates/` - HTML templates
- ✅ `static/` - CSS/JS files
- ✅ `README.md` - Documentation
- ✅ `*.md` - Documentation files

---

## 🔐 Best Practices

1. **Never commit `.env` files** - Always use `env.example` as template
2. **Use environment variables** - Set secrets in deployment platform (Render, Railway, etc.)
3. **Rotate keys regularly** - Especially if you suspect they were exposed
4. **Review before pushing** - Always check `git status` and `git diff` before pushing
5. **Use Git hooks** - Consider pre-push hooks to prevent accidental commits

---

## 📝 Current .gitignore Status

Your `.gitignore` file is properly configured to protect:
- ✅ Environment variables (`.env*` files)
- ✅ OAuth credentials (`credentials.json`)
- ✅ Authentication tokens (`token.pickle`)
- ✅ Private keys (`*.pem`, `*.key`)
- ✅ Uploads directory (user uploads)
- ✅ Python cache files (`__pycache__/`)
- ✅ Virtual environments (`venv/`, `env/`)

---

## 🆘 Need Help?

If you're unsure whether a file should be committed:
1. Check if it contains API keys, passwords, or secrets
2. If yes → Add to `.gitignore` and don't commit
3. If no → Safe to commit
4. When in doubt → **Don't commit it!**

