SET "ps_script=%cd%\..\tools\install-fonts.ps1"
SET "fonts_common=%cd%\fonts\common"
FOR /f "tokens=3" %%a IN ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName 2^>nul') DO SET "ComputerName=%%a"
SET "fonts_current=%cd%\fonts\%ComputerName%"

IF EXIST "%fonts_common%" (
    powershell.exe -ExecutionPolicy Bypass -File "%ps_script%" -Path "%fonts_common%"
)
IF EXIST "%fonts_current%" (
    powershell.exe -ExecutionPolicy Bypass -File "%ps_script%" -Path "%fonts_current%"
)
