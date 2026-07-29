@echo off
echo Starting localtunnel for Flask API on port 5000...
echo This will give you a public URL (e.g., https://xxxxx.localthost.run or lt).
echo You can set devBaseUrl in your Flutter app to this public URL.
echo.
npx localtunnel --port 5000
pause
