FOR /F "skip=2 tokens=2,*" %%A IN ('reg.exe query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Desktop"') DO set "DESKTOP_PATH=%%B"
call set "DESKTOP_PATH=%DESKTOP_PATH%"

attrib -r -s -h -a %PUBLIC%\Desktop\*.lnk
%COMSPEC% /c del /s /q "%PUBLIC%\Desktop\*.lnk"
attrib -r -s -h -a "%systemdrive%\Users\%username%\Desktop\*.lnk"
%COMSPEC% /c del /s /q "%systemdrive%\Users\%username%\Desktop\*.lnk"

attrib -r -s -h -a %PUBLIC%\Desktop\desktop.ini
%COMSPEC% /c del /s /q "%PUBLIC%\Desktop\desktop.ini"
attrib -r -s -h -a "%systemdrive%\Users\%username%\Desktop\desktop.ini"
%COMSPEC% /c del /s /q "%systemdrive%\Users\%username%\Desktop\desktop.ini"

attrib -r -s -h -a "%DESKTOP_PATH%\*.lnk"
%COMSPEC% /c del /s /q "%DESKTOP_PATH%\*.lnk"
attrib -r -s -h -a "%DESKTOP_PATH%\desktop.ini"
%COMSPEC% /c del /s /q "%DESKTOP_PATH%\desktop.ini"
