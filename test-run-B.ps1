
. ./az-steps-0-init.ps1

$runBeginTime = LogRunBegin "test-run-B"

./az-steps-1-rg.ps1

./az-steps-4b-win-vm-bicep.ps1

./az-steps-7-cleanup.ps1

LogRunEnd "test-run-B" $runBeginTime
