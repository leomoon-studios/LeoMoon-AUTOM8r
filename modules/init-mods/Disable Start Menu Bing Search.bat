wmic os get name | find "Windows 11 " > nul && (echo Windows 11 & GOTO :WIN_11)

exit /b

:WIN_11
%WINDIR%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t  REG_DWORD /d "1" /f
exit /b
