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


[System.Windows.MessageBox]::Show('Regelschirm Config 2.0 successfully installed!', 'Regelschirm Config Updater', 'OK', 'Information')