param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "..\self-improvement-object-lib.ps1")

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

function Get-Section {
    param([string]$Content, [string]$Heading)
    $pattern = "(?ms)^##\s+" + [regex]::Escape($Heading) + "\s*\r?\n(.*?)(?=^##\s|\z)"
    $match = [regex]::Match($Content, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ""
}

function Get-LedgerBlocks {
    param([string]$Text)
    $blocks = @()
    foreach ($match in [regex]::Matches($Text, "(?ms)^###\s+(.+?)\s*\r?\n(.*?)(?=^###\s|\z)")) {
        $fields = [ordered]@{}
        foreach ($line in ($match.Groups[2].Value -split "\r?\n")) {
            $fieldMatch = [regex]::Match($line, "^\s*-\s+([^:]+):\s*(.*)\s*$")
            if ($fieldMatch.Success) {
                $fields[$fieldMatch.Groups[1].Value.Trim()] = $fieldMatch.Groups[2].Value.Trim()
            }
        }
        $blocks += [pscustomobject]@{
            title = $match.Groups[1].Value.Trim()
            fields = $fields
        }
    }
    return $blocks
}

function Get-BlockField {
    param([object]$Block, [string]$Name)
    if ($null -eq $Block) { return "" }
    if ($Block.fields.Contains($Name)) { return [string]$Block.fields[$Name] }
    return ""
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
& (Join-Path $Root "scripts\lib\commands\check-task-state.ps1") -Root $Root

Write-Output ""
Write-Output "### Final claim consistency"
$activePath = Join-Path $Root "docs\tasks\active.md"
$active = Get-Content -LiteralPath $activePath -Raw -Encoding UTF8
$activeStatus = Get-Section -Content $active -Heading "Status"
$activeNext = Get-Section -Content $active -Heading "Next"
$activeUnverified = Get-Section -Content $active -Heading "Unverified"
$attemptPath = Join-Path $Root "docs\tasks\attempts.md"
$latestAttempt = $null
if (Test-Path -LiteralPath $attemptPath) {
    $latestAttempt = @(Get-LedgerBlocks (Get-Content -LiteralPath $attemptPath -Raw -Encoding UTF8)) | Select-Object -Last 1
}
$latestAttemptId = Get-BlockField $latestAttempt "id"
$latestAttemptStatus = Get-BlockField $latestAttempt "status"
Write-Output ("latest_attempt: {0} status={1}" -f $latestAttemptId, $latestAttemptStatus)
if (@("running", "review_needed") -contains $latestAttemptStatus) {
    Add-WarningLine "Latest task attempt is still open."
}
if ($activeUnverified -match "pending_validation:\s*true|unverified:\s*true") {
    Add-WarningLine "Active task still marks validation as pending."
}
if ($activeNext -match "commit|push|validate|eval|strict|diff") {
    Add-WarningLine "Active task still lists finish actions in Next."
}
$finalReportPath = Join-Path $Root "docs\Codex-adoption-proof-state-drift-audit.md"
if (Test-Path -LiteralPath $finalReportPath) {
    $finalReport = Get-Content -LiteralPath $finalReportPath -Raw -Encoding UTF8
    if ($finalReport -match "completed|pushed" -and ($activeUnverified -match "pending_validation:\s*true|unverified:\s*true")) {
        Add-WarningLine "Final report claims completion while active task is unverified."
    }
}
if ($activeStatus -match "completed|pushed" -and ($activeUnverified -match "pending_validation:\s*true|unverified:\s*true")) {
    Add-WarningLine "Active status claims completion while Unverified is still pending."
}

Write-Output ""
Write-Output "### Knowledge indexes"
& (Join-Path $Root "scripts\lib\commands\validate-knowledge-index.ps1") -Root $Root

Write-Output ""
Write-Output "### Document structure"
& (Join-Path $Root "scripts\lib\commands\validate-doc-structure.ps1") -Root $Root

Write-Output ""
Write-Output "### Acceptance records"
& (Join-Path $Root "scripts\lib\commands\validate-acceptance-records.ps1") -Root $Root

Write-Output ""
Write-Output "### Text risk scan"
& (Join-Path $Root "scripts\lib\commands\scan-text-risk.ps1") -Root $Root

Write-Output ""
Write-Output "### Repository skills"
& (Join-Path $Root "scripts\lib\commands\validate-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\validate-skill-contracts.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-skills.ps1") -Root $Root

Write-Output ""
Write-Output "### Profile duplication"
& (Join-Path $Root "scripts\lib\commands\audit-profile-duplication.ps1") -Root $Root

Write-Output ""
Write-Output "### Minimality"
& (Join-Path $Root "scripts\lib\commands\audit-minimality.ps1") -Root $Root

Write-Output ""
Write-Output "### File usage"
& (Join-Path $Root "scripts\lib\commands\audit-file-usage.ps1") -Root $Root

Write-Output ""
Write-Output "### Active references"
& (Join-Path $Root "scripts\lib\commands\audit-active-references.ps1") -Root $Root

Write-Output ""
Write-Output "### System improvement proposals"
& (Join-Path $Root "scripts\lib\commands\audit-system-improvement-proposals.ps1") -Root $Root

Invoke-ExitAwareCheck -Label "Failure objects" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-failure-log.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Lesson objects" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-lessons.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Routing" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-routing-v1.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "Active load" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-active-load.ps1") -Arguments @{ Root = $Root }

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
& (Join-Path $Root "scripts\lib\commands\check-agent-readiness.ps1") -Root $Root

Write-Output ""
Write-Output "### Agent eval"
& (Join-Path $Root "scripts\lib\commands\eval-agent-system.ps1") -Root $Root

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
