Set-StrictMode -Version Latest

# ----------------------------------------------------------------------
#  Source the function definitions.

. .\az-funcs.ps1

Import-Module .\AppConfig\AppConfig.psm1 -Force

$opts = Get-AppConfig -Path .\local-settings.psd1

# SetLogFileName $opts.logFileName

SetLogFileName ([IO.Path]::GetFullPath(".\log-msg.txt"))
SetRunLogFileName ([IO.Path]::GetFullPath(".\log-run.txt"))


# ----------------------------------------------------------------------
# Get credentials and keys from a file in a local encrypted folder.

#  Source the file to assign variables.

# $credsFile = $config.credsFile.Replace("%USERPROFILE%", $env:USERPROFILE)
. $opts.credsFile

if (0 -eq $VMUser.Length) {
    Write-Host "Failed to get User Name from '$($opts.credsFile)'."
    Exit 1
}

if (0 -eq $VMPass.Length) {
    Write-Host "Failed to get Password from '$($opts.credsFile)'."
    Exit 1
}

if (0 -eq $GHRepoURI.Length) {
    Write-Host "Failed to get GitHub repo URI from '$($opts.credsFile)'."
    Exit 1
}


# ----------------------------------------------------------------------
# Display the settings.

Say("Settings:")
Say "rgName = '$($opts.rgName)'"
Say "rgLocation = '$($opts.rgLocation)'"
Say "storageAcctName = '$($opts.storageAcctName)'"
Say "containerPublic = '$($opts.containerPublic)'"
Say "containerPrivate = '$($opts.containerPrivate)'"
Say "vnetName = '$($opts.vnetName)'"
Say "subnetName = '$($opts.subnetName)'"
Say "nicName = '$($opts.nicName)'"
Say "pipName = '$($opts.pipName)'"
Say "nsgName = '$($opts.nsgName)'"
Say "vmName = '$($opts.vmName)'"
Say "vmSize = '$($opts.vmSize)'"
Say "vmImageUrn = '$($opts.vmImageUrn)'"
Say "azcopyPath = '$($opts.azcopyPath)'"
Say "azcopyName = '$($opts.azcopyName)'"
Say "lazInstallerPath = '$($opts.lazInstallerPath)'"
Say "lazInstallerName = '$($opts.lazInstallerName)'"
Say "gitInstallerPath = '$($opts.gitInstallerPath)'"
Say "gitInstallerName = '$($opts.gitInstallerName)'"
Say "srcZipPath = '$($opts.srcZipPath)'"
Say "srcZipName = '$($opts.srcZipName)'"
Say "repoDirName = '$($opts.repoDirName)'"
Say "lazProjectFileName = '$($opts.lazProjectFileName)'"
Say "outputFileName = '$($opts.outputFileName)'"
Say "downloadPath = '$($opts.downloadPath)'"
