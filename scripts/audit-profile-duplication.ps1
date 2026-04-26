param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$primaryFiles = @(
    "docs\profile\user-model.md",
    "docs\profile\preference-map.md"
)
$legacyFile = "skills\personal-work-assistant\references\user-profile.md"

$missing = @()
foreach ($rel in ($primaryFiles + $legacyFile)) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $rel))) {
        $missing += $rel
    }
}
if ($missing.Count -gt 0) {
    throw ("Missing profile files: " + ($missing -join ", "))
}

$legacyPath = Join-Path $Root $legacyFile
$legacy = Get-Content -LiteralPath $legacyPath -Raw
$legacyLines = ($legacy -split "`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count

if ($legacyLines -gt 25) {
    Write-Warning "Legacy personal-work-assistant profile reference has $legacyLines non-empty lines. Keep it as a pointer to docs/profile to avoid duplicate maintenance."
} else {
    Write-Output "Profile duplication check passed."
}
