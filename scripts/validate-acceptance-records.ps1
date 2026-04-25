param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$base = Join-Path $Root "docs\validation\v2-acceptance"
$index = Join-Path $base "index.md"

if (-not (Test-Path -LiteralPath $index)) {
    throw "Missing acceptance index: docs\validation\v2-acceptance\index.md"
}

$records = @(
    "research-literature",
    "zotero-pdf",
    "video-source",
    "office-document",
    "code-change",
    "web-source"
)

$headings = @(
    "## 输入",
    "## 执行路径",
    "## 产物",
    "## 验证",
    "## 复盘",
    "## 边界"
)

$indexContent = Get-Content -LiteralPath $index -Raw
$errors = @()

foreach ($record in $records) {
    $relative = "docs/validation/v2-acceptance/$record.md"
    $path = Join-Path $base "$record.md"
    if (-not (Test-Path -LiteralPath $path)) {
        $errors += "Missing acceptance record: $relative"
        continue
    }
    if ($indexContent -notlike "*$relative*") {
        $errors += "Acceptance index does not include: $relative"
    }
    $content = Get-Content -LiteralPath $path -Raw
    foreach ($heading in $headings) {
        if ($content -notlike "*$heading*") {
            $errors += "$relative missing heading: $heading"
        }
    }
}

if ($errors.Count -gt 0) {
    throw ("Acceptance record errors:`n" + ($errors -join "`n"))
}

Write-Output "Acceptance records check passed."

