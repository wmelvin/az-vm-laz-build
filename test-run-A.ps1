
. ./az-steps-0-init.ps1

$runBeginTime = LogRunBegin "test-run-A"

./az-steps-1-rg.ps1

./az-steps-4-win-vm.ps1

./az-steps-7-cleanup.ps1

LogRunEnd "test-run-A" $runBeginTime
