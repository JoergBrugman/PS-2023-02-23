#region *** Funktion zur Aktvierung von CredSSP - nur selten notwendig 
function Enable-guAWSManCredSSP {
    # Ohne WinRM-Dienst geht es nicht
    Set-Service WinRM -StartupType Automatic
    Start-Service WinRM
    
    Enable-WSManCredSSP -Role client -DelegateComputer @("*.$([System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain())", "10.11.1.*")
  
    $allowed = @("WSMAN/*.$([System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain())", "WSMAN/10.11.1.*") 
          
    $key = 'hklm:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation' 
    if (!(Test-Path $key)) { 
        mkdir $key 
    } 
    New-ItemProperty -Path $key -Name AllowFreshCredentials -Value 1 -PropertyType Dword -Force             
          
    $key = Join-Path $key 'AllowFreshCredentials' 
    if (!(Test-Path $key)) { 
        mkdir $key 
    } 
    $i = 1 
    $allowed | ForEach-Object { 
        # Script does not take into account existing entries in this key 
        New-ItemProperty -Path $key -Name $i -Value $_ -PropertyType String -Force 
        $i++ 
    } 
}
#endregion

#region **** WinRM-Dienst konfigurieren
Stop-Service WinRM
Set-Service WinRM -StartupType Automatic
#WinRM set winrm/config/client '@{TrustedHosts ="10.11.1.0"}'
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.11.1.*" # oder alternativ auch so... 
Restart-Service WinRM
#endregion

#region *** Credentials vorbereiten
$username = "ah@guatrain.local"
$password = convertto-securestring "EiWoha7T@" -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential `
    -argumentlist $username, $password
#endregion

#region **** Für die Demo Infos zu unseren Schulungs-VMs ermitteln...
Get-Date
$computers = @()
for ($i = 176; $i -le 182; $i++) {
    $computers += [PSCustomObject]@{
        Computer = "10.11.1.$($i)"
        Running  = (Test-Connection -ComputerName "10.11.1.$($i)" -Quiet -Count 1)
    }
}
Get-Date
#endregion

#region *** Jetzt einen ScriptBlock vorbereiten und diesen per Remote-PS auf den ermittelten Rechnern ausführen...
$sb = { param($p1) Write-Host "Auf Rechner $p1 : $(whoami.exe)" }
foreach ($c in $computers) {
    Invoke-Command -ComputerName $c.Computer -ScriptBlock $sb -ArgumentList ($c.Computer) -Credential $cred -Authentication Negotiate
}

foreach ($c in $computers) {
    Invoke-Command -ComputerName $c.Computer -ScriptBlock $sb -ArgumentList ($c.Computer)  -Authentication NegotiateWithImplicitCredential
}

#endregion


