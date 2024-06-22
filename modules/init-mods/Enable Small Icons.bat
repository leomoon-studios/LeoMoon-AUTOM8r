wmic os get name | find "Windows 7 " > nul  && (echo Windows 7 & GOTO :WIN_7_10)
wmic os get name | find "Windows 8 " > nul  && (echo Windows 8 & GOTO :WIN_7_10)
wmic os get name | find "Windows 10 " > nul && (echo Windows 10 & GOTO :WIN_7_10)
wmic os get name | find "Windows 11 " > nul && (echo Windows 11 & GOTO :WIN_11)

exit /b

:WIN_7_10
%WINDIR%\system32\reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" /v "IconSize" /t  REG_DWORD /d "32" /f
%WINDIR%\system32\reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" /v "Mode" /t  REG_DWORD /d "1" /f
%WINDIR%\system32\reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" /v "LogicalViewMode" /t  REG_DWORD /d "3" /f
%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t  REG_DWORD /d "1" /f
exit /b

:WIN_11
%WINDIR%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t  REG_DWORD /d "1" /f
exit /b
