%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\Network Connections" /v "MUIVerb" /t REG_SZ /d "View Network Connections" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\Network Connections" /v "Icon" /t REG_SZ /d "netcenter.dll,0" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\Network Connections" /v "Position" /t REG_SZ /d "Bottom" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\Network Connections\command" /ve /t REG_SZ /d "control ncpa.cpl" /f