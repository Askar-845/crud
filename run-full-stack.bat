@echo off
REM Full Stack Application Launcher
REM Runs both Spring Boot backend and React frontend automatically

echo ========================================
echo Starting Full Stack Application
echo ========================================
echo.

REM Kill processes on ports 8080 and 3000
echo Cleaning up existing processes...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080"') do (
    taskkill /F /PID %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":3000"') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo Ports cleaned.
echo.

REM Start backend in one window
echo Starting Backend (Spring Boot) on port 8080...
start "Spring Boot Backend" cmd /k "cd /d "%cd%" && .\mvnw.cmd spring-boot:run"

REM Wait for backend to start
timeout /t 4 /nobreak

REM Start frontend in another window
echo Starting Frontend (React) on port 3000...
start "React Frontend" cmd /k "cd /d "%cd%\frontend" && npm start"

echo.
echo ========================================
echo Both applications are starting!
echo ========================================
echo Frontend: http://localhost:3000
echo Backend API: http://localhost:8080
echo.
echo Check the command windows for logs
echo Close the windows to stop services
echo ========================================
pause
