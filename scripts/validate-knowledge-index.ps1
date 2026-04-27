param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$mainIndex = Join-Path $Root "docs\knowledge\index.md"
if (-not (Test-Path -LiteralPath $mainIndex)) {
    throw "Missing knowledge index: $mainIndex"
}

$combined = Get-Content -LiteralPath $mainIndex -Raw

$itemRoot = Join-Path $Root "docs\knowledge\items"
$items = Get-ChildItem -Path $itemRoot -Filter "*.md" -File -ErrorAction SilentlyContinue
$missingItems = @()
foreach ($item in $items) {
    $rel = ("docs/knowledge/items/" + $item.Name)
    if ($combined -notlike "*$rel*") {
        $missingItems += $rel
    }
}

if ($missingItems.Count -gt 0) {
    throw ("Knowledge items missing from indexes: " + ($missingItems -join ", "))
}

$missingReferencedPaths = @()
foreach ($match in [regex]::Matches($combined, '`(docs[\/\\][^`]+|templates[\/\\][^`]+|scripts[\/\\][^`]+)`')) {
    $candidate = $match.Groups[1].Value.Trim()
    if ($candidate -match '^docs[\/\\]knowledge[\/\\]items[\/\\]YYYY') { continue }
    $fsPath = Join-Path $Root ($candidate -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $fsPath)) {
        $missingReferencedPaths += $candidate
    }
}

if ($missingReferencedPaths.Count -gt 0) {
    throw ("Knowledge indexes reference missing paths: " + (($missingReferencedPaths | Select-Object -Unique) -join ", "))
}

Write-Output "Knowledge index check passed."

