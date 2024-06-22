SET gitName=VALUE
SET gitEmail=VALUE

IF NOT "%gitName%"=="" ( "C:\Program Files\Git\bin\git" config --global user.name "%gitName%" )
IF NOT "%gitEmail%"=="" ( "C:\Program Files\Git\bin\git" config --global user.email "%gitEmail%" )

@REM fix for fatal: detected dubious ownership in repository
"C:\Program Files\Git\bin\git" config --global --add safe.directory "*"

"C:\Program Files\Git\bin\git" config --global core.editor "code --wait"
"C:\Program Files\Git\bin\git" config --global diff.tool vscode
"C:\Program Files\Git\bin\git" config --global difftool.vscode.cmd "code --wait --diff $LOCAL $REMOTE"
"C:\Program Files\Git\bin\git" config --global merge.tool vscode
"C:\Program Files\Git\bin\git" config --global mergetool.vscode.cmd "code --wait $MERGED"
