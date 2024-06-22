wmic os get name | find "Windows 10 " > nul && (echo Windows 10 & GOTO :WIN_11)

exit /b

:WIN_11
%COMSPEC% /c powershell.exe -executionpolicy bypass -Command "& '..\tools\WinSetView.ps1' -file '..\tools\WinSetView_Win10.ini'"
exit /b
