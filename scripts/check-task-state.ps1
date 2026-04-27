param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$path = Join-Path $Root "docs\tasks\active.md"
if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing task state file: docs/tasks/active.md"
}

$content = Get-Content -LiteralPath $path -Raw
$requiredHeadings = @(
    "# Active Task",
    "## Goal",
    "## Read Sources",
    "## Commands",
    "## Artifacts",
    "## Unverified",
    "## Blockers",
    "## Next",
    "## Recovery",
    "## Anti-Sycophancy"
)

$missing = @()
foreach ($heading in $requiredHeadings) {
    if ($content -notlike "*$heading*") {
        $missing += $heading
    }
}

if ($missing.Count -gt 0) {
    throw ("Task state missing required headings: " + ($missing -join ", "))
}

if ($content -match "commit and push before finishing|旧任务|提交和推送前需再次") {
    throw "Task state appears stale."
}

Write-Output "Task state check passed."
