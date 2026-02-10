@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM =========================
REM WAYBLOX Self-Updater
REM =========================

REM Get script info
set "SCRIPT_PATH=%~f0"
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_NAME=%~nx0"

set "REPO_URL=https://github.com/5redfreddy/WAYBLOX.git"

REM Normalize path (remove trailing backslash)
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM -------------------------
REM Ensure Git is installed
REM -------------------------
where git >nul 2>&1
if errorlevel 1 (
    powershell -NoProfile -Command ^
        "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Git is not installed. Installing Git now.','WAYBLOX','OK','Information')"

    where winget >nul 2>&1 || (
        powershell -NoProfile -Command ^
            "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Winget is not available. Please update Windows.','WAYBLOX Error','OK','Error')"
        exit /b 1
    )

    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements

    REM Relaunch so PATH is refreshed
    start "" "%SCRIPT_PATH%"
    exit /b
)

REM -------------------------
REM Clean script parent folder
REM -------------------------
echo Cleaning folder: %SCRIPT_DIR%

for %%F in ("%SCRIPT_DIR%\*") do (
    if /I not "%%~nxF"=="%SCRIPT_NAME%" (
        if exist "%%F\" (
            echo Deleting folder: %%~nxF
            rmdir /s /q "%%F"
        ) else (
            echo Deleting file: %%~nxF
            del /f /q "%%F"
        )
    )
)

REM -------------------------
REM Download WAYBLOX here
REM -------------------------
echo Downloading WAYBLOX into script folder...
git clone "%REPO_URL%" "%SCRIPT_DIR%"

REM -------------------------
REM Done
REM -------------------------
powershell -NoProfile -Command ^
    "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('WAYBLOX has been refreshed successfully!','WAYBLOX','OK','Information')"

exit /b 0
