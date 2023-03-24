Import-Module C:\Users\guauser\Documents\PS\guA.BC.AdminTool\guA.BC.AdminTool.psm1 -Force
. (Get-guANavAdminTool).FullName -Force | Out-Null

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
$newBCServerInfo = $selBcServerInfo | New-guABCServerInstance $serverName -PortOffset 100 -ServiceAccount User -ServiceAccountCredential $Cred -Verbose


# Passende WebServer-Instanz erstellen
New-NAVWebServerInstance -WebServerInstance $serverName `
    -ServerInstance $serverName `
    -Server localhost `
    -ClientServicesCredentialType $newBCServerInfo.ClientServicesCredentialType `
    -ClientServicesPort $newBCServerInfo.ClientServicesPort `
    -ManagementServicesPort $newBCServerInfo.ManagementServicesPort `
    -SiteDeploymentType SubSite

Select-guABcServerInfo -OutputName Single | `
    Get-NAVServerUser | `
    Select-Object USerName, FullName, Enabled, ChangePassword, LicenseType | `
    Out-GridView 