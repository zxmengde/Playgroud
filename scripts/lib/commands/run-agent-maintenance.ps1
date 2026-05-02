param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path,
    [switch]$Full
)

$ErrorActionPreference = "Stop"

Write-Output "Playgroud maintenance audit"
Write-Output ("time: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"))

& (Join-Path $Root "scripts\lib\commands\audit-minimality.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-active-references.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-system-improvement-proposals.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-automation-config.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-mcp-config.ps1")
& (Join-Path $Root "scripts\lib\commands\audit-video-skill-readiness.ps1")
& (Join-Path $Root "scripts\lib\commands\audit-zotero-library.ps1")

if ($Full) {
    & (Join-Path $Root "scripts\lib\commands\validate-system.ps1") -Root $Root
} else {
    & (Join-Path $Root "scripts\lib\commands\check-task-state.ps1") -Root $Root
    & (Join-Path $Root "scripts\lib\commands\validate-knowledge-index.ps1") -Root $Root
    & (Join-Path $Root "scripts\lib\commands\scan-text-risk.ps1") -Root $Root
}

Write-Output "Playgroud maintenance audit completed."
