@echo off
setlocal enabledelayedexpansion
title Aseprite Builder Pro - [Full Pipeline]

:: =================================================================
:: 1. CONFIGURATION
:: =================================================================
:: This sets the workspace to the folder where the .bat file is located
set "ROOT_DIR=%~dp0workspace"
set "ASEPRITE_DIR=%ROOT_DIR%\aseprite"
set "BUILD_DIR=%ROOT_DIR%\build"
set "SKIA_DIR=%ROOT_DIR%\skia"
set "INSTALLER_DIR=%ROOT_DIR%\installer"
set "SKIA_ZIP=%ROOT_DIR%\Skia-Windows-Release-x64.zip"
set "ISS_FILE=%ROOT_DIR%\aseprite_installer.iss"

:: =================================================================
:: 2. PRE-FLIGHT CHECKS
:: =================================================================
echo [1/6] Running Safety Checks...
if not exist "%ROOT_DIR%" mkdir "%ROOT_DIR%" 2>nul

:: Check for required tools in PATH
where cmake >nul 2>nul || (echo [!] CMake missing. & pause & exit /b)
where ninja >nul 2>nul || (echo [!] Ninja missing. & pause & exit /b)

:: Locate Visual Studio
for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do set "VS_INSTALL_DIR=%%i"
if not defined VS_INSTALL_DIR (echo [!] Visual Studio 2022/2019 missing. & pause & exit /b)

:: =================================================================
:: 3. FETCH VERSION & DYNAMIC DOWNLOAD URL
:: =================================================================
echo [2/6] Fetching latest release metadata...
:: This PowerShell block finds the EXACT 'Source.zip' asset URL to avoid 404 errors
set "PS_CMD=$r=(Invoke-WebRequest -UseBasicParsing https://api.github.com/repos/aseprite/aseprite/releases/latest).Content|ConvertFrom-Json; $u=$r.assets|Where-Object {$_.name -like '*Source.zip'}|Select-Object -ExpandProperty browser_download_url; $v=$r.tag_name; echo \"$u|$v\""

for /f "tokens=1,2 delims=|" %%a in ('powershell -Command "%PS_CMD%"') do (
    set "DOWNLOAD_URL=%%a"
    set "ASE_VER=%%b"
)

if "%DOWNLOAD_URL%"=="" (
    echo [!] Critical Error: Could not find the Source.zip download link.
    pause & exit /b
)
echo [+] Detected Version: %ASE_VER%
echo [+] Asset URL: %DOWNLOAD_URL%

echo.
echo WARNING: This will wipe %ROOT_DIR% for a clean build.
set /p "CONFIRM=Proceed with build? (Y/N): "
if /i "%CONFIRM%" neq "Y" exit /b

:: =================================================================
:: 4. CLEANING & DOWNLOADING
:: =================================================================
echo [3/6] Cleaning and Downloading...
rd /s /q "%ASEPRITE_DIR%" 2>nul
rd /s /q "%BUILD_DIR%" 2>nul
mkdir "%BUILD_DIR%" "%INSTALLER_DIR%" "%ASEPRITE_DIR%" 2>nul

:: Download Aseprite Source
set "ASE_ZIP=%ROOT_DIR%\aseprite_src.zip"
echo Downloading Aseprite...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%ASE_ZIP%'"

:: Smart Extraction
echo Extracting Aseprite...
set "TEMP_EXTRACT=%ROOT_DIR%\temp_ext"
mkdir "%TEMP_EXTRACT%" 2>nul
powershell -Command "Expand-Archive -Force '%ASE_ZIP%' '%TEMP_EXTRACT%'"
for /d %%f in ("%TEMP_EXTRACT%\*") do xcopy /e /y /q "%%f\*" "%ASEPRITE_DIR%\"
rd /s /q "%TEMP_EXTRACT%"
del /f /q "%ASE_ZIP%"

:: Download Skia (If not present)
if not exist "%SKIA_ZIP%" (
    echo Downloading Skia...
    powershell -Command "Invoke-WebRequest -Uri 'https
