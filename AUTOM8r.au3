#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=resources\gear.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Language=1033
;#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#pragma compile(Out, AUTOM8r.exe)
#pragma compile(Compression, 9)
#pragma compile(Comments, This program is freeware.)
#pragma compile(ProductName, LeoMoon AUTOM8r)
#pragma compile(FileDescription, LeoMoon AUTOM8r)
#pragma compile(FileVersion, 2.2.2.0)
#pragma compile(LegalCopyright, Amin Babaeipanah)
#pragma compile(CompanyName, LeoMoon Studios)
#pragma compile(LegalTrademarks, LeoMoon Studios)
#pragma compile(ProductVersion, 2.2.2)

#include <File.au3> ;search n replace
#include <AutoItConstants.au3> ;mapping drives
#include <FileConstants.au3> ;filecopy
#include <WinAPIFiles.au3> ;x64 redirection
#include <WinAPIGdi.au3> ;_fontInstall
#include <WinAPIShellEx.au3> ;_fontInstall
#include <WinAPIFiles.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <SendMessage.au3>

Opt("WinTitleMatchMode", 2) ;match any string in title
RegWrite('HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters', 'AllowInsecureGuestAuth','REG_DWORD','1') ;enable smb2 guest access
;disable uac
RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System', 'ConsentPromptBehaviorAdmin', 'REG_DWORD', '0')
RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System', 'EnableLUA', 'REG_DWORD', '0')
;variables
Global $title = 'LeoMoon AUTOM8r'
Global $files_dir = 'modules'
Global $setup_path = @ScriptDir&'\'&$files_dir
Global $ini_file = @ScriptDir&'\AUTOM8r.ini'
Global $source = IniRead($ini_file, 'AUTOM8', 'network_path', '')
Global $debug = IniRead($ini_file, 'AUTOM8', 'debug', '')
Global $show_batch_window = IniRead($ini_file, 'AUTOM8', 'show_batch_window', '')
Global $env_vars_section_name = IniRead($ini_file, 'AUTOM8', 'env_vars_section_name', '')
Global $init_section_name = IniRead($ini_file, 'AUTOM8', 'init_mods_section_name', '')
Global $install_apps_section_name = IniRead($ini_file, 'AUTOM8', 'install_apps_section_name', '')
Global $uninstall_section_name = IniRead($ini_file, 'AUTOM8', 'uninstall_apps_section_name', '')
Global $pin_apps_section_name = IniRead($ini_file, 'AUTOM8', 'pin_apps_section_name', '')
Global $post_section_name = IniRead($ini_file, 'AUTOM8', 'post_mods_section_name', '')
Global $mounts_section_name = IniRead($ini_file, 'AUTOM8', 'mounts_section_name', '')
Global $runapps_section_name = IniRead($ini_file, 'AUTOM8', 'run_apps_section_name', '')
Global $startupregdel_section_name = IniRead($ini_file, 'AUTOM8', 'startup_reg_delete_section_name', '')
Global $hSnd
Global $net = False
Global $self_delete = False

; runAsAdmin
If Not IsAdmin() Then
    MsgBox(16, 'Error!', 'Please run this program as admin.')
    Exit
EndIf

; ini search
If Not FileExists($ini_file) Then
    ; Search for the first matching AUTOM8r*.ini file
    $search = FileFindFirstFile(@ScriptDir & '\AUTOM8r*.ini')
    If $search <> -1 Then
        $ini_file = FileFindNextFile($search)
        FileClose($search)
        $ini_file = @ScriptDir & '\' & $ini_file
    Else
        MsgBox(16, 'Error!', $ini_file&' does not exist!')
        Exit
    EndIf
EndIf

If $debug == 1 Then ConsoleWrite(@LF&"Using INI file: " & $ini_file & @LF)

; check internet connection
$ret = DllCall("WinInet.dll","int","InternetGetConnectedState","int_ptr",0,"int",0)
If $ret[0] Then $net = True

; ask user first
If $debug == 0 Then
    $t = MsgBox (4, $title ,'Do you want to AUTOM8 this computer?')
    If $t = 7 Then
        Exit
    EndIf
EndIf

If $debug == 0 Then ManageDefenderExclusion($setup_path, True)

; copy files
_copyFiles($install_apps_section_name)

; detect missing files
_detectMissing($install_apps_section_name)

; start ui
if $debug <> 1 Then
    $hSnd = SplashTextOn($title, 'Applying Mods...'&@LF&'Please wait...', 500, 55,-1,-1, 12, "Tahoma", 10)
    Local $sPos = WinGetPos($hSnd)
    WinMove($hSnd, '', $sPos[0], $sPos[1]-350)
EndIf

; env-vars
If $debug == 1 Then _debugBlock(StringUpper($env_vars_section_name))
_addEnvVars($env_vars_section_name)

; init-mods
If $debug == 1 Then _debugBlock(StringUpper($init_section_name))
_scriptRunSection($init_section_name, '.bat')

; install fonts
If $debug == 1 Then _debugBlock('FONTS')
_installFonts()

; install-apps
If $debug == 1 Then _debugBlock(StringUpper($install_apps_section_name))
_installAppsSection($install_apps_section_name)

; uninstall-apps
If $debug == 1 Then _debugBlock(StringUpper($uninstall_section_name))
_uninstallAppsSection($uninstall_section_name)

; startup-reg-delete
If $debug == 1 Then _debugBlock(StringUpper($startupregdel_section_name))
_startupRegDeleteSection($startupregdel_section_name)

; pin-apps
If $debug == 1 Then _debugBlock(StringUpper($pin_apps_section_name))
_generatePinApps($pin_apps_section_name)
;~ _pinApps($pin_apps_section_name, 500)

; post-mods
If $debug == 1 Then _debugBlock(StringUpper($post_section_name))
_scriptRunSection($post_section_name, '.bat')

; run-apps
If $debug == 1 Then _debugBlock(StringUpper($runapps_section_name))
_runAppsSection($runapps_section_name, 1000)

; mounts
;~ If $debug == 1 Then _debugBlock(StringUpper($mounts_section_name))
;~ _mounts($mounts_section_name, 500)

; finish
If $debug == 1 Then _debugBlock(StringUpper('CLEANUP'))
_cleanup($init_section_name)

Exit

Func _copyFiles($section)
    If Not FileExists($setup_path) Then
        If $debug == 1 Then _debugBlock('COPY')
        $self_delete = True
        $title = $title&' [Network Install]'
        If Not FileExists($source) Then
            MsgBox(16, 'Error!', $source&' does not exist!')
            Exit
        EndIf
        if $debug == 1 Then
            ConsoleWrite($source&'\'&$files_dir&'\'&$init_section_name&' TO '&$setup_path&'\'&$init_section_name&@LF)
            ConsoleWrite($source&'\'&$files_dir&'\'&$post_section_name&' TO '&$setup_path&'\'&$post_section_name&@LF)
            ConsoleWrite($source&'\'&$files_dir&'\tools'&' TO '&$setup_path&'\tools'&@LF)
        Else
            ProgressOn($title, 'Copying required files. Please wait...', "Copying: ", -1, -1, 16)
            _copyProgress($source&'\'&$files_dir&'\'&$init_section_name, $setup_path&'\'&$init_section_name, 2)
            _copyProgress($source&'\'&$files_dir&'\'&$post_section_name, $setup_path&'\'&$post_section_name, 2)
            _copyProgress($source&'\'&$files_dir&'\tools', $setup_path&'\tools', 2)
        EndIf
        ;copy setup files
        Local $aSections = IniReadSection($ini_file, $section)
        If Not @error Then
            For $i = 1 To $aSections[0][0]
                If IniRead($ini_file, $section, $aSections[$i][0], '') = 1 Then
                    ;~ $key = StringSplit($aSections[$i][0],',')
                    $appName = $aSections[$i][0]
                    $iFile = _FileListToArray($source&'\'&$files_dir&'\'&$section, $appName&'*', 1, True)
                    If IsArray($iFile) Then
                        For $f = 1 To $iFile[0]
                            if $debug == 1 Then
                                ConsoleWrite($iFile[$f]&' TO '&$setup_path&'\'&$section&@LF)
                            Else
                                _copyProgress($iFile[$f], $setup_path&'\'&$section)
                            EndIf
                        Next
                    EndIf
                EndIf
            Next
        EndIf
        ProgressOff()
    Else
        $title = $title&' [Local Install]'
    EndIf
EndFunc

Func _detectMissing($section)
    Local $miss_files = ''
    Local $aSections = IniReadSection($ini_file, $section)
    If Not @error Then
        For $i = 1 To $aSections[0][0]
            If IniRead($ini_file, $section, $aSections[$i][0], '') = 1 Then
                ;~ $key = StringSplit($aSections[$i][0],',')
                $appName = $aSections[$i][0]
                $iFile = _FileListToArray($setup_path&'\'&$section, $appName&'*', 1, True)
                If Not IsArray($iFile) Then $miss_files &= $appName&', '
            EndIf
        Next
    EndIf
    ;show what files are missing
    If $miss_files <> '' Then
        If $debug == 1 Then
            ConsoleWrite('Missing setup files: '&$miss_files&@LF)
        Else
            MsgBox(0, $title ,'Missing setup files: '&$miss_files)
        EndIf
        Exit
    EndIf
EndFunc

Func _debugBlock($text)
    ConsoleWrite(@LF & _
        '######################################################'&@LF & _
        '####### '&$text&@LF & _
        '######################################################'&@LF)
EndFunc

Func _copyProgress($source, $destination, $type = 1)
    Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
    Local $aPathSplit = _PathSplit($source, $sDrive, $sDir, $sFileName, $sExtension)
    $name = $aPathSplit[3]&$aPathSplit[4]
    If $type == 2 Then
        $total = DirGetSize($source)
        DirCreate($destination)
        $nameDisplay = '"'&$name&'"'&' Folder'
        $PID = Run('robocopy /S "'&$source&'" "'&$destination&'" "*.*"', @ScriptDir, @SW_HIDE)
        ;$PID = Run('xcopy /z /y "'&$source&'" "'&$destination&'"', @ScriptDir, @SW_HIDE)
    Else
        $total = FileGetSize($source)
        $nameDisplay = '"'&$name&'"'
        ;ConsoleWrite($name&@LF)
        $PID = Run('robocopy /S "'&StringTrimRight($aPathSplit[1]&$aPathSplit[2], 1)&'" "'&$destination&'" "'&$name&'"', @ScriptDir, @SW_HIDE)
        ;$PID = Run('xcopy /z /y "'&$source&'" "'&$destination&'"', @ScriptDir,@SW_HIDE)
    EndIf
    While ProcessExists($PID)
        $aMem = ProcessGetStats($PID, 1)
        If IsArray($aMem) Then $Percent = (($aMem[4]/$total)*100)
        ProgressSet(Round($Percent), 'Copying: '&$nameDisplay, 'Copying required files. Please wait...')
        Sleep(10)
    WEnd
    ProgressSet(100, 'Copying: '&$nameDisplay, 'Copying required files. Please wait...')
EndFunc

Func _installFonts()
    Local $install_fonts_script = $setup_path & '\tools\install-fonts.ps1'
    Local $fonts_common = $source & '\fonts\common'
    Local $pc_name = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName", "ComputerName")
    $pc_name = StringLower($pc_name)
    Local $fonts_current = $source & '\fonts\' & $pc_name
    if $debug == 1 Then
        If FileExists($fonts_common) Then ConsoleWrite('INSTALL FONTS: powershell.exe -ExecutionPolicy Bypass -File "' & $install_fonts_script & '" -Path "' & $fonts_common & '"'&@LF)
        If FileExists($fonts_current) Then ConsoleWrite('INSTALL FONTS: powershell.exe -ExecutionPolicy Bypass -File "' & $install_fonts_script & '" -Path "' & $fonts_current & '"'&@LF)
    Else
        If FileExists($fonts_common) Then
            ControlSetText($hSnd, '', 'Static1', 'Installing fonts: '&$fonts_common&@LF&'Please wait...')
            If $show_batch_window == 1 Then
                RunWait('powershell.exe -ExecutionPolicy Bypass -File "' & $install_fonts_script & '" -Path "' & $fonts_common & '"', "", @SW_SHOW)
            Else
                RunWait('powershell.exe -ExecutionPolicy Bypass -File "' & $install_fonts_script & '" -Path "' & $fonts_common & '"', "", @SW_HIDE)
            EndIf
        EndIf
        If FileExists($fonts_current) Then
            ControlSetText($hSnd, '', 'Static1', 'Installing fonts: '&$fonts_current&@LF&'Please wait...')
            If $show_batch_window == 1 Then
                RunWait('powershell.exe -ExecutionPolicy Bypass -File "' & $install_fonts_script & '" -Path "' & $fonts_current & '"', "", @SW_SHOW)
            Else
                RunWait('powershell.exe -ExecutionPolicy Bypass -File "' & $install_fonts_script & '" -Path "' & $fonts_current & '"', "", @SW_HIDE)
            EndIf
        EndIf
    EndIf
EndFunc

Func _addEnvVars($section)
    Local $aEnvVars = IniReadSection($ini_file, $section)
    If Not @error Then
        For $i = 1 To $aEnvVars[0][0]
            ; Split the key to get the environment variable name and value
            Local $aKeyParts = StringSplit($aEnvVars[$i][0], "|")
            If $debug == 1 Then
                ConsoleWrite("Processing entry: " & $aEnvVars[$i][0] & " = " & $aEnvVars[$i][1] & @LF)
            EndIf
            ; Check if the format is correct
            If UBound($aKeyParts) <> 3 Then
                If $debug == 1 Then
                    ConsoleWrite("  ERROR: Invalid format for entry: " & $aEnvVars[$i][0] & @LF)
                EndIf
                ContinueLoop
            EndIf
            If $aEnvVars[$i][1] == 1 Then
                Local $sEnvVarName = $aKeyParts[1]
                Local $sEnvVarValue = $aKeyParts[2]
                If $debug == 1 Then
                    ConsoleWrite("  ENV VAR: " & $sEnvVarName & @LF)
                    ConsoleWrite("  VALUE: " & $sEnvVarValue & @LF)
                EndIf
                ; Get the existing environment variable value from the registry
                Local $sExistingValue = RegRead("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", $sEnvVarName)
                If $debug == 0 And Not @error Then
                    Local $sBackupFile = "C:\ENV_" & $sEnvVarName & "_" & @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC & ".txt"
                    Local $hFile = FileOpen($sBackupFile, 2)
                    If $hFile <> -1 Then
                        FileWrite($hFile, $sExistingValue)
                        FileClose($hFile)
                    EndIf
                EndIf
                If Not @error Then ; Key exists
                    If $debug == 1 Then
                        ConsoleWrite("  EXISTING VALUE: " & $sExistingValue & @LF)
                    EndIf
                    If StringInStr($sExistingValue, $sEnvVarValue) == 0 Then
                        If StringInStr($sExistingValue, ";") Then
                            If $debug == 1 Then
                                ConsoleWrite("    APPENDING" & @LF)
                            Else
                                RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", $sEnvVarName, "REG_SZ", $sExistingValue & ";" & $sEnvVarValue)
                            EndIf
                        Else
                            If $debug == 1 Then
                                ConsoleWrite("    REPLACING" & @LF)
                            Else
                                RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", $sEnvVarName, "REG_SZ", $sEnvVarValue)
                            EndIf
                        EndIf
                    Else
                        ConsoleWrite("    SKIPPING" & @LF)
                    EndIf
                Else
                    ; If the variable doesn't exist, set it
                    If $debug == 1 Then
                        ConsoleWrite("    ADDING" & @LF)
                    Else
                        RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", $sEnvVarName, "REG_SZ", $sEnvVarValue)
                    EndIf
                EndIf
            EndIf
            ConsoleWrite(@LF)
        Next
    EndIf
    ; Notify the system that environment variables have changed if not in debug mode
    If $debug == 0 Then
        Local $HWND_BROADCAST = 0xFFFF
        Local $WM_SETTINGCHANGE = 0x1A
        DllCall("user32.dll", "int", "SendMessageTimeout", "hwnd", $HWND_BROADCAST, "uint", $WM_SETTINGCHANGE, "ptr", 0, "str", "Environment", "uint", 0, "uint", 5000, "ptr", 0)
    EndIf
EndFunc

Func _installAppsSection($section)
    Local $aSections = IniReadSection($ini_file, $section)
    If Not @error Then
        For $i = 1 To $aSections[0][0]
            If $aSections[$i][1] == 1 Then
                Local $extract = False
                Local $appName = $aSections[$i][0]
                Local $file, $extractDir, $extractCmd
                Local $binFile = ''
                Local $working_dir = ''
                Local $skip = ''
                Local $partial = False
                If FileExists($setup_path & '\' & $section & '\' & $appName & 'Setup.exe') Then
                    $file = $appName & 'Setup.exe'
                ElseIf FileExists($setup_path & '\' & $section & '\' & $appName & 'Setup.msi') Then
                    $file = $appName & 'Setup.msi'
                ElseIf FileExists($setup_path & '\' & $section & '\' & $appName & 'Setup.iso') Then
                    $extract = True
                    $file = $appName & 'Setup.iso'
                    $extractDir = $setup_path & "\extract\" & $appName
                    $extractCmd = @ComSpec & ' /c ""' & $setup_path & '\tools\7z.exe" x "' & $setup_path & '\' & $section & '\' & $file & '" -o"' & $extractDir & '""'
                    Local $setupFilePath = IniRead($ini_file, $appName, "setup-file", "setup.exe")
                EndIf
                If $extract Then
                    $binFile = $extractDir&'\'&$setupFilePath
                    $working_dir = $extractDir
                Else
                    $binFile = $setup_path&'\'&$section&'\'&$file
                    $working_dir = $setup_path&'\'&$section
                EndIf
                ;Read application-specific installation parameters
                Local $postfile = $appName & 'Post.bat'
                Local $displayname = IniRead($ini_file, $appName, "display-name", "")
                Local $partialsearch = IniRead($ini_file, $appName, "partial-search", "")
                ;~ Local $param = StringReplace(IniRead($ini_file, $appName, "silent-switches", ""), '|EQUAL|', '=')
                ;~ $param = StringReplace($param, '|COMMA|', ',')
                Local $param = IniRead($ini_file, $appName, "silent-switches", "")
                Local $driver = IniRead($ini_file, $appName, "driver-install", "")
                Local $winwait = IniRead($ini_file, $appName, "win-wait", "")
                Local $controlid = IniRead($ini_file, $appName, "click-element", "")
                Local $appclose = IniRead($ini_file, $appName, "process-close", "")
                Local $runclose = IniRead($ini_file, $appName, "run-close", "")
                Local $postsetup = IniRead($ini_file, $appName, "post-setup", "")
                ;Determine if app is installed
                If $partialsearch == 1 Then $partial = True
                Local $aFoundApps = _appSearch($displayname, $partial)
                If UBound($aFoundApps) > 0 Then $skip = ' (SKIP)'
                If $debug == 1 Then
                    ConsoleWrite($appName & $skip & @LF)
                    If $extract Then
                        ConsoleWrite('  extract:' & @LF)
                        ConsoleWrite('    extract dir: ' & $extractDir & @LF)
                        ConsoleWrite('    extract cmd: ' & $extractCmd & @LF)
                    EndIf
                    ConsoleWrite('  display-name: ' & $displayname & @LF)
                    ConsoleWrite('  partial-search: ' & $partialsearch & @LF)
                    ConsoleWrite('  file: ' & $file & @LF)
                    ConsoleWrite('  full-path: ' & $binFile & @LF)
                    ConsoleWrite('  silent-switches: ' & $param & @LF)
                    ConsoleWrite('  driver-install: ' & $driver & @LF)
                    ConsoleWrite('  win-wait: ' & $winwait & @LF)
                    ConsoleWrite('  click-element: ' & $controlid & @LF)
                    ConsoleWrite('  process-close: ' & $appclose & @LF)
                    ConsoleWrite('  run-close: ' & $runclose & @LF)
                    ConsoleWrite('  post-setup: ' & $postsetup & @LF)
                    ConsoleWrite('  cmd: ' & $binFile & ', ' & $param & ', ' & $working_dir & @LF)
                    If FileExists($setup_path&'\'&$section&'\'&$postfile) Then ConsoleWrite('    post-command: '&@ComSpec&' /c "'&$setup_path&'\'&$section&'\'&$postfile&'"'&@LF)
                Else
                    If UBound($aFoundApps) == 0 Then
                        If $extract Then
                            ControlSetText($hSnd, '', 'Static1', 'Extracting '&$appName&'...'&@LF&'Please wait...')
                            DirCreate($extractDir)
                            If $show_batch_window == 1 Then
                                RunWait($extractCmd, "", @SW_SHOW)
                            Else
                                RunWait($extractCmd, "", @SW_HIDE)
                            EndIf
                        EndIf
                        ControlSetText($hSnd, '', 'Static1', 'Installing '&$file&'...'&@LF&'Please wait...')
                        If $driver == 1 Then
                            $pid = ShellExecute($binFile, $param, $working_dir)
                            Local $hWnd = WinWait('Windows Security', '', 15)
                            WinActivate($hWnd)
                            ControlClick($hWnd, '', 'Button1')
                            ;~ ProcessWaitClose($pid, 15)
                        Else
                            $pid = ShellExecuteWait($binFile, $param, $working_dir)
                            ;~ ProcessWaitClose($pid, 15)
                        EndIf
                        ProcessWaitClose($pid, 15)
                        If $winwait <> 'disabled' Then
                            Local $hWnd = WinWait($winwait, '', 15)
                            WinActivate($hWnd)
                            ControlClick($hWnd, '', $controlid)
                        EndIf
                        If $appclose <> 'disabled' Then
                            Local $wait = 1
                            While 1
                                If $wait = 150 Then ExitLoop
                                If ProcessExists($appclose) Then
                                    ProcessClose($appclose)
                                    ExitLoop
                                EndIf
                                Sleep(100)
                                $wait += 1
                            WEnd
                        EndIf
                        If $runclose <> 'disabled' Then _runClose($runclose)
                        WinActivate($hSnd) ;activate status popup
                        ;prepare post file if exists and run it
                        If FileExists($setup_path&'\'&$section&'\'&$postfile) And $postsetup == 1 Then
                            _fileEdit($section, $appName, 'Post.bat')
                            Sleep(1000) ;sleep before running post script
                            If $show_batch_window == 1 Then
                                RunWait(@ComSpec&' /c "'&$setup_path&'\'&$section&'\'&$postfile&'"', $setup_path&'\'&$section, @SW_SHOW)
                            Else
                                RunWait(@ComSpec&' /c "'&$setup_path&'\'&$section&'\'&$postfile&'"', $setup_path&'\'&$section, @SW_HIDE)
                            EndIf
                        EndIf
                    EndIf
                EndIf
                If $debug == 1 Then ConsoleWrite(@LF)
            EndIf
        Next
    EndIf
EndFunc

Func ManageDefenderExclusion($sDirectory, $bAdd = True)
    Local $sCommand
    If $bAdd Then
        $sCommand = 'PowerShell -executionpolicy bypass -Command "Add-MpPreference -ExclusionPath ' & "'" & $sDirectory & "'" & '"'
    Else
        $sCommand = 'PowerShell -executionpolicy bypass -Command "Remove-MpPreference -ExclusionPath ' & "'" & $sDirectory & "'" & '"'
    EndIf
    Local $iPID = RunWait(@ComSpec & " /c " & $sCommand, "", @SW_HIDE)
    If ProcessWaitClose($iPID) <> 0 Then
        ConsoleWrite("Error managing exclusion in Defender: " &@LF)
        Return False
    Else
        ConsoleWrite("Successfully managed exclusion in Defender for " & $sDirectory & @CRLF)
        Return True
    EndIf
EndFunc

Func _uninstallAppsSection($section)
    Local $aUninstall = IniReadSection($ini_file, $section)
    If Not @error Then
        For $i = 1 To $aUninstall[0][0]
            If $aUninstall[$i][1] = 1 Then
                ControlSetText($hSnd, '', 'Static1', 'Uninstalling '&$aUninstall[$i][0]&@LF&'Please wait...')
                Local $aFoundApps = _appSearch($aUninstall[$i][0], True)
                If $debug == 1 Then
                    ConsoleWrite('UNINSTALL: '&$aUninstall[$i][0]&@LF)
                    If UBound($aFoundApps) <> 0 Then
                        For $app In $aFoundApps
                            Local $aApp = StringSplit($app, '[SPLIT]', $STR_ENTIRESPLIT)
                            ConsoleWrite("  DISPLAY NAME: $aApp[1] - "&$aApp[1]&@LF)
                            ConsoleWrite("  DISPLAY VERSION: $aApp[2] - "&$aApp[2]&@LF)
                            ConsoleWrite("  PUBLISHER: $aApp[3] - "&$aApp[3]&@LF)
                            ConsoleWrite("  UNINSTALL STRING: $aApp[4] - "&$aApp[4]&@LF)
                            ConsoleWrite('  UNINSTALL COMMAND: '&_uninstallStringLogic($aApp[4])&@LF)
                            ConsoleWrite(@LF)
                        Next
                    Else
                        ConsoleWrite('  App named '&$aUninstall[$i][0]&' not installed'&@LF&@LF)
                    EndIf
                Else
                    ; Regular runwait to uninstall
                    If UBound($aFoundApps) <> 0 Then RunWait(_uninstallStringLogic($aApp[4]), @TempDir)
                    ;~ ; uninstall with timeout
                    ;~ $rPID = Run(_uninstallStringLogic($aApp[4]), @TempDir)
                    ;~ If Not ProcessWaitClose($rPID, 25) Then
                    ;~     ; If the process is still running after 25 seconds, forcefully terminate it
                    ;~     ProcessClose($rPID)
                    ;~ EndIf
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func _appSearch($sSearch, $bPartial)
    Local $aRegPaths[3]
    Local $sUninstallPath = "\Microsoft\Windows\CurrentVersion\Uninstall"
    ; Define the registry paths for both x86 and x64 systems
    If @OSArch = "X64" Then
        $aRegPaths[0] = "HKLM\SOFTWARE\Wow6432Node" & $sUninstallPath
        $aRegPaths[1] = "HKLM64\SOFTWARE" & $sUninstallPath
        $aRegPaths[2] = "HKCU\SOFTWARE" & $sUninstallPath
    Else
        $aRegPaths[0] = "HKLM\SOFTWARE" & $sUninstallPath
        $aRegPaths[1] = "HKCU\SOFTWARE" & $sUninstallPath
        ; Optionally handle $aRegPaths[2] if not used
        ReDim $aRegPaths[2]
    EndIf
    ; Array to store application details
    Local $aApplications[1] = [""]
    ; Process each registry path
    For $sRegPath In $aRegPaths
        ; Enumerate all subkeys (each subkey is an application)
        Local $i = 1
        While 1
            Local $sSubKey = RegEnumKey($sRegPath, $i)
            If @error <> 0 Then ExitLoop
            $i += 1
            ; Get application details
            Local $sDisplayName = RegRead($sRegPath & "\" & $sSubKey, "DisplayName")
            If $sDisplayName = "" Then $sDisplayName = "EMPTY"
            Local $sDisplayVersion = RegRead($sRegPath & "\" & $sSubKey, "DisplayVersion")
            If $sDisplayVersion = "" Then $sDisplayVersion = "EMPTY"
            Local $sPublisher = RegRead($sRegPath & "\" & $sSubKey, "Publisher")
            If $sPublisher = "" Then $sPublisher = "EMPTY"
            Local $sUninstallString = RegRead($sRegPath & "\" & $sSubKey, "UninstallString")
            If $sUninstallString = "" Then $sUninstallString = "EMPTY"
            ; Check if the application name matches the search key
            If ($bPartial And StringInStr($sDisplayName, $sSearch, 2) > 0) Or (Not $bPartial And $sDisplayName = $sSearch) Then
                ; Prepare the application detail string
                $found = $sDisplayName & "[SPLIT]" & $sDisplayVersion & "[SPLIT]" & $sPublisher & "[SPLIT]" & $sUninstallString
                _ArrayAdd($aApplications, $found)
            EndIf
        WEnd
    Next
    _ArrayDelete($aApplications, 0)
    Return $aApplications
EndFunc

Func _uninstallStringLogic($uninstallString)
    Local $return
    If StringInStr($uninstallString, 'msiexec.exe') <> 0 Then ;Checking if it's MSI setup
        If StringInStr($uninstallString, ' /I') <> 0 Then
            $uninstallString = StringReplace($uninstallString, ' /I', ' /X') ;Replacing /I with /X if it exists
            $switch = ' /passive /NORESTART'
            ;MsiExec.exe /I{AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE} /passive /NORESTART
            $return = $uninstallString&$switch
        Else
            $switch = ' /passive /NORESTART'
            ;MsiExec.exe /X{AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE} /passive /NORESTART
            $return = $uninstallString&$switch
        EndIf
    ElseIf StringInStr($uninstallString, 'regsvr') <> 0 Then
        ;regsvr32 /u /s "C:\Program Files\SampleProduct 14\uninstall.dll"
        $return = @ComSpec & ' /c '&$uninstallString
    ElseIf StringInStr($uninstallString, 'rundll') <> 0 Then
        ;RunDll32 C:\Program Files\SampleProduct 13\Ctor.dll,LaunchSetup "C:\Program Files\SampleProduct 13\{BBBCAE4B-B416-4182-A6F2-438180894A81}\setup.exe" -l0x9  -removeonly
        ;Rundll32 uninstall.dll,uninstall
        $return = @ComSpec & ' /c '&$uninstallString
    ElseIf StringInStr($uninstallString, '"') <> 0 Then ;Checking if '"' exists
        $switch = ' /S /silent /qb /NORESTART'
        ;"C:\Program Files\SampleProduct 01\uninstall.exe" /U C:\Program Files\SampleProduct 01\install.log
        ;"C:\Program Files\SampleProduct 03\uninstall.exe"
        ;"C:\Program Files\SampleProduct 05\uninstall.exe" -uninstall
        ;"C:\Program Files\SampleProduct 07\uninstall.exe" /D="C:\Program Files\SampleProduct 07\"
        ;"C:\Program Files\SampleProduct 09\uninstall.exe" /Uninstall
        ;"C:\Program Files\SampleProduct 11\uninstall.exe" Uninstall
        $return = @ComSpec & ' /c '&$uninstallString&$switch
    ElseIf StringInStr($uninstallString, '"') = 0 Then ;Checkin if '"' doesn't exist
        If StringInStr($uninstallString, ' -') <> 0 Then
            If StringInStr($uninstallString, '" -') = 0 Then
                $uninstallString = StringReplace($uninstallString, ' -', '" -')
                If StringInStr($uninstallString, '= ') <> 0 Then
                    If StringInStr($uninstallString, '= "') = 0 Then
                        $uninstallString = StringReplace($uninstallString, '= ', '="')
                        If StringInStr($uninstallString, 'exe"') = 0 Then
                            $uninstallString = StringReplace($uninstallString, 'exe', 'exe"')
                            $switch = ' /S /silent /qb /NORESTART'
                            ;C:\Program Files\SampleProduct 08\uninstall.exe -LOG= C:\Program Files\SampleProduct 08\install.log -OEM=
                            $return = @ComSpec & ' /c "'&$uninstallString&$switch
                        Else
                            $switch = ' /S /silent /qb /NORESTART'
                            ;Extra
                            $return = @ComSpec & ' /c "'&$uninstallString&$switch
                        EndIf
                    Else
                        If StringInStr($uninstallString, 'exe"') = 0 Then
                            $uninstallString = StringReplace($uninstallString, 'exe', 'exe"')
                            $switch = ' /S /silent /qb /NORESTART'
                            ;C:\Program Files\SampleProduct 06\uninstall.exe -uninstall
                            $return = @ComSpec & ' /c "'&$uninstallString&$switch
                        Else
                            $switch = ' /S /silent /qb /NORESTART'
                            ;Extra
                            $return = @ComSpec & ' /c "'&$uninstallString&$switch
                        EndIf
                    EndIf
                Else
                    $switch = ' /S /silent /qb /NORESTART'
                    ;C:\Program Files\SampleProduct 06\uninstall.exe -uninstall
                    $return = @ComSpec & ' /c "'&$uninstallString&$switch
                EndIf
            EndIf
        ElseIf StringInStr($uninstallString, 'exe /') <> 0 Then
            If StringInStr($uninstallString, 'exe /UNINSTALL') Then
                ;Do nothing
            Else
                $uninstallString = StringReplace($uninstallString, 'exe /', 'exe" /')
                $switch = ' /S /silent /qb /NORESTART'
                ;C:\Program Files\SampleProduct 02\uninstall.exe /U C:\Program Files\SampleProduct 02\install.log
                ;C:\Program Files\SampleProduct 10\uninstall.exe /Uninstall
                $return = @ComSpec & ' /c "'&$uninstallString&$switch
            EndIf
        ElseIf StringInStr($uninstallString, 'exe ') <> 0 Then
            $uninstallString = StringReplace($uninstallString, 'exe ', 'exe" ')
            $switch = ''
            ;C:\Program Files\SampleProduct 12\uninstall.exe Uninstall
            $return = @ComSpec & ' /c "'&$uninstallString&$switch
        Else
            $switch = ' /S /silent /qb /NORESTART'
            ;C:\Program Files\SampleProduct 04\uninstall.exe
            $return = @ComSpec & ' /c "'&$uninstallString&'"'&$switch
        EndIf
    EndIf
    Return $return
EndFunc

Func _scriptRunSection($section, $postName, $wait=0)
    Local $aSections = IniReadSection($ini_file, $section)
    If Not @error Then
        For $i = 1 To $aSections[0][0]
            $modfile = $aSections[$i][0]&$postName
            If FileExists($setup_path&'\'&$section&'\'&$modfile) And $aSections[$i][1] == 1 Then
                If $debug == 1 Then
                    ConsoleWrite($aSections[$i][0]&$postName&':'&@LF)
                    ConsoleWrite('  RUN:'&@LF & _
                                '    SCRIPT: "'&$setup_path&'\'&$section&'\'&$aSections[$i][0]&$postName&'"'&@LF & _
                                '    WORKINGDIR: "'&$setup_path&'\'&$section&'"'&@LF&@LF)
                Else
                    ControlSetText($hSnd, '', 'Static1', 'Running '&$aSections[$i][0]&'...'&@LF&'Please wait...')
                    _fileEdit($section, $aSections[$i][0], $postName) ;prepare bat file
                    ;~ RunWait(@ComSpec&' /c "'&$setup_path&'\'&$section&'\'&$aSections[$i][0]&$postName&'"', $setup_path&'\'&$section, @SW_HIDE)
                    If $show_batch_window == 1 Then
                        ShellExecuteWait('"'&$setup_path&'\'&$section&'\'&$aSections[$i][0]&$postName&'"', '', $setup_path&'\'&$section, '', @SW_SHOW)
                    Else
                        ShellExecuteWait('"'&$setup_path&'\'&$section&'\'&$aSections[$i][0]&$postName&'"', '', $setup_path&'\'&$section, '', @SW_HIDE)
                    EndIf
                EndIf
            EndIf
        Next
    EndIf
    Sleep($wait)
EndFunc

Func _mounts($section, $wait=0)
    ControlSetText($hSnd, '', 'Static1', 'Mounting network drives...'&@LF&'Please wait...')
    Local $aSections = IniReadSection($ini_file, $section)
    If Not @error Then
        For $i = 1 To $aSections[0][0]
            If $debug == 1 Then
                ConsoleWrite('  MOUNTING: '&$aSections[$i][1]&' to '&$aSections[$i][0] & ":"&@LF)
            Else
                DriveMapAdd($aSections[$i][0] & ":", $aSections[$i][1], 1)
            EndIf
        Next
    EndIf
EndFunc

Func _startExplorer()
    $strComputer = "localhost"
    $objWMI = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
    Local $objexplorer = $objWMI.Get("win32_process")
    $objexplorer.create("explorer.exe")
EndFunc

Func _restartExplorer()
    ;Save icon positions (probably not needed since we are doing a graceful exit)
    DllCall("shell32.dll", "none", "SHChangeNotify", "long", 0x8000000, "uint", BitOR(0x0, 0x1000), "ptr", 0, "ptr", 0)
    ;Close the explorer shell gracefully
    $hSysTray_Handle = _WinAPI_FindWindow('Shell_TrayWnd', '')
    _SendMessage($hSysTray_Handle, 0x5B4, 0, 0)
    While WinExists($hSysTray_Handle)
        Sleep(500)
    WEnd
    _startExplorer()
    While Not _WinAPI_GetShellWindow()
        Sleep(500)
    WEnd
    EnvUpdate()
EndFunc

Func _generatePinApps($section)
    Local $aSections = IniReadSection($ini_file, $section)
    Local $batchContent = "" & @CRLF & _
                            "SET syspinApp=%~dp0\post\pttb.exe" & @CRLF & _
                            "DEL /F /S /Q /A " & Chr(34) & "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" & Chr(34) & @CRLF & _
                            "REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F" & @CRLF & _
                            "%syspin% -r"&@CRLF
                            ;~ "taskkill /F /IM explorer.exe" & @CRLF & _
                            ;~ "start explorer" & @CRLF & _
                            ;~ "powershell -Command " & Chr(34) & "While (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }" & Chr(34) & @CRLF
    If Not @error Then
        For $i = 1 To $aSections[0][0]
            If $aSections[$i][1] = 1 Then
                If $debug == 1 Then
                    If FileExists($aSections[$i][0]) Then ConsoleWrite('PINNING: '&$aSections[$i][0]&@LF)
                Else
                    If FileExists($aSections[$i][0]) Then $batchContent &= "IF EXIST " & Chr(34) & $aSections[$i][0] & Chr(34) & " " & "%syspinApp% " & Chr(34) & $aSections[$i][0] & Chr(34) & @CRLF
                EndIf
            EndIf
        Next
    EndIf
    If $debug <> 1 Then
        Local $sDesktopPath = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders", "Desktop")
        $sDesktopPath = _WinAPI_ExpandEnvironmentStrings($sDesktopPath)
        DirCopy($setup_path&'\tools\post', $sDesktopPath&'\post', 1)
        If FileExists($sDesktopPath & "\Pin Apps.bat") Then FileDelete($sDesktopPath & "\Pin Apps.bat")
        FileWrite($sDesktopPath & "\Pin Apps.bat", $batchContent)
    EndIf
EndFunc

Func _pinApps($section, $wait=0)
    ControlSetText($hSnd, '', 'Static1', 'Pinning apps...'&@LF&'Please wait...')
    Local $aSections = IniReadSection($ini_file, $section)
    If $debug == 0 Then
        If $show_batch_window == 1 Then
            RunWait(@ComSpec & ' /c DEL /F /S /Q /A "' & @AppDataDir & "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" & '"', "", @SW_SHOW)
            RunWait(@ComSpec & ' /c REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F', "", @SW_SHOW)
        Else
            RunWait(@ComSpec & ' /c DEL /F /S /Q /A "' & @AppDataDir & "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" & '"', "", @SW_HIDE)
            RunWait(@ComSpec & ' /c REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F', "", @SW_HIDE)
            RunWait(@ComSpec & ' /c REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F', "", @SW_HIDE)
        EndIf
        RunWait($setup_path&'\tools\post\pttb -r', @ScriptDir, @SW_HIDE)
        ;~ _restartExplorer()
    EndIf
    If Not @error Then
        For $i = 1 To $aSections[0][0]
            If $aSections[$i][1] = 1 Then
                If $debug == 1 Then
                    If FileExists($aSections[$i][0]) Then ConsoleWrite('PINNING: '&$aSections[$i][0]&@LF)
                Else
                    If FileExists($aSections[$i][0]) Then
                        RunWait($setup_path&'\tools\pttb "'&$aSections[$i][0], @ScriptDir, @SW_HIDE)
                        Sleep($wait)
                    EndIf
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func _fileEdit($section, $key, $postName)
    $line = 1
    Local $aMod = IniReadSection($ini_file, $section&'-vars')
    If Not @error Then
        For $p = 1 To $aMod[0][0]
            If StringInStr($aMod[$p][0], $key) Then ;modify post script with post-vars
                If $debug == 1 Then
                    ConsoleWrite('  REPLACE:'&@LF & _
                                '    LINE '&$line&' WITH: "'&'SET '&StringReplace($aMod[$p][0], ' ', '')&'='&$aMod[$p][1]&'"'&@LF & _
                                '    IN: "'&$setup_path&'\'&$section&'\'&$key&$postName&@LF)
                Else
                    _FileWriteToLine($setup_path&'\'&$section&'\'&$key&$postName, $line, 'SET '&StringReplace($aMod[$p][0], ' ', '')&'='&$aMod[$p][1], True)
                EndIf
                $line += 1
            EndIf
        Next
    EndIf
EndFunc

Func _runClose($proc)
    Local $iPID = Run('"'&$proc&'"', '', @SW_HIDE)
    ProcessWait($iPID, 10)
    Sleep(1000)
    ProcessClose($iPID)
EndFunc

Func _getName($file, $var=1) ;1=file, 2=folder
    Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
    Local $aPathSplit = _PathSplit($file, $sDrive, $sDir, $sFileName, $sExtension)
    If $var == 1 Then
        Return $aPathSplit[3]
    Else
        Return $aPathSplit[1]&$aPathSplit[2]
    EndIf
EndFunc

Func _runAppsSection($section, $sleep=0)
    Local $aPins = IniReadSection($ini_file, $section)
    If Not @error Then
        For $i = 1 To $aPins[0][0]
            If $aPins[$i][1] == 1 And FileExists($aPins[$i][0]) Then
                ControlSetText($hSnd, '', 'Static1', 'Running '&_getName($aPins[$i][0], 1)&' to configure...'&@LF&'Please wait...')
                If $debug == 1 Then
                    ConsoleWrite('RUN TO CONF: '&$aPins[$i][0]&@LF)
                Else
                    Run($aPins[$i][0])
                    Sleep($sleep)
                EndIf
            EndIf
        Next
    EndIf
EndFunc

Func _startupRegDeleteSection($section)
    Local $aRegDelete = IniReadSection($ini_file, $section)
    If Not @error Then
        For $i = 1 To $aRegDelete[0][0]
            If $aRegDelete[$i][1] = 1 Then
                _startupRegDelete($aRegDelete[$i][0])
            EndIf
        Next
    EndIf
EndFunc

Func _startupRegDelete($keyName)
    ; Define base registry paths
    Local $aRegPaths[3]
    Local $sUninstallPath = "\Microsoft\Windows\CurrentVersion\Run"
    ; Define base registry paths
    If @OSArch = "X64" Then
        $aRegPaths[0] = "HKLM\SOFTWARE\Wow6432Node" & $sUninstallPath
        $aRegPaths[1] = "HKLM64\SOFTWARE" & $sUninstallPath
        $aRegPaths[2] = "HKCU\SOFTWARE" & $sUninstallPath
    Else
        $aRegPaths[0] = "HKLM\SOFTWARE" & $sUninstallPath
        $aRegPaths[1] = "HKCU\SOFTWARE" & $sUninstallPath
        ReDim $aRegPaths[2]
    EndIf
    ; Iterate through each registry path
    If $debug == 1 Then ConsoleWrite('REG DELETE CHECK: ' & $keyName & @LF)
    For $i = 0 To UBound($aRegPaths) - 1
        ; Enumerate all values under the registry key
        Local $j = 1
        While 1
            Local $sValueName = RegEnumVal($aRegPaths[$i], $j)
            If @error Then ExitLoop
            ; Check if the value name contains the keyName substring
            If StringInStr($sValueName, $keyName) Then
                If $debug == 1 Then
                    ; In debug mode, log that the key was found and would be deleted
                    ConsoleWrite("  KEY FOUND: " & $aRegPaths[$i] & "\" & $sValueName & @LF)
                Else
                    ; Delete the registry key
                    RegDelete($aRegPaths[$i], $sValueName)
                EndIf
            Else
                ; Log key not found if in debug mode
                If $debug == 1 Then ConsoleWrite("  KEY SKIPPED: " & $aRegPaths[$i] & "\" & $sValueName & @LF)
            EndIf
            $j += 1
        WEnd
    Next
    If $debug == 1 Then ConsoleWrite(@LF)
EndFunc

Func _cleanup($section)
    If $debug == 1 Then
        If IniRead($ini_file, $section, 'Disable UAC', '') == 0 Then
            ConsoleWrite('UAC: True'&@LF)
        Else
            ConsoleWrite('UAC: False'&@LF)
        EndIf
    Else
        If IniRead($ini_file, $section, 'Disable UAC', '') == 0 Then
            RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System', 'ConsentPromptBehaviorAdmin', 'REG_DWORD', '1')
            RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System', 'EnableLUA', 'REG_DWORD', '1')
        EndIf
    EndIf
    if $debug <> 1 Then SplashOff()
    If $debug == 1 Then
        If $self_delete Then
            ConsoleWrite('CLEANUP: True (network install)'&@LF)
        Else
            ConsoleWrite('CLEANUP: False (local install)'&@LF)
        EndIf
        ConsoleWrite(' cleanup cmd: '&@ComSpec&' /c ping 127.0.0.1 -n 5 & del /f /s /q "'&@ScriptFullPath&'" & del /f /s /q "'&@ScriptDir&'\AUTOM8r.ini" & rmdir /s /q "'&@ScriptDir&'\'&$files_dir&'" & PowerShell -executionpolicy bypass -Command "Remove-MpPreference -ExclusionPath '''&@ScriptDir&'\'&$files_dir&'''"'&@LF)
    Else
        If $self_delete Then
            DirRemove($setup_path, 1)
            Local $psCommands = 'Write-Host " [i] Cleaning up in 5 seconds...";' & _
                'Start-Sleep -Seconds 5; ' & _
                'Remove-Item -Path "' & @ScriptFullPath & '" -Force -ErrorAction SilentlyContinue; ' & _
                'Remove-Item -Path "' & @ScriptDir & '\AUTOM8r.ini" -Force -ErrorAction SilentlyContinue; ' & _
                'Remove-Item -Path "' & @ScriptDir & '\' & $files_dir & '" -Recurse -Force -ErrorAction SilentlyContinue; ' & _
                'Remove-MpPreference -ExclusionPath "' & @ScriptDir & '\' & $files_dir & '" -ErrorAction SilentlyContinue'
            If $show_batch_window == 1 Then
                Run(@ComSpec & ' /c PowerShell -Command "' & $psCommands & '"', @SystemDir, @SW_SHOW)
            Else
                Run(@ComSpec & ' /c PowerShell -Command "' & $psCommands & '"', @SystemDir, @SW_HIDE)
            EndIf
        EndIf
    EndIf
Endfunc
