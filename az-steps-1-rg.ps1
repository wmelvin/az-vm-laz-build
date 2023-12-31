# ----------------------------------------------------------------------

# az login

# az account set -s $SUBSCRIPTION

# ----------------------------------------------------------------------

#  Source the initialization script.
. ./az-steps-0-init.ps1

$beginTime = LogRunBegin "az-steps-1-rg"

Say "`nSTEP - Create resource group: $($opts.rgName)`n"

#  https://learn.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-create

az group create -n $opts.rgName -l $opts.rgLocation

# az group list -o table

LogRunEnd "az-steps-1-rg" $beginTime
