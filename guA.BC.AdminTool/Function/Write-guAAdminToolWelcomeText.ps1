<#
.SYNOPSIS
Funktionsübersicht des Moduls guA.BC.AdminTool
.DESCRIPTION
Funktionsübersicht und -beschreibung des Moduls guA.BC.AdminTool
.EXAMPLE
Write-guAAdminToolWelcomeText
.NOTES
#>
function Write-guAAdminToolWelcomeText {
    [CmdletBinding()]
    param ( )
    
    begin {
    }
    
    process {
        # Funktionen des Moduls ermitteln und Funktionsname und Kurzbeschreibung merken
        $info = foreach ($cmd in get-command -module guA.BC.AdminTool -CommandType Function) {
            [PSCustomObject]@{
                Function = [string](get-help $cmd).Name
                Synopsis = [string](get-help $cmd).Synopsis 
            }
        }
        # Max. Länge des Namens feststellen 
        $maxlen = 0
        foreach ($i in $info) {
            if ($maxLen -le $i.Function.Length) {
                $maxLen = $i.Function.Length
            }
        }
        
        #Clear-Host
        Write-Host -ForegroundColor Yellow "get&use Academy BC AdminTool"
        write-Host "Dieses Modul setzt das Modul das Microsoft BC Admin Tool voraus "
        write-Host "und erweitert dieses für Schulungszwecke der get&use Academy GmbH."
        Write-Host
        # Jetzt alle Funktionsnamen und Kurzbeschreibungen ausgeben
        foreach ($i in $info) {
            Write-Host "$($i.Function.PadRight($maxLen)) `t $(($i.Synopsis.Trim()))"
        }
        Write-Host
        Write-Host -ForegroundColor White "Copyright get&use Academy GmbH, $(Get-Date -Format 'yyyy')"
        Write-Host -ForegroundColor White "Diese Skripte sind ausschließlich zur Nutzung auf den von der get&use Academy GmbH" 
        Write-Host -ForegroundColor White "bereitgestellten Schulungsumgebungen zu Schulungszwecken vorgesehen." 
        Write-Host -ForegroundColor White "Für jegliche anderweitige Nutzung wird jegliche Haftung ausdrücklich ausgeschlossen!"
        Write-Host
    }
    
    end {
        
    }
}

Export-ModuleMember -Function Write-guAAdminToolWelcomeText
