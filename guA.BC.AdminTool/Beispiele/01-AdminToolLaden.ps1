Import-Module C:\Users\guauser\Documents\PS\guA.BC.AdminTool\guA.BC.AdminTool.psm1 -Force 
# Hier ist der Pfad zum NavAdminTool versionsabhängig und statisch
#. 'C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1'
# Daher ist in unserem Modul eine Funktion Get-guANavAdminTool implemtiert, 
# die den Pfand dynamisch ermittelt :-)
. (Get-guANavAdminTool).FullName -Force | Out-Null

Get-NAVServerInstance
Get-NAVServerConfiguration -ServerInstance BC210