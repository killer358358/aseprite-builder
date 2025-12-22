@echo off
setlocal enabledelayedexpansion
title Aseprite Builder Pro

:: ==== CONFIGURATION ====
set "ROOT_DIR=%CD%\aseprite_workspace"
set "ASEPRITE_DIR=%ROOT_DIR%\aseprite"
set "BUILD_DIR=%ROOT_DIR%\build"
set "SKIA_DIR=%ROOT_DIR%\skia"
set "INSTALLER_DIR=%ROOT_DIR%\installer"
set "SKIA_ZIP=%ROOT_DIR%\Skia-Windows-Release-x64.zip"
set "ISS_FILE=%ROOT_DIR%\aseprite_installer.iss"

echo [1/6] Running Safety Checks...
if not exist "%ROOT_DIR%" mkdir "%ROOT_DIR%"
where cmake >nul 2>nul || (echo [!] CMake missing. & pause & exit /b)
where ninja >nul 2>nul || (echo [!] Ninja missing. & pause & exit /b)

for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do set "VS_INSTALL_DIR=%%i"
if not defined VS_INSTALL_DIR (echo [!] Visual Studio missing. & pause & exit /b)

echo [2/6] Fetching latest version...
for /f "delims=" %%i in ('powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (Invoke-WebRequest -UseBasicParsing https://api.github.com/repos/aseprite/aseprite/releases/latest).Content | ConvertFrom-Json | Select-Object -ExpandProperty tag_name"') do set "ASE_VER=%%i"
if "%ASE_VER%"=="" set "ASE_VER=v1.3.12"

echo.
echo WARNING: This will clean %ROOT_DIR%
set /p "CONFIRM=Proceed? (Y/N): "
if /i "%CONFIRM%" neq "Y" exit /b

echo [3/6] Cleaning and Downloading...
rd /s /q "%ASEPRITE_DIR%" 2>nul
rd /s /q "%BUILD_DIR%" 2>nul
mkdir "%BUILD_DIR%" "%INSTALLER_DIR%" "%ASEPRITE_DIR%" 2>nul

set "ASE_ZIP=%ROOT_DIR%\aseprite_src.zip"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/aseprite/aseprite/releases/download/%ASE_VER%/Aseprite-%ASE_VER%-Source.zip' -OutFile '%ASE_ZIP%'"
set "TEMP_EXTRACT=%ROOT_DIR%\temp_ext"
mkdir "%TEMP_EXTRACT%" 2>nul
powershell -Command "Expand-Archive -Force '%ASE_ZIP%' '%TEMP_EXTRACT%'"
for /d %%f in ("%TEMP_EXTRACT%\*") do xcopy /e /y /q "%%f\*" "%ASEPRITE_DIR%\"
rd /s /q "%TEMP_EXTRACT%"
del /f /q "%ASE_ZIP%"

if not exist "%SKIA_ZIP%" powershell -Command "Invoke-WebRequest -Uri 'https://github.com/aseprite/skia/releases/latest/download/Skia-Windows-Release-x64.zip' -OutFile '%SKIA_ZIP%'"
if not exist "%SKIA_DIR%" (mkdir "%SKIA_DIR%" & powershell -Command "Expand-Archive -Force '%SKIA_ZIP%' '%SKIA_DIR%'")

echo [4/6] Setting up Environment...
call "%VS_INSTALL_DIR%\VC\Auxiliary\Build\vcvars64.bat" >nul

echo [5/6] Compiling (This will take a while)...
pushd "%BUILD_DIR%"
cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLAF_BACKEND=skia -DSKIA_DIR="%SKIA_DIR%" -DSKIA_LIBRARY_DIR="%SKIA_DIR%\out\Release-x64" -DSKIA_LIBRARY="%SKIA_DIR%\out\Release-x64\skia.lib" -DENABLE_UPDATER=OFF -DVERSION_OVERRIDE="%ASE_VER%" "%ASEPRITE_DIR%"
ninja
popd

echo [6/6] Generating Installer...
if exist "%BUILD_DIR%\bin\aseprite.exe" (
    (
        echo [Setup]
        echo AppName=Aseprite
        echo AppVersion=%ASE_VER%
        echo DefaultDirName={autopf}\Aseprite
        echo DefaultGroupName=Aseprite
        echo OutputBaseFilename=aseprite-setup-%ASE_VER%
        echo OutputDir=%INSTALLER_DIR%
        echo Compression=lzma
        echo SolidCompression=yes
        echo [Files]
        echo Source: "%BUILD_DIR%\bin\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
        echo [Icons]
        echo Name: "{group}\Aseprite"; Filename: "{app}\aseprite.exe"
    ) > "%ISS_FILE%"
    where iscc >nul 2>nul && iscc "%ISS_FILE%"
)

echo Done! Check %INSTALLER_DIR%
pause
