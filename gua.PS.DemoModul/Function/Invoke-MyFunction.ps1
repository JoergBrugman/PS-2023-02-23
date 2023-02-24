function Invoke-MyFunction {
    [CmdletBinding()]
    param ()
	
    begin {}
	
    process {
        Write-Host 'Invoke-MyFuntion'
    }
	
    end {}
}