@echo off
setlocal

:loop
cls
set /p name="Enter a name to search (or type 'exit' to quit): "

if /i "%name%"=="exit" goto end

powershell.exe -ExecutionPolicy Bypass -File "%~dp0get-progid.ps1" -Name "%name%"

echo.
pause
goto loop

:end
endlocal
exit
