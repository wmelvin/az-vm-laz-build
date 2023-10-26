
#  Source the initialization script.
. ./az-steps-0-init.ps1

Say "`nSTEP - Shutting down VM '$($opts.vmName)'`n"

#  https://learn.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-stop

az vm stop --resource-group $opts.rgName --name $opts.vmName


Say "`nSTEP - Deleting resource group '$($opts.rgName)'`n"

#  https://learn.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-delete

az group delete --name $opts.rgName --yes
