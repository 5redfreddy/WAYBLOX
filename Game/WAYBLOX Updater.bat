@echo off
setlocal EnableExtensions

REM =========================
REM WAYBLOX Auto-Updater
REM =========================

set "REPO_URL=https://github.com/5redfreddy/WAYBLOX.git"
set "DOCS=%USERPROFILE%\Documents"
set "FOLDER=WAYBLOX"
set "FULLPATH=%DOCS%\%FOLDER%"

REM -------------------------
REM Detect relaunch flag
REM -------------------------
if "%~1"=="--continue" goto CONTINUE

REM -------------------------
REM Check for Git
REM -------------------------
where git >nul 2>&1
if errorlevel 1 (
    powershell -NoProfile -Command ^
        "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Git is not installed. WAYBLOX will install Git now (no restart required).','WAYBLOX','OK','Information')"

    where winget >nul 2>&1 || (
        powershell -NoProfile -Command ^
            "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Winget is not available. Please update Windows.','WAYBLOX Error','OK','Error')"
        exit /b 1
    )

    echo Installing Git with winget...
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements

    REM Relaunch script in a new shell with updated PATH
    echo Relaunching updater...
    start "" "%~f0" --continue
    exit /b
)

:CONTINUE
REM -------------------------
REM Verify Git works
REM -------------------------
where git >nul 2>&1 || (
    powershell -NoProfile -Command ^
        "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Git installation failed.','WAYBLOX Error','OK','Error')"
    exit /b 1
)

REM -------------------------
REM Clone or Update
REM -------------------------
cd /d "%DOCS%" || exit /b 1

if not exist "%FULLPATH%\" (
    git clone "%REPO_URL%"
    powershell -NoProfile -Command ^
        "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('WAYBLOX installed successfully!','WAYBLOX','OK','Information')"
) else (
    cd "%FULLPATH%"
    git pull
    powershell -NoProfile -Command ^
        "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('WAYBLOX is up to date!','WAYBLOX','OK','Information')"
)

exit /b 0
