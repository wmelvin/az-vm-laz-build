
#  Source the initialization script.
. ./az-steps-0-init.ps1

$beginTime = LogRunBegin "az-steps-5-custom-script"

#  https://learn.microsoft.com/en-us/cli/azure/vm/extension/image?view=azure-cli-latest#az-vm-extension-image-list()

# az vm extension image list --latest --location $rgLocation --publisher Microsoft.Compute --name CustomScript

# az vm extension image list-names --publisher Microsoft.Azure.Extensions -l $rgLocation



Say "`nSTEP - Set the Custom Script Extension.`n"

#  Assign variables for the Custom Script Extension.

$fileUri = @(
  "https://$($opts.storageAcctName).blob.core.windows.net/$($opts.containerPublic)/on-vm-launch.ps1";
  "https://$($opts.storageAcctName).blob.core.windows.net/$($opts.containerPublic)/$($opts.azcopyName)";
)

$extName = "LazarusBuilder"
$extType = "CustomScriptExtension"
$extPublisher = "Microsoft.Compute"
$extVersion = "1.10.15"
$timestamp = (Get-Date).Ticks

$publicConfig = @{
  "fileUris" = $fileUri;
  "timestamp" = "$timestamp"
}

# Second call to ConvertTo-Json escapes the double-quotes in output from the first.
$publicConfigJson = $publicConfig | ConvertTo-Json -Compress | ConvertTo-Json


#  Generate a SAS for access to the private blob storage.
#  https://learn.microsoft.com/en-us/cli/azure/storage/container?view=azure-cli-latest#az-storage-container-generate-sas()

$storageKey = $(az storage account keys list -g $opts.rgName -n $opts.storageAcctName --query '[0].value' -o tsv)

$expireDate = (Get-Date).AddDays(7).ToString("yyyy-MM-dd")

$sas = az storage container generate-sas `
--account-name $opts.storageAcctName `
--account-key $storageKey `
--name $opts.containerPrivate `
--permissions rcwl `
--expiry $expireDate

#  Permissions 'rcwl' = read, create, write, list.

#  Extract the fields from the storage account connection string to the the BlobEndpoint.
$connStrJson = az storage account show-connection-string --name $opts.storageAcctName --resource-group $opts.rgName
$connObj = $connStrJson | ConvertFrom-Json
$connContext = ConvertFrom-StringData -StringData $connObj.connectionString.Replace(";", "`n")

#  Construct the SAS URI for the storage blob container.
$sasUri = "$($connContext.BlobEndpoint)$($opts.containerPrivate)?$($sas)"

$privateConfig = @{
  "commandToExecute" = "powershell.exe -ExecutionPolicy Unrestricted -Command .\on-vm-launch.ps1 -FilesURI '$sasUri' -GHRepoURI '$GHRepoURI'"
}

$privateConfigJson = $privateConfig | ConvertTo-Json -Compress

#  Load the private configuration JSON from a file to escape from 
#  string-escaping-hell when trying to pass the JSON as a parameter.
$privateConfigJson > .\temp.json

#  Set the Custom Script Extension on the VM.
#  https://learn.microsoft.com/en-us/cli/azure/vm/extension?view=azure-cli-latest#az-vm-extension-set()

az vm extension set `
-g $opts.rgName `
--vm-name $opts.vmName `
--name $extType `
--extension-instance-name $extName `
--publisher $extPublisher `
--version $extVersion `
--settings $publicConfigJson `
--protected-settings .\temp.json

#  Delete the temporary file.
Remove-Item .\temp.json

LogRunEnd "az-steps-5-custom-script" $beginTime


# ----------------------------------------------------------------------
#  Additional commands to run manually (F8):

#  List the extensions to see if the CSE is there.

# az vm extension list -g $opts.rgName --vm-name $opts.vmName


#  Delete the extension before setting it again.
#  https://learn.microsoft.com/en-us/cli/azure/vm/extension?view=azure-cli-latest#az-vm-extension-delete()

# az vm extension delete -g $opts.rgName --vm-name $opts.vmName -n $extName


# https://learn.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-restart()

# az vm restart -g $opts.rgName -n $opts.vmName
