#include <Array.au3>

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

;~ Local $aFoundApps = _appSearch('adobe', True)
;~ ConsoleWrite(UBound($aFoundApps)&@LF)
;~ For $app In $aFoundApps
;~     Local $aApp = StringSplit($app, '[SPLIT]', $STR_ENTIRESPLIT)
;~     For $i = 1 To $aApp[0]
;~         ConsoleWrite("$aApp[" & $i & "] - " & $aApp[$i]&@LF)
;~     Next
;~     ConsoleWrite(@LF)
;~ Next
