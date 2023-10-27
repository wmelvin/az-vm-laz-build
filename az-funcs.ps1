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


$msgLogFileName = ""

function SetLogFileName([string]$fileName)
{
    $script:msgLogFileName = $fileName
}

function WriteLog([string]$message)
{
    #  Messages are logged if the msgLogFileName is assigned a value.
    if (0 -lt $script:msgLogFileName.Length) {
        $logMsg = "[{0}] {1}" -f (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"), $message.Trim()
        Out-File -FilePath $script:msgLogFileName -Encoding ascii -Append -InputObject $logMsg
    }
}

$runLogFileName = ""

function SetRunLogFileName([string]$fileName)
{
    $script:runLogFileName = $fileName
}

function LogRunBegin([string]$name)
{
    $startTime = Get-Date
    if (0 -lt $script:runLogFileName.Length) {
        $logMsg = "[{0}] BEGIN: {1}" -f $startTime.ToString("yyyy-MM-dd HH:mm:ss"), $name
        Out-File -FilePath $script:runLogFileName -Encoding ascii -Append -InputObject $logMsg
    }
    return $startTime
}

function LogRunEnd([string]$name, [datetime]$startTime)
{
    if (0 -lt $script:runLogFileName.Length) {
        $endTime = Get-Date
        $logMsg = "[{0}] END: {1} ({2})" -f $endTime.ToString("yyyy-MM-dd HH:mm:ss"), $name, (New-TimeSpan $startTime $endTime).ToString()
        Out-File -FilePath $script:runLogFileName -Encoding ascii -Append -InputObject $logMsg
    }
}
