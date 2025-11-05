# 🔐 Multi-User Authentication Guide

## Current Situation

**How it works now:**
- The app authenticates **once** at server startup with **one Google account**
- All forms are created using that **single authenticated account**
- There's only **one `token.pickle` file** shared by all users

**Problem:**
- If User A creates a form, it's created in the **server's Google account**, not User A's account
- User B can't create forms with their own Google account
- All forms belong to the same Google account

## Solution Options

### ✅ **Option 1: Current Setup (Single Account)**

**Best for:**
- Personal use
- Single organization
- Forms owned by one account

**How it works:**
- One Google account authenticates at startup
- All forms created belong to that account
- Users can create forms, but they're owned by the server account

**Setup:**
- Add test users in Google Cloud Console OAuth consent screen
- Only those test users can authenticate
- Forms are created in the authenticated account

---

### ✅ **Option 2: Per-User Authentication (Recommended for Multi-User)**

**Best for:**
- Public websites
- Multiple users with their own accounts
- Forms owned by each user's account

**How it works:**
- Each user authenticates with their own Google account
- Forms are created in **their own Google account**
- Each user has their own token stored in session

**Implementation Requirements:**
1. Web-based OAuth flow (not local server)
2. Session management
3. Per-user token storage
4. OAuth callback endpoint

---

## Implementation: Per-User Authentication

### Step 1: Update OAuth Configuration

**Change from Desktop App to Web Application:**

1. Go to Google Cloud Console → Credentials
2. Create **new OAuth 2.0 Client ID**:
   - Application type: **Web application** (not Desktop app)
   - Authorized redirect URIs:
     - `http://localhost:5000/auth/callback` (for local)
     - `https://your-app.onrender.com/auth/callback` (for Render)
3. Download the new credentials.json

### Step 2: Code Changes Needed

#### A. Update `google_form_generator.py` to support per-user tokens:

```python
class GoogleFormGenerator:
    def __init__(self, credentials_file: str = 'credentials.json', 
                 token_file: str = None, user_credentials=None):
        """
        Initialize with optional user-specific credentials.
        
        Args:
            credentials_file: Path to OAuth credentials JSON
            token_file: Path to token file (optional, for backward compat)
            user_credentials: User's OAuth credentials object (for multi-user)
        """
        self.credentials_file = credentials_file
        self.token_file = token_file
        self.user_credentials = user_credentials
        self.service = None
        self.drive_service = None
        self.docs_service = None
        
        if user_credentials:
            # Use provided user credentials
            self.creds = user_credentials
            self._build_services()
        else:
            # Fallback to file-based authentication
            self._authenticate()
```

#### B. Add OAuth flow endpoints to `app.py`:

```python
from flask import session, redirect, url_for
from google_auth_oauthlib.flow import Flow

@app.route('/auth/login')
def login():
    """Initiate OAuth flow for user."""
    flow = Flow.from_client_secrets_file(
        'credentials.json',
        scopes=GoogleFormGenerator.SCOPES,
        redirect_uri=url_for('callback', _external=True)
    )
    
    authorization_url, state = flow.authorization_url(
        access_type='offline',
        include_granted_scopes='true'
    )
    
    session['oauth_state'] = state
    return redirect(authorization_url)

@app.route('/auth/callback')
def callback():
    """Handle OAuth callback."""
    flow = Flow.from_client_secrets_file(
        'credentials.json',
        scopes=GoogleFormGenerator.SCOPES,
        redirect_uri=url_for('callback', _external=True)
    )
    
    flow.fetch_token(authorization_response=request.url)
    credentials = flow.credentials
    
    # Store in session
    session['user_credentials'] = {
        'token': credentials.token,
        'refresh_token': credentials.refresh_token,
        'token_uri': credentials.token_uri,
        'client_id': credentials.client_id,
        'client_secret': credentials.client_secret,
        'scopes': credentials.scopes
    }
    
    return redirect(url_for('index'))

@app.route('/auth/logout')
def logout():
    """Logout user."""
    session.pop('user_credentials', None)
    return redirect(url_for('index'))
```

#### C. Update form creation to use user's credentials:

```python
@app.route('/api/create-form-with-questions', methods=['POST'])
def create_form_with_questions():
    """Create form with user's credentials."""
    # Get user's credentials from session
    user_creds_data = session.get('user_credentials')
    
    if not user_creds_data:
        return jsonify({
            'success': False,
            'error': 'Please login with your Google account first',
            'redirect': '/auth/login'
        }), 401
    
    # Reconstruct credentials object
    from google.oauth2.credentials import Credentials
    user_creds = Credentials(
        token=user_creds_data['token'],
        refresh_token=user_creds_data['refresh_token'],
        token_uri=user_creds_data['token_uri'],
        client_id=user_creds_data['client_id'],
        client_secret=user_creds_data['client_secret'],
        scopes=user_creds_data['scopes']
    )
    
    # Create form generator with user's credentials
    form_generator = GoogleFormGenerator(user_credentials=user_creds)
    
    # Create form (will be in user's account)
    form = form_generator.create_form(title, description)
    # ... rest of form creation
```

### Step 3: Update Frontend

Add login/logout buttons to `templates/index.html`:

```html
<div id="auth-section">
    {% if user_logged_in %}
        <button onclick="logout()">Logout</button>
        <span>Logged in as: {{ user_email }}</span>
    {% else %}
        <a href="/auth/login" class="btn">Login with Google</a>
    {% endif %}
</div>
```

---

## Comparison Table

| Feature | Single Account (Current) | Multi-User (Proposed) |
|---------|-------------------------|----------------------|
| **Setup Complexity** | ✅ Simple | ⚠️ More complex |
| **User Experience** | ✅ No login needed | ⚠️ Users must login |
| **Form Ownership** | Server account | User's account |
| **OAuth Type** | Desktop app | Web application |
| **Token Storage** | Single file | Per-user session |
| **Test Users** | Must be added | Any user can login* |
| **Best For** | Personal/Org use | Public websites |

*If app is published, otherwise test users still needed

---

## Quick Decision Guide

**Use Single Account (Current) if:**
- ✅ Personal use
- ✅ Internal organization tool
- ✅ You want all forms in one account
- ✅ Simple setup

**Use Multi-User if:**
- ✅ Public website
- ✅ Users want forms in their own accounts
- ✅ Need to track forms per user
- ✅ Enterprise/SaaS application

---

## Security Considerations

### Single Account:
- ⚠️ All users share one account
- ⚠️ Limited to test users (unless published)
- ✅ Simple security model

### Multi-User:
- ✅ Each user has their own account
- ✅ Better privacy/isolation
- ⚠️ Need secure session management
- ⚠️ Need to handle token refresh

---

## Implementation Priority

**For now (Quick):**
- Keep current single-account setup
- Add all potential users as "Test Users" in Google Cloud Console
- Forms will be created in server account

**For later (Full Multi-User):**
- Implement web-based OAuth flow
- Add session management
- Update frontend with login/logout
- Store tokens per user

---

## Need Help Implementing?

I can help you implement multi-user authentication if you want. Just let me know!

**Current recommendation:** If you're just getting started, stick with single-account setup and add users as test users. Upgrade to multi-user later if needed.

