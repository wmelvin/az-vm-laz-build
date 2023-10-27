
#  Run the whole kit.

# Out-File -FilePath ./log-run.txt -InputObject "Run started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -Append -Encoding ascii
# $runAllbeginTime = Get-Date

. ./az-steps-0-init.ps1

$runAllBeginTime = LogRunBegin "az-run-all"

# ./az-steps-1-rg.ps1
# ./az-steps-2-storage.ps1
# ./az-steps-3-upload.ps1
# ./az-steps-4-win-vm.ps1
# ./az-steps-5-custom-script.ps1
# ./az-steps-6-download.ps1
# ./az-steps-7-cleanup.ps1

# Out-File -FilePath ./log-run.txt -InputObject "Run ended: $((New-TimeSpan $runAllBeginTime (Get-Date)).ToString())" -Append -Encoding ascii

LogRunEnd "az-run-all" $runAllBeginTime