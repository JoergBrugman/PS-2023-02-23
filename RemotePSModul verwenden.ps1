Set-Location -LiteralPath $PSScriptRoot
Import-Module $PSScriptRoot\guA.PS.RemotePS\guA.PS.RemotePS.psm1 -force -Verbose
$PSScriptRoot

#region **** F¸r die Demo Infos zu unseren Schulungs-VMs ermitteln...
$computers = @()
for ($i = 176; $i -le 182; $i++) {
    $computers += [PSCustomObject]@{
        Computer = "10.11.1.$($i)"
        Running  = (Test-Connection -ComputerName "10.11.1.$($i)" -Quiet -Count 1)
    }
}
#endregion

#region *** Computer und Skript ausw‰hlen
$selComputers = $computers | Out-GridView -Title 'Computer f¸r die Ausf¸hrung eines Scriptes ausw‰hlen' -OutputMode Multiple
$scriptName = Get-ChildItem -Path $PSScriptRoot\RemoteScripte -File | Select-Object Name | Out-GridView -Title 'RemotScript fùr die Ausfùhrung auf den Computern auswùhlen' -OutputMode Single 
if ($null -ne $scriptName) {
    $scriptName = (Get-ChildItem -Path $PSScriptRoot\RemoteScripte -File | Where-Object { $_.Name -like $scriptName.Name }).FullName
}
#endregion

$ret =Invoke-guARemoteScriptOnComputers -Computername $selComputers.Computer -RemoteScriptName $scriptName

#region *** Credentials vorbereiten
$username = "ah@guatrain.local"
$password = convertto-securestring "EiWoha7T@" -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential `
    -argumentlist $username, $password
#endregion
Invoke-guARemoteScriptOnComputers -Computername $selComputers.Computer `
    -RemoteScriptName $scriptName -Credential $cred

# Invoke-Command -ComputerName 10.11.1.190 -Authentication Negotiate -ScriptBlock {whoami} 
