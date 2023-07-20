######################################################################################
# Version V1.0
# 21/02/2022
######################################################################################

#region - Logging Implementation
function WriteLog
{
    Param ([string]$LogString)
    $LogFile = "setup.log"
    $DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    $LogMessage = "$Datetime $LogString"
    Add-content $LogFile -value $LogMessage
}
#WriteLog "This is my log message"
#endregion

#region - Enable Hyper-V
function EnableHyperV
{
    $status = (Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online)
    if($status.ToString() -like '*True*')
    {
        WriteLog "Hyper-V enabled successfully"
    }
    else
    {
        Get-Error
        WriteLog ("Unable to enable Hyper-V on this PC and the error is - " + $Error)
    }
}
#EnableHyperV

#endregion

#region - Check Docker Version
function CheckDockerVersion
{
    $Docker_version = (docker --version)
    if ($Docker_version -like 'Docker version*')
    {
        WriteLog ("Docker Desktop is already installed and version is - " + $Docker_version)
    }
    else 
    {
        WriteLog ("Docker desktop is not installed on this machine, please install.")
    }
}
#CheckDockerVersion
#endregion

#region - Install Docker Desktop
function InstallDockerDesktop
{
    $status = (choco install docker-desktop)
    if ($status -gt 0)
    {
        WriteLog "Docker desktop is successfully installed."
    }
    else
    {
        WriteLog "Problem in Docker desktop installation."
    }
   
}
#endregion

#region - CLI Login
function CLILogin
{
    $status = (docker login -u XXXXXX -p XXXXXXX docker.io)
    
    if ($status -like '*Succeeded*')
    {
        WriteLog "Docker login using CLI is Success."
    }
    else
    {
        WriteLog "Problem in Docker login using CLI."
    } 
}
#CLILogin
#endregion

#region - Run full command with Docker

function installContainers
{
    $dockerPath = 'C:\AZDO\Project\Docker'
    $basePath = get-location
    
    WriteLog ("Moved to docker folder path " + $dockerPath)
    (set-location $dockerPath)
    #Write-Host $dockerPath    
    
    #$Command = (docker-compose -f ./docker-compose.yml -f ./docker-compose.bring.yml up --build -d)
    #WriteLog ("the command is " +$Command)
    $status = (docker-compose -f ./docker-compose.yml -f ./docker-compose.bring.yml up --build -d)
    
    if ($status -like '*done*')
    {
        WriteLog "Successfully completed Container/Image setup."
    }
    else
    {
        WriteLog ("Problem in Container/Image setup - " + $Error)
    } 
    
    (set-location $basePath)
    WriteLog ("Move back to base path " + $basePath)
}
#installContainers
#endregion

#region - Verify mandatory certificates
function verifyCertificates
{
    $cert = (Get-ChildItem -Path Cert:\LocalMachine\Root)

    $certificatesList = 'XXXXX Root CA', 'XXXX DevOps Certificate Authority'
    
    #Number of certificate list to be match is given in $totalMatchCount
    $totalMatchCount = 2
    $count = 0

    foreach ($item in $certificatesList)
    {
        if ($cert -like ('*'+$item+'*'))
        {
            $count++
            WriteLog ($item +" certificate is installed ")
        }
        else 
        {
            WriteLog ($item +" certificate is not installed, installation required please refer 'https://dev.azure.com/Docker' for more help. ")
        }     
    }

    if($totalMatchCount -like $count)
    {
        WriteLog ("All Required certificates are installed")
        return $true
    }
    else
    {
        WriteLog ("Some certificates still not installed please review the log, and refer 'https://dev.azure.com/Docker' for more help.")
        return $false
    }

}
#verifyCertificates
#calling verifyCertificates function
<#
    if(verifyCertificates -like $true)
    {
        WriteLog ("True returned successfully")
    }
    else
    {
        WriteLog ("False returned")
    }
#>
#endregion

#region parameterized the DB deployment

function deployDB
{
    
}

#endregion

