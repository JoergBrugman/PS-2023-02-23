#Get-Date
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
#Get-Date
. $adminTool.FullName | Out-Null
Get-NAVServerInstance 