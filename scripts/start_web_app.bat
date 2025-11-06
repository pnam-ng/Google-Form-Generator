@echo off
REM Windows batch script to start the web application

echo.
echo ================================================================
echo   AI-Powered Google Form Creator - Web Application
echo ================================================================
echo.

cd /d "%~dp0\.."
python scripts\run_app.py

pause


