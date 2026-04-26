param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$required = @(
    "docs\core\companion-target.md",
    "docs\core\self-configuration.md",
    "docs\core\identity-and-goal.md",
    "docs\core\permission-boundary.md",
    "docs\core\execution-loop.md",
    "docs\core\memory-state.md",
    "docs\core\finish-readiness.md",
    "docs\assistant\index.md",
    "docs\references\assistant",
    "docs\references\assistant\index.md",
    "docs\references\assistant\self-improvement-loop.md",
    "docs\capabilities\index.md",
    "docs\capabilities\gap-review.md",
    "docs\capabilities\companion-roadmap.md",
    "docs\capabilities\pruning-review.md",
    "docs\references\assistant\external-capability-radar.md",
    "docs\knowledge\system-improvement\harness-log.md",
    "docs\knowledge\system-improvement\skill-audit.md"
)

$missing = @()
foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $path))) {
        $missing += $path
    }
}

if ($missing.Count -gt 0) {
    throw ("Missing v2 document structure paths: " + ($missing -join ", "))
}

$assistantDir = Join-Path $Root "docs\assistant"
$unexpectedAssistantMarkdown = @(Get-ChildItem -Path $assistantDir -Filter "*.md" -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne "index.md" })
if ($unexpectedAssistantMarkdown.Count -gt 0) {
    throw ("Unexpected legacy assistant markdown files: " + (($unexpectedAssistantMarkdown | Select-Object -ExpandProperty Name) -join ", "))
}

Write-Output "Document structure check passed."

