function Invoke-MyFunction {
    [CmdletBinding()]
    param ()
	
    begin {}
	
    process {
        Write-Host 'Invoke-MyFuntion'
    }
	
    end {}
}

function Invoke-MyFunctionWitParameters {
    [CmdletBinding()]
    param (
        # Parameter help description
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

function Invoke-MyFunctionWithCustObjParam {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(ValueFromPipeline,Mandatory)]
        [object[]]
        $MyUser
    )
    
    begin {
        
    }
    
    process {
        foreach ($o in $MyUser) {
            Write-Host "$($o.FullName) - $($o.Vorname) - $($o.Active)"
        }
        
    }
    
    end {
        
    }
}

# Hier kommen die Funktionsaufrufe
Invoke-MyFunction 

Invoke-MyFunctionWitParameters -Name @('Hans Huber','Karin Schreck')
Invoke-MyFunctionWitParameters 'Hans Huber'
@('Hans Huber','Karin Schreck') | Invoke-MyFunctionWitParameters

$users = Get-ADUser -Filter *
Invoke-MyFunctionWitParameters -Name $users.Name
$users | Invoke-MyFunctionWitParameters # FEHLER

$custObj = foreach($u in $users) {
    [PSCustomObject]@{
        FullName = $u.Name
        Active = $u.Enabled
        Vorname = $u.Surname
    }
}
$custObj | Invoke-MyFunctionWitParameters
$custObj | Invoke-MyFunctionWithCustObjParam
