
$config = Import-PowerShellDataFile -Path .\local-settings-template.psd1
$config


$config = Import-PowerShellDataFile -Path ..\Uploads\on-vm-settings.psd1
$config


Start-Transcript -Path .\snips.log -Append
. ./az-steps-0-init.ps1
Stop-Transcript
