# Param example in powershell
param (
    
    #Validate selector
    [Parameter(Mandatory=$true)]
    [ValidateSet('one', 'two')]
    [string]$validate

    )

#Global Variable
$initialLocation = Get-Location

#region - logging implementation
function LogIt
{
    param
    (
        [parameter(Mandatory=$true)]
        [String] $line,

        [Parameter(Mandatory=$false)]
        [ValidateSet('INFO', 'WARNING', 'ERROR')]
        [String] $level = "INFO"
    )
    process
    {
        $outputLog = ($initialLocation.ToString() + "\Excel_Test.log")
        Add-Content -Path $outputLog -Value ((Get-Date).ToString() + " - [" + $level + "] - " + $line) -Force
        Write-Output -InputObject ($line)
    }
}
#endregion

#region
function LoggingTesting
{
    process
    {
        $result = @{
                    'status'  = $false;
                    'message' = "";
                    'level'   = "INFO"
                   }

        $check = Get-ExecutionPolicy -Scope CurrentUser | Out-String
        If ($check.ToLower() -Match "unrestricted")
        {
            $result["message"] = "   +  Execution Policy: Ok."
            $result["status"] = $true
        }
        Else
        {
            $result["message"] = "   +  Execution Policy: Is not 'Unrestricted'."
            $result["level"] = "ERROR"
            $result["status"] = $false
        }
        return $result
    }
}
#endregion

#configureEnvironment
If ($validate.Contains('one'))
{
    LogIt ("One is selected")

    #Call LoggingTesting function.
    $LoggingTest = LoggingTesting
    LogIt -line ($LoggingTest['message']) -level $LoggingTest["level"]
    
}

If ($validate.Contains('two'))
{
    LogIt ("Two is selected")  
}

#Set path to initial Location
Set-Location $initialLocation
Pause
