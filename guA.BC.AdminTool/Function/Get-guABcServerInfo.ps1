function Get-guABcServerInfo {
    [CmdletBinding()]
    param (
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