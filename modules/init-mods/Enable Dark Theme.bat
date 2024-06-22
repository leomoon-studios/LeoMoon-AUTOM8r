%WINDIR%\system32\reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v "AccentColor" /t REG_DWORD /d "0x002b2b2b" /f
%WINDIR%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v "AccentColorInactive" /t REG_DWORD /d "0x000b0b0b" /f
%WINDIR%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d "1" /f
