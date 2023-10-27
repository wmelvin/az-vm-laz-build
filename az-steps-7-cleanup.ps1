
#  Source the initialization script.
. ./az-steps-0-init.ps1

WriteLog "BEGIN: az-steps-7-cleanup"
$beginTime = Get-Date

Say "`nSTEP - Shutting down VM '$($opts.vmName)'`n"

#  https://learn.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-stop

az vm stop --resource-group $opts.rgName --name $opts.vmName


Say "`nSTEP - Deleting resource group '$($opts.rgName)'`n"

#  https://learn.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-delete

az group delete --name $opts.rgName --yes

WriteLog "END: az-steps-7-cleanup (run time $((New-TimeSpan $beginTime (Get-Date)).ToString()))"
