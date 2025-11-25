@echo off
echo ========================================
echo Restarting Amazon Q API Service
echo ========================================
echo.

REM Kill existing process on port 18100
echo [1/4] Stopping existing service...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :18100') do (
    echo Found process: %%a
    taskkill /F /PID %%a >nul 2>&1
)
timeout /t 2 /nobreak >nul

REM Clear token cache to avoid using wrong account
echo [2/4] Clearing token cache...
del "%USERPROFILE%\.amazonq_token_cache*.json" >nul 2>&1

REM Start the service
echo [3/4] Starting service on port 18100...
start "Amazon Q API Service" python main.py

REM Wait and check status
echo [4/4] Checking service status...
timeout /t 3 /nobreak >nul

netstat -ano | findstr :18100 >nul
if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Service started successfully!
    echo Running on http://0.0.0.0:18100
    echo ========================================
) else (
    echo.
    echo ========================================
    echo WARNING: Service may not have started
    echo Please check the console window
    echo ========================================
)

echo.
pause
