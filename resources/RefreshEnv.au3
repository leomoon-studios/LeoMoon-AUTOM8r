Local $HWND_BROADCAST = 0xFFFF
Local $WM_SETTINGCHANGE = 0x1A
DllCall("user32.dll", "int", "SendMessageTimeout", "hwnd", $HWND_BROADCAST, "uint", $WM_SETTINGCHANGE, "ptr", 0, "str", "Environment", "uint", 0, "uint", 5000, "ptr", 0)
