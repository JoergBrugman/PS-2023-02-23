Import-Module C:\Users\guauser\Documents\PS\gua.PS.DemoModul\guA.PS.DemoModul.psm1 -Verbose -Force

Invoke-MyFunctionWithParameters -FullName @('Hans Huber','Karin Schreck')
Invoke-MyFunctionWithParameters 'Hans Huber'
@('Hans Huber','Karin Schreck') | Invoke-MyFunctionWithParameters

$users = Get-ADUser -Filter *
Invoke-MyFunctionWithParameters -FullName $users.Name

$custObj = foreach($u in $users) {
    [PSCustomObject]@{
        FullName = $u.Name
        Active = $u.Enabled
        Nachname = $u.Surname
    }
}
Invoke-MyFunctionWithParameters -FullName $custObj.FullName
$custObj | Invoke-MyFunctionWithParameters

