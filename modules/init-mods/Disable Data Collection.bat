%COMSPEC% /c sc stop "DiagTrack"
%COMSPEC% /c sc config "DiagTrack"  start=disabled
%COMSPEC% /c sc stop "dmwappushservice"
%COMSPEC% /c sc config "dmwappushservice"  start=disabled

%WINDIR%\system32\reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "Allow Telemetry" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "Allow Telemetry" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "Allow Telemetry" /t  REG_DWORD /d "0" /f

%WINDIR%\system32\reg.exe add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "Value" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "Value" /t  REG_DWORD /d "0" /f

%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t  REG_DWORD /d "0" /f

%WINDIR%\system32\reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t  REG_DWORD /d "0" /f
%WINDIR%\system32\reg.exe add "HKLM\System\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t  REG_DWORD /d "0" /f

%WINDIR%\system32\reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t  REG_DWORD /d "0" /f
