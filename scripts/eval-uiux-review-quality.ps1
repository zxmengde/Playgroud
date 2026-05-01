param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$path = Join-Path $Root "docs\validation\system-improvement\uiux-review-sample.md"
if (-not (Test-Path -LiteralPath $path)) {
    throw "uiux-review-quality: sample file missing."
}

$content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
foreach ($heading in @(
        "## Scenario",
        "## Checklist",
        "## Evidence",
        "## Findings",
        "## Risks"
    )) {
    if ($content -notlike "*$heading*") {
        throw "uiux-review-quality: missing heading $heading."
    }
}

if ($content -notlike "*Desktop*" -or $content -notlike "*Mobile*") {
    throw "uiux-review-quality: sample must mention both desktop and mobile evidence."
}

foreach ($term in @("Interaction", "Accessibility", "Responsive")) {
    if ($content -notlike "*$term*") {
        throw "uiux-review-quality: sample must mention $term evidence."
    }
}

Write-Output "uiux-review-quality: pass"
