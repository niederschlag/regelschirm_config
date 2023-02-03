Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
Add-Type -AssemblyName 'System.IO.Compression'

function Unzip {
    param([string]$f)

    $zipFile = [System.IO.Compression.ZipFile]::OpenRead($f)
    
    foreach ($entry in $zipFile.Entries.Where( { $_.Name.length -gt 0 })) {
        
        Write-Output $entry.Name

        if ($entry.Name -eq 'autoexec_custom.cfg') {
            continue
        }
        if ($entry.Name -eq '.gitignore') {
            continue
        }

        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, "$PSScriptRoot\$($entry.Name)", $true)
    }

    $zipFile.Dispose()
}

Invoke-WebRequest https://github.com/niederschlag/regelschirm_config/archive/refs/heads/master.zip -OutFile config.zip
Unzip -f "$PSScriptRoot\config.zip"
rm config.zip