<#
.SYNOPSIS
    Pfad und Name der NavAdminTool.ps1 ermitteln
.DESCRIPTION
    Pfad und Name der NavAdminTool.ps1 ermitteln
.NOTES
.LINK
.EXAMPLE
    . (Get-guANavAdminTool).FullName
    Es wird die Datei NavAdminTool.ps1 ermittelt und dann geladen.
#>
function Get-guANavAdminTool {
    [CmdletBinding()]
    param ( )
    
    begin {
    }
    
    process {
        $adminTool = @()
        foreach ($p in (Get-ChildItem -path ENV: | Where-Object { $_.Name -like 'ProgramFiles*' }).Value) {
            if ($adminTool.Count -eq 0) {
                $adminTool += foreach ($fi in `
                    (Get-ChildItem -Path ($p) -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'NavAdminTool.ps1' })) {
                    [PSCustomObject]@{
                        Name     = $fi.Name
                        FullName = $fi.FullName
                    }
                }
            }
        }
        
    }
    
    end {
        return $adminTool
    }
}

Export-ModuleMember -Function Get-guANavAdminTool