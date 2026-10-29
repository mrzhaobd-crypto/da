@echo off
cd /d "%~dp0"
call flutter pub get
if errorlevel 1 goto failed
call flutter build web --release
if errorlevel 1 goto failed
cd mock_server
call npm ci
if errorlevel 1 goto failed
start "" http://localhost:3000
call npm start
goto end
:failed
echo Please install Flutter and Node.js and check the error above.
pause
:end
