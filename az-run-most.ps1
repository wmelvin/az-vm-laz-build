
#  Run all but the cleanup, so the VM is available to debug or explore.

. ./az-steps-0-init.ps1

$runAllBeginTime = LogRunBegin "az-run-most"

./az-steps-1-rg.ps1
./az-steps-2-storage.ps1
./az-steps-3-upload.ps1
./az-steps-4-win-vm.ps1
./az-steps-5-custom-script.ps1
./az-steps-6-download.ps1

Yell "`nRemember to delete the resource group when you're done!`n"

LogRunEnd "az-run-most" $runAllBeginTime
