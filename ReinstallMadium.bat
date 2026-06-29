@echo off
setlocal EnableDelayedExpansion

color 0A

set "URL=https://github.com/RandomFixes/MadiumFixes/raw/refs/heads/main/Madium-Bootstrapper.exe"
set "FILE=Madium-Bootstrapper.exe"
set "TEMPFILE=%TEMP%\%FILE%"
set "MADIUM=%LOCALAPPDATA%\Madium"
set "TARGET=%LOCALAPPDATA%\Madium\Bin\Madium.exe"
set "DESKTOP=%USERPROFILE%\Desktop"

echo [INFO] Starting installation...

if exist "%MADIUM%" (
    echo [INFO] Detecting processes using Madium files...

    for /f "tokens=2" %%P in ('handle.exe "%MADIUM%" 2^>nul ^| findstr /i ".exe"') do (
        taskkill /F /PID %%P >nul 2>&1
    )

    timeout /t 2 /nobreak >nul

    echo [INFO] Removing existing Madium folder...
    rmdir /S /Q "%MADIUM%"

    if exist "%MADIUM%" (
        color 0C
        echo [ERROR] Failed to remove Madium folder.
        pause
        exit /b 1
    )

    echo [SUCCESS] Old Madium folder removed.
)

echo [INFO] Downloading Madium Bootstrapper...

powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%TEMPFILE%'"

if not exist "%TEMPFILE%" (
    color 0C
    echo [ERROR] Download failed.
    pause
    exit /b 1
)

echo [SUCCESS] Download completed.

echo [INFO] Launching bootstrapper...
start /wait "" "%TEMPFILE%"

echo [INFO] Checking installation...

if not exist "%TARGET%" (
    color 0C
    echo [ERROR] Madium.exe was not found.
    pause
    exit /b 1
)

echo [SUCCESS] Madium.exe found.

echo [INFO] Creating desktop shortcut...

powershell -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%DESKTOP%\Madium.lnk');$s.TargetPath='%TARGET%';$s.WorkingDirectory='%LOCALAPPDATA%\Madium\Bin';$s.Save()"

echo [SUCCESS] Desktop shortcut created.

del "%TEMPFILE%" >nul 2>&1

echo [SUCCESS] Installation completed successfully.

pause
exit
