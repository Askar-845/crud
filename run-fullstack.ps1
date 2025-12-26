#!/usr/bin/env pwsh
# Full Stack Application Launcher
# Runs both Spring Boot backend and React frontend automatically

$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "Starting Full Stack Application..." -ForegroundColor Cyan
Write-Host ""

# Kill any existing processes on ports 8080 and 3000
Write-Host "Cleaning up existing processes..." -ForegroundColor Yellow
try {
    $proc8080 = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
    if ($proc8080) {
        Get-Process -Id $proc8080.OwningProcess -ErrorAction SilentlyContinue | Stop-Process -Force
        Write-Host "Stopped process on port 8080" -ForegroundColor Green
    }
}
catch {
    # Silently continue if no process found
}

try {
    $proc3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
    if ($proc3000) {
        Get-Process -Id $proc3000.OwningProcess -ErrorAction SilentlyContinue | Stop-Process -Force
        Write-Host "Stopped process on port 3000" -ForegroundColor Green
    }
}
catch {
    # Silently continue if no process found
}

Write-Host ""
Write-Host "Starting Backend (Spring Boot) on port 8080..." -ForegroundColor Cyan
Start-Job -ScriptBlock {
    Set-Location $using:projectPath
    & .\mvnw.cmd spring-boot:run
} -Name "Backend"

Start-Sleep -Seconds 3

Write-Host "Starting Frontend (React) on port 3000..." -ForegroundColor Cyan
Start-Job -ScriptBlock {
    Set-Location "$using:projectPath\frontend"
    & npm start
} -Name "Frontend"

Write-Host ""
Write-Host "Both applications are starting!" -ForegroundColor Green
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host "Backend API: http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "Watching logs... Press Ctrl+C to stop all services" -ForegroundColor Yellow
Write-Host ""

# Monitor both jobs
$running = $true
while ($running) {
    $backend = Get-Job -Name "Backend" -ErrorAction SilentlyContinue
    $frontend = Get-Job -Name "Frontend" -ErrorAction SilentlyContinue
    
    if (($backend -and $backend.State -eq "Failed") -or ($frontend -and $frontend.State -eq "Failed")) {
        Write-Host ""
        Write-Host "Error in one of the services. Stopping all..." -ForegroundColor Red
        Get-Job | Stop-Job
        Get-Job | Remove-Job
        $running = $false
    }
    
    Start-Sleep -Seconds 2
}

# Clean up on exit
Write-Host "Stopping all services..." -ForegroundColor Yellow
Get-Job | Stop-Job
Get-Job | Remove-Job
Write-Host "All services stopped." -ForegroundColor Green
