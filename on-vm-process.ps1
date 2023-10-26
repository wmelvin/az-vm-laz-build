# ----------------------------------------------------------------------
# on-vm-process.ps1
#
# Called by on-vm-launch.ps1 which is executed by the Custom Script
# extension.
#
# * Installs the Lazarus Free Pascal IDE software.
# * If a GitHub repo URI is specified:
#   * Installs PortableGit.
#   * Clones the repo using the URI.
# * If a GitHub repo URI is not specified:
#   * Extracts the source code from a ZIP archive.
# * Builds the project.
# * Copies the resulting executable to the storage blob container.
#
# WARNING: Commands and errors are written to text files that can be 
# examined on the VM for debugging. This is not a secure practice 
# because some secrets may be included in the files. However, in this
# case, the VM is intended to be short-lived and the files are deleted
# when the VM is deallocated.
#
# ----------------------------------------------------------------------

param($FilesURI, $GHRepoURI)

function Set-RunLocation($runDir)
{
  Set-Location $runDir
  [environment]::CurrentDirectory = $runDir
}

function Invoke-Cmd($cmd)
{
  $cmd >> .\debug.txt
  try {
    Invoke-Expression -Command $cmd -ErrorAction Stop
    if ($LASTEXITCODE -ne 0) {
      "ERROR LASTEXITCODE $LASTEXITCODE" >> .\error.txt
      $cmd >> .\error.txt
    }
  }
  catch {
    "ERROR catch" >> .\error.txt
    $cmd >> .\error.txt
  }
}


Set-RunLocation "C:\action"

$config = Import-PowerShellDataFile -Path ./on-vm-settings.psd1

$config >> .\debug.txt

$srcHome = "C:\action\$($config.repoDirName)"

#  Install the Lazarus IDE which includes Free Pascal compiler.

if (Test-Path "C:\lazarus\lazbuild.exe") {
    Write-Host "Lazarus is already installed."
}
else {
  $cmdPath = ".\$($config.lazInstallerName)"
  $argList = ('/SILENT', '/SUPPRESSMSGBOXES', '/LOG', '/NORESTART')
  ($cmdPath + ' ' + $argList) >> .\debug.txt
  Start-Process -FilePath $cmdPath -ArgumentList $argList -Wait
}

if (-not (Test-Path "C:\lazarus\lazbuild.exe")) {
  $errmsg = "Failed to install Lazarus"
  Write-Host $errmsg
  $errmsg >> .\error.txt
  Return
}


if (0 -lt $GHRepoURI.Length) {
  #  If a GitHub repo URI is specified, clone the repo using the URI.

  #  Extract PortableGit.
  $cmdPath = ".\$($config.gitInstallerName)"
  $argList = (' -oC:\action\PortableGit', '-y')
  ($cmdPath + ' ' + $argList) >> .\debug.txt
  Start-Process -FilePath $cmdPath -ArgumentList $argList -Wait

  if (-not (Test-Path "C:\action\PortableGit\cmd\git.exe")) {
    $errmsg = "Failed to install PortableGit"
    Write-Host $errmsg
    $errmsg >> .\error.txt
    Return
  }

  #  Setup the environment to use git.
  $env:gitdir = "C:\action\PortableGit\cmd"
  $env:Path = $env:gitdir + ';' + $env:Path

  #  Prevent the credential helper-selector from prompting for input.
  $cmd = "& git config --system --unset credential.helper"
  Invoke-Cmd $cmd

  #  Clone the git repository.
  $cmd = "& git clone `"$GHRepoURI`""
  Invoke-Cmd $cmd
}
else {
  #  If a GitHub repo URI was not specified, assume the source was included in
  #  files copied from storage.

  #  Confirm the source code archive exists.
  if (-not (Test-Path ".\$($config.srcZipName)")) {
    $errmsg = "Cannot find $($config.srcZipName)"
    Write-Host $errmsg
    $errmsg >> .\error.txt
    Return
  }

  #  Extract the source code archive. Use -Force to overwrite existing files.
  Expand-Archive -LiteralPath ".\$($config.srcZipName)" -DestinationPath C:\action -Force
}


$outExe = "$srcHome\$($config.outputFileName)"

#  Delete existing output from previous build.
if (Test-Path $outExe) {
  Remove-Item $outExe
}

$lazProjFile = "$srcHome\$($config.lazProjectFileName)"

if (-not (Test-Path $lazProjFile)) {
  $errmsg = "Cannot find Lazarus project file."
  Write-Host $errmsg
  $errmsg >> .\error.txt
  Return
}

#  Build the Lazarus project.

Set-RunLocation $srcHome
$cmdPath = 'C:\lazarus\lazbuild.exe'
$argList = "$($config.lazProjectFileName)"
($cmdPath + ' ' + $argList) >> .\debug.txt
Start-Process -FilePath $cmdPath -ArgumentList $argList -Wait

if (-not (Test-Path $outExe)) {
  $errmsg = "Failed to build executable."
  Write-Host $errmsg
  $errmsg >> .\error.txt
  Set-RunLocation "C:\action"
  Return
}

#  Copy the built executable to blob storage using azcopy.

Set-RunLocation "C:\action"

$dst = $FilesURI  # URI must include SAS with Create permission.

$cmd = "&`".\azcopy.exe`" cp `"$outExe`" `"$dst`" --overwrite=true"
Invoke-Cmd $cmd
