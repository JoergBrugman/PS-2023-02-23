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
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ManagementApiServicesPort,
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
        $ReturnValue = $null
        
    }
    
    process {
        # Eine Funktion gibt alles zurück, was nicht von etwas anderem erfasst wird. 
        # Da wir am Ende nur die neue BcServerInfo zurückgeben möchten, müssen alle anderen "Ausgaben", 
        # z.B. von New-NavServerInstance abgefangen werden. Daswird dadurch erreicht, dass der gesamte Skriptblock
        # in folgenden Konstrukt eingepackt wird: 
        # . { Alle Anweisungen, der Ausgaben unterdrückt werden sollen } | Out-Null 
        . {
            if ($PortOffset -gt 0) {
                Write-Verbose "PortOffset $PortOffset wird angewendet"
                $ManagementServicesPort += $PortOffset
                $SOAPServicesPort += $PortOffset
                $ODATAServicesPort += $PortOffset
                $DeveloperServicesPort += $PortOffset
                $SnapshotDebuggerServicesPort += $PortOffset
                $ClientServicesPort += $PortOffset
                $ManagementApiServicesPort += $PortOffset 
            } 
            Write-Verbose "Server Instance $ServerInstance erstellen"
            New-NAVServerInstance $ServerInstance `
                -ManagementServicesPort $ManagementServicesPort -SOAPServicesPort $SOAPServicesPort `
                -ODataServicesPort $ODataServicesPort -DeveloperServicesPort $DeveloperServicesPort `
                -SnapshotDebuggerServicesPort $SnapshotDebuggerServicesPort -ClientServicesPort $ClientServicesPort `
                -ClientServicesCredentialType  $ClientServicesCredentialType `
                -ServiceAccount $ServiceAccount -ServiceAccountCredential $ServiceAccountCredential

            Write-Verbose "ManagementApiServicesPort konfigurieren"
            Set-NAVServerConfiguration $ServerInstance -KeyName ManagementApiServicesPort -KeyValue $ManagementApiServicesPort
            Write-Verbose "PublicWebBaseUrl konfigurieren"
            Set-NAVServerConfiguration $ServerInstance -KeyName PublicWebBaseUrl -KeyValue "http://localhost:8080/$ServerInstance"

            Write-Verbose "ServiceTier $ServerInstance starten"
            Start-NAVServerInstance -ServerInstance $ServerInstance
        } | Out-Null
    }
    
    end {
        return Get-guABcServerInfo -ServerInstance $ServerInstance
    }
}

Set-Alias -Name New-guANavServerInstance -Value New-guABcServerInstance
Export-ModuleMember -Function New-guABcServerInstance -Alias New-guANavServerInstance