Import-Module C:\Users\guauser\Documents\PS\guA.BC.AdminTool\guA.BC.AdminTool.psm1 -Force 
. (Get-guANavAdminTool).FullName -Force | Out-Null

Get-guABcServerInfo
Get-guANavServerInfo -ServerInstance BC210