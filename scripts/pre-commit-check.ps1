param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

Write-Output "Pre-commit check"

& (Join-Path $Root "scripts\scan-text-risk.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-active-references.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-system-improvement-proposals.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-knowledge-index.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-doc-structure.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-acceptance-records.ps1") -Root $Root
& (Join-Path $Root "scripts\eval-agent-system.ps1") -Root $Root

Write-Output "Pre-commit check passed."
