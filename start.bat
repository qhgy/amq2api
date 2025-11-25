@echo off
echo Starting Amazon Q to Claude API Proxy...
echo.

cd /d "%~dp0"

if not exist "venv\Scripts\activate.bat" (
    echo Virtual environment not found!
    echo Please run: python -m venv venv
    pause
    exit /b 1
)

call venv\Scripts\activate.bat

echo Checking dependencies...
python -c "import fastapi" 2>nul
if errorlevel 1 (
    echo Installing dependencies...
    pip install -r requirements.txt --no-cache-dir
)

echo.
echo Starting service on port 8080...
echo Press Ctrl+C to stop the service
echo.

python main.py

pause
