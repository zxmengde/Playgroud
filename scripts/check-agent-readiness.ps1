param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

$warnings = @()
function Add-WarningLine {
    param([string]$Message)
    $script:warnings += $Message
}

Write-Output "Agent readiness checks"

Write-Output ""
Write-Output "## Minimality"
& (Join-Path $Root "scripts\audit-minimality.ps1") -Root $Root

Write-Output ""
Write-Output "## Active references"
& (Join-Path $Root "scripts\audit-active-references.ps1") -Root $Root

Write-Output ""
Write-Output "## MCP configuration"
& (Join-Path $Root "scripts\audit-mcp-config.ps1")

Write-Output ""
Write-Output "## Runtime"
& (Join-Path $Root "scripts\test-codex-runtime.ps1") -Root $Root -SkipNetwork

Write-Output ""
Write-Output "## Repository skills"
& (Join-Path $Root "scripts\validate-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-skills.ps1") -Root $Root

Write-Output ""
Write-Output "## Video skills"
& (Join-Path $Root "scripts\audit-video-skill-readiness.ps1")

Write-Output ""
Write-Output "## Task state"
& (Join-Path $Root "scripts\check-task-state.ps1") -Root $Root

$hookPath = Join-Path $Root ".codex\hooks.json"
if (-not (Test-Path -LiteralPath $hookPath)) {
    Add-WarningLine "Project hooks file is missing."
}

if ($warnings.Count -gt 0) {
    Write-Output ""
    Write-Output "## Warnings"
    $warnings | ForEach-Object { Write-Output ("- {0}" -f $_) }
    if ($Strict) {
        throw "Agent readiness warnings exist in strict mode."
    }
}

Write-Output ""
Write-Output "Agent readiness check completed."
