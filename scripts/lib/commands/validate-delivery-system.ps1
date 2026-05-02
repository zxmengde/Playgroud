param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "..\self-improvement-object-lib.ps1")

$results = @()
$hasFailure = $false

function Add-ResultLine {
    param([string]$Level, [string]$Message)
    $script:results += ("{0} {1}" -f $Level, $Message)
}

function Fail {
    param([string]$Message)
    $script:hasFailure = $true
    Add-ResultLine -Level "FAIL" -Message $Message
}

function Pass {
    param([string]$Message)
    Add-ResultLine -Level "PASS" -Message $Message
}

function Require-Path {
    param([string]$RelativePath)
    $full = Join-Path $Root ($RelativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (Test-Path -LiteralPath $full) {
        Pass "path exists: $RelativePath"
        return $true
    }
    Fail "missing path: $RelativePath"
    return $false
}

function Get-FileText {
    param([string]$RelativePath)
    $full = Join-Path $Root ($RelativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $full)) { return "" }
    return Get-Content -LiteralPath $full -Raw -Encoding UTF8
}

$requiredPaths = @(
    "docs/core/delivery-contract.md",
    "docs/core/tool-use-budget.md",
    "docs/core/skill-use-policy.md",
    "docs/core/context-modes.md",
    "docs/core/typed-object-registry.md",
    "docs/capabilities/external-adoptions.md",
    "docs/validation/real-task-evals.md",
    "docs/tasks/board.md",
    "docs/tasks/attempts.md",
    "docs/knowledge/promotion-ledger.md",
    "docs/knowledge/research/research-queue.md",
    "docs/references/assistant/hook-risk-stdin-smoke.md"
)
foreach ($path in $requiredPaths) { [void](Require-Path $path) }

$projects = @(
    "everything-claude-code",
    "ui-ux-pro-max-skill",
    "obsidian-skills",
    "oh-my-codex",
    "vibe-kanban",
    "context-mode",
    "Auto-claude-code-research-in-sleep",
    "AI-Research-SKILLs",
    "Trellis",
    "claude-scholar"
)

$cardsText = Get-FileText "docs/capabilities/external-adoptions.md"
$cardStatuses = @{}
$requiredCardFields = @(
    "source_project",
    "status",
    "inspected_evidence",
    "learned_mechanism",
    "local_artifact",
    "trigger_condition",
    "codex_behavior_delta",
    "user_visible_entry",
    "verification",
    "rollback"
)
$adoptedOrPartial = 0
foreach ($project in $projects) {
    $pattern = "(?ms)^##\s+" + [regex]::Escape($project) + "\s*\r?\n(.*?)(?=^##\s|\z)"
    $match = [regex]::Match($cardsText, $pattern)
    if (-not $match.Success) {
        Fail "external adoption card missing: $project"
        continue
    }

    $card = $match.Groups[1].Value
    foreach ($field in $requiredCardFields) {
        if ($card -notmatch "(?m)^" + [regex]::Escape($field) + "\s*:") {
            Fail "external adoption card $project missing field: $field"
        }
    }

    $statusMatch = [regex]::Match($card, "(?m)^status:\s*([A-Za-z_]+)\s*$")
    if (-not $statusMatch.Success) {
        Fail "external adoption card $project missing parseable status"
        continue
    }
    $status = $statusMatch.Groups[1].Value
    $cardStatuses[$project] = $status
    if (@("adopted", "partial", "rejected_with_substitute") -notcontains $status) {
        Fail "external adoption card $project has invalid final status: $status"
    }
    if ($status -eq "adopted" -or $status -eq "partial") {
        $adoptedOrPartial += 1
    }
}
if ($adoptedOrPartial -ge 8) {
    Pass "external adoption adopted_or_partial=$adoptedOrPartial"
} else {
    Fail "external adoption adopted_or_partial below minimum: $adoptedOrPartial < 8"
}
foreach ($project in @("obsidian-skills", "vibe-kanban", "Auto-claude-code-research-in-sleep")) {
    if ($cardStatuses[$project] -ne "adopted") {
        Fail "required external mechanism is not adopted: $project"
    }
}
foreach ($needle in @("knowledge promote", "promotion-ledger.md", "task attempt", "attempts.md", "research enqueue", "research review-gate")) {
    if ($cardsText -notmatch [regex]::Escape($needle)) {
        Fail "external adoption cards missing callable artifact text: $needle"
    }
}

