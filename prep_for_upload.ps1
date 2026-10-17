$ErrorActionPreference = "Stop"

$srcMods = Join-Path $PSScriptRoot "mods"
$srcWorkshop = Join-Path $PSScriptRoot "workshop.txt"
$srcPreview = Join-Path $PSScriptRoot "preview.png"
$workshop = Join-Path $env:USERPROFILE "Zomboid_B41\Workshop\A_Deadline-Internal-Modpack_Ch3"
$contents = Join-Path $workshop "Contents"
$dstMods = Join-Path $contents "mods"

if (-not (Test-Path -LiteralPath $srcMods)) { throw "Missing source folder: $srcMods" }
if (-not (Test-Path -LiteralPath $srcWorkshop)) { throw "Missing file: $srcWorkshop" }
if (-not (Test-Path -LiteralPath $srcPreview)) { throw "Missing file: $srcPreview" }

Remove-Item -LiteralPath $dstMods -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $dstMods | Out-Null
Copy-Item -Path (Join-Path $srcMods "*") -Destination $dstMods -Recurse -Force
Copy-Item -LiteralPath $srcWorkshop -Destination $workshop -Force
Copy-Item -LiteralPath $srcPreview -Destination $workshop -Force

Write-Host "Prepared upload workshop folder at $workshop"
