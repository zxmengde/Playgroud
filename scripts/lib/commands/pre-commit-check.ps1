param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"

Write-Output "Pre-commit check"

& (Join-Path $Root "scripts\lib\commands\scan-text-risk.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\validate-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-active-references.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-system-improvement-proposals.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\validate-knowledge-index.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\validate-doc-structure.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\validate-acceptance-records.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\eval-agent-system.ps1") -Root $Root

Write-Output "Pre-commit check passed."
