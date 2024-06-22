param (
    [string]$Name
)

function Search-RegistryKeys {
    param (
        [string]$PartialName,
        [string]$RegistryPath
    )

    $keys = Get-ChildItem -Path $RegistryPath

    foreach ($key in $keys) {
        if ($key.PSChildName -like "*$PartialName*") {
            [PSCustomObject]@{
                KeyName = $key.PSChildName
                Path    = $key.PSPath
            }
        }
    }
}

if ($Name) {
    $resultsHKCU = Search-RegistryKeys -PartialName $Name -RegistryPath "HKCU:\Software\Classes"
    $resultsHKLM = Search-RegistryKeys -PartialName $Name -RegistryPath "HKLM:\Software\Classes"

    $results = $resultsHKCU + $resultsHKLM
    if ($results) {
        $results | Format-Table -AutoSize
    } else {
        Write-Host "No matching keys found."
    }
} else {
    Write-Host "Please provide a partial name using the -Name parameter."
}
