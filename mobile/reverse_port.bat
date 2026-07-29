@echo off
echo Setting up ADB reverse proxy for port 5000...
echo.

set ADB_PATH=adb
where adb >nul 2>nul
if %errorlevel% neq 0 (
    set ADB_PATH="C:\Users\abhin\AppData\Local\Android\Sdk\platform-tools\adb.exe"
    if not exist "C:\Users\abhin\AppData\Local\Android\Sdk\platform-tools\adb.exe" (
        set ADB_PATH="%USERPROFILE%\AppData\Local\Android\Sdk\platform-tools\adb.exe"
        if not exist "%USERPROFILE%\AppData\Local\Android\Sdk\platform-tools\adb.exe" (
            echo ERROR: adb command not found in PATH or at default Android SDK location.
            echo.
            pause
            exit /b 1
        )
    )
)

echo Reversing port 5000 using: %ADB_PATH%
%ADB_PATH% reverse tcp:5000 tcp:5000

if %errorlevel% equ 0 (
    echo.
    echo SUCCESS: Port 5000 is now forwarded.
    echo Your Flutter app can connect to the local backend on localhost:5000.
) else (
    echo.
    echo FAILED: Could not reverse port. Please check that:
    echo    1. Your physical Android device is connected via USB.
    echo    2. USB debugging is enabled in Developer Options.
)
echo.
pause
