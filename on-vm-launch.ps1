# ----------------------------------------------------------------------
# on-vm-launch.ps1
#
# * Executed by the Custom Script Extension.
#
# * Copies files from storage blob container specified in $FilesURI.
#
# * Launches on-vm-process.ps1 to complete processing using files
#   copied from a private storage blob container.
#
# * Errors are written to text files that can be examined on the VM
#   if something goes wrong.
#
# ----------------------------------------------------------------------

param($FilesURI, $GHRepoURI)

$cmd = "& .\azcopy.exe cp `"$FilesURI`" C: --recursive=true --overwrite=true"

try {
  Invoke-Expression -Command $cmd -ErrorAction Stop
  if ($LASTEXITCODE -ne 0) {
    "ERROR LASTEXITCODE $LASTEXITCODE" >> .\error.txt
    $cmd >> .\error.txt
  }

} catch {
  "ERROR catch" >> .\error.txt
  $cmd >> .\error.txt
}

# The on-vm-process.ps1 script also needs azcopy.exe.
Copy-Item .\azcopy.exe -Destination "C:\action\"

C:\action\on-vm-process.ps1 -FilesURI $FilesURI -GHRepoURI $GHRepoURI
