param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path,
    [Parameter(Mandatory = $true)]
    [ValidateSet("external-mechanism-review-check", "research-memo-quality", "uiux-review-quality", "product-engineering-closeout")]
    [string]$Name
)

$ErrorActionPreference = "Stop"

$specs = @{
    "external-mechanism-review-check" = @{
        Path = "docs\validation\system-improvement\external-mechanism-review-sample.md"
        Headings = @(
            "## Question",
            "## Candidates",
            "## Mechanisms",
            "## Source Evidence",
            "## Fit Decision",
            "## Minimum Implementation",
            "## Risks",
            "## Re-evaluation"
        )
        MustContain = @("commit", "path", "line")
        MustNotMatch = "假定|assume|assumed"
    }
    "research-memo-quality" = @{
        Path = "docs\validation\system-improvement\research-memo-sample.md"
        Headings = @(
            "## Question",
            "## Why This Matters",
            "## Sources",
            "## Facts",
            "## Inferences",
            "## Uncertainty",
            "## Experiment / Verification Plan",
            "## Decision",
            "## What Should Be Remembered"
        )
    }
    "uiux-review-quality" = @{
        Path = "docs\validation\system-improvement\uiux-review-sample.md"
        Headings = @(
            "## Scenario",
            "## Checklist",
            "## Evidence",
            "## Findings",
            "## Risks"
        )
        MustContain = @("Desktop", "Mobile", "Interaction", "Accessibility", "Responsive")
    }
    "product-engineering-closeout" = @{
        Path = "docs\validation\system-improvement\product-engineering-sample.md"
        Headings = @(
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
        )
    }
}

$spec = $specs[$Name]
$path = Join-Path $Root $spec.Path
if (-not (Test-Path -LiteralPath $path)) {
    throw "${Name}: sample file missing."
}

$content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
foreach ($heading in @($spec.Headings)) {
    if ($content -notlike "*$heading*") {
        throw "${Name}: missing heading $heading."
    }
}

if ($spec.ContainsKey("MustContain")) {
    foreach ($term in @($spec.MustContain)) {
        if ($content -notlike "*$term*") {
            throw "${Name}: sample must mention $term."
        }
    }
}

if ($spec.ContainsKey("MustNotMatch") -and $content -match $spec.MustNotMatch) {
    throw "${Name}: prohibited weak evidence wording found."
}

Write-Output "${Name}: pass"
