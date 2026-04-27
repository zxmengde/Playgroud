param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$recordPath = Join-Path $Root "docs\validation\v2-acceptance.md"

if (-not (Test-Path -LiteralPath $recordPath)) {
    throw "Missing acceptance record: docs\validation\v2-acceptance.md"
}

$types = @(
    "科研文献",
    "Zotero/PDF",
    "视频资料",
    "Office 文档",
    "代码修改",
    "网页资料",
    "受控自我改进"
)

$headings = @(
    "# 代表性验收记录",
    "## 验证"
)

$content = Get-Content -LiteralPath $recordPath -Raw
$errors = @()

foreach ($heading in $headings) {
    if ($content -notlike "*$heading*") {
        $errors += "Acceptance record missing heading: $heading"
    }
}

foreach ($type in $types) {
    if ($content -notlike "*| $type |*") {
        $errors += "Acceptance record missing type row: $type"
    }
}

if ($errors.Count -gt 0) {
    throw ("Acceptance record errors:`n" + ($errors -join "`n"))
}

Write-Output "Acceptance records check passed."

