param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$path = Join-Path $Root "docs\validation\system-improvement\external-mechanism-review-sample.md"
if (-not (Test-Path -LiteralPath $path)) {
    throw "external-mechanism-review-check: sample file missing."
}

$content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
foreach ($heading in @(
        "## Question",
        "## Candidate",
        "## Mechanisms",
        "## Evidence",
        "## Minimum Implementation",
        "## Re-evaluation"
    )) {
    if ($content -notlike "*$heading*") {
        throw "external-mechanism-review-check: missing heading $heading."
    }
}

Write-Output "external-mechanism-review-check: pass"
