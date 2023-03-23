. 'C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1'
Import-Module C:\Users\guauser\Documents\PS\guA.BC.AdminTool\guA.BC.AdminTool.psm1 -Force

# Server auswählen
# $bcServerInfos = Get-guABcServerInfo;
# $selBcServerInfo = $bcServerInfos | Out-GridView -Title 'BC ServerInfo auswählen' -OutputMode Single
$selBcServerInfo = Select-guABcServerInfo

# Credentials für den Service-Account ermitteln
$password = ConvertTo-SecureString "EiWoha7T@" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("guatrain\BCServerAccount", $password)
# oder auch so... 
#$Cred = Get-Credential -UserName "guatrain\BCServerAccount" -Message 'Password eingeben'

# Name des neuen ServiceTier abfragen
$defaulServerName = 'BC';
$serverName = Read-Host "Servername [$($defaulServerName)] mit <Enter> bestätigen oder neuen Namen eigeben"
$serverName = ($defaulServerName, $serverName)[[bool]$serverName]

# Neuen Server erstellen
$newBCServerInfo = $selBcServerInfo | `
    New-guABCServerInstance $serverName -PortOffset 1000 -ServiceAccount User -ServiceAccountCredential $Cred -Verbose


# Passende WebServer-Instanz erstellen
New-NAVWebServerInstance -WebServerInstance $serverName `
    -ServerInstance $serverName `
    -Server localhost `
    -ClientServicesCredentialType ([string]$newBCServerInfo.ClientServicesCredentialType).TrimStart() `
    -ClientServicesPort $newBCServerInfo.ClientServicesPort `
    -ManagementServicesPort $newBCServerInfo.ManagementServicesPort `
    -SiteDeploymentType SubSite