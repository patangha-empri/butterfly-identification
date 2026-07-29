#!/bin/bash
echo "Setting up ADB reverse proxy..."
echo "This routes http://localhost:5000 on your phone to port 5000 on your PC."
echo "Make sure your Android phone is connected via USB and USB debugging is enabled."
echo ""

# Find ADB
if command -v adb &> /dev/null; then
  ADB_CMD="adb"
else
  # Check default Windows paths
  USER_HOME=$(eval echo ~$USER)
  WINDOWS_ADB="/c/Users/abhin/AppData/Local/Android/Sdk/platform-tools/adb.exe"
  if [ -f "$WINDOWS_ADB" ]; then
    ADB_CMD="$WINDOWS_ADB"
  else
    WINDOWS_ADB_ALT="$USER_HOME/AppData/Local/Android/Sdk/platform-tools/adb.exe"
    if [ -f "$WINDOWS_ADB_ALT" ]; then
      ADB_CMD="$WINDOWS_ADB_ALT"
    else
      echo "Error: adb command not found in PATH or at default Android SDK location."
      echo "Please add adb to your PATH or update this script with your adb path."
      exit 1
    fi
  fi
fi

echo "Running: $ADB_CMD reverse tcp:5000 tcp:5000"
$ADB_CMD reverse tcp:5000 tcp:5000
if [ $? -eq 0 ]; then
  echo "SUCCESS: Port 5000 successfully reversed!"
  echo "In your Flutter code (dio_client.dart), set devBaseUrl to: http://localhost:5000"
else
  echo "FAILED: Could not set up ADB reverse. Is your device connected?"
fi