$capabilityPath = Join-Path $Root "docs\capabilities\capability-map.yaml"
try {
    $capabilityMap = Read-JsonYamlFile -Path $capabilityPath
    $allowedMaturity = @("declared", "smoke_passed", "task_proven", "user_proven", "experimental", "deprecated")
    $boundProjects = New-Object System.Collections.Generic.HashSet[string]
    foreach ($capability in @($capabilityMap.capabilities)) {
        if (-not $capability.id) { Fail "capability missing id" }
        if (-not $capability.maturity_status) { Fail "capability $($capability.id) missing maturity_status" }
        if ($capability.PSObject.Properties.Name -contains "status") { Fail "capability $($capability.id) still uses old status field" }
        if ($allowedMaturity -notcontains $capability.maturity_status) {
            Fail "capability $($capability.id) invalid maturity_status: $($capability.maturity_status)"
        }
        foreach ($field in @("source_projects", "user_visible_entry", "codex_trigger", "evidence", "verification", "known_limits", "rollback")) {
            if (-not ($capability.PSObject.Properties.Name -contains $field)) {
                Fail "capability $($capability.id) missing field: $field"
            }
        }
        foreach ($sourceProject in @($capability.source_projects)) { [void]$boundProjects.Add([string]$sourceProject) }
    }
    foreach ($project in $projects) {
        if (-not $boundProjects.Contains($project)) {
            Fail "external project not bound to capability map: $project"
        }
    }
    Pass ("capability map checked capabilities={0}" -f @($capabilityMap.capabilities).Count)
} catch {
    Fail "capability map parse/check failed: $($_.Exception.Message)"
}

$evalText = Get-FileText "docs/validation/real-task-evals.md"
$evalNames = @(
    "writing-revision-eval",
    "python-package-delivery-eval",
    "ui-change-eval",
    "repo-maintenance-eval"
)
$evalFields = @(
    "task_input",
    "expected_user_outcome",
    "hidden_obligations",
    "required_artifacts",
    "required_verification",
    "common_failure_modes",
    "pass_conditions",
    "fail_conditions",
    "evidence_required",
    "rollback_or_recovery"
)
foreach ($evalName in $evalNames) {
    $pattern = "(?ms)^##\s+" + [regex]::Escape($evalName) + "\s*\r?\n(.*?)(?=^##\s|\z)"
    $match = [regex]::Match($evalText, $pattern)
    if (-not $match.Success) {
        Fail "real task eval missing: $evalName"
        continue
    }
    $section = $match.Groups[1].Value
    foreach ($field in $evalFields) {
        if ($section -notmatch "(?m)^" + [regex]::Escape($field) + "\s*:") {
            Fail "real task eval $evalName missing field: $field"
        }
    }
}
Pass "real task eval specs checked"

$boardText = Get-FileText "docs/tasks/board.md"
foreach ($section in @("Active", "Next", "Blocked", "Done", "Recovery")) {
    if ($boardText -notmatch "(?m)^##\s+$section\s*$") {
        Fail "task board missing section: $section"
    }
}
foreach ($field in @("checkpoint", "next_action", "stale_detection", "resume_summary")) {
    if ($boardText -notmatch [regex]::Escape($field)) {
        Fail "task board missing field: $field"
    }
}
Pass "task board checked"

$contextText = Get-FileText "docs/core/context-modes.md"
foreach ($mode in @("delivery", "research", "audit", "uiux", "coding", "recovery")) {
    if ($contextText -notmatch "\|\s*$mode\s*\|") {
        Fail "context mode missing: $mode"
    }
}
Pass "context modes checked"

