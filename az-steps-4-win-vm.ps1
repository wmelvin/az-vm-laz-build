
#  Source the initialization script.
. ./az-steps-0-init.ps1

WriteLog "BEGIN: az-steps-4-win-vm"
$beginTime = Get-Date

Say "`nSTEP - Create VNet: $($opts.vnetName)`n"

az network vnet create `
--resource-group $opts.rgName `
--name $opts.vnetName `
--address-prefix "10.1.0.0/16" `
--subnet-name $opts.subnetName `
--subnet-prefix "10.1.1.0/24"

# az network vnet list -g $opts.rgName


Say "`nSTEP - Create Public IP Address: $($opts.pipName)`n"

az network public-ip create `
--resource-group $opts.rgName `
--name $opts.pipName

# az network public-ip list -o table


Say "`nSTEP - Create Network Security Group: $($opts.nsgName)`n"

az network nsg create `
--resource-group $opts.rgName `
--name $opts.nsgName

# az network nsg list -o table


Say "`nSTEP - Create NIC: $($opts.nicName)`n"

az network nic create `
--resource-group $opts.rgName `
--name $opts.nicName `
--vnet-name $opts.vnetName `
--subnet $opts.subnetName `
--network-security-group $opts.nsgName `
--public-ip-address $opts.pipName

# az network nic list -o table


Say "`nSTEP - Create Virtual Machine: $($opts.vmName)`n"

az vm create `
--resource-group $opts.rgName `
--location $opts.rgLocation `
--name $opts.vmName `
--nics $opts.nicName `
--size $opts.vmSize `
--image $opts.vmImageUrn `
--admin-username $VMUser `
--admin-password $VMPass

# az vm list -o table

Say "`nSTEP - Open RDP Port.`n"

az vm open-port -g $opts.rgName --name $opts.vmName --port "3389"

# ----------------------------------------------------------------------

#  Get IP address.

az vm list-ip-addresses -n $opts.vmName -o table

# ----------------------------------------------------------------------

WriteLog "END: az-steps-4-win-vm (run time $((New-TimeSpan $beginTime (Get-Date)).ToString()))"
