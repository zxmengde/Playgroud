param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [switch]$Full
)

$ErrorActionPreference = "Stop"

Write-Output "Playgroud maintenance audit"
Write-Output ("time: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"))

& (Join-Path $Root "scripts\audit-minimality.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-active-references.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-system-improvement-proposals.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-automations.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-skill-sync.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-mcp-config.ps1")
& (Join-Path $Root "scripts\audit-video-skill-readiness.ps1")
& (Join-Path $Root "scripts\audit-zotero-library.ps1")

if ($Full) {
    & (Join-Path $Root "scripts\validate-system.ps1") -Root $Root
} else {
    & (Join-Path $Root "scripts\check-task-state.ps1") -Root $Root
    & (Join-Path $Root "scripts\validate-knowledge-index.ps1") -Root $Root
    & (Join-Path $Root "scripts\scan-text-risk.ps1") -Root $Root
}

Write-Output "Playgroud maintenance audit completed."
