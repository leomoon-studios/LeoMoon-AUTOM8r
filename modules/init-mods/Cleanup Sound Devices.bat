%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v ShowHiddenDevices /t REG_DWORD /d 00000000 /f
%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v ShowDisconnectedDevices /t REG_DWORD /d 00000000 /f
%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v VolumeUnits /t REG_DWORD /d 00000000 /f
