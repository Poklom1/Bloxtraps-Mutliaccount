@echo off
:: Uninstall Bloxstrap Multi-instance Tool

set "scriptPath=C:\Users\qiuja\Downloads\bloxstrap-multi-instance-integration-main\bloxstrap-multi-instance-integration-main\Multi-instance.ps1"

:: Check if the PowerShell script exists at the provided path
if not exist "%scriptPath%" (
    echo The script was not found at the specified path.
    pause
    exit /b
)

:: Run the script with "uninstall" argument
echo Uninstalling Bloxstrap Multi-instance Integration...
powershell -ExecutionPolicy Bypass -File "%scriptPath%" uninstall

pause

