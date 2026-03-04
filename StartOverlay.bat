@echo off
cd C:\git\chat
:LOOP
start "" /high /wait "godot-4.4.1.exe"  --quiet --no-header
if %ERRORLEVEL% neq 0 (
    echo Crash detected. Restarting...
    timeout /t 2 >nul
    goto LOOP
)