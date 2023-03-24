Import-Module C:\Users\guauser\Documents\PS\gua.PS.DemoModul\guA.PS.DemoModul.psm1 -Verbose -Force

Invoke-MyFunctionWithParameters -Name @('Hans Huber','Karin Schreck')
Invoke-MyFunctionWithParameters 'Hans Huber'
@('Hans Huber','Karin Schreck') | Invoke-MyFunctionWithParameters

$users = Get-ADUser -Filter *
Invoke-MyFunctionWithParameters -Name $users.Name

$custObj = foreach($u in $users) {
    [PSCustomObject]@{
        Name = $u.Name
        Aktiv = $u.Enabled
        Nachname = $u.Surname
    }
}
Invoke-MyFunctionWithParameters -Name $custObj.Name
$custObj | Invoke-MyFunctionWithParameters

