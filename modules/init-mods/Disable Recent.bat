%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t  REG_DWORD /d "1" /f