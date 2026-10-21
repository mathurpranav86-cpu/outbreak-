@echo off
setlocal enabledelayedexpansion
title Outbreak: 2D Zombie Survival

echo ===================================================
echo Launching Outbreak: 2D Zombie Survival (Godot 4)
echo ===================================================

:: 1. Check if godot is in PATH
where godot >nul 2>nul
if %ERRORLEVEL% equ 0 (
    godot --path "%~dp0"
    exit /b 0
)

:: 2. Search local WinGet installation
set WINGET_GODOT=%LOCALAPPDATA%\Microsoft\WinGet\Packages
for /r "%WINGET_GODOT%" %%f in (*godot*.exe) do (
    set "EXE_NAME=%%~nxf"
    if not "!EXE_NAME:_console=!"=="!EXE_NAME!" (
        rem skip console exe if windowed is available
    ) else (
        echo Found Godot at: %%f
        start "" "%%f" --path "%~dp0"
        exit /b 0
    )
)

:: Fallback to any godot executable found
for /r "%WINGET_GODOT%" %%f in (*godot*.exe) do (
    echo Found Godot at: %%f
    "%%f" --path "%~dp0"
    exit /b 0
)

echo.
echo [ERROR] Godot executable not found automatically.
echo Please run: winget install GodotEngine.GodotEngine
echo Or open Godot and import project.godot from this directory.
pause