$skillPolicyText = Get-FileText "docs/core/skill-use-policy.md"
foreach ($skill in @("playgroud-maintenance", "failure-promoter", "external-mechanism-researcher", "research-engineering-loop", "product-engineering-closer", "uiux-reviewer", "knowledge-curator", "tool-router", "finish-verifier")) {
    if ($skillPolicyText -notmatch [regex]::Escape($skill)) {
        Fail "skill use policy missing skill: $skill"
    }
}
foreach ($needle in @("adopted_mechanism_default_load", "trigger_to_skill_eval_lesson_loop", "knowledge-promotion-lifecycle", "task-board-session-recovery", "research-queue-review-gate")) {
    if ($skillPolicyText -notmatch [regex]::Escape($needle)) {
        Fail "skill use policy missing adopted mechanism rule: $needle"
    }
}
Pass "skill use policy checked"

$researchQueueText = Get-FileText "docs/knowledge/research/research-queue.md"
foreach ($field in @("review_gate", "evidence_quality", "run_log", "interruption_recovery", "user_authorization_boundary")) {
    if ($researchQueueText -notmatch [regex]::Escape($field)) {
        Fail "research queue missing field: $field"
    }
}
foreach ($needle in @("research enqueue", "research review-gate", "research run-log")) {
    if ($researchQueueText -notmatch [regex]::Escape($needle)) {
        Fail "research queue missing command entry: $needle"
    }
}
Pass "research queue checked"

$promotionLedgerText = Get-FileText "docs/knowledge/promotion-ledger.md"
foreach ($field in @("id", "source", "status", "target", "evidence", "verification", "rollback", "next_action", "updated_at")) {
    if ($promotionLedgerText -notmatch "(?m)^-\s+" + [regex]::Escape($field) + "\s*:") {
        Fail "knowledge promotion ledger missing schema field: $field"
    }
}
foreach ($status in @("raw_note", "curated_note", "verified_knowledge", "archived", "superseded")) {
    if ($promotionLedgerText -notmatch [regex]::Escape($status)) {
        Fail "knowledge promotion ledger missing status enum: $status"
    }
}
Pass "knowledge promotion ledger checked"

$taskAttemptsText = Get-FileText "docs/tasks/attempts.md"
foreach ($field in @("id", "task_id", "status", "checkpoint", "resume_summary", "next_action", "stale_after", "verification", "rollback", "updated_at")) {
    if ($taskAttemptsText -notmatch "(?m)^-\s+" + [regex]::Escape($field) + "\s*:") {
        Fail "task attempts missing schema field: $field"
    }
}
foreach ($status in @("running", "review_needed", "blocked", "done", "cancelled")) {
    if ($taskAttemptsText -notmatch [regex]::Escape($status)) {
        Fail "task attempts missing status enum: $status"
    }
}
Pass "task attempts checked"

$rootFiles = @("README.md", "AGENTS.md", "docs/core/index.md")
foreach ($file in $rootFiles) {
    [void](Require-Path $file)
}
$readme = Get-FileText "README.md"
foreach ($needle in @("delivery-contract.md", "tool-use-budget.md", "external-adoptions.md", "cache status", "git status --short")) {
    if ($readme -notmatch [regex]::Escape($needle)) {
        Fail "README missing key entry: $needle"
    }
}
$agents = Get-FileText "AGENTS.md"
foreach ($needle in @("delivery-contract.md", "tool-use-budget.md", "skill-use-policy.md", "Serena")) {
    if ($agents -notmatch [regex]::Escape($needle)) {
        Fail "AGENTS missing key entry: $needle"
    }
}
$core = Get-FileText "docs/core/index.md"
foreach ($needle in @("delivery-contract.md", "docs/tasks/board.md", "Serena", "real-task-evals.md")) {
    if ($core -notmatch [regex]::Escape($needle)) {
        Fail "core index missing key entry: $needle"
    }
}
Pass "entry documents checked"

try {
    $helpOutput = & (Join-Path $Root "scripts\codex.ps1") help
    $helpText = ($helpOutput -join "`n")
    foreach ($needle in @("git <args>", "cache <name>", "clean-external-repos", "task <name>", "attempt", "knowledge <name>", "promote", "research <name>", "enqueue", "review-gate")) {
        if ($helpText -notmatch [regex]::Escape($needle)) {
            Fail "codex help missing: $needle"
        }
    }
    Pass "codex help checked"
} catch {
    Fail "codex help failed: $($_.Exception.Message)"
}

$hookDoc = Get-FileText "docs/references/assistant/hook-risk-stdin-smoke.md"
foreach ($needle in @("tool_input", "git reset --hard", "stdin")) {
    if ($hookDoc -notmatch [regex]::Escape($needle)) {
        Fail "hook risk stdin smoke doc missing: $needle"
    }
}
Pass "hook stdin smoke doc checked"

$tracked = @(& git -C $Root -c core.quotePath=false ls-files)
$trackedDirs = @($tracked | ForEach-Object {
        $dir = Split-Path ($_ -replace "/", "\") -Parent
        while (-not [string]::IsNullOrWhiteSpace($dir)) {
            $dir
            $dir = Split-Path $dir -Parent
        }
    } | Sort-Object -Unique)

$allDirs = @(Get-ChildItem -LiteralPath $Root -Recurse -Directory -Force -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch '\\\.git(\\|$)' })
$emptyDirs = @($allDirs | Where-Object { @(Get-ChildItem -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0 })
$oneFileDirs = @($allDirs | Where-Object {
        $children = @(Get-ChildItem -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue)
        @($children | Where-Object { -not $_.PSIsContainer }).Count -eq 1 -and @($children | Where-Object { $_.PSIsContainer }).Count -eq 0
    })
$onlyIndexDirs = @($oneFileDirs | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "index.md") })
$skillEmptyDirs = @($emptyDirs | Where-Object { $_.FullName -like (Join-Path $Root ".agents\skills\*") })
$commandScripts = @(Get-ChildItem -LiteralPath (Join-Path $Root "scripts\lib\commands") -Filter "*.ps1" -File -ErrorAction SilentlyContinue)
$topLevelDirs = @(Get-ChildItem -LiteralPath $Root -Directory -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".git" })

$maxDepth = 0
$docsMaxDepth = 0
foreach ($dir in $allDirs) {
    $relative = $dir.FullName.Substring($Root.Length).TrimStart('\')
    if ([string]::IsNullOrWhiteSpace($relative)) { continue }
    $depth = @($relative -split [regex]::Escape([string][System.IO.Path]::DirectorySeparatorChar)).Count
    if ($depth -gt $maxDepth) { $maxDepth = $depth }
    if ($relative -like "docs\*" -and $depth -gt $docsMaxDepth) { $docsMaxDepth = $depth }
}

$cachePath = Join-Path $Root ".cache\external-repos"
$cacheFiles = 0
$cacheDirs = 0
if (Test-Path -LiteralPath $cachePath) {
    $cacheFiles = @(Get-ChildItem -LiteralPath $cachePath -Recurse -File -Force -ErrorAction SilentlyContinue).Count
    $cacheDirs = @(Get-ChildItem -LiteralPath $cachePath -Recurse -Directory -Force -ErrorAction SilentlyContinue).Count
}

Pass ("directory stats tracked_files={0}; tracked_dirs={1}; all_dirs={2}; empty_dirs={3}; one_file_dirs={4}; only_index_dirs={5}; max_depth={6}; docs_max_depth={7}; command_scripts={8}; top_level_dirs={9}; cache_files={10}; cache_dirs={11}" -f $tracked.Count, $trackedDirs.Count, $allDirs.Count, $emptyDirs.Count, $oneFileDirs.Count, $onlyIndexDirs.Count, $maxDepth, $docsMaxDepth, $commandScripts.Count, $topLevelDirs.Count, $cacheFiles, $cacheDirs)

if ($skillEmptyDirs.Count -gt 0) {
    Fail ("empty .agents/skills directories remain: " + (($skillEmptyDirs | ForEach-Object { $_.FullName.Substring($Root.Length + 1) }) -join ", "))
}
if ($cacheFiles -gt 0 -or $cacheDirs -gt 0) {
    Fail (".cache/external-repos is not clean: files=$cacheFiles dirs=$cacheDirs")
}

$results | ForEach-Object { Write-Output $_ }
if ($hasFailure) { exit 1 }
exit 0
