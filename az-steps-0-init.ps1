Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ----------------------------------------------------------------------
#  Source the function definitions.

. .\az-funcs.ps1

# ----------------------------------------------------------------------
#  Load configuration settings.

Import-Module .\AppConfig\AppConfig.psm1 -Force

$opts = Get-AppConfig -Path .\local-settings.psd1

SetLogMsgFileName ([IO.Path]::GetFullPath(".\log-msg.txt"))

SetLogRunFileName ([IO.Path]::GetFullPath(".\log-run.txt"))

# ----------------------------------------------------------------------
#  Check some path and file settings.

if (! [IO.Directory]::Exists($opts.projectRoot)) {
    Yell "ERROR: The project root directory '$($opts.projectRoot)' does not exist."
    Exit 1
}

# check exists $opts.lazInstallerPath
if (! [IO.File]::Exists($opts.lazInstallerPath)) {
    Yell "ERROR: The Lazarus installer file '$($opts.lazInstallerPath)' does not exist."
    Exit 1
}

# $opts.gitInstallerPath
if (! [IO.File]::Exists($opts.gitInstallerPath)) {
    Yell "ERROR: The Git installer file '$($opts.gitInstallerPath)' does not exist."
    Exit 1
}

# $opts.ahkInstallerPath
if (! [IO.File]::Exists($opts.ahkInstallerPath)) {
    Yell "ERROR: The AutoHotKey installer file '$($opts.ahkInstallerPath)' does not exist."
    Exit 1
}

# $opts.azcopyPath
if (! [IO.File]::Exists($opts.azcopyPath)) {
    Yell "ERROR: The AzCopy executable file '$($opts.azcopyPath)' does not exist."
    Exit 1
}

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
Say "ahkInstallerPath = '$($opts.ahkInstallerPath)'"
Say "ahkInstallerName = '$($opts.ahkInstallerName)'"
Say "srcZipPath = '$($opts.srcZipPath)'"
Say "srcZipName = '$($opts.srcZipName)'"
Say "kitZipPath = '$($opts.kitZipPath)'"
Say "kitZipName = '$($opts.kitZipName)'"
Say "kitBuildScript = '$($opts.kitBuildScript)'"
Say "repoDirName = '$($opts.repoDirName)'"
Say "lazProjectFileName = '$($opts.lazProjectFileName)'"
Say "outputFileName = '$($opts.outputFileName)'"
Say "downloadPath = '$($opts.downloadPath)'"
Say "postProcessScript = '$($opts.postProcessScript)'"
