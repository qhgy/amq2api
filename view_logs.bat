@echo off
chcp 65001 >nul
echo ========================================
echo   Amazon Q Proxy - Log Viewer
echo ========================================
echo.

cd /d "%~dp0"

if not exist "logs" (
    echo [ERROR] Logs directory not found!
    echo [INFO] Service may not have been started yet
    pause
    exit /b 1
)

:menu
echo.
echo Select log file to view:
echo.
echo 1. Today's main log
echo 2. Today's error log
echo 3. List all log files
echo 4. Tail main log (last 50 lines)
echo 5. Tail error log (last 50 lines)
echo 6. Open logs folder
echo 0. Exit
echo.
set /p choice="Enter your choice: "

if "%choice%"=="1" goto view_main
if "%choice%"=="2" goto view_error
if "%choice%"=="3" goto list_logs
if "%choice%"=="4" goto tail_main
if "%choice%"=="5" goto tail_error
if "%choice%"=="6" goto open_folder
if "%choice%"=="0" exit /b 0
goto menu

:view_main
for /f "tokens=*" %%a in ('dir /b /od logs\amq2api_*.log 2^>nul ^| findstr /v "error"') do set latest=%%a
if "%latest%"=="" (
    echo [ERROR] No main log file found
    pause
    goto menu
)
echo.
echo Viewing: logs\%latest%
echo ========================================
type "logs\%latest%"
echo.
echo ========================================
pause
goto menu

:view_error
for /f "tokens=*" %%a in ('dir /b /od logs\amq2api_error_*.log 2^>nul') do set latest=%%a
if "%latest%"=="" (
    echo [ERROR] No error log file found
    pause
    goto menu
)
echo.
echo Viewing: logs\%latest%
echo ========================================
type "logs\%latest%"
echo.
echo ========================================
pause
goto menu

:list_logs
echo.
echo Log files:
echo ========================================
dir /b /od logs\*.log
echo ========================================
pause
goto menu

:tail_main
for /f "tokens=*" %%a in ('dir /b /od logs\amq2api_*.log 2^>nul ^| findstr /v "error"') do set latest=%%a
if "%latest%"=="" (
    echo [ERROR] No main log file found
    pause
    goto menu
)
echo.
echo Last 50 lines of: logs\%latest%
echo ========================================
powershell -Command "Get-Content 'logs\%latest%' -Tail 50"
echo.
echo ========================================
pause
goto menu

:tail_error
for /f "tokens=*" %%a in ('dir /b /od logs\amq2api_error_*.log 2^>nul') do set latest=%%a
if "%latest%"=="" (
    echo [ERROR] No error log file found
    pause
    goto menu
)
echo.
echo Last 50 lines of: logs\%latest%
echo ========================================
powershell -Command "Get-Content 'logs\%latest%' -Tail 50"
echo.
echo ========================================
pause
goto menu

:open_folder
echo.
echo Opening logs folder...
explorer logs
goto menu
