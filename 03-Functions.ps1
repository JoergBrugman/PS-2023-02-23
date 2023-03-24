function Invoke-MyFunction {
    [CmdletBinding()]
    param ()
	
    begin {}
	
    process {
        Write-Host 'Invoke-MyFuntion'
    }
	
    end {}
}

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

function Invoke-MyFunctionWithCustObjParam {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(ValueFromPipeline, Mandatory)]
        [object[]]
        $MyUser
    )
    
    begin {
        
    }
    
    process {
        foreach ($o in $MyUser) {
            Write-Host "$($o.Name) - $($o.Vorname) - $($o.Aktiv)"
        }
        
    }
    
    end {
        
    }
}

function Invoke-MyFunctionWithParameterSet {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Names_ParameterSet')]
        [string[]]
        $Name,
        [Parameter(ParameterSetName = 'Selection_ParameterSet')]
        [switch]
        $UserSelectionDialog
    )
    
    begin {
        Write-Host "BEGIN - $Name /  $($Name.Count)"
    }
    
    process {
        switch ($PsCmdlet.ParameterSetName) {
            "Names_ParameterSet" {
                # nichts zu tun
            }
            "Selection_ParameterSet" {
                $Name = (Get-ADUser -Filter * | Out-GridView -Title "User auswählen" -OutputMode Multiple).Name
            }
            # "__AllParameterSets" { 
            # }
        }

        foreach ($n in $Name) {
            Write-Host "PROCESS - $n / $($n.GetType()) / $($n.Count)"
        }
    }
    
    end {
        Write-Host "END - $Name / $($Name.Count)`n`n"
    }
}


# Hier kommen die Funktionsaufrufe
Invoke-MyFunction 

help Invoke-MyFunctionWithParameters -ShowWindow
Invoke-MyFunctionWithParameters -Name @('Hans Huber', 'Karin Schreck')
Invoke-MyFunctionWithParameters 'Hans Huber'
@('Hans Huber', 'Karin Schreck') | Invoke-MyFunctionWithParameters
$users = Get-ADUser -Filter *
Invoke-MyFunctionWithParameters -Name $users.Name
$users | Invoke-MyFunctionWithParameters

$custObj = foreach ($u in $users) {
    [PSCustomObject]@{
        Name    = $u.Name
        Aktiv   = $u.Enabled
        Vorname = $u.Surname
    }
}
$custObj | Invoke-MyFunctionWithParameters
$custObj | Invoke-MyFunctionWithCustObjParam

$adUser = Get-ADUser -Filter *  
Invoke-MyFunctionWithParameterSet -Name $adUser.Name
$adUser | Invoke-MyFunctionWithParameterSet
Invoke-MyFunctionWithParameterSet -UserSelectionDialog
