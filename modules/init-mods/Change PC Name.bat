SET ChangePCNameTo=VALUE

If not "%ChangePCNameTo%"=="" (
%WINDIR%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Hostname" /t REG_SZ /d "%ChangePCNameTo%" /f
%WINDIR%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Hostname" /t REG_SZ /d "%ChangePCNameTo%" /f
%WINDIR%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /v "ComputerName" /t REG_SZ /d "%ChangePCNameTo%" /f
%WINDIR%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v "ComputerName" /t REG_SZ /d "%ChangePCNameTo%" /f
)