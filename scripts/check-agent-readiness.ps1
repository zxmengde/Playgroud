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

function Invoke-ExitAwareCheck {
    param(
        [Parameter(Mandatory = $true)][string]$Label,
        [Parameter(Mandatory = $true)][string]$ScriptPath,
        [hashtable]$Arguments = @{}
    )

    Write-Output ""
    Write-Output ("## {0}" -f $Label)
    & $ScriptPath @Arguments
    $exitCode = $LASTEXITCODE
    if ($exitCode -eq 1) {
        throw "$Label failed."
    }
    if ($exitCode -eq 2) {
        Add-WarningLine "$Label reported warnings."
    }
}

Write-Output "Agent readiness checks"

Write-Output ""
Write-Output "## Minimality"
& (Join-Path $Root "scripts\audit-minimality.ps1") -Root $Root

Write-Output ""
Write-Output "## Active references"
& (Join-Path $Root "scripts\audit-active-references.ps1") -Root $Root

Invoke-ExitAwareCheck -Label "Object validators" -ScriptPath (Join-Path $Root "scripts\validate-failure-log.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Lesson validators" -ScriptPath (Join-Path $Root "scripts\validate-lessons.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Routing validators" -ScriptPath (Join-Path $Root "scripts\validate-routing-v1.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Skill contracts" -ScriptPath (Join-Path $Root "scripts\validate-skill-contracts.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Active load" -ScriptPath (Join-Path $Root "scripts\validate-active-load.ps1") -Arguments @{ Root = $Root }

Write-Output ""
Write-Output "## MCP configuration"
& (Join-Path $Root "scripts\audit-mcp-config.ps1")

Write-Output ""
Write-Output "## Hooks"
$configPath = "$env:USERPROFILE\.codex\config.toml"
$hooksEnabled = $false
if (Test-Path -LiteralPath $configPath) {
    $configContent = Get-Content -LiteralPath $configPath -Raw
    $hooksEnabled = $configContent -match '(?m)^\s*codex_hooks\s*=\s*true\b'
}
Write-Output ("codex_hooks_enabled: {0}" -f $hooksEnabled)
if (-not $hooksEnabled) {
    Add-WarningLine "User-level Codex hooks feature is disabled."
}
$hookPath = Join-Path $Root ".codex\hooks.json"
if (-not (Test-Path -LiteralPath $hookPath)) {
    Add-WarningLine "Project hooks file is missing."
} else {
    $hookContent = Get-Content -LiteralPath $hookPath -Raw
    foreach ($requiredHook in @("PreToolUse", "SessionStart", "PostToolUse", "Stop")) {
        if ($hookContent -notlike "*$requiredHook*") {
            Add-WarningLine "Project hooks file does not mention $requiredHook."
        }
    }
}

Write-Output ""
Write-Output "## Automations"
& (Join-Path $Root "scripts\audit-automation-config.ps1") -Root $Root

Write-Output ""
Write-Output "## Runtime"
& (Join-Path $Root "scripts\test-codex-runtime.ps1") -Root $Root -SkipNetwork

Write-Output ""
Write-Output "## Serena and Obsidian"
& (Join-Path $Root "scripts\audit-serena-obsidian-readiness.ps1") -Root $Root

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
