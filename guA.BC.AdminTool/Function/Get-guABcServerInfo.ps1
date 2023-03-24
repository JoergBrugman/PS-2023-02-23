<#
.SYNOPSIS
    Ruft Dienstdetails und die Konfiguration für die angegebene Business Central Server-Instanz ab.
.DESCRIPTION
    Verwenden Sie das Cmdlet Get-guABcServerInfo, um Dienstdetails für die angegebene Business Central Server-Instanz abzurufen.
    
    Wenn keine Business Central Server-Instanz angegeben ist, ruft das Cmdlet Dienstdetails für alle Business Central Server-Instanzen auf dem Servercomputer ab. Die Dienstdetails umfassen den Namen der Instanz (z. B. BusinessCentralServer$BusinessCentral), den Anzeigenamen (z. B. Business Central Server [BusinessCentral]), den Status der Instanz (Wird ausgeführt oder Angehalten), das Dienstkonto (d. h , das Konto, das der Business Central Server für seine Anmeldeinformationen verwendet), die Business Central Server-Version (z. B. 13.0.33571.0) und ob die Instanz die standardmäßige Business Central Server-Instanz ist.
.NOTES
.LINK
.EXAMPLE
    Get-guABcServerInfo MyInstance    
    Dieses Beispiel gibt Statusinformationen und Konfiguration für die MyInstance Business Central Server-Instanz zurück.
#>
function Get-guABcServerInfo {
    [CmdletBinding()]
    param (
        # Gibt den Namen einer Business Central Server-Instanz an, z. B. BusinessCentral oder myinstance. Sie können entweder den vollständigen Namen einer Instanz angeben, z. B. BusinessCentralServer$myinstance, oder den Kurznamen, z. B. myinstance.    
        [Parameter(Position = 0)]
        [string]
        $ServerInstance
    )
    
    begin {
        
    }
    
    process {
        $nsInstances = Get-NAVServerInstance -ServerInstance $ServerInstance
        $nsInfoAll = foreach ($nsi in $nsInstances) { 
            [PSCustomObject]@{
                ServerInstance          = ([string]$nsi.ServerInstance)
                DisplayName             = ([string]$nsi.DisplayName)
                State                   = ([string]$nsi.State )
                ServiceAccount          = ([string]$nsi.ServiceAccount)
                Version                 = ([string]$nsi.Version)
                Default                 = ([string]$nsi.Default)
                NAVServerInstanceObject = $nsi
            }
        }

        foreach ($nsInfo in $nsInfoAll) {
            $nsc = Get-NAVServerConfiguration -ServerInstance $nsInfo.ServerInstance;
            
            $nsInfo | Add-Member -MemberType NoteProperty -Name NavServerConfigurationObject -Value $nsc

            $keysWanted = @(
                'ManagementServicesPort', 'SOAPServicesPort', 'ODataServicesPort', 'DeveloperServicesPort', 'SnapshotDebuggerServicesPort',
                'ClientServicesPort', 'ManagementApiServicesPort', 
                'ClientServicesCredentialType', '*Database', '*Company', '*Language', '*Services*Enabled', '*BaseUrl')
            foreach ($kw in $keysWanted) {
                $props = ($nsc.GetEnumerator() | Where-Object { $_.Key -like $kw })
                if ($null -ne $props) {
                    foreach ($prop in $props) {
                        $nsInfo | Add-Member -MemberType NoteProperty -Name ([string]$prop.Key) -Value ([string]$prop.Value) -ErrorAction SilentlyContinue
                    }
                }
            }
        }

        return $nsInfoAll
        
    }
    
    end {
        
    }
}

Set-Alias -Name Get-guANavServerInfo -Value Get-guABcServerInfo
Export-ModuleMember -Function Get-guABcServerInfo -Alias Get-guANavServerInfo