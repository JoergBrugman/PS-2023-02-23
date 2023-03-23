. 'C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1'
Import-Module C:\Users\guauser\Documents\PS\guA.BC.AdminTool\guA.BC.AdminTool.psm1 -Force

$x = Get-guABcServerInfo
Get-guANavServerInfo -ServerInstance BC210