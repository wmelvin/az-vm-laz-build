
#  Source the initialization script.
. ./az-steps-0-init.ps1

$beginTime = LogRunBegin "az-steps-4b-win-vm-bicep"

Say "`nSTEP - Create Virtual Machine using bicep file: $($opts.vmName)`n"

# az-deployment-group-create
# URL: https://learn.microsoft.com/en-us/cli/azure/deployment/group?view=azure-cli-latest#az-deployment-group-create

#az deployment group what-if `

az deployment group create `
--resource-group $($opts.rgName) `
--template-file .\bicep\win-vm.bicep `
--parameters `
  rg_location=$($opts.rgLocation) `
  vm_name=$($opts.vmName) `
  vm_size=$($opts.vmSize) `
  vm_image_urn=$($opts.vmImageUrn) `
  vm_user=$VMUser `
  vm_pass=$VMPass `
  pip_name=$($opts.pipName) `
  nsg_name=$($opts.nsgName) `
  vnet_name=$($opts.vnetName) `
  subnet_name=$($opts.subnetName) `
  nic_name=$($opts.nicName)


# ----------------------------------------------------------------------

#  Get IP address.

# az vm list-ip-addresses -n $opts.vmName -o table

# ----------------------------------------------------------------------

LogRunEnd "az-steps-4b-win-vm-bicep" $beginTime
