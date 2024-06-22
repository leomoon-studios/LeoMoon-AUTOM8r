%COMSPEC% /c taskkill /F /IM OneDrive.exe
%COMSPEC% /c %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
%COMSPEC% /c rd "%UserProfile%\OneDrive" /Q /S
%COMSPEC% /c rd "%LocalAppData%\Microsoft\OneDrive" /Q /S
%COMSPEC% /c rd "%ProgramData%\Microsoft OneDrive" /Q /S
%COMSPEC% /c rd "C:\OneDriveTemp" /Q /S
%WINDIR%\system32\reg.exe add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKCR64\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t  REG_DWORD /d "0" /f
%COMSPEC% /c taskkill /F /IM OneDrive.exe
%WINDIR%\system32\reg.exe delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f