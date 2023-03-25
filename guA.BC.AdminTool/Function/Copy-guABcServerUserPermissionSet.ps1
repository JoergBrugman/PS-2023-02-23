<#
.SYNOPSIS
    Kopiert die Berechtigungss�tze eines Users zu anderen Usern.
.DESCRIPTION
    Kopiert die Berechtigungss�tze eines Users zu beliebig vielen anderen Usern. Bestehende 
    Berechtigungss�tze bei den Ziel-Usern bleiben dabei unangetastet.
.NOTES
.LINK
.EXAMPLE
    Copy-guABcServerUserPermissionSet -ServerInstance 'BC210' -UserSelectionDialog
    Es wird zun�chst der User ausgew�hlt, dessen Berechtigungss�tze kopiert werden und 
    dann die User, die dieses bekommen.  
.EXAMPLE
    Copy-guABcServerUserPermissionSet -ServerInstance 'BC210'' -FromUser 'MYDOMAIN\ab' -ToUsers 'MYDOMAIN\dh','MYDOMAIN\ah'
    Kopiert die Berechtigungss�tze von User ab und legt diese bei den Usern dh und ah an.
#>
function Copy-guABcServerUserPermissionSet {
    [CmdletBinding()]
    param (
        # Name der Server-Instanz
        [Parameter(Mandatory, Position = 0)]
        [string]
        $ServerInstance,
        # Quell-User, dessen Brerechtigungss�tze kopiert werden sollen
        [Parameter(Mandatory, ParameterSetName = 'Users')]
        [string]
        $FromUser,
        # Ziel-Users, die die Berechtigungs�tze zugewiesen bekommen sollen
        [Parameter(Mandatory, ParameterSetName = 'Users', ValueFromPipeline)]
        [string[]]
        $ToUsers,
        # Der Quell-User und die Ziel-User werden in einem Auswahlfenster ausgew�hlt 
        [Parameter(ParameterSetName = 'Selection')]
        [switch]
        $UserSelectionDialog
    )
    
    begin {
        if ((Get-Command -Module ActiveDirectory) -eq 0) {
            throw "ActiveDirectory module ist nicht verf�gbar. Sie k�nnen dieses mit dem Kommando [Add-WindowsFeature RSAT-AD-PowerShell] installieren."
        }
    
        Import-Module ActiveDirectory
    }
    
    process {
        if ($UserSelectionDialog) {
            # User ermittel und ausw�hlen
            $FromUserSel = Get-NAVServerUser -ServerInstance $ServerInstance | Out-GridView -Title 'Quell-User f�r Berechtigungss�tze w�hlen' -OutputMode Single
            $ToUsersSel = Get-NAVServerUser -ServerInstance $ServerInstance | Out-GridView -Title 'Ziel-User f�r Berechtigungss�tze w�hlen' -OutputMode Multiple 
            $FromUser = ([string]($FromUserSel).UserName)
            $ToUsers = ([string[]]($ToUsersSel).UserName)
        }
        # Permissionsets kopieren
        if ($null -ne $FromUser) {
            $PermSets = Get-NAVServerUserPermissionSet -ServerInstance $ServerInstance -UserName $FromUser
            # $PermSets
            foreach ($User in $ToUsers) { 
                $currUser = ([string](Get-NAVServerUser -ServerInstance $ServerInstance | Where-Object { $_.UserName -eq $User }).FullName)
                foreach ($Set in $PermSets) {
                    # PermissionSet nur kopieren, wenn noch nicht bereits vorhanden 
                    if ($null -eq (Get-NAVServerUserPermissionSet -ServerInstance $ServerInstance -UserName $User -PermissionSetId $Set.PermissionSetID)) {
                        Write-Host "$User ($currUser) Berechtigungssatz $($Set.PermissionSetID) zuweisen"
                        New-NAVServerUserPermissionSet -ServerInstance $ServerInstance -UserName $User -PermissionSetId $Set.PermissionsetID -Scope $Set.Scope -AppName $Set.AppName -CompanyName $Set.CompanyName -Force
                    }
                    else {
                        Write-Host "$User ($currUser) verf�gt bereits �ber den Berechtigungssatz $($Set.PermissionSetID)"
                    }
                }
            }
        }
        
    }
    
    end {
    }
}

Set-Alias -Name Copy-guANavServerUserPermissionSet -Value Copy-guABcServerUserPermissionSet
Export-ModuleMember -Function Copy-guABcServerUserPermissionSet -Alias Copy-guANavServerUserPermissionSet