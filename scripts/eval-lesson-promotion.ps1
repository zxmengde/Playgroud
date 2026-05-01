param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "self-improvement-object-lib.ps1")

& (Join-Path $PSScriptRoot "validate-lessons.ps1") -Root $Root | Out-Host
if ($LASTEXITCODE -eq 1) {
    throw "lesson-promotion: lesson validator reported blocking errors."
}

$rows = Get-LessonObjects -Root $Root
if ($rows.Count -lt 2) {
    throw "lesson-promotion: expected at least two lesson objects."
}

$promotedCount = @($rows | Where-Object { @("promoted", "verified") -contains $_.Data.status }).Count
if ($promotedCount -lt 2) {
    throw "lesson-promotion: expected both historical lessons to be promoted or verified."
}

Write-Output "lesson-promotion: pass"
