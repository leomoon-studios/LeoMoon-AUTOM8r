reg add "HKEY_CURRENT_USER\Control Panel\International" /v sShortDate /t REG_SZ /d "yyyy/MM/dd" /f
reg add "HKEY_USERS\.DEFAULT\Control Panel\International" /v sShortDate /t REG_SZ /d "yyyy/MM/dd" /f

reg add "HKEY_CURRENT_USER\Control Panel\International" /v iTime /t REG_SZ /d "1" /f
reg add "HKEY_USERS\.DEFAULT\Control Panel\International" /v iTime /t REG_SZ /d "1" /f

reg add "HKEY_CURRENT_USER\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f
reg add "HKEY_USERS\.DEFAULT\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f
