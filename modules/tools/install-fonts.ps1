param (
    [string]$Path = $(throw "Please provide the source folder path.")
)

Add-Type -AssemblyName System.Drawing
$destinationFolder = "C:\Windows\Fonts"
$fontFiles = @()

function Install-Font {
    param (
        [string]$fontFile
    )

    $fontName = (Get-Item -Path $fontFile).Name
    $destinationPath = Join-Path -Path $destinationFolder -ChildPath $fontName

    # Try to load the font file to check if it is valid
    try {
        $font = New-Object System.Drawing.Text.PrivateFontCollection
        $font.AddFontFile($fontFile)
        if ($font.Families.Length -eq 0) {
            throw "Invalid font file"
        }
    } catch {
        Write-Host "Skipping corrupted or invalid font file: $fontFile"
        return
    }

    # Try to copy the font file to the destination folder, forcefully replacing any existing file
    try {
        Copy-Item -Path $fontFile -Destination $destinationPath -Force
    } catch [System.IO.IOException] {
        Write-Host "Error copying font file (file may be in use): $fontFile"
        return
    } catch {
        Write-Host "Error copying font file: $fontFile"
        return
    }

    $key = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    $valueName = $fontName
    $valueData = $destinationPath
    Set-ItemProperty -Path $key -Name $valueName -Value $valueData -Force
    Write-Host "Installed font: $fontName"
}

$fontFiles += Get-ChildItem -Path $Path -Filter *.ttf -Recurse
$fontFiles += Get-ChildItem -Path $Path -Filter *.otf -Recurse

# Install each font
foreach ($fontFile in $fontFiles) {
    Install-Font -fontFile $fontFile.FullName
}
