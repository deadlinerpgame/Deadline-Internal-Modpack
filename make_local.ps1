$ErrorActionPreference = "Stop"

$src = Join-Path $PSScriptRoot "mods"
$workshop = "C:\Users\Milo\Zomboid_B41\Workshop\A_Deadline-Internal-Modpack_Ch3"
$contents = Join-Path $workshop "Contents"
$dst = Join-Path $contents "mods"
$srcWorkshop = Join-Path $PSScriptRoot "workshop.txt"
$srcPreview = Join-Path $PSScriptRoot "preview.png"

if (-not (Test-Path -LiteralPath $src)) { throw "Missing source folder: $src" }

$sourceModInfos = @(Get-ChildItem -LiteralPath $src -Recurse -Filter "mod.info")
if ($sourceModInfos.Count -eq 0) { throw "No mod.info files found under: $src" }
foreach ($info in $sourceModInfos) {
    $lines = Get-Content -LiteralPath $info.FullName
    if (-not ($lines | Where-Object { $_ -match '^\s*id\s*=\s*\S+' })) {
        throw "Missing id= in $($info.FullName)"
    }
    if (-not ($lines | Where-Object { $_ -match '^\s*name\s*=\s*\S+' })) {
        throw "Missing name= in $($info.FullName)"
    }
}

Remove-Item -LiteralPath $dst -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item -Path (Join-Path $src "*") -Destination $dst -Recurse -Force

if (Test-Path -LiteralPath $srcWorkshop) {
    Copy-Item -LiteralPath $srcWorkshop -Destination $workshop -Force
}
if (Test-Path -LiteralPath $srcPreview) {
    Copy-Item -LiteralPath $srcPreview -Destination $workshop -Force
}

Get-ChildItem -LiteralPath $dst -Recurse -Filter "mod.info" | ForEach-Object {
    $lines = Get-Content -LiteralPath $_.FullName
    $lines = $lines | ForEach-Object {
        if ($_ -match '^(\s*id\s*=\s*)DL3_(\S+)\s*$') {
            return "$($Matches[1])dev_DL3_$($Matches[2])"
        }
        if ($_ -match '^(\s*name\s*=\s*)(.*)$') {
            return "$($Matches[1])$($Matches[2] -replace 'Deadline', 'Deadline_local')"
        }
        return $_
    }
    [IO.File]::WriteAllText($_.FullName, ($lines -join [Environment]::NewLine), [Text.UTF8Encoding]::new($false))
}

$localModInfos = @(Get-ChildItem -LiteralPath $dst -Recurse -Filter "mod.info")
foreach ($info in $localModInfos) {
    $lines = Get-Content -LiteralPath $info.FullName
    if (-not ($lines | Where-Object { $_ -match '^\s*id\s*=\s*dev_DL3_\S+' -or $_ -match '^\s*id\s*=\s*(Buildwork|ClothesUpgrade|DL_Server)' })) {
        throw "Unexpected local id= in $($info.FullName)"
    }
    if (-not ($lines | Where-Object { $_ -match '^\s*name\s*=\s*\S+' })) {
        throw "Missing local name= in $($info.FullName)"
    }
}

Write-Host "Deployed local workshop mods to $dst"
