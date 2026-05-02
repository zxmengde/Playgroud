param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"

$path = Join-Path $Root "docs\validation\system-improvement\research-memo-sample.md"
if (-not (Test-Path -LiteralPath $path)) {
    throw "research-memo-quality: sample file missing."
}

$content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
foreach ($heading in @(
        "## Question",
        "## Why This Matters",
        "## Sources",
        "## Facts",
        "## Inferences",
        "## Uncertainty",
        "## Experiment / Verification Plan",
        "## Decision",
        "## What Should Be Remembered"
    )) {
    if ($content -notlike "*$heading*") {
        throw "research-memo-quality: missing heading $heading."
    }
}

Write-Output "research-memo-quality: pass"
