@echo off
title VS Code Auto Setup

echo Running VS Code Auto Setup...
powershell -ExecutionPolicy Bypass -File "%~dp0setup_vscode.ps1"

echo.
echo Setup complete. You may now start Visual Studio Code.
pause