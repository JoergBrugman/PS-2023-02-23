# Liste der Subfolder mit zu ladenden Funktionen
$functFolder = @('Function', 'Helper')

# Unterverzeichnisse nacheinander durchgehen 
foreach ($f in $functFolder) {
    # Kompletten Subfolder Path erstellen 
    $functPath = Join-Path -Path $PSScriptRoot -ChildPath $f
    # Liste mit allen Funktionsskriptnamen erstellen
    $functList = Get-ChildItem -Path $functPath -Name -ErrorAction SilentlyContinue
    # Alle Funktionsskripte mit dot sourcing laden
    foreach ($funct in $functList) {
        . (Join-Path -Path $functPath -ChildPath $funct)
    } 
}
