#!/bin/bash

# Find ADB binary
ADB_PATH="adb"

if ! command -v adb &> /dev/null; then
    # 1. Try Windows Git Bash userprofile path
    if [ -n "$USERPROFILE" ]; then
        # Convert C:\Users\xxx to /c/Users/xxx for git bash compatibility
        WIN_PROFILE_PATH=$(echo "$USERPROFILE" | sed -e 's/\\/\//g' -e 's/://g' -e 's/^/\//' -e 's/^\/\([a-zA-Z]\)/\/\L\1/')
        WIN_ADB="$WIN_PROFILE_PATH/AppData/Local/Android/Sdk/platform-tools/adb.exe"
        if [ -f "$WIN_ADB" ]; then
            ADB_PATH="$WIN_ADB"
        fi
    fi
    
    # 2. Try explicit Windows paths for user 'abhin'
    if [ "$ADB_PATH" = "adb" ]; then
        ABHIN_ADB="/c/Users/abhin/AppData/Local/Android/Sdk/platform-tools/adb.exe"
        if [ -f "$ABHIN_ADB" ]; then
            ADB_PATH="$ABHIN_ADB"
        fi
    fi

    # 3. Try standard macOS paths
    if [ "$ADB_PATH" = "adb" ]; then
        GENERIC_MAC_ADB="$HOME/Library/Android/sdk/platform-tools/adb"
        if [ -f "$GENERIC_MAC_ADB" ]; then
            ADB_PATH="$GENERIC_MAC_ADB"
        fi
    fi

    # 4. If still not found, error out
    if [ "$ADB_PATH" = "adb" ]; then
        echo "❌ Error: 'adb' command not found in PATH, and could not locate Android SDK."
        exit 1
    fi
fi

echo "🔄 Reversing port 5000 using: $ADB_PATH"
"$ADB_PATH" reverse tcp:5000 tcp:5000

if [ $? -eq 0 ]; then
    echo "✅ Success! Port 5000 is now forwarded. Your Flutter app can connect to the local backend on localhost:5000."
else
    echo "❌ Failed to reverse port. Please check that:"
    echo "   1. Your physical Android device is connected via USB."
    echo "   2. USB debugging is enabled in Developer Options."
    echo "   3. Run '$ADB_PATH devices' to verify the connection status."
fi
