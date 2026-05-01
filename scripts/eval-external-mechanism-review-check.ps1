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
        "## Candidates",
        "## Mechanisms",
        "## Source Evidence",
        "## Fit Decision",
        "## Minimum Implementation",
        "## Risks",
        "## Re-evaluation"
    )) {
    if ($content -notlike "*$heading*") {
        throw "external-mechanism-review-check: missing heading $heading."
    }
}

if ($content -match "假定|assume|assumed") {
    throw "external-mechanism-review-check: evidence cannot be hypothetical."
}

if ($content -notmatch "commit" -or $content -notmatch "path" -or $content -notmatch "line") {
    throw "external-mechanism-review-check: source evidence must include commit, path, and line references."
}

Write-Output "external-mechanism-review-check: pass"
