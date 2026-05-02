param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "..\self-improvement-object-lib.ps1")

& (Join-Path $PSScriptRoot "validate-failure-log.ps1") -Root $Root | Out-Host
if ($LASTEXITCODE -eq 1) {
    throw "repeat-failure-capture: failure validator reported blocking errors."
}

$rows = Get-FailureObjects -Root $Root
if ($rows.Count -lt 2) {
    throw "repeat-failure-capture: expected at least two failure objects."
}

$requiredIds = @(
    "FAIL-20260427-210500-a1c201",
    "FAIL-20260427-213000-b77d42"
)
foreach ($requiredId in $requiredIds) {
    if ($rows.Data.id -notcontains $requiredId) {
        throw "repeat-failure-capture: missing historical failure $requiredId."
    }
}

Write-Output "repeat-failure-capture: pass"
