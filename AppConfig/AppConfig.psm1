
function Get-AppConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    function ReplaceTags($setting, $projRoot, $uploadsPath) {
        $setting = $setting.Replace("%USERPROFILE%", $env:USERPROFILE)
        $setting = $setting.Replace("%PROJECT_ROOT%", $projRoot)
        $setting = $setting.Replace("%UPLOADS_PATH%", $uploadsPath)
        return $setting
    }

    $config = Import-PowerShellDataFile -Path $Path

    $config.projectRoot = [IO.Path]::TrimEndingDirectorySeparator($config.projectRoot.Replace("%USERPROFILE%", $env:USERPROFILE))

    $projRoot = $config.projectRoot

    $config.baseUploadsPath = ReplaceTags $config.baseUploadsPath $projRoot ""

    $upldPath = $config.baseUploadsPath

    $config.credsFile = $config.credsFile.Replace("%USERPROFILE%", $env:USERPROFILE)

    $config.lazInstallerPath = ReplaceTags $config.lazInstallerPath $projRoot $upldPath
    $config.gitInstallerPath = ReplaceTags $config.gitInstallerPath $projRoot $upldPath
    $config.ahkInstallerPath = ReplaceTags $config.ahkInstallerPath $projRoot $upldPath
    $config.azcopyPath = ReplaceTags $config.azcopyPath $projRoot $upldPath
    $config.srcZipPath = ReplaceTags $config.srcZipPath $projRoot $upldPath
    $config.kitZipPath = ReplaceTags $config.kitZipPath $projRoot $upldPath
    $config.kitBuildScript = ReplaceTags $config.kitBuildScript $projRoot $upldPath
    $config.downloadPath = ReplaceTags $config.downloadPath $projRoot $upldPath
    
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
    $config.Add("ahkInstallerName", [System.IO.Path]::GetFileName($config.ahkInstallerPath))
    $config.Add("srcZipName", [System.IO.Path]::GetFileName($config.srcZipPath))
    $config.Add("kitZipName", [System.IO.Path]::GetFileName($config.kitZipPath))
    
    return $config
}