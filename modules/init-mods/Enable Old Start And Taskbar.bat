wmic os get name | find "Windows 11 " > null && (echo Windows 11 & GOTO :WIN_11)

exit /b

:WIN_11
rem no widgets
%WINDIR%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t  REG_DWORD /d "0" /f
rem align left
%WINDIR%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t  REG_DWORD /d "0" /f
rem no task view
%WINDIR%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t  REG_DWORD /d "0" /f
exit /b
