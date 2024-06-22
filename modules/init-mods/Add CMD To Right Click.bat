%WINDIR%\system32\reg.exe add "HKCR\Directory\shell\cmd2" /ve /t REG_SZ /d "@shell32.dll,-8506" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\shell\cmd2" /v "MUIVerb" /t REG_SZ /d "Open CMD Here" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\shell\cmd2" /v "Icon" /t REG_SZ /d "imageres.dll,-5323" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\shell\cmd2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\shell\cmd2\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f
%WINDIR%\system32\reg.exe add "HKCR\LibraryFolder\background\shell\cmd2" /ve /t REG_SZ /d "@shell32.dll,-8506" /f
%WINDIR%\system32\reg.exe add "HKCR\LibraryFolder\background\shell\cmd2" /v "MUIVerb" /t REG_SZ /d "Open CMD Here" /f
%WINDIR%\system32\reg.exe add "HKCR\LibraryFolder\background\shell\cmd2" /v "Icon" /t REG_SZ /d "imageres.dll,-5323" /f
%WINDIR%\system32\reg.exe add "HKCR\LibraryFolder\background\shell\cmd2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
%WINDIR%\system32\reg.exe add "HKCR\LibraryFolder\background\shell\cmd2\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f
%WINDIR%\system32\reg.exe add "HKCR\Drive\shell\cmd2" /ve /t REG_SZ /d "@shell32.dll,-8506" /f
%WINDIR%\system32\reg.exe add "HKCR\Drive\shell\cmd2" /v "MUIVerb" /t REG_SZ /d "Open CMD Here" /f
%WINDIR%\system32\reg.exe add "HKCR\Drive\shell\cmd2" /v "Icon" /t REG_SZ /d "imageres.dll,-5323" /f
%WINDIR%\system32\reg.exe add "HKCR\Drive\shell\cmd2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
%WINDIR%\system32\reg.exe add "HKCR\Drive\shell\cmd2\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\background\shell\cmd2" /ve /t REG_SZ /d "@shell32.dll,-8506" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\background\shell\cmd2" /v "MUIVerb" /t REG_SZ /d "Open CMD Here" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\background\shell\cmd2" /v "Icon" /t REG_SZ /d "imageres.dll,-5323" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\background\shell\cmd2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
%WINDIR%\system32\reg.exe add "HKCR\Directory\background\shell\cmd2\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f