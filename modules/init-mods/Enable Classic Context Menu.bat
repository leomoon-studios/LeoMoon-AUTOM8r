wmic os get name | find "Windows 11 " > null && (echo Windows 11 & GOTO :WIN_11)

exit /b

:WIN_11
%WINDIR%\system32\reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /ve /t REG_SZ /d "" /f
%WINDIR%\system32\reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f
exit /b
