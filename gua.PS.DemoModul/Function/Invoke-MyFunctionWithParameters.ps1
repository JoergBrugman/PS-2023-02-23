<#
.SYNOPSIS
    Demo von Paramtern
.DESCRIPTION
    Diese Funktion zeigt die Verwendung Parametern und das Verhalten der unterschiedliche 
    Verhalten der Funktion mit direkt übergebenen Paramtern und Parametern, die über 
    eine Pipeline reinkommen 
.NOTES
    
.LINK
    
.EXAMPLE
    Invoke-MyFunctionWitParameters -FullName @('Hans Huber','Karin Schreck')
.EXAMPLE
    @('Hans Huber','Karin Schreck') | Invoke-MyFunctionWitParameters
#>
function Invoke-MyFunctionWithParameters {
    [CmdletBinding()]
    param (
        # Namen, die verarbeitet werden sollen
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [string[]]
        $FullName
    )
    
    begin {
       Write-Host "BEGIN: $FullName" 
    }
    
    process {
        Write-Host "PROCESS: $FullName"
        foreach ($n in $FullName) {
            Write-Host "  - $n"
        }
    }
    
    end {
        Write-Host "END: $FullName" 
        
    }
}

New-Alias -Name imfwp -Value Invoke-MyFunctionWithParameters
Export-ModuleMember -Function Invoke-MyFunctionWithParameters -Alias XYZ