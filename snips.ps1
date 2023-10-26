
$config = Import-PowerShellDataFile -Path .\local-settings-template.psd1
$config

$config = Import-PowerShellDataFile -Path ..\Uploads\on-vm-settings.psd1
$config
