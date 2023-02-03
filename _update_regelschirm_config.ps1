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

# create autoexec_custom if it doesn't exist
if (!(Test-Path "$PSScriptRoot\autoexec_custom.cfg")) {
    @(
        '// main settings/preferences',
        'sensitivity "1"',
        'zoom_sensitivity_ratio_mouse "1"',
        'volume "0.70"',
        'voice_mixer_volume "0.8"',
        'voice_scale "0.7"',
        'exec ch_draken',
        'exec vm_dev1ce'
    ) | % {
        Add-Content -Path "autoexec_custom.cfg" -Value $_
    }
}