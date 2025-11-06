# Google Forms Generator

A cross-platform Python tool for automated creation of Google Forms using Google's Forms API.

## Features

- ✅ Automated Google Forms creation
- ✅ Cross-platform support (Windows, macOS, Linux)
- ✅ Easy-to-use Python API
- ✅ OAuth 2.0 authentication
- ✅ Support for various question types
- ✅ Form customization options

## Prerequisites

- Python 3.7 or higher
- Google Cloud Project with Forms API enabled
- OAuth 2.0 credentials

## Setup Instructions

### 1. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 2. Google Cloud Console Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the required APIs:
   - Navigate to "APIs & Services" > "Library"
   - Enable **Google Forms API** (search and enable)
   - Enable **Google Drive API** (search and enable) - REQUIRED!
   - Enable **Google Docs API** (search and enable) - Required for Docs link feature
   
   **Note:** 
   - Google Forms API requires Google Drive API to create forms. Both must be enabled.
   - Google Docs API is needed if you want to generate forms from Google Docs links.

4. Create OAuth 2.0 Credentials:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth client ID"
   - Configure the OAuth consent screen (if not done already)
   - Choose application type: **Desktop app**
   - Download the credentials JSON file
   - Rename it to `credentials.json` and place it in the project root

### 3. First Run

On first run, the script will open a browser window for authentication. Follow these steps:

1. Sign in with your Google account
2. Grant necessary permissions
3. A `token.pickle` file will be created to store your credentials

## Usage

### Basic Example

```python
from google_form_generator import GoogleFormGenerator

# Initialize the generator
generator = GoogleFormGenerator()

# Create a new form
form = generator.create_form(
    title="My Survey Form",
    description="This is a sample survey"
)

# Add questions
form.add_question(
    question_text="What is your name?",
    question_type="text"
)

form.add_question(
    question_text="How would you rate our service?",
    question_type="scale",
    scale_min=1,
    scale_max=5
)

form.add_question(
    question_text="Select your favorite color",
    question_type="choice",
    options=["Red", "Blue", "Green", "Yellow"]
)

# Save the form
form_url = generator.save_form(form)
print(f"Form created: {form_url}")
```

### Advanced Example

See `scripts/example.py` for more detailed examples.

## API Reference

### GoogleFormGenerator

Main class for creating and managing Google Forms.

#### Methods

- `create_form(title, description=None)`: Create a new form
- `save_form(form)`: Save form and return the URL
- `get_form(form_id)`: Retrieve an existing form
- `update_form(form_id, updates)`: Update an existing form

### Question Types

- `text`: Short answer text
- `paragraph`: Long answer text
- `choice`: Multiple choice (single answer)
- `checkbox`: Multiple choice (multiple answers)
- `dropdown`: Dropdown menu
- `scale`: Linear scale
- `date`: Date picker
- `time`: Time picker
- `file`: File upload

## Troubleshooting

### Quick Diagnostic

Run the diagnostic script to check your setup:

```bash
python scripts/diagnose_setup.py
```

### Common Issues

#### 403: access_denied Error

If you see this error:
```
FormGeneration chưa hoàn tất quy trình xác minh của Google...
Lỗi 403: access_denied
```

**Solution:** You need to add your email to the Test users list in Google Cloud Console.

📖 **See detailed fix guide:** `docs/FIX_403_ERROR.md`

Quick fix:
1. Go to Google Cloud Console > APIs & Services > OAuth consent screen
2. Scroll to "Test users" section
3. Click "ADD USERS"
4. Add your Google email
5. Click "SAVE"
6. Run your script again

### Other Authentication Issues

- Make sure `credentials.json` is in the project root
- Delete `token.pickle` and re-authenticate if you see token errors
- Ensure the OAuth consent screen is properly configured
- Run `python diagnose_setup.py` to check your setup

### API Errors

#### "Google Drive API has not been used... or it is disabled"

**Error:** 403 error mentioning Drive API not enabled

**Solution:**
1. Go to Google Cloud Console > APIs & Services > Library
2. Search for "Google Drive API"
3. Click "Enable"
4. Wait a few minutes for activation
5. Run your script again

**Note:** Both Google Forms API AND Google Drive API must be enabled!

### Other API Errors

- Verify that Google Forms API is enabled in your Google Cloud project
- Verify that Google Drive API is enabled (required for Forms API)
- Check that your credentials have the necessary scopes

## 🌐 Web UI (NEW!) - Perfect for Non-Technical Users

### Easy-to-Use Web Interface

**Perfect for clients who aren't technical!** Beautiful, modern web interface that works on Windows, macOS, and Linux.

**Quick Start:**
```bash
# Windows
scripts\start_web_app.bat

# macOS/Linux
./scripts/start_web_app.sh

# Or directly
python scripts/run_app.py
```

Then open your browser at `http://127.0.0.1:5000`

**Features:**
- 🎨 Modern, user-friendly web interface
- 📝 Text input or file upload
- 📄 Drag & drop file support
- ✅ Real-time progress indicators
- 🔗 Direct links to created forms
- 📱 Responsive design (works on mobile)

📖 **See detailed guide:** `docs/README_WEB_UI.md`

## AI-Powered Form Creation 🤖

### CLI Version (For Developers)

You can also use the command-line interface:

**Quick Start:**
```bash
python ai_form_creator.py
```

**Features:**
- 🤖 AI-powered form generation using Gemini 2.5 Flash
- 📝 Create forms from text descriptions
- 📄 Create forms from file uploads (txt, pdf, docx, csv, xlsx)
- ✨ Automatic question type detection
- 🔗 Direct Google Form creation

**See detailed guide:** `docs/README_AI.md`

**Example:**
```python
from ai_form_creator import AIFormCreator

creator = AIFormCreator("YOUR_GEMINI_API_KEY")
form_url = creator.create_form_from_text("""
Create a customer feedback form with:
- Customer name (required)
- Rating (1-5 scale)
- Favorite features (multiple choice)
- Comments
""")
```

## Project Structure

```
GoogleFormGenerate/
├── app.py                      # Main Flask web application
├── ai_form_creator.py          # AI-powered form creator
├── gemini_form_generator.py    # Gemini AI integration
├── google_form_generator.py    # Google Forms API wrapper
├── script_parser.py            # Script parser for form creation
├── config_helper.py            # Configuration helper
├── gunicorn_config.py          # Gunicorn server configuration
├── requirements.txt            # Python dependencies
├── env.example                 # Environment variables template
├── README.md                   # This file
│
├── deployment/                 # Deployment configurations
│   ├── Dockerfile              # Docker configuration
│   ├── docker-compose.yml      # Docker Compose config
│   ├── Procfile                # Heroku/Render Procfile
│   ├── render.yaml             # Render.com configuration
│   ├── railway.toml            # Railway.app configuration
│   ├── fly.toml                # Fly.io configuration
│   └── railway.json            # Railway.json config
│
├── docs/                       # Documentation
│   ├── README_DOCS.md          # Documentation index
│   ├── setup_guide.md          # Detailed setup guide
│   ├── deployment_guide.md     # Deployment instructions
│   ├── DEPLOY_RENDER.md        # Render.com deployment
│   └── ...                     # Other documentation files
│
├── scripts/                    # Utility scripts
│   ├── run_app.py              # Web app launcher
│   ├── start_web_app.bat       # Windows launcher
│   ├── start_web_app.sh        # macOS/Linux launcher
│   ├── quick_start.py          # Quick start example
│   ├── example.py              # Advanced examples
│   ├── test_ai_form.py         # AI form testing
│   ├── diagnose_setup.py       # Setup diagnostic
│   └── install_dependencies.py # Dependency installer
│
├── examples/                   # Example files
│   └── example_input.txt       # Example input file
│
├── static/                     # Web UI static files
│   ├── style.css               # Main stylesheet
│   ├── style_components.css    # Component styles
│   └── script.js               # Frontend JavaScript
│
├── templates/                  # Web UI templates
│   └── index.html              # Main HTML template
│
└── uploads/                    # User uploads directory
```

## Documentation

All documentation files are located in the `docs/` directory. See `docs/README_DOCS.md` for a complete index.

## License

MIT License

