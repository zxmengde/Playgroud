param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "self-improvement-object-lib.ps1")

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
    Write-Output ("### {0}" -f $Label)
    & $ScriptPath @Arguments
    $exitCode = $LASTEXITCODE
    if ($exitCode -eq 1) {
        throw "$Label failed."
    }
    if ($exitCode -eq 2) {
        Add-WarningLine "$Label reported warnings."
    }
}

Write-Output "## Finish readiness checks"

Write-Output ""
Write-Output "### Git status"
$gitStatus = & git -C $Root status --short --branch 2>&1
$gitStatus | ForEach-Object { Write-Output $_ }
if (@($gitStatus | Where-Object { $_ -match '^\?\?|^ M|^M |^A |^ D|^D ' }).Count -gt 0) {
    Add-WarningLine "Working tree has local changes; final response must mention validation status."
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
& (Join-Path $Root "scripts\validate-skill-contracts.ps1") -Root $Root
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

Invoke-ExitAwareCheck -Label "Failure objects" -ScriptPath (Join-Path $Root "scripts\validate-failure-log.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Lesson objects" -ScriptPath (Join-Path $Root "scripts\validate-lessons.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Routing" -ScriptPath (Join-Path $Root "scripts\validate-routing-v1.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Active load" -ScriptPath (Join-Path $Root "scripts\validate-active-load.ps1") -Arguments @{ Root = $Root }

Write-Output ""
Write-Output "### Open failures and active lessons"
$openHighImpact = @(
    Get-FailureObjects -Root $Root |
    Where-Object {
        @("captured", "triaged", "candidate") -contains $_.Data.status -and
        $_.Data.impact -eq "high"
    }
)
Write-Output ("open_high_impact_failures: {0}" -f $openHighImpact.Count)
if ($openHighImpact.Count -gt 0) {
    Add-WarningLine "Open high-impact failures remain."
}
$activeLessons = @(Get-ActiveLessonSummaries -Root $Root)
Write-Output ("active_lessons: {0}" -f $activeLessons.Count)

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
