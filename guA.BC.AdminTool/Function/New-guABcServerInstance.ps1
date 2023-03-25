<#
.SYNOPSIS
    Erstellt eine neue BC Server Instance (ServiceTier)
.DESCRIPTION
    Erstellt eine neue BC Server Instance (ServiceTier). Die angegebenen Ports können mit einem Offset vor der Erstellung modifiziert werden.
    Nach der Erstellung wird die neue Server Instance gestartet.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    $newBCServerInfo = Select-guABcServerInfo | New-guABCServerInstance 'BC' -PortOffset 100 -ServiceAccount User -ServiceAccountCredential $Cred -Verbose
    Nach der Auswahl einer Server Instance wird auf deren Basis eine neue Server Instance erzeugt. Deren ServerInfo wird in der Variablen $newBCServerInfo gespeichert.
#>
function New-guABcServerInstance {
    [CmdletBinding()]
    param (
        # ServerInstance
        [Parameter(Mandatory, Position = 0)]
        [String] $ServerInstance,
        # ManagementServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ManagementServicesPort,
        # SOAPServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $SOAPServicesPort,
        # ODATAServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ODATAServicesPort,
        # DeveloperServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $DeveloperServicesPort,
        # SnapshotDebuggerServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $SnapshotDebuggerServicesPort,
        # ClientServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ClientServicesPort,
        # ManagementApiServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ManagementApiServicesPort,
        # ServiceAccount ('LocalService', 'LocalSystem', 'NetworkService', 'User')
        [Parameter(Mandatory)]
        [ValidateSet('LocalService', 'LocalSystem', 'NetworkService', 'User')]
        [String] $ServiceAccount,
        # ServiceAccountCredential
        [Parameter()]
        [PSCredential] $ServiceAccountCredential,
        # PortOffset
        [Parameter()]  [ValidateScript({ $_ -ge 0 })]
        [Int] $PortOffset,
        # ClientServicesCredentialType ("Windows", "NavUserPassword")
        [Parameter()]
        [ValidateSet("Windows", "NavUserPassword")]
        [String] $ClientServicesCredentialType = "Windows"
    )
    
    begin {
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