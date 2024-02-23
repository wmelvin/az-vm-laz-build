
# There are three replacement tags that can be used in the settings below:
#   %USERPROFILE%   -  The user's profile directory which comes from the environment variable $env:USERPROFILE.
#   %PROJECT_ROOT%  -  The root of the project directory as specified in the 'projectRoot' setting.
#   %UPLOADS_PATH%  -  The path to the directory for files to be uploaded to the VM as specified in the 'baseUploadsPath' setting.

@{
    projectRoot = "<PATH_TO_PROJECT_ROOT>"
    
    baseTag = "demo"
    
    uniqTag = "123"
    
    rgLocation = "<LOCATION>"
    
    containerPublic = "pubfiles"
    
    containerPrivate = "action"
    
    #  Windows 11 Pro.
    vmImageUrn =  "MicrosoftWindowsDesktop:windows-11:win11-22h2-pro:22621.2283.230901"
    
    vmSize =  "Standard_DS2_v2"
    
    credsFile = "<PATH_TO_CREDS_FILE>"

    baseUploadsPath = "%PROJECT_ROOT%\Uploads"

    azcopyPath = "%UPLOADS_PATH%\azcopy.exe"
    
    #  Update the following line to match the path to your Lazarus installer file.
    lazInstallerPath = "%UPLOADS_PATH%\lazarus-3.0-fpc-3.2.2-win64.exe"
    
    #  Update the following line to match the path to your Portable Git installer file.
    gitInstallerPath = "%UPLOADS_PATH%\PortableGit-2.42.0.2-64-bit.7z.exe"

    #  Update the following line to match the path to your AutoHotKey zip file.
    ahkInstallerPath = "%PROJECT_ROOT%\Uploads\AutoHotkey_2.0.11.zip"
    
    #  If you are using a downloaded source archive, instead of cloning a Git
    #  repository, update the following line to match the path to your zip
    #  file to be uploaded.
    srcZipPath = "%UPLOADS_PATH%\<YOUR_ZIP_FILE>"
    
    #  If any additional files are needed on the VM, update the following line
    #  to match the path to your zip file to be uploaded.
    #  If no additional files are needed, set the value to an empty string.
    kitZipPath = "%PROJECT_ROOT%\Uploads\UploadKit.zip"

    #  When the repository is cloned, or the archive extacted, the Lazarus project
    #  file will be in the following directory path under the directory where 
    #  processing happens on the VM (C:\action\<SUBPATH>).
    repoDirName = "<SUBPATH>"
    
    lazProjectFileName = "<PROJECT_NAME>.lpi"
    
    outputFileName = "<PROJECT_NAME>.exe"

    outputLogName = "laz-build-windows-output.txt"

    downloadPath = "%PROJECT_ROOT%\Downloads"
}


#  Alternate vmImageUrn values:

#  Windows 11 with Visual Studio
# vmImageUrn = "MicrosoftVisualStudio:visualstudio2022:vs-2022-comm-latest-win11-n-gen2:2024.02.15"

#  Windows Server 2019
# vmImageUrn = "MicrosoftWindowsServer:WindowsServer:2019-datacenter-smalldisk-g2:17763.4851.230905"

#  Windows Server 2022
# vmImageUrn = "MicrosoftWindowsServer:WindowsServer:2022-datacenter-smalldisk-g2:20348.887.220806"

#  Windows Server 2022 Azure edition
# vmImageUrn = "MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition-smalldisk:20348.887.220806"
