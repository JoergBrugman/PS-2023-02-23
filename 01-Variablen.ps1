# Variable deklarieren und zuweisen
$path = 'C:\Temp'

# Variablen sind Objekte mit Methods und Properties (.net)
Get-Member -InputObject $path # Methods und Prperties anzeigen
$path.GetType() # Methode
$path.Length # Property

# ------------------------------------------------
# AUFGABE: Verzeichnisse und Dateien anlegen 
# ------------------------------------------------
# Basis-Verzeichnis anlegen und in Variable merken
$baseItem = New-Item -Path $path -Name 'TestData' -ItemType Directory -Force
$baseItem.FullName
# Verzeichnis1 mit Dateien anlegen
$newItem = New-Item -Path $baseItem.FullName -Name 'Verzeichnis1' -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei1-1.txt' -ItemType File -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei1-2.txt' -ItemType File -ErrorAction SilentlyContinue
# Verzeichnis2 mit Dateien anlegen
$newItem = New-Item -Path $baseItem.FullName -Name 'Verzeichnis2' -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei2-1.txt' -ItemType File -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei2-2.txt' -ItemType File -ErrorAction SilentlyContinue
# Verzeichnis3 mit Dateien anlegen
$newItem = New-Item -Path $baseItem.FullName -Name 'Verzeichnis3' -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei3-1.txt' -ItemType File -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei3-2.txt' -ItemType File -ErrorAction SilentlyContinue

# Alles in diesem Verzeichnis emitteln
Get-ChildItem -Path $path -Recurse -Depth 0
Get-ChildItem -Path $path 
Get-ChildItem -Path $path -Recurse -Depth 2
# und jetzt in einer Variablen ablegen
$items = Get-ChildItem -Path $path -Recurse
$items.GetType()
(Get-ChildItem -Path $baseItem).GetType() # oder auch so...
# Anzahl ermitteln
$items.Count
# Enumeration der Items erstellen lassen
$items.GetEnumerator()
