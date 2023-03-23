$path = 'C:\Temp'
$baseItem = New-Item -Path $path -Name 'TestData-Remote' -ItemType Directory -Force

$newItem = New-Item -Path $baseItem.FullName -Name 'Verzeichnis1' -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei1-1.txt' -ItemType File -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei1-2.txt' -ItemType File -ErrorAction SilentlyContinue

$newItem = New-Item -Path $baseItem.FullName -Name 'Verzeichnis2' -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei2-1.txt' -ItemType File -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei2-2.txt' -ItemType File -ErrorAction SilentlyContinue

$newItem = New-Item -Path $baseItem.FullName -Name 'Verzeichnis3' -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei3-1.txt' -ItemType File -ErrorAction SilentlyContinue
New-Item -Path $newItem.FullName -Name 'Datei3-2.txt' -ItemType File -ErrorAction SilentlyContinue

$items = Get-ChildItem -Path $path -Recurse