
#  Source the initialization script.
. ./az-steps-0-init.ps1

$beginTime = LogRunBegin "az-steps-2-storage"

Say "`nSTEP - Create Storage Account: $($opts.storageAcctName)`n"

#  Create the Storage Account.
#    https://docs.microsoft.com/en-us/cli/azure/storage/account?view=azure-cli-latest#az-storage-account-create

az storage account create `
-n $opts.storageAcctName `
-l $opts.rgLocation `
-g $opts.rgName `
--allow-blob-public-access true `
--sku Standard_LRS

# az storage account show -g $rgName -n $storageAcctName | ConvertFrom-Json


#  Get the storage account key.
#    Example found in Microsoft Docs: "Mount a file share to a Python function app - Azure CLI"
#    https://docs.microsoft.com/en-us/azure/azure-functions/scripts/functions-cli-mount-files-storage-linux

$storageKey = $(az storage account keys list -g $opts.rgName -n $opts.storageAcctName --query '[0].value' -o tsv)


#  Create storage containers for blob data.
#    https://docs.microsoft.com/en-us/cli/azure/storage/container?view=azure-cli-latest#az-storage-container-create

Say "`nSTEP - Create Storage Container: $($opts.containerPublic)`n"

az storage container create `
--account-key $storageKey `
--account-name $opts.storageAcctName `
--public-access blob `
--name $opts.containerPublic

Say "`nSTEP - Create Storage Container: $($opts.containerPrivate)`n"

az storage container create `
--account-key $storageKey `
--account-name $opts.storageAcctName `
--name $opts.containerPrivate

LogRunEnd "az-steps-2-storage" $beginTime
