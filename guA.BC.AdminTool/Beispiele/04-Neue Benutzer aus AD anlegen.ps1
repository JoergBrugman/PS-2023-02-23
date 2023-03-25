Import-Module C:\Users\guauser\Documents\PS\guA.BC.AdminTool\guA.BC.AdminTool.psm1 -Force
. (Get-guANavAdminTool).FullName -Force | Out-Null

$selUsers = Get-ADUser -Filter * | Out-GridView -Title "AD-User f�r die Erstellung als BC-User ausw�hlen" -OutputMode Multiple
# Alternative Funktion von Waldo unter: https://github.com/waldo1001/Cloud.Ready.Software.PowerShell/blob/master/PSModules/Cloud.Ready.Software.NAV/Add-NAVUsersFromAD.ps1#L45

# Instanz f�r die Arbeit w�hlen
$ServerInfo = Select-guABcServerInfo -OutputMode Single    # (Get-guABcServerInfo | Out-GridView -Title "Server Instanz w�hlen" -OutputMode Single).ServerInstance

if ($null -ne $ServerInfo) {
    # BC-User erstellen
    foreach ($u in $selUsers) {
        New-NAVServerUser -ServerInstance $ServerInfo.ServerInstance -WindowsAccount $u.UserPrincipalName -FullName $u.Name -LicenseType Full -State Enabled -CreateWebServicesKey 
    }

    # User ermittel und ausw�hlen
    $FromUser = Get-NAVServerUser -ServerInstance $ServerInfo.ServerInstance | Out-GridView -Title 'Quell-User f�r Berechtigungss�tze w�hlen' -OutputMode Single
    $ToUsers = Get-NAVServerUser -ServerInstance $ServerInfo.ServerInstance | Out-GridView -Title 'Ziel-User f�r Berechtigungss�tze w�hlen' -OutputMode Multiple

    # Berechtigungss�tze kopieren
    Copy-guABcServerUserPermissionSet -ServerInstance $ServerInfo.ServerInstance -FromUser $FromUser.UserName -ToUsers ([string[]]($ToUsers).UserName)
    Copy-guABcServerUserPermissionSet -ServerInstance $ServerInfo.ServerInstance -UserSelectionDialog -Verbose
    ([string[]]($ToUsers).UserName) | Copy-guABcServerUserPermissionSet -ServerInstance $ServerInfo.ServerInstance -FromUser $FromUser.UserName 
    @('guatrain\administrator'; 'guatrain\guauser') | Copy-guABcServerUserPermissionSet -ServerInstance $ServerInfo.ServerInstance -FromUser $FromUser.UserName 
}

