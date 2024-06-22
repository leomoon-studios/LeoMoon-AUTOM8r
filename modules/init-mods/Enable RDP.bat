%WINDIR%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-TCP" /v "UserAuthentication" /t REG_DWORD /d "1" /f
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes