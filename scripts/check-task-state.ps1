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
    "## Status",
    "## Last Updated",
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

$lastUpdatedMatch = [regex]::Match($content, '(?m)^## Last Updated\s*\r?\n\s*(\d{4}-\d{2}-\d{2})')
if (-not $lastUpdatedMatch.Success) {
    throw "Task state missing ISO date under Last Updated."
}

$statusMatch = [regex]::Match($content, '(?ms)^## Status\s*\r?\n(.*?)(?=^##\s|\z)')
if (-not $statusMatch.Success -or [string]::IsNullOrWhiteSpace($statusMatch.Groups[1].Value.Trim())) {
    throw "Task state Status section is empty."
}

Write-Output "Task state check passed."
