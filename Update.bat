@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM =========================
REM WAYBLOX Self-Updater
REM =========================
REM Script info
set "SCRIPT_PATH=%~f0"
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_NAME=%~nx0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "REPO_URL=https://github.com/5redfreddy/WAYBLOX.git"
set "TEMP_CLONE=%TEMP%\WAYBLOX_UPDATE_TEMP"

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
    start "" "%SCRIPT_PATH%"
    exit /b
)

REM -------------------------
REM Clean script folder (except updater)
REM -------------------------
echo Cleaning script directory...
for %%F in ("%SCRIPT_DIR%\*") do (
    if /I not "%%~nxF"=="%SCRIPT_NAME%" (
        if exist "%%F\" (
            attrib -r -s -h "%%F\*" /s /d >nul 2>&1
            rmdir /s /q "%%F" >nul 2>&1
        ) else (
            attrib -r -s -h "%%F" >nul 2>&1
            del /f /q "%%F" >nul 2>&1
        )
    )
)

REM -------------------------
REM Remove old temp clone (force delete)
REM -------------------------
if exist "%TEMP_CLONE%" (
    echo Removing old temp files...
    attrib -r -s -h "%TEMP_CLONE%\*" /s /d >nul 2>&1
    rmdir /s /q "%TEMP_CLONE%" >nul 2>&1
    REM If rmdir fails, use PowerShell as backup
    if exist "%TEMP_CLONE%" (
        powershell -NoProfile -Command "Remove-Item -Path '%TEMP_CLONE%' -Recurse -Force -ErrorAction SilentlyContinue"
    )
)

REM -------------------------
REM Clone to TEMP
REM -------------------------
echo Downloading WAYBLOX to temp...
git clone "%REPO_URL%" "%TEMP_CLONE%"
if errorlevel 1 (
    powershell -NoProfile -Command ^
        "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Failed to download WAYBLOX.','WAYBLOX Error','OK','Error')"
    exit /b 1
)

REM -------------------------
REM Copy files into script folder
REM -------------------------
echo Copying files...
robocopy "%TEMP_CLONE%" "%SCRIPT_DIR%" /E /NFL /NDL /NJH /NJS /NC /NS

REM -------------------------
REM Cleanup (force delete .git folder)
REM -------------------------
echo Cleaning up...
attrib -r -s -h "%TEMP_CLONE%\*" /s /d >nul 2>&1
rmdir /s /q "%TEMP_CLONE%" >nul 2>&1
REM PowerShell fallback for stubborn folders
if exist "%TEMP_CLONE%" (
    powershell -NoProfile -Command "Remove-Item -Path '%TEMP_CLONE%' -Recurse -Force -ErrorAction SilentlyContinue"
)

REM -------------------------
REM Done
REM -------------------------
powershell -NoProfile -Command ^
    "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('WAYBLOX has been fully refreshed!','WAYBLOX','OK','Information')"
exit /b 0
