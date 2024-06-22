%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\ControlPanel" /v "MUIVerb" /t REG_SZ /d "System Properties" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\ControlPanel" /v "Icon" /t REG_SZ /d "imageres.dll,-149" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\ControlPanel" /v "Position" /t REG_SZ /d "Bottom" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\ControlPanel\command" /ve /t REG_SZ /d "explorer.exe shell:::{bb06c0e4-d293-4f75-8a90-cb05b6477eee}" /f
