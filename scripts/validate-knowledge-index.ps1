param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$mainIndex = Join-Path $Root "docs\knowledge\index.md"
if (-not (Test-Path -LiteralPath $mainIndex)) {
    throw "Missing knowledge index: $mainIndex"
}

$requiredIndexes = @(
    "docs\knowledge\research\index.md",
    "docs\knowledge\project\index.md",
    "docs\knowledge\web-source\index.md",
    "docs\knowledge\system-improvement\index.md"
)

$missingIndexes = @()
foreach ($rel in $requiredIndexes) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $rel))) {
        $missingIndexes += $rel
    }
}
if ($missingIndexes.Count -gt 0) {
    throw ("Missing knowledge category indexes: " + ($missingIndexes -join ", "))
}

$combined = Get-Content -LiteralPath $mainIndex -Raw
foreach ($rel in $requiredIndexes) {
    $combined += "`n" + (Get-Content -LiteralPath (Join-Path $Root $rel) -Raw)
}

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

Write-Output "Knowledge index check passed."

