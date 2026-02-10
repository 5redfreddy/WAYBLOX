@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM =========================
REM WAYBLOX Auto-Updater
REM Author: David
REM =========================

set "REPO_URL=https://github.com/5redfreddy/WAYBLOX.git"
set "FOLDER=WAYBLOX"
set "DOCS=%USERPROFILE%\Documents"
set "FULLPATH=%DOCS%\%FOLDER%"
set "GIT_INSTALLER=%TEMP%\git-installer.exe"
set "GIT_URL=https://github.com/git-for-windows/git/releases/latest/download/Git-64-bit.exe"

REM -------------------------
REM Function: Message Box
REM -------------------------
set MSG=powershell -NoProfile -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show(

REM -------------------------
REM Check for Git
REM -------------------------
git --version >nul 2>&1
if errorlevel 1 (
    %MSG%'Git is not installed.\n\nWAYBLOX will now download and install Git automatically.','WAYBLOX','OK','Warning')"

    echo Downloading Git...
    powershell -NoProfile -Command ^
        "Invoke-WebRequest -Uri '%GIT_URL%' -OutFile '%GIT_INSTALLER%'"

    if not exist "%GIT_INSTALLER%" (
        %MSG%'Failed to download Git. Please install it manually.','WAYBLOX Error','OK','Error')"
        exit /b 1
    )

    echo Installing Git...
    "%GIT_INSTALLER%" /VERYSILENT /NORESTART

    del "%GIT_INSTALLER%" >nul 2>&1

    REM Refresh PATH
    set "PATH=%PATH%;C:\Program Files\Git\cmd"

    git --version >nul 2>&1
    if errorlevel 1 (
        %MSG%'Git installation failed.\nPlease restart your PC and try again.','WAYBLOX Error','OK','Error')"
        exit /b 1
    )
)

REM -------------------------
REM Change to Documents
REM -------------------------
cd /d "%DOCS%" || exit /b 1

REM -------------------------
REM Clone or Update
REM -------------------------
if not exist "%FULLPATH%\" (
    echo WAYBLOX not found. Cloning...
    git clone "%REPO_URL%"
    if errorlevel 1 (
        %MSG%'Failed to clone WAYBLOX repository.','WAYBLOX Error','OK','Error')"
        exit /b 1
    )

    %MSG%'WAYBLOX has been installed successfully!','WAYBLOX Installed','OK','Information')"
) else (
    echo WAYBLOX found. Updating...
    cd "%FULLPATH%" || exit /b 1
    git pull
    if errorlevel 1 (
        %MSG%'Failed to update WAYBLOX repository.','WAYBLOX Error','OK','Error')"
        exit /b 1
    )

    %MSG%'WAYBLOX is already up to date!','WAYBLOX Updated','OK','Information')"
)

exit /b 0
