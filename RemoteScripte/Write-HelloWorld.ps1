Write-Host 'Hello World!' -ForegroundColor Yellow
Write-Host "$(whoami) on IP $((Get-NetIPAddress -InterfaceAlias Ethernet).IPAddress)" -ForegroundColor Yellow