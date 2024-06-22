SET pythonModules=VALUE

IF EXIST "%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\python.exe" ( DEL "%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\python.exe" )
IF EXIST "%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\python3.exe" ( DEL "%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\python3.exe" )

@REM %COMSPEC% /c SETX PATH "%path%;C:\Python;"
%COMSPEC% /c powershell.exe -executionpolicy bypass -Command ^
	"$oldPath = [Environment]::GetEnvironmentVariable('PATH', 'User');" ^
	"if ($oldPath -ne $null) {" ^
	"	if (-Not ($oldPath -split ';' -like 'C:\Python')) {" ^
	"		[Environment]::SetEnvironmentVariable('PATH', $oldPath+';C:\Python','User');" ^
	"	}" ^
	"	$oldPath = [Environment]::GetEnvironmentVariable('PATH', 'User');" ^
	"	if (-Not ($oldPath -split ';' -like 'C:\Python\Scripts')) {" ^
	"		[Environment]::SetEnvironmentVariable('PATH', $oldPath+';C:\Python\Scripts','User');" ^
	"	}" ^
	"}"
%COMSPEC% /c C:\Python\python -m pip install -U pip
%COMSPEC% /c C:\Python\python -m pip install -U setuptools
If not "%pythonModules%"=="" (
	FOR %%x IN (%pythonModules%) DO %COMSPEC% /c "C:\Python\python" -m pip install %%x
)
