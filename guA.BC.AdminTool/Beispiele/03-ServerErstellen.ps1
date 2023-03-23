. 'C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1'
Import-Module C:\Users\guauser\Documents\PS\guA.BC.AdminTool\guA.BC.AdminTool.psm1 -Force

# Server auswählen
# $bcServerInfos = Get-guABcServerInfo;
# $selBcServerInfo = $bcServerInfos | Out-GridView -Title 'BC ServerInfo auswählen' -OutputMode Single
$selBcServerInfo = Select-guABcServerInfo

# Name des neuen ServiceTier abfragen

# Neuen Server erstellen

# Passende WebServer-Instanz erstellen