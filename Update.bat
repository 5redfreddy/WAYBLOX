@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ======================================================
REM WAYBLOX Smart Self-Updater v3.0
REM ======================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_NAME=%~nx0"
set "REPO_URL=https://github.com/5redfreddy/WAYBLOX.git"
set "TEMP_CLONE=%TEMP%\WAYBLOX_UPDATE_TEMP"
set "VERSION_FILE=%SCRIPT_DIR%version.txt"

title WAYBLOX Smart Updater

REM -------------------------
REM 1. Admin Elevation
REM -------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

REM -------------------------
REM 2. Check for Git
REM -------------------------
where git >nul 2>&1 || (
    echo Git is required. Please install it via Winget or git-scm.com.
    pause
    exit /b 1
)

REM -------------------------
REM 3. Check for Updates (Hash Comparison)
REM -------------------------
echo Checking for updates...

REM Get the latest commit hash from the remote GitHub repo
for /f "tokens=1" %%a in ('git ls-remote "%REPO_URL%" HEAD') do set "REMOTE_HASH=%%a"

REM Get the local hash from our version file
if exist "%VERSION_FILE%" (
    set /p LOCAL_HASH=<"%VERSION_FILE%"
) else (
    set "LOCAL_HASH=NONE"
)

if "%REMOTE_HASH%"=="%LOCAL_HASH%" (
    echo [+] WAYBLOX is already up to date!
    timeout /t 3 >nul
    exit /b 0
)

echo [!] New version detected. Starting sync...

REM -------------------------
REM 4. Download & Mirror
REM -------------------------
if exist "%TEMP_CLONE%" rmdir /s /q "%TEMP_CLONE%"

echo [1/3] Downloading latest changes...
git clone --depth 1 "%REPO_URL%" "%TEMP_CLONE%" >nul 2>&1

if %errorlevel% neq 0 (
    echo [!] Failed to connect to GitHub.
    pause
    exit /b 1
)

echo [2/3] Synchronizing files (Removing deprecated files)...
REM /MIR: Mirrors the directory (Deletes local files that were removed from GitHub)
REM /XF: Excludes the updater itself
REM /XD: Excludes the .git folder to keep your install directory clean
robocopy "%TEMP_CLONE%" "%SCRIPT_DIR%\" /MIR /XF "%SCRIPT_NAME%" /XD .git /R:2 /W:2 /NFL /NDL /NJH /NJS

REM -------------------------
REM 5. Save Version & Cleanup
REM -------------------------
echo [3/3] Finalizing...
echo %REMOTE_HASH%>"%VERSION_FILE%"
rmdir /s /q "%TEMP_CLONE%"

powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('WAYBLOX has been updated to the latest version and old files were removed.', 'Update Complete', 'OK', 'Information')"
exit /b 0
