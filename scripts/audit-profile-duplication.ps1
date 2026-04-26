param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$primaryFiles = @(
    "docs\profile\user-model.md",
    "docs\profile\preference-map.md"
)

$missing = @()
foreach ($rel in $primaryFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $rel))) {
        $missing += $rel
    }
}
if ($missing.Count -gt 0) {
    throw ("Missing profile files: " + ($missing -join ", "))
}

$legacyCandidates = @(
    "skills\personal-work-assistant\references\user-profile.md",
    "skills\personal-work-assistant\SKILL.md"
)

$existingLegacy = @()
foreach ($rel in $legacyCandidates) {
    if (Test-Path -LiteralPath (Join-Path $Root $rel)) {
        $existingLegacy += $rel
    }
}

if ($existingLegacy.Count -gt 0) {
    throw ("Legacy profile or skill files still exist: " + ($existingLegacy -join ", "))
}

Write-Output "Profile duplication check passed."
