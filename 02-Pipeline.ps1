# Variable deklarieren und zuweisen
$basePath = 'C:\Temp\TestData'

# Alles in diesem Verzeichnis und den Unterverzeichnissen ermitteln
Get-ChildItem -Path $basePath -Recurse 
# Welche Methods und Properties haben die Items?
Get-ChildItem -Path $basePath -Recurse | Get-Member 
# jetzt nur die Properties 
Get-ChildItem -Path $basePath -Recurse | Get-Member -MemberType Properties

# mit Sortierung 
Get-ChildItem -Path $basePath -Recurse | Sort-Object -Property BaseName

# mit Ausgabeformatierung
Get-ChildItem -Path $basePath -Recurse | `
    Sort-Object -Property BaseName | `
    Format-Table -Property BaseName, Extension, PSParentPath, DirectoryName

# TIPP: Wenn eine interaktive Auswahl benötigt wird    
$sel = Get-ChildItem -Path $basePath -Recurse | `
    Sort-Object -Property BaseName | `
    Out-GridView -Title 'Elemente-Liste' -OutputMode Multiple

# Mit Filterung 
#   - ausgewählte Dateien mit Inhalt versorgen...
(Get-ChildItem -Path $basePath -File -Recurse | `
    Out-GridView -Title 'Elemente-auswählen' -OutputMode Multiple) | `
    ForEach-Object { $_.FullName; Add-Content -Path $_.FullName -Value 'Das ist der neue Text' }
#   - Property filtern
Get-ChildItem -Path $basePath -File -Recurse | Where-Object -Property Length -GT 0 | `
    Select-Object -Property Name, DirectoryName, Length | Out-GridView
#   - Filterscript für komplexe Filter, die mit Property nicht merh zu machen sind
Get-ChildItem -Path $basePath -File -Recurse | `
    Where-Object -FilterScript { ($_.Length -gt 0) -and ($_.DirectoryName -like '*2') } | `
    Select-Object -Property Name, DirectoryName, Length | Out-GridView
