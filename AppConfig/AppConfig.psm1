
function Get-AppConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $config = Import-PowerShellDataFile -Path $Path

    $config.projectRoot = [IO.Path]::TrimEndingDirectorySeparator($config.projectRoot.Replace("%USERPROFILE%", $env:USERPROFILE))

    $config.credsFile = $config.credsFile.Replace("%USERPROFILE%", $env:USERPROFILE)

    $config.lazInstallerPath = $config.lazInstallerPath.Replace("%PROJECT_ROOT%", $config.projectRoot)
    $config.gitInstallerPath =$config.gitInstallerPath.Replace("%PROJECT_ROOT%", $config.projectRoot)
    $config.azcopyPath = $config.azcopyPath.Replace("%PROJECT_ROOT%", $config.projectRoot)
    $config.srcZipPath = $config.srcZipPath.Replace("%PROJECT_ROOT%", $config.projectRoot)
    $config.downloadPath = $config.downloadPath.Replace("%PROJECT_ROOT%", $config.projectRoot)
    
    if ([bool]$config.logFileName) {
        $config.logFileName = $config.logFileName.Replace("%PROJECT_ROOT%", $config.projectRoot)
    }

    $config.Add("baseName", $config.baseTag + $config.uniqTag)
    $config.Add("rgName", $config.baseName + "_rg")
    $config.Add("storageAcctName", $config.baseName + "storacct")
    $config.Add("vnetName", $config.baseName + "vnet")
    $config.Add("subnetName", $config.baseName + "subnet")
    $config.Add("nicName", $config.baseName + "nic")
    $config.Add("pipName", $config.baseName + "pip")
    $config.Add("nsgName", $config.baseName + "nsg")
    $config.Add("vmName", $config.baseName + "winVM")
    $config.Add("azcopyName", [System.IO.Path]::GetFileName($config.azcopyPath))
    $config.Add("lazInstallerName", [System.IO.Path]::GetFileName($config.lazInstallerPath))
    $config.Add("gitInstallerName", [System.IO.Path]::GetFileName($config.gitInstallerPath))
    $config.Add("srcZipName", [System.IO.Path]::GetFileName($config.srcZipPath))
    
    return $config
}