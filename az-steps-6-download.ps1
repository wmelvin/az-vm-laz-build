
#  Reference:
#  https://learn.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-list
#  https://learn.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-download


#  Source the initialization script.
. ./az-steps-0-init.ps1

$beginTime = LogRunBegin "az-steps-6-download"

Say "`nSTEP - Preparing to download from blob storage.`n"

#  Get the storage account key.
$storageKey = $(az storage account keys list -g $opts.rgName -n $opts.storageAcctName --query '[0].value' -o tsv)

$downloadFileName = $opts.outputFileName

$downloadDest = [IO.Path]::Combine($opts.downloadPath, $downloadFileName)

$blobNames = az storage blob list `
--account-name $opts.storageAcctName `
--account-key $storageKey `
--container-name $opts.containerPrivate `
--query '[].name' -o tsv

if ($blobNames -contains $downloadFileName) {
    if (Test-Path $downloadDest) {
        Say "`nRemove existing '$downloadDest'`n"
        Remove-Item $downloadDest
    }
    Say "`nDownloading '$downloadFileName'`n"
    $result = az storage blob download `
    --account-name $opts.storageAcctName `
    --account-key $storageKey `
    --file $downloadDest `
    --container-name $opts.containerPrivate `
    --name $downloadFileName
    $result | Out-Null
}
else {
    Yell "Blob not found: $downloadFileName"
}

LogRunEnd "az-steps-6-download" $beginTime
