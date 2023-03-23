function Select-guABcServerInfo {
    [CmdletBinding()]
    param (
        # Eine oder meherere ServerInfo(s) ausw√§hlen
        [Parameter()]
        [ValidateSet("Single","Multiple")]
        $OutputName = 'Single'
    )
    
    begin {
        
    }
    
    process {
        return Get-guABcServerInfo | Out-GridView -Title 'BC ServerInfo ausw‰hlen' -OutputMode $OutputName
    }
    
    end {
        
    }
}

Export-ModuleMember -Function Select-guABcServerInfo