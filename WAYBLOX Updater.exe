@echo off
setlocal

REM david

REM git check

git --version >nul 2>&1
if errorlevel 1 (
    powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('to be up-to-date with the WAYBLOX repository, please install GIT to proceed! Get GIT at: https://git-scm.com/downloads/win','WAYBLOX error!', 'OK', 'Warning')"
    exit /b
)

REM Set the git repo url

set "REPO_URL=https://github.com/5redfreddy/WAYBLOX"

REM get user's documents folder

set "DOCS=%USERPROFILE%\Documents"
set "FOLDER=WAYBLOX"
set "FULLPATH=%DOCS%\%FOLDER%"

REM change to documents directory
cd /d "%DOCS%"

REM check if WAYBLOX folder exists
if not exist "%FULLPATH%\" (
    echo WAYBLOX folder not found. Cloning repository...
    git clone %REPO_URL%
  powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('WAYBLOX directory installed! please restart the program for updates and such.','WAYBLOX installed!', 'OK', 'Information')"
    exit /b
) else (
    echo WAYBLOX folder exists. Pulling latest changes...
    cd "%FULLPATH%"
    git pull
  powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('WAYBLOX is up-to-date!','WAYBLOX updated!', 'OK', 'Information')"
    exit /b
)

pause
