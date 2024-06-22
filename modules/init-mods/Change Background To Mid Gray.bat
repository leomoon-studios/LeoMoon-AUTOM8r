%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v BackgroundType /t REG_DWORD /d 1 /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\Desktop" /v WallPaper /t REG_SZ /d "" /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "0" /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d "0" /f
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "50 50 50" /f
:: accent colors
%WINDIR%\system32\reg.exe add "HKCU\Control Panel\Desktop" /v AutoColorization /t REG_DWORD /d 0 /f
%WINDIR%\system32\reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v AccentColorMenu /t REG_DWORD /d 0xff484a4c /f
%WINDIR%\system32\RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
