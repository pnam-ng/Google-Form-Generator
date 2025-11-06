#!/bin/bash
# macOS/Linux shell script to start the web application

echo ""
echo "================================================================"
echo "  AI-Powered Google Form Creator - Web Application"
echo "================================================================"
echo ""

cd "$(dirname "$0")/.."
python3 scripts/run_app.py


