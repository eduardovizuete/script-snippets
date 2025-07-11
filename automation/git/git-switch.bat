@echo off
REM Git Account Switcher - Quick Access Batch File
REM Place this in a directory that's in your PATH for global access

echo.
echo ==========================================
echo           Git Account Switcher
echo ==========================================
echo.
echo Available actions:
echo   1. Switch Git Account (Interactive)
echo   2. Show Current Git Account
echo   3. Clear Git Credentials
echo   4. Switch with Manual Input
echo   5. Show Usage Guide
echo.

set /p choice="Select action (1-5): "

if "%choice%"=="1" (
    powershell -ExecutionPolicy Bypass -File "%~dp0git-account-switcher.ps1" -Action switch -Interactive
) else if "%choice%"=="2" (
    powershell -ExecutionPolicy Bypass -File "%~dp0git-account-switcher.ps1" -Action show
) else if "%choice%"=="3" (
    powershell -ExecutionPolicy Bypass -File "%~dp0git-account-switcher.ps1" -Action clear
) else if "%choice%"=="4" (
    set /p name="Enter Git username: "
    set /p email="Enter Git email: "
    powershell -ExecutionPolicy Bypass -File "%~dp0git-account-switcher.ps1" -Action switch -Name "%name%" -Email "%email%"
) else if "%choice%"=="5" (
    powershell -ExecutionPolicy Bypass -File "%~dp0git-account-switcher.ps1" -Action show
    echo.
    powershell -ExecutionPolicy Bypass -File "%~dp0git-account-switcher.ps1" -Action list 2>nul || echo Run the PowerShell script directly for full usage guide
) else (
    echo Invalid choice. Please select 1-5.
)

echo.
pause
