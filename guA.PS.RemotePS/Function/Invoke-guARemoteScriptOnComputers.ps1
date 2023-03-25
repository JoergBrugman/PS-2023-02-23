<#
.SYNOPSIS
    PS-Script auf Remote-Computern ausf�hren 
.DESCRIPTION
    PS-Script auf Remote-Computern ausf�hren
.NOTES
.EXAMPLE
    Invoke-guARemoteScriptOnComputers -Computername 10.11.1.177,10.11.1.178 -RemoteScriptName '.\bsp.ps1'
    Auf den Computern mit der IP 10.11.1.177 und 10.11.1.178 wird das PS-Skript bsp.ps1 remote ausgef�hrt.
#>
function Invoke-guARemoteScriptOnComputers {
    [CmdletBinding()]
    param(
        # Computernamen oder IPs
        [parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]] $Computername,
        # Pfad des auszuf�hrenden PS-Script 
        [parameter(Mandatory)]
        [string] $RemoteScriptName,
        # Credentials f�r die Auf�hrung (optional)
        [Parameter()]
        [pscredential] $Credential
    )
    begin {
        Write-Host ('RemoteSkript "' + (Split-Path $scriptName -Leaf) + '" auf Computern ausf�hren...')
    }
    process {
        # ScriptBlock f�r die Computer-Remote-Session mit dem Installations-Skript vorbereiten
        $scriptForComputer = (Get-Command $RemoteScriptName | Select-Object -ExpandProperty ScriptBlock).ToString()  

        # Hosts durchlaufen und einen Remote-Session auf den dort laufenden VMs er�ffnen
        foreach ($c in $Computername) {
            if ($null -eq $Credential) {
                Write-Host "NegotiateWithImplicitCredential"
                Invoke-Command -ComputerName $c -ScriptBlock ([Scriptblock]::Create($scriptForComputer))  -Authentication NegotiateWithImplicitCredential
            }
            else {
                Write-Host "Negotiate"
                Invoke-Command -ComputerName $c -ScriptBlock ([Scriptblock]::Create($scriptForComputer)) -Credential $Credential -Authentication Negotiate
            }
        }
    }
}