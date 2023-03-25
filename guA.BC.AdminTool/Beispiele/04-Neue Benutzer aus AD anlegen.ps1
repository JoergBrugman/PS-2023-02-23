Import-Module C:\Users\guauser\Documents\PS\guA.BC.AdminTool\guA.BC.AdminTool.psm1 -Force
. (Get-guANavAdminTool).FullName -Force | Out-Null

$selUsers = Get-ADUser -Filter * | Out-GridView -Title "AD-User für die Erstellung als BC-User auswählen" -OutputMode Multiple
# Alternative Funktion von Waldo unter: https://github.com/waldo1001/Cloud.Ready.Software.PowerShell/blob/master/PSModules/Cloud.Ready.Software.NAV/Add-NAVUsersFromAD.ps1#L45

# Instanz für die Arbeit wählen
$ServerInfo = Select-guABcServerInfo -OutputMode Single    # (Get-guABcServerInfo | Out-GridView -Title "Server Instanz wählen" -OutputMode Single).ServerInstance

if ($null -ne $ServerInfo) {
    # BC-User erstellen
    foreach ($u in $selUsers) {
        New-NAVServerUser -ServerInstance $ServerInfo.ServerInstance -WindowsAccount $u.UserPrincipalName -FullName $u.Name -LicenseType Full -State Enabled -CreateWebServicesKey 
    }

    # User ermittel und auswählen
    $FromUser = Get-NAVServerUser -ServerInstance $ServerInfo.ServerInstance | Out-GridView -Title 'Quell-User für Berechtigungssätze wählen' -OutputMode Single
    $ToUsers = Get-NAVServerUser -ServerInstance $ServerInfo.ServerInstance | Out-GridView -Title 'Ziel-User für Berechtigungssätze wählen' -OutputMode Multiple

    # Berechtigungssätze kopieren
    Copy-guABcServerUserPermissionSet -ServerInstance $ServerInfo.ServerInstance -FromUser $FromUser.UserName -ToUsers ([string[]]($ToUsers).UserName)
    Copy-guABcServerUserPermissionSet -ServerInstance $ServerInfo.ServerInstance -UserSelectionDialog -Verbose
    ([string[]]($ToUsers).UserName) | Copy-guABcServerUserPermissionSet -ServerInstance $ServerInfo.ServerInstance -FromUser $FromUser.UserName 
    @('guatrain\administrator'; 'guatrain\guauser') | Copy-guABcServerUserPermissionSet -ServerInstance $ServerInfo.ServerInstance -FromUser $FromUser.UserName 
}

