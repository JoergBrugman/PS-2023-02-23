function New-guABcServerInstance {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0)]
        [String] $ServerInstance,
        # Parameter help description
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ManagementServicesPort,
        # Parameter help description
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $SOAPServicesPort,
        # Parameter help description
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ODATAServicesPort,
        # Parameter help description
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $DeveloperServicesPort,
        # Parameter help description
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $SnapshotDebuggerServicesPort,
        # Parameter help description
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ClientServicesPort,
        # Parameter help description
        [Parameter(Mandatory)]
        [ValidateSet('LocalService', 'LocalSystem', 'NetworkService', 'User')]
        [String] $ServiceAccount,
        # Parameter help description
        [Parameter()]
        [PSCredential] $ServiceAccountCredential,
        # Parameter help description
        [Parameter()]  [ValidateScript({ $_ -ge 0 })]
        [Int] $PortOffset,
        # Parameter help description
        [Parameter()]
        [ValidateSet("Windows", "NavUserPassword")]
        [String] $ClientServicesCredentialType = "Windows"
    )
    
    begin {
        
    }
    
    process {
        if ($PortOffset -gt 0) {
            Write-Verbose "PortOffset $PortOffset wird angewendet"
            $ManagementServicesPort = $ManagementServicesPort + $PortOffset
            $SOAPServicesPort = $SOAPServicesPort + $PortOffset
            $ODATAServicesPort = $ODATAServicesPort + $PortOffset
            $DeveloperServicesPort = $DeveloperServicesPort +$PortOffset
            $SnapshotDebuggerServicesPort = $SnapshotDebuggerServicesPort + $PortOffset
            $ClientServicesPort = $ClientServicesPort + $PortOffset 
        } 
        Write-Verbose "Server Instance $ServerInstance erstellen"
        Write-Host "XXXX: $ClientServicesCredentialType"
        New-NAVServerInstance $ServerInstance `
            -ManagementServicesPort $ManagementServicesPort -SOAPServicesPort $SOAPServicesPort `
            -ODataServicesPort $ODataServicesPort -DeveloperServicesPort $DeveloperServicesPort `
            -SnapshotDebuggerServicesPort $SnapshotDebuggerServicesPort -ClientServicesPort $ClientServicesPort `
            -ClientServicesCredentialType  $ClientServicesCredentialType `
            -ServiceAccount $ServiceAccount -ServiceAccountCredential $ServiceAccountCredential

        Write-Verbose "PublicWebBaseUrl konfigurieren"
        Set-NAVServerConfiguration $ServerInstance -KeyName PublicWebBaseUrl -KeyValue "http://localhost:8080/$ServerInstance"

        Write-Verbose "ServiceTier $ServerInstance starten"
        Start-NAVServerInstance -ServerInstance $ServerInstance

        return Get-guABcServerInfo -ServerInstance $ServerInstance
    }
    
    end {
    }
}

Set-Alias -Name New-guANavServerInstance -Value New-guABcServerInstance
Export-ModuleMember -Function New-guABcServerInstance -Alias New-guANavServerInstance