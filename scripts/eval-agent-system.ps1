param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [switch]$JsonOnly
)

$ErrorActionPreference = "Stop"

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

$results = @()

$tracked = @(& git -C $Root ls-files)
$deleted = @(& git -C $Root ls-files --deleted)
$others = @(& git -C $Root ls-files --others --exclude-standard)
$currentCount = ($tracked.Count - $deleted.Count + $others.Count)
Add-Result "tracked_file_count" ($currentCount -le 127) ("current_files=$currentCount; target_max=127")

Add-Result "core_single_entry" (Test-Path (Join-Path $Root "docs\core\index.md")) "docs/core/index.md exists"
$legacyCore = @(Get-ChildItem -Path (Join-Path $Root "docs\core") -Filter "*.md" -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "index.md" })
Add-Result "no_legacy_core_files" ($legacyCore.Count -eq 0) ("legacy_core_files=$($legacyCore.Count)")

$legacyCaps = @(Get-ChildItem -Path (Join-Path $Root "docs\capabilities") -Filter "*.md" -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "index.md" })
Add-Result "no_legacy_capability_files" ($legacyCaps.Count -eq 0) ("legacy_capability_files=$($legacyCaps.Count)")

$legacySkills = @(Get-ChildItem -Path (Join-Path $Root "skills") -Recurse -File -ErrorAction SilentlyContinue)
Add-Result "no_legacy_skills_directory_files" ($legacySkills.Count -eq 0) ("legacy_skill_files=$($legacySkills.Count)")

$repoSkill = Join-Path $Root ".agents\skills\playgroud-maintenance\SKILL.md"
Add-Result "repository_skill_exists" (Test-Path -LiteralPath $repoSkill) ".agents/skills/playgroud-maintenance/SKILL.md"

$hookConfig = Join-Path $Root ".codex\hooks.json"
Add-Result "hooks_config_exists" (Test-Path -LiteralPath $hookConfig) ".codex/hooks.json"

try {
    $mcpOutput = & (Join-Path $Root "scripts\audit-mcp-config.ps1") 2>&1
    $mcpText = ($mcpOutput -join "`n")
    Add-Result "mcp_allowlist" ($LASTEXITCODE -eq 0 -and $mcpText -notmatch "not in allowlist|Blocked MCP") "MCP allowlist audit completed"
} catch {
    Add-Result "mcp_allowlist" $false $_.Exception.Message
}

$configPath = "$env:USERPROFILE\.codex\config.toml"
$hooksEnabled = $false
if (Test-Path -LiteralPath $configPath) {
    $configContent = Get-Content -LiteralPath $configPath -Raw
    $hooksEnabled = $configContent -match '(?m)^\s*codex_hooks\s*=\s*true\b'
}
Add-Result "codex_hooks_enabled" $hooksEnabled ("config_path=$configPath")

$automationRoot = Join-Path $env:USERPROFILE ".codex\automations"
$automationFiles = @()
if (Test-Path -LiteralPath $automationRoot) {
    $automationFiles = @(Get-ChildItem -Path $automationRoot -Recurse -Filter "automation.toml" -File -ErrorAction SilentlyContinue)
}
$automationNames = ($automationFiles | ForEach-Object { $_.FullName }) -join ";"
$hasReadiness = $automationNames -match "playgroud-readiness-audit"
$hasTriage = $automationNames -match "playgroud-improvement-triage"
Add-Result "automations_exist" ($hasReadiness -and $hasTriage) ("automation_files=$($automationFiles.Count)")

try {
    & (Join-Path $Root "scripts\audit-automation-config.ps1") -Root $Root | Out-Null
    Add-Result "automation_prompts_valid" ($LASTEXITCODE -eq 0) "automation config audit completed"
} catch {
    Add-Result "automation_prompts_valid" $false $_.Exception.Message
}

$activePath = Join-Path $Root "docs\tasks\active.md"
$active = ""
if (Test-Path -LiteralPath $activePath) { $active = Get-Content -LiteralPath $activePath -Raw }
$stale = $active -match "提交和推送前需再次|旧任务|old automation task"
Add-Result "active_task_not_stale" (-not $stale) "active task does not contain known stale markers"

$usageOutput = & (Join-Path $Root "scripts\audit-file-usage.ps1") -Root $Root
$usageText = ($usageOutput -join "`n")
$lowCount = 999
if ($usageText -match "low-reference candidates:\s*(\d+)") {
    $lowCount = [int]$Matches[1]
}
Add-Result "low_reference_reduced" ($lowCount -le 20) ("low_reference_candidates=$lowCount; target_max=20")

$summary = [pscustomobject]@{
    generated_at = (Get-Date).ToString("s")
    pass = (($results | Where-Object { -not $_.pass }).Count -eq 0)
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
