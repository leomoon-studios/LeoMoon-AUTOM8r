%WINDIR%\system32\reg.exe add "HKCU\Control Panel\TimeDate\AdditionalClocks\1" /v "Enable" /t REG_DWORD /d "1" /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\TimeDate\AdditionalClocks\1" /v "DisplayName" /t REG_SZ /d "Iran" /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\TimeDate\AdditionalClocks\1" /v "TzRegKeyName" /t REG_SZ /d "Iran Standard Time" /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\TimeDate\AdditionalClocks\2" /v "Enable" /t REG_DWORD /d "1" /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\TimeDate\AdditionalClocks\2" /v "DisplayName" /t REG_SZ /d "Amsterdam" /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\TimeDate\AdditionalClocks\2" /v "TzRegKeyName" /t REG_SZ /d "W. Europe Standard Time" /f