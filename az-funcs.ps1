# ----------------------------------------------------------------------
# Define some functions:

# -- Display a message in green text.
function Say([string]$message)
{
    Write-Host -ForegroundColor Green "$message"
    WriteLog $message
}


# -- Display a message in yellow text.
function Yell([string]$message)
{
    Write-Host -ForegroundColor Yellow "$message"
    WriteLog $message
}


$logFileName = ""

function SetLogFileName([string]$fileName)
{
    $script:logFileName = $fileName
}

function WriteLog([string]$message)
{
    #  Messages are logged if the logFileName is assigned a value.
    if (0 -lt $script:logFileName.Length) {
        $logMsg = "[{0}] {1}" -f (Get-Date).ToString("yyy-MM-dd HH:mm:ss"), $message.Trim()
        Out-File -FilePath $script:logFileName -Encoding ascii -Append -InputObject $logMsg
    }
}
