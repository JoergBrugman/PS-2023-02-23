<#
.SYNOPSIS
    Demo für eine Funktion mit Parametern
.DESCRIPTION
    Diese Funktion zeigt die Verwendung verschiedener Argumente für das 
    Parameter-Attribut [Parameter(Argumnet1, Argument2, ...)] 
    Behandelte Argumente:
        - Position = 0
        - Mandatory
        - ValueFromPipelineByPropertyName
.NOTES
.EXAMPLE
    Invoke-MyFunctionWithParameters -Name " Hans Huber"
.EXAMPLE
    Invoke-MyFunctionWithParameters @('Hans Huber', 'Peter Müller')
.EXAMPLE
    @('Hans Huber', 'Peter MÃ¼ller') | Invoke-MyFunctionWithParameters 
.EXAMPLE
    $adUser = Get-ADUser -Filter *; Invoke-MyFunctionWithParameters -Name $adUser.Name
.EXAMPLE
    Get-ADUser -Filter * | Invoke-MyFunctionWithParameters
#>
function Invoke-MyFunctionWithParameters {
    [CmdletBinding()]
    param (
        # Parameterbeschreibungen sollten immer als Kommentar direkt vor der Parameterdefinition erfolgen.
        # So lässt sich Code und Doku besser zusammenhalten!
        # Namen für die Funktion 
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string[]]
        $Name
    )
    
    begin {
        Write-Host "BEGIN: $Name / $($Name.Count)" 
    }
    
    process {
        Write-Host "PROCESS: $Name / $($Name.Count)"
        foreach ($n in $Name) {
            Write-Host "  - $n"
        }
    }
    
    end {
        Write-Host "END: $Name / $($Name.Count)" 
        
    }
}


New-Alias -Name imfwp -Value Invoke-MyFunctionWithParameters
Export-ModuleMember -Function Invoke-MyFunctionWithParameters -Alias imfwp