param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"

$path = Join-Path $Root "docs\validation\system-improvement\product-engineering-sample.md"
if (-not (Test-Path -LiteralPath $path)) {
    throw "product-engineering-closeout: sample file missing."
}

$content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
foreach ($heading in @(
        "## Goal",
        "## Users",
        "## Constraints",
        "## Success Criteria",
        "## PRD Summary",
        "## Implementation Plan",
        "## Verification",
        "## Release Risk",
        "## Rollback",
        "## Stop Condition"
    )) {
    if ($content -notlike "*$heading*") {
        throw "product-engineering-closeout: missing heading $heading."
    }
}

Write-Output "product-engineering-closeout: pass"
