@echo off
setlocal EnableExtensions

REM =========================
REM WAYBLOX Hard Updater
REM =========================

set "REPO_URL=https://github.com/5redfreddy/WAYBLOX.git"
set "DOCS=%USERPROFILE%\Documents"
set "FOLDER=WAYBLOX"
set "FULLPATH=%DOCS%\%FOLDER%"

REM -------------------------
REM Ensure Git is installed
REM -------------------------
where git >nul 2>&1
if errorlevel 1 (
    powershell -NoProfile -Command ^
        "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Git is not installed. WAYBLOX will install Git now.','WAYBLOX','OK','Information')"

    where winget >nul 2>&1 || (
        powershell -NoProfile -Command ^
            "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Winget is not available. Please update Windows.','WAYBLOX Error','OK','Error')"
        exit /b 1
    )

    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements

    REM Relaunch with new PATH
    start "" "%~f0"
    exit /b
)

REM -------------------------
REM Delete old WAYBLOX
REM -------------------------
if exist "%FULLPATH%\" (
    echo Removing old WAYBLOX folder...
    rmdir /s /q "%FULLPATH%"
)

REM -------------------------
REM Re-download WAYBLOX
REM -------------------------
cd /d "%DOCS%" || exit /b 1
echo Downloading fresh WAYBLOX...
git clone "%REPO_URL%"

REM -------------------------
REM Done
REM -------------------------
powershell -NoProfile -Command ^
    "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('WAYBLOX has been re-downloaded successfully!','WAYBLOX','OK','Information')"

exit /b 0
