
#  Source the initialization script.
. ./az-steps-0-init.ps1

WriteLog "BEGIN: az-steps-3-upload"

Say "`nSTEP - Prepare to upload files to blob storage`n"

if (-not (Test-Path $opts.lazInstallerPath)) {
  Yell "`nFile not found: $($opts.lazInstallerPath)"
  Exit
}

if (0 -lt $opts.srcZipPath.Length) {
  if (-not (Test-Path $opts.srcZipPath)) {
    Yell "`nFile not found: $($opts.srcZipPath)"
    Exit
  }
}


#  Create a settings file to upload.
#  This file can be read by Import-PowerShellDataFile
#  BTW: As of writing, there is no Export-PowerShellDataFile.

$outStr = "@{`n"
$outStr += "  lazInstallerName = `"$($opts.lazInstallerName)`"`n"
$outStr += "  gitInstallerName = `"$($opts.gitInstallerName)`"`n"
$outStr += "  srcZipName = `"$($opts.srcZipName)`"`n"
$outStr += "  repoDirName = `"$($opts.repoDirName)`"`n"
$outStr += "  lazProjectFileName = `"$($opts.lazProjectFileName)`"`n"
$outStr += "  outputFileName = `"$($opts.outputFileName)`"`n"
$outStr += "}`n"

$settingsFilePath = [IO.Path]::GetFullPath("..\Uploads\on-vm-settings.psd1")
$settingsFileName = [IO.Path]::GetFileName($settingsFilePath)

Out-File -FilePath $settingsFilePath -InputObject $outStr -Encoding ascii


#  Get the storage account key.
$storageKey = $(az storage account keys list -g $opts.rgName -n $opts.storageAcctName --query '[0].value' -o tsv)


Say "`nSTEP - Upload files to blob storage container '$($opts.containerPublic)'`n"

$blobsPublic = az storage blob list `
--account-name $opts.storageAcctName `
--account-key $storageKey `
--container-name $opts.containerPublic `
--query '[].name' -o tsv


#  https://learn.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-upload()

#  Note: some of the commands have '--overwrite true' so changes can be uploaded
#  during debugging by selecting and running the single command.

#  Upload the on-vm-launch script. Overwrite if already present.
az storage blob upload `
--account-name $opts.storageAcctName `
--account-key $storageKey `
--file ".\on-vm-launch.ps1" `
--container-name $opts.containerPublic `
--name "on-vm-launch.ps1" `
--overwrite true

#  Upload the AzCopy executable if not already present.
if (-not ($blobsPublic -contains $opts.azcopyName)) {
  az storage blob upload `
  --account-name $opts.storageAcctName `
  --account-key $storageKey `
  --file $opts.azcopyPath `
  --container-name $opts.containerPublic `
  --name $opts.azcopyName
}


Say "`nSTEP - Upload files to blob storage container '$($opts.containerPrivate)'`n"

$blobsPrivate = az storage blob list `
--account-name $opts.storageAcctName `
--account-key $storageKey `
--container-name $opts.containerPrivate `
--query '[].name' -o tsv

#  Upload the settings file. Overwrite if already present.
az storage blob upload `
--account-name $opts.storageAcctName `
--account-key $storageKey `
--file $settingsFilePath `
--container-name $opts.containerPrivate `
--name $settingsFileName `
--overwrite true

#  Upload the on-vm-process script. Overwrite if already present.
az storage blob upload `
--account-name $opts.storageAcctName `
--account-key $storageKey `
--file ".\on-vm-process.ps1" `
--container-name $opts.containerPrivate `
--name "on-vm-process.ps1" `
--overwrite true

#  Upload the Lazarus installer if not already present.
if (-not ($blobsPrivate -contains $opts.lazInstallerName)) {
  az storage blob upload `
  --account-name $opts.storageAcctName `
  --account-key $storageKey `
  --file $opts.lazInstallerPath `
  --container-name $opts.containerPrivate `
  --name $opts.lazInstallerName
}

#  Upload the Git installer if not already present.
if (-not ($blobsPrivate -contains $opts.gitInstallerName)) {
  az storage blob upload `
  --account-name $opts.storageAcctName `
  --account-key $storageKey `
  --file $opts.gitInstallerPath `
  --container-name $opts.containerPrivate `
  --name $opts.gitInstallerName
}

#  Upload the source code zip archive. Overwrite if already present.
#  Source code zip archive is not needed if the repo is to be cloned from 
#  GitHub instead.
if (0 -lt $opts.srcZipPath.Length) {
  az storage blob upload `
  --account-name $opts.storageAcctName `
  --account-key $storageKey `
  --file $opts.srcZipPath `
  --container-name $opts.containerPrivate `
  --name $opts.srcZipName `
  --overwrite true
}

WriteLog "END: az-steps-3-upload"
