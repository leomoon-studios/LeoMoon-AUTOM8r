SET ChangeUserFolderDocuments=VALUE
SET ChangeUserFolderDesktop=VALUE
SET ChangeUserFolderDownloads=VALUE
SET ChangeUserFolderPictures=VALUE
SET ChangeUserFolderMusic=VALUE
SET ChangeUserFolderVideos=VALUE

::documents
If not "%ChangeUserFolderDocuments%"=="" (
	IF not exist %ChangeUserFolderDocuments% (
		mkdir %ChangeUserFolderDocuments%
	)
	IF exist %ChangeUserFolderDocuments% (
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal" /t REG_SZ /d "%ChangeUserFolderDocuments%" /f
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Personal" /t REG_EXPAND_SZ /d "%ChangeUserFolderDocuments%" /f
	)
)
::desktop
If not "%ChangeUserFolderDesktop%"=="" (
	IF not exist %ChangeUserFolderDesktop% (
		mkdir %ChangeUserFolderDesktop%
	)
	IF exist %ChangeUserFolderDesktop% (
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop" /t REG_SZ /d "%ChangeUserFolderDesktop%" /f
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Desktop" /t REG_EXPAND_SZ /d "%ChangeUserFolderDesktop%" /f
	)
)
::downloads
If not "%ChangeUserFolderDownloads%"=="" (
	IF not exist %ChangeUserFolderDownloads% (
		mkdir %ChangeUserFolderDownloads%
	)
	IF exist %ChangeUserFolderDownloads% (
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_SZ /d "%ChangeUserFolderDownloads%" /f
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_EXPAND_SZ /d "%ChangeUserFolderDownloads%" /f
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" /t REG_EXPAND_SZ /d "%ChangeUserFolderDownloads%" /f
	)
)
::pictures
If not "%ChangeUserFolderPictures%"=="" (
	IF not exist %ChangeUserFolderPictures% (
		mkdir %ChangeUserFolderPictures%
	)
	IF exist %ChangeUserFolderPictures% (
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Pictures" /t REG_SZ /d "%ChangeUserFolderPictures%" /f
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Pictures" /t REG_EXPAND_SZ /d "%ChangeUserFolderPictures%" /f
	)
)
::music
If not "%ChangeUserFolderMusic%"=="" (
	IF not exist %ChangeUserFolderMusic% (
		mkdir %ChangeUserFolderMusic%
	)
	IF exist %ChangeUserFolderMusic% (
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Music" /t REG_SZ /d "%ChangeUserFolderMusic%" /f
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Music" /t REG_EXPAND_SZ /d "%ChangeUserFolderMusic%" /f
	)
)
::videos
If not "%ChangeUserFolderVideos%"=="" (
	IF not exist %ChangeUserFolderVideos% (
		mkdir %ChangeUserFolderVideos%
	)
	IF exist %ChangeUserFolderVideos% (
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Video" /t REG_SZ /d "%ChangeUserFolderVideos%" /f
		%WINDIR%\system32\reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Video" /t REG_EXPAND_SZ /d "%ChangeUserFolderVideos%" /f
	)
)