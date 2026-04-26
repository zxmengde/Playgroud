param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

function Add-WarningLine {
    param([string]$Message)
    $script:warnings += $Message
}

$warnings = @()

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
Write-Output "### Skill validation"
& (Join-Path $Root "scripts\validate-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-skills.ps1") -Root $Root

Write-Output ""
Write-Output "### Profile duplication"
& (Join-Path $Root "scripts\audit-profile-duplication.ps1") -Root $Root

Write-Output ""
Write-Output "### Minimality"
& (Join-Path $Root "scripts\audit-minimality.ps1") -Root $Root

Write-Output ""
Write-Output "### Agent readiness"
& (Join-Path $Root "scripts\check-agent-readiness.ps1") -Root $Root

Write-Output ""
Write-Output "### Anti-sycophancy review"
$active = Get-Content -LiteralPath (Join-Path $Root "docs\tasks\active.md") -Raw
foreach ($marker in @("是否只完成字面要求", "是否检查真实目标", "是否把用户粗略判断当作事实", "是否用流畅语言掩盖未验证结论")) {
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
