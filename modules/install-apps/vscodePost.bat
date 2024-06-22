SET vscodeExtensions=VALUE

REM Install extensions
If not "%vscodeExtensions%"=="" (
    FOR %%x IN (%vscodeExtensions%) DO %COMSPEC% /c "C:\Program Files\Microsoft VS Code\bin\code" --install-extension %%x
)

REM Setup right click with reg
IF EXIST "C:\Program Files\Microsoft VS Code\Code.exe" (
    %WINDIR%\system32\reg.exe add "HKCR\*\shell\Open with VS Code" /ve /t REG_SZ /d "Edit with VS Code" /f
    %WINDIR%\system32\reg.exe add "HKCR\*\shell\Open with VS Code" /v "Icon" /t REG_SZ /d "C:\Program Files\Microsoft VS Code\Code.exe,0" /f
    %WINDIR%\system32\reg.exe add "HKCR\*\shell\Open with VS Code\command" /ve /t REG_SZ /d "\"C:\Program Files\Microsoft VS Code\Code.exe\" \"%%1\"" /f
    %WINDIR%\system32\reg.exe add "HKCR\Directory\shell\vscode" /ve /t REG_SZ /d "Open Folder as VS Code Project" /f
    %WINDIR%\system32\reg.exe add "HKCR\Directory\shell\vscode" /v "Icon" /t REG_SZ /d "\"C:\Program Files\Microsoft VS Code\Code.exe\",0" /f
    %WINDIR%\system32\reg.exe add "HKCR\Directory\shell\vscode\command" /ve /t REG_SZ /d "\"C:\Program Files\Microsoft VS Code\Code.exe\" \"%%1\"" /f
    %WINDIR%\system32\reg.exe add "HKCR\Directory\background\shell\vscode" /ve /t REG_SZ /d "Open Folder as VS Code Project" /f
    %WINDIR%\system32\reg.exe add "HKCR\Directory\background\shell\vscode" /v "Icon" /t REG_SZ /d "\"C:\Program Files\Microsoft VS Code\Code.exe\",0" /f
    %WINDIR%\system32\reg.exe add "HKCR\Directory\background\shell\vscode\command" /ve /t REG_SZ /d "\"C:\Program Files\Microsoft VS Code\Code.exe\" \"%%V\"" /f
)

REM Apply Git changes
git config --global core.editor "code --wait"
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait $MERGED"
git config --global diff.tool vscode
git config --global difftool.vscode.cmd "code --wait --diff $LOCAL $REMOTE"