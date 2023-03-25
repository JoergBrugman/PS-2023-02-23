<#
.SYNOPSIS
    Auswahl einer Business Central Server-Instanz mit anschließender Rückgabe der Dienstdetails und Konfiguration.
.DESCRIPTION
    Auswahl einer Business Central Server-Instanz mit anschließender Rückgabe der Dienstdetails und Konfiguration.
.NOTES
.LINK
.EXAMPLE
    $ServerInfo = Select-guABcServerInfo
    Auswahl einer einzelnen Server-Instanz. Die ServerInfo wird in der Variablen $ServerInfo gespeichert.
#>
function Select-guABcServerInfo {
    [CmdletBinding()]
    param (
        # OutputMode ("Single","Multiple")
        [Parameter()]
        [ValidateSet("Single","Multiple")]
        $OutputMode = 'Single'
    )
    
    begin {
    }
    
    process {
        return Get-guABcServerInfo | Out-GridView -Title 'BC ServerInfo auswählen' -OutputMode $OutputName
    }
    
    end {
    }
}

Set-Alias -Name Select-guANavServerInfo -Value Select-guABcServerInfo
Export-ModuleMember -Function Select-guABcServerInfo -Alias Select-guABcServerInfo