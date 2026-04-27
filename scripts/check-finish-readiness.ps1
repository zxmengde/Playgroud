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

Write-Output "## Finish readiness checks"

Write-Output ""
Write-Output "### Git status"
$gitStatus = & git -C $Root status --short --branch 2>&1
$gitStatus | ForEach-Object { Write-Output $_ }
if (($gitStatus | Where-Object { $_ -match '^\?\?|^ M|^M |^A |^ D|^D ' }).Count -gt 0) {
    Add-WarningLine "Working tree has local changes; final response must mention this."
}

Write-Output ""
Write-Output "### Task state"
& (Join-Path $Root "scripts\check-task-state.ps1") -Root $Root

Write-Output ""
Write-Output "### Knowledge indexes"
& (Join-Path $Root "scripts\validate-knowledge-index.ps1") -Root $Root

Write-Output ""
Write-Output "### Document structure"
& (Join-Path $Root "scripts\validate-doc-structure.ps1") -Root $Root

Write-Output ""
Write-Output "### Acceptance records"
& (Join-Path $Root "scripts\validate-acceptance-records.ps1") -Root $Root

Write-Output ""
Write-Output "### Text risk scan"
& (Join-Path $Root "scripts\scan-text-risk.ps1") -Root $Root

Write-Output ""
Write-Output "### Repository skills"
& (Join-Path $Root "scripts\validate-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-skills.ps1") -Root $Root

Write-Output ""
Write-Output "### Profile duplication"
& (Join-Path $Root "scripts\audit-profile-duplication.ps1") -Root $Root

Write-Output ""
Write-Output "### Minimality"
& (Join-Path $Root "scripts\audit-minimality.ps1") -Root $Root

Write-Output ""
Write-Output "### File usage"
& (Join-Path $Root "scripts\audit-file-usage.ps1") -Root $Root

Write-Output ""
Write-Output "### Active references"
& (Join-Path $Root "scripts\audit-active-references.ps1") -Root $Root

Write-Output ""
Write-Output "### System improvement proposals"
& (Join-Path $Root "scripts\audit-system-improvement-proposals.ps1") -Root $Root

Write-Output ""
Write-Output "### Agent readiness"
& (Join-Path $Root "scripts\check-agent-readiness.ps1") -Root $Root

Write-Output ""
Write-Output "### Agent eval"
& (Join-Path $Root "scripts\eval-agent-system.ps1") -Root $Root

$active = Get-Content -LiteralPath (Join-Path $Root "docs\tasks\active.md") -Raw
foreach ($marker in @("Literal-only", "Real-goal", "User-premise", "Unverified-claims")) {
    if ($active -notlike "*$marker*") {
        Add-WarningLine "Active task state does not mention anti-sycophancy marker: $marker"
    }
}

if ($warnings.Count -gt 0) {
    Write-Output ""
    Write-Output "### Warnings"
    $warnings | ForEach-Object { Write-Output "- $_" }
    if ($Strict) {
        throw "Finish readiness warnings exist in strict mode."
    }
}

Write-Output ""
Write-Output "Finish readiness check completed."
