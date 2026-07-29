@echo off
echo Setting up ADB reverse proxy...
echo This routes http://localhost:5000 on your phone to port 5000 on your PC.
echo Make sure your Android phone is connected via USB and USB debugging is enabled.
echo.

set ADB_CMD=adb
where adb >nul 2>nul
if %errorlevel% neq 0 (
    set ADB_CMD="C:\Users\abhin\AppData\Local\Android\Sdk\platform-tools\adb.exe"
    if not exist "C:\Users\abhin\AppData\Local\Android\Sdk\platform-tools\adb.exe" (
        set ADB_CMD="%USERPROFILE%\AppData\Local\Android\Sdk\platform-tools\adb.exe"
        if not exist "%USERPROFILE%\AppData\Local\Android\Sdk\platform-tools\adb.exe" (
            echo Error: adb command not found in PATH or at default Android SDK location.
            echo Please add adb to your PATH or update this script.
            pause
            exit /b 1
        )
    )
)

echo Running: %ADB_CMD% reverse tcp:5000 tcp:5000
%ADB_CMD% reverse tcp:5000 tcp:5000
if %errorlevel% == 0 (
    echo SUCCESS: Port 5000 successfully reversed!
    echo In your Flutter code ^(dio_client.dart^), set devBaseUrl to: http://localhost:5000
) else (
    echo FAILED: Could not set up ADB reverse. Is your device connected?
)
pause
