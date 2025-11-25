@echo off
chcp 65001 >nul
echo ========================================
echo   Restart Amazon Q Proxy (Port 18100)
echo ========================================
echo.

cd /d "%~dp0"

set PORT=18100
set ENV_FILE=.env.18100

echo [1/4] Stopping existing service...
taskkill /F /IM python.exe /FI "WINDOWTITLE eq *uvicorn*" 2>nul
if %errorlevel% equ 0 (
    echo [OK] Service stopped
    timeout /t 2 >nul
) else (
    echo [INFO] No running service found
)

echo.
echo [2/4] Cleaning up port %PORT%...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :%PORT% ^| findstr LISTENING') do (
    echo Found process %%a using port %PORT%, terminating...
    taskkill /F /PID %%a 2>nul
)
timeout /t 1 >nul

echo.
echo [3/4] Checking environment...
if not exist "venv\Scripts\activate.bat" (
    echo [ERROR] Virtual environment not found, please run: python -m venv venv
    pause
    exit /b 1
)

if not exist "%ENV_FILE%" (
    echo [ERROR] Configuration file %ENV_FILE% not found!
    pause
    exit /b 1
)

echo [OK] Environment check passed

echo.
echo [4/4] Starting new service...
echo.
echo ========================================
echo [INFO] Starting service...
echo [INFO] Service URL: http://localhost:%PORT%
echo [INFO] Health check: http://localhost:%PORT%/health
echo [INFO] Press Ctrl+C to stop
echo ========================================
echo.

REM Create logs directory if not exists
if not exist "logs" mkdir logs

REM Copy config file to .env temporarily
copy /Y %ENV_FILE% .env >nul

echo [INFO] Logs directory: %cd%\logs

call venv\Scripts\activate.bat && python main.py

if errorlevel 1 (
    echo.
    echo [ERROR] Service failed to start! Please check configuration and logs
    echo [ERROR] Check logs in: %cd%\logs
    pause
)
