%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\Programs and Features" /v "MUIVerb" /t REG_SZ /d "Programs and Features" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\Programs and Features" /v "Icon" /t REG_SZ /d "imageres.dll,-87" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\Programs and Features" /v "Position" /t REG_SZ /d "Bottom" /f
%WINDIR%\system32\reg.exe add "HKCR\DesktopBackground\Shell\Programs and Features\command" /ve /t REG_SZ /d "control appwiz.cpl" /f