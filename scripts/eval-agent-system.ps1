param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [switch]$JsonOnly
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "self-improvement-object-lib.ps1")

function Add-Result {
    param(
        [string]$Name,
        [bool]$Pass,
        [string]$Detail
    )

    $script:results += [pscustomobject]@{
        name = $Name
        pass = $Pass
        detail = $Detail
    }
}

function Invoke-EvalScript {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$ScriptPath
    )

    try {
        $output = & $ScriptPath -Root $Root 2>&1
        $detail = (($output | ForEach-Object { $_.ToString() }) -join " ").Trim()
        if ([string]::IsNullOrWhiteSpace($detail)) {
            $detail = "pass"
        }
        Add-Result $Name $true $detail
    } catch {
        Add-Result $Name $false $_.Exception.Message
    }
}

$results = @()

$tracked = @(& git -C $Root ls-files)
$deleted = @(& git -C $Root ls-files --deleted)
$others = @(& git -C $Root ls-files --others --exclude-standard)
$currentCount = ($tracked.Count - $deleted.Count + $others.Count)
Add-Result "tracked_file_count" ($currentCount -le 175) ("current_files=$currentCount; target_max=175")

$legacySkills = @(Get-ChildItem -Path (Join-Path $Root "skills") -Recurse -File -ErrorAction SilentlyContinue)
Add-Result "no_legacy_skills_directory_files" ($legacySkills.Count -eq 0) ("legacy_skill_files=$($legacySkills.Count)")

$repoSkills = @(Get-ChildItem -Path (Join-Path $Root ".agents\skills") -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)
Add-Result "repository_skill_count" ($repoSkills.Count -ge 9 -and $repoSkills.Count -le 12) ("repository_skills=$($repoSkills.Count)")

$routingExists = Test-Path -LiteralPath (Join-Path $Root "docs\knowledge\system-improvement\routing-v1.yaml")
Add-Result "routing_exists" $routingExists "routing-v1.yaml"

$failureCount = @(Get-ChildItem -Path (Join-Path $Root "docs\knowledge\system-improvement\failures") -Filter "*.yaml" -File -ErrorAction SilentlyContinue).Count
$lessonCount = @(Get-ChildItem -Path (Join-Path $Root "docs\knowledge\system-improvement\lessons") -Filter "*.yaml" -File -ErrorAction SilentlyContinue).Count
Add-Result "failure_objects_present" ($failureCount -ge 2) ("failure_objects=$failureCount")
Add-Result "lesson_objects_present" ($lessonCount -ge 2) ("lesson_objects=$lessonCount")

$hookConfig = Join-Path $Root ".codex\hooks.json"
$hookChainComplete = $false
if (Test-Path -LiteralPath $hookConfig) {
    $hookText = Get-Content -LiteralPath $hookConfig -Raw
    $hookChainComplete = @("PreToolUse", "SessionStart", "PostToolUse", "Stop") | Where-Object { $hookText -like "*$_*" } | Measure-Object | Select-Object -ExpandProperty Count
    $hookChainComplete = ($hookChainComplete -eq 4)
}
Add-Result "hook_chain_complete" $hookChainComplete ".codex/hooks.json contains PreToolUse, SessionStart, PostToolUse, Stop"

$configPath = "$env:USERPROFILE\.codex\config.toml"
$hooksEnabled = $false
if (Test-Path -LiteralPath $configPath) {
    $configContent = Get-Content -LiteralPath $configPath -Raw
    $hooksEnabled = $configContent -match '(?m)^\s*codex_hooks\s*=\s*true\b'
}
Add-Result "codex_hooks_enabled" $hooksEnabled ("config_path=$configPath")

try {
    $mcpOutput = & (Join-Path $Root "scripts\audit-mcp-config.ps1") 2>&1
    $mcpText = ($mcpOutput -join "`n")
    Add-Result "mcp_allowlist" ($LASTEXITCODE -eq 0 -and $mcpText -notmatch "not in allowlist|Blocked MCP") "MCP allowlist audit completed"
} catch {
    Add-Result "mcp_allowlist" $false $_.Exception.Message
}

try {
    & (Join-Path $Root "scripts\audit-automation-config.ps1") -Root $Root | Out-Null
    Add-Result "automation_prompts_valid" ($LASTEXITCODE -eq 0) "automation config audit completed"
} catch {
    Add-Result "automation_prompts_valid" $false $_.Exception.Message
}

$usageOutput = & (Join-Path $Root "scripts\audit-file-usage.ps1") -Root $Root
$usageText = ($usageOutput -join "`n")
$lowCount = 999
if ($usageText -match "low-reference candidates:\s*(\d+)") {
    $lowCount = [int]$Matches[1]
}
Add-Result "low_reference_reduced" ($lowCount -le 35) ("low_reference_candidates=$lowCount; target_max=35")

foreach ($validator in @(
        @{ Name = "validate_failure_log"; Path = "scripts\validate-failure-log.ps1" },
        @{ Name = "validate_lessons"; Path = "scripts\validate-lessons.ps1" },
        @{ Name = "validate_routing"; Path = "scripts\validate-routing-v1.ps1" },
        @{ Name = "validate_skill_contracts"; Path = "scripts\validate-skill-contracts.ps1" },
        @{ Name = "validate_active_load"; Path = "scripts\validate-active-load.ps1" }
    )) {
    try {
        $output = & (Join-Path $Root $validator.Path) -Root $Root 2>&1
        $detail = ("exit={0}" -f $LASTEXITCODE)
        Add-Result $validator.Name ($LASTEXITCODE -ne 1) $detail
    } catch {
        Add-Result $validator.Name $false $_.Exception.Message
    }
}

Invoke-EvalScript -Name "repeat_failure_capture" -ScriptPath (Join-Path $Root "scripts\eval-repeat-failure-capture.ps1")
Invoke-EvalScript -Name "lesson_promotion" -ScriptPath (Join-Path $Root "scripts\eval-lesson-promotion.ps1")
Invoke-EvalScript -Name "routing_selection" -ScriptPath (Join-Path $Root "scripts\eval-routing-selection.ps1")
Invoke-EvalScript -Name "external_mechanism_review_check" -ScriptPath (Join-Path $Root "scripts\eval-external-mechanism-review-check.ps1")
Invoke-EvalScript -Name "research_memo_quality" -ScriptPath (Join-Path $Root "scripts\eval-research-memo-quality.ps1")
Invoke-EvalScript -Name "uiux_review_quality" -ScriptPath (Join-Path $Root "scripts\eval-uiux-review-quality.ps1")
Invoke-EvalScript -Name "session_recovery" -ScriptPath (Join-Path $Root "scripts\eval-session-recovery.ps1")
Invoke-EvalScript -Name "unverified_closeout_block" -ScriptPath (Join-Path $Root "scripts\eval-unverified-closeout-block.ps1")
Invoke-EvalScript -Name "product_engineering_closeout" -ScriptPath (Join-Path $Root "scripts\eval-product-engineering-closeout.ps1")

$summary = [pscustomobject]@{
    generated_at = (Get-Date).ToString("s")
    pass = (@($results | Where-Object { -not $_.pass }).Count -eq 0)
    results = $results
}

if ($JsonOnly) {
    $summary | ConvertTo-Json -Depth 4
} else {
    Write-Output "Agent system eval"
    $summary.results | ForEach-Object {
        Write-Output ("- {0}: {1} ({2})" -f $_.name, $(if ($_.pass) { "pass" } else { "fail" }), $_.detail)
    }
    Write-Output ("overall: {0}" -f $(if ($summary.pass) { "pass" } else { "fail" }))
}

if (-not $summary.pass) {
    throw "Agent system eval failed."
}
