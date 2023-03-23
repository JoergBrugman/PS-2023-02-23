<#
.SYNOPSIS
    PS-Script in VMs ausführen 
.DESCRIPTION
    Die VMs in der Auswahlliste (als Parameter oder Pipe übergeben) werden gestarten
.PARAMETER SelectedVMs
    Array mit den Spalten "VM","Node" und "State", auf denen das PS-Script ausgeführt werden soll
.PARAMETER RemoteScriptName 
    Pfad des auszuführenden PS-Script 
.NOTES
    Kann für Schulungsraum- und Cluster-Images verwendet werden!
.EXAMPLE
    $selectedVMs = Select-guAClusterVMs
    Execute-RemoteScriptInVMs -SelectedVMs $selectedVMs -RemoteScriptName '.\bsp.ps1'
#>
function Invoke-guARemoteScriptOnComputers {
    [CmdletBinding()]
    param(
        [parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]] $Computername,
        [parameter(Mandatory)]
        [string] $RemoteScriptName,
        # Parameter help description
        [Parameter()]
        [pscredential] $Credential
    )
    begin {
        Write-Host ('RemoteSkript "' + (Split-Path $scriptName -Leaf) + '" auf Computern ausführen...')
    }
    process {
        # ScriptBlock für die Computer-Remote-Session mit dem Installations-Skript vorbereiten
        $scriptForComputer = (Get-Command $RemoteScriptName | Select-Object -ExpandProperty ScriptBlock).ToString()  

        # Hosts durchlaufen und einen Remote-Session auf den dort laufenden VMs eröffnen
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