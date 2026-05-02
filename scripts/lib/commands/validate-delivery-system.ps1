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

function Get-H2Section {
    param([string]$Content, [string]$Heading)
    $pattern = "(?ms)^##\s+" + [regex]::Escape($Heading) + "\s*\r?\n(.*?)(?=^##\s|\z)"
    $match = [regex]::Match($Content, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ""
}

function Get-FieldValue {
    param([string]$Text, [string]$Field)
    $match = [regex]::Match($Text, "(?m)^" + [regex]::Escape($Field) + "\s*:\s*(.*)\s*$")
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ""
}

function Get-BacktickValues {
    param([string]$Text)
    $values = @()
    foreach ($match in [regex]::Matches($Text, '`([^`]+)`')) {
        $values += $match.Groups[1].Value.Trim()
    }
    return $values
}

function Normalize-ReferencePath {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return "" }
    $candidate = $Value.Trim()
    if ($candidate -match '^https?://') { return "" }
    $candidate = ($candidate -split '\s+')[0]
    $candidate = ($candidate -split '\|')[0]
    $candidate = ($candidate -split '#')[0]
    $candidate = $candidate.Trim(" `t`r`n;,.。'")
    if ($candidate -notmatch '^(docs|scripts|templates|\.agents|\.codex|README\.md|AGENTS\.md)') {
        return ""
    }
    return ($candidate -replace "\\", "/")
}

function Test-ReferenceExists {
    param([string]$Value)
    $relative = Normalize-ReferencePath $Value
    if ([string]::IsNullOrWhiteSpace($relative)) { return $false }
    $full = Join-Path $Root ($relative -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    return (Test-Path -LiteralPath $full)
}

function Get-ReferencePaths {
    param([string]$Text)
    $rawValues = @(Get-BacktickValues $Text)
    if ($rawValues.Count -eq 0) {
        $rawValues = @($Text -split ';' | ForEach-Object { $_.Trim() })
    }
    $paths = @()
    foreach ($value in $rawValues) {
        $relative = Normalize-ReferencePath $value
        if (-not [string]::IsNullOrWhiteSpace($relative)) { $paths += $relative }
    }
    return @($paths | Sort-Object -Unique)
}

function Test-SelfOnlyEvidence {
    param([string]$EvidenceText)
    $selfPaths = @(
        "docs/capabilities/external-adoptions.md",
        "docs/capabilities/capability-map.yaml",
        "docs/knowledge/promotion-ledger.md",
        "docs/tasks/attempts.md",
        "scripts/lib/commands/validate-delivery-system.ps1"
    )
    $paths = @(Get-ReferencePaths $EvidenceText)
    if ($paths.Count -eq 0) { return $true }
    foreach ($path in $paths) {
        if ($selfPaths -notcontains $path) { return $false }
    }
    return $true
}

function Test-UserEntryDiscoverable {
    param([string]$Entry, [string]$HelpText)
    if ([string]::IsNullOrWhiteSpace($Entry)) { return $false }
    foreach ($value in @(Get-BacktickValues $Entry)) {
        if (Test-ReferenceExists $value) { return $true }
        foreach ($commandName in @("task", "knowledge", "research", "capability", "cache", "git", "doctor", "validate", "eval")) {
            if ($value -match ("(^|\\s)" + [regex]::Escape($commandName) + "(\\s|$)") -and $HelpText -match [regex]::Escape($commandName)) {
                return $true
            }
        }
    }
    return ($Entry -match "docs/workflows|docs/core|scripts/codex.ps1")
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

function Extract-FirstTaskId {
    param([string]$Text)
    $match = [regex]::Match($Text, 'TASK-\d{8}-[A-Za-z0-9-]+')
    if ($match.Success) { return $match.Value }
    return ""
}

$requiredPaths = @(
    "docs/core/delivery-contract.md",
    "docs/core/adoption-proof-standard.md",
    "docs/core/tool-use-budget.md",
    "docs/core/skill-use-policy.md",
    "docs/core/context-modes.md",
    "docs/core/typed-object-registry.md",
    "docs/capabilities/external-adoptions.md",
    "docs/validation/real-task-evals.md",
    "docs/validation/adoption-proof-fixtures.md",
    "docs/tasks/board.md",
    "docs/tasks/attempts.md",
    "docs/knowledge/promotion-ledger.md",
    "docs/knowledge/research/research-queue.md",
    "docs/knowledge/research/run-log.md",
    "docs/references/assistant/hook-risk-stdin-smoke.md"
)
foreach ($path in $requiredPaths) { [void](Require-Path $path) }

$helpOutput = @()
$helpText = ""
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
$allowedAdoptionStatus = @("documented", "command_stub", "smoke_passed", "partial", "integration_tested", "task_used", "user_confirmed", "deprecated")
$highProofStatus = @("integration_tested", "task_used", "user_confirmed")
$requiredCardFields = @(
    "source_project",
    "status",
    "inspected_evidence",
    "learned_mechanism",
    "local_artifact",
    "trigger_condition",
    "codex_behavior_delta",
    "user_visible_entry",
    "evidence",
    "integration_proof",
    "verification",
    "rollback",
    "prevents_past_error"
)
$highProofCount = 0
foreach ($project in $projects) {
    $card = Get-H2Section -Content $cardsText -Heading $project
    if ([string]::IsNullOrWhiteSpace($card)) {
        Fail "external adoption card missing: $project"
        continue
    }

    foreach ($field in $requiredCardFields) {
        if ($card -notmatch "(?m)^" + [regex]::Escape($field) + "\s*:") {
            Fail "external adoption card $project missing field: $field"
        }
    }

    $status = Get-FieldValue -Text $card -Field "status"
    if ([string]::IsNullOrWhiteSpace($status)) {
        Fail "external adoption card $project missing parseable status"
        continue
    }
    $cardStatuses[$project] = $status
    if ($allowedAdoptionStatus -notcontains $status) {
        Fail "external adoption card $project invalid proof status: $status"
    }
    if ($status -eq "adopted" -or $status -eq "rejected_with_substitute") {
        Fail "external adoption card $project uses retired status: $status"
    }

    if ($highProofStatus -contains $status) {
        $highProofCount += 1
        foreach ($field in @("trigger_condition", "codex_behavior_delta", "user_visible_entry", "evidence", "integration_proof", "verification", "rollback", "prevents_past_error")) {
            if ([string]::IsNullOrWhiteSpace((Get-FieldValue -Text $card -Field $field))) {
                Fail "external adoption card $project high proof status missing non-empty $field"
            }
        }

        $artifactText = Get-FieldValue -Text $card -Field "local_artifact"
        $artifactExists = $false
        foreach ($value in @(Get-BacktickValues $artifactText)) {
            if (Test-ReferenceExists $value) { $artifactExists = $true }
        }
        if (-not $artifactExists) { Fail "external adoption card $project has no existing local artifact path" }

        $entry = Get-FieldValue -Text $card -Field "user_visible_entry"
        if (-not (Test-UserEntryDiscoverable -Entry $entry -HelpText $helpText)) {
            Fail "external adoption card $project user_visible_entry is not discoverable"
        }

        $evidence = Get-FieldValue -Text $card -Field "evidence"
        if (Test-SelfOnlyEvidence -EvidenceText $evidence) {
            Fail "external adoption card $project evidence is self-referential only"
        }

        $proof = Get-FieldValue -Text $card -Field "integration_proof"
        if ($proof -notmatch "docs/validation/adoption-proof-fixtures.md|scripts/codex.ps1|check-finish-readiness.ps1|run-log.md|validate-delivery-system.ps1") {
            Fail "external adoption card $project missing recognizable integration proof"
        }
    }
}
if ($highProofCount -lt 4) {
    Fail "external adoption high-proof mechanisms below minimum: $highProofCount < 4"
} else {
    Pass "external adoption proof statuses checked high_proof=$highProofCount"
}

foreach ($project in @("obsidian-skills", "vibe-kanban", "Auto-claude-code-research-in-sleep")) {
    if ($cardStatuses[$project] -ne "integration_tested" -and $cardStatuses[$project] -ne "task_used" -and $cardStatuses[$project] -ne "user_confirmed") {
        Fail "required external mechanism lacks integration proof status: $project status=$($cardStatuses[$project])"
    }
}

$capabilityPath = Join-Path $Root "docs\capabilities\capability-map.yaml"
try {
    $capabilityMap = Read-JsonYamlFile -Path $capabilityPath
    $allowedMaturity = @("documented", "command_stub", "smoke_passed", "partial", "integration_tested", "task_used", "user_confirmed", "deprecated")
    $boundProjects = New-Object System.Collections.Generic.HashSet[string]
    foreach ($enumValue in @($capabilityMap.maturity_status_enum)) {
        if ($allowedMaturity -notcontains $enumValue) { Fail "capability maturity enum contains retired value: $enumValue" }
    }
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

$proofStandard = Get-FileText "docs/core/adoption-proof-standard.md"
foreach ($needle in @("integration_tested", "self", "adopted", "command_stub", "validator", "prevents_past_error")) {
    if ($proofStandard -notmatch [regex]::Escape($needle)) {
        Fail "adoption proof standard missing: $needle"
    }
}
Pass "adoption proof standard checked"

$fixtureText = Get-FileText "docs/validation/adoption-proof-fixtures.md"
foreach ($needle in @(
        "Positive Knowledge Promotion",
        "raw_note -> curated_note -> verified_knowledge",
        "Positive Task Attempt Lifecycle",
        "running -> review_needed -> done",
        "Positive Research Queue Lifecycle",
        "queued -> review_gate -> blocked",
        "self-referential-adoption-evidence",
        "open-attempt-final-claim",
        "queue-without-review-gate"
    )) {
    if ($fixtureText -notmatch [regex]::Escape($needle)) {
        Fail "adoption proof fixture missing: $needle"
    }
}
$negativeEvidence = Get-H2Section -Content $fixtureText -Heading "Expected Failure Cases"
if ($negativeEvidence -notmatch "self-referential-adoption-evidence" -or -not (Test-SelfOnlyEvidence -EvidenceText $negativeEvidence)) {
    Fail "fixture self-referential failure case is not recognized"
}
if ($fixtureText -notmatch "queue-without-review-gate(?s).*expected_result:\s*fail") {
    Fail "fixture missing queue without review gate failure expectation"
}
Pass "adoption proof fixtures checked"

$evalText = Get-FileText "docs/validation/real-task-evals.md"
$evalNames = @("writing-revision-eval", "python-package-delivery-eval", "ui-change-eval", "repo-maintenance-eval")
$evalFields = @("task_input", "expected_user_outcome", "hidden_obligations", "required_artifacts", "required_verification", "common_failure_modes", "pass_conditions", "fail_conditions", "evidence_required", "rollback_or_recovery")
foreach ($evalName in $evalNames) {
    $section = Get-H2Section -Content $evalText -Heading $evalName
    if ([string]::IsNullOrWhiteSpace($section)) {
        Fail "real task eval missing: $evalName"
        continue
    }
    foreach ($field in $evalFields) {
        if ($section -notmatch "(?m)^" + [regex]::Escape($field) + "\s*:") {
            Fail "real task eval $evalName missing field: $field"
        }
    }
}
if ($evalText -match "adopted/partial|task_proven|user_proven") {
    Fail "real task eval still uses retired adoption or maturity status"
}
Pass "real task eval specs checked"

$promotionLedgerText = Get-FileText "docs/knowledge/promotion-ledger.md"
$promotionBlocks = @(Get-LedgerBlocks $promotionLedgerText)
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
$promotionStatuses = @($promotionBlocks | ForEach-Object { Get-BlockField $_ "status" })
$hasPromotionLifecycle = ($promotionStatuses -contains "raw_note") -and (($promotionStatuses -contains "curated_note") -or ($promotionStatuses -contains "verified_knowledge"))
$hasVerifiedOrObsidianReady = $false
$hasNonSelfPromotionEvidence = $false
foreach ($block in $promotionBlocks) {
    $evidence = Get-BlockField $block "evidence"
    if (-not (Test-SelfOnlyEvidence -EvidenceText $evidence)) { $hasNonSelfPromotionEvidence = $true }
    if ((Get-BlockField $block "status") -eq "verified_knowledge" -or (Get-BlockField $block "target") -eq "obsidian_ready") {
        $hasVerifiedOrObsidianReady = $true
        if (Test-SelfOnlyEvidence -EvidenceText $evidence) {
            Fail "knowledge promotion proof $($block.title) uses self-referential evidence only"
        }
    }
}
if (-not $hasPromotionLifecycle) { Fail "knowledge promotion ledger lacks raw_note -> curated/verified lifecycle proof" }
if (-not $hasVerifiedOrObsidianReady) { Fail "knowledge promotion ledger lacks verified_knowledge or obsidian_ready proof" }
if (-not $hasNonSelfPromotionEvidence) { Fail "knowledge promotion ledger lacks non-self evidence" }
Pass "knowledge promotion ledger checked"

$taskAttemptsText = Get-FileText "docs/tasks/attempts.md"
$attemptBlocks = @(Get-LedgerBlocks $taskAttemptsText)
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
$latestAttempt = $attemptBlocks | Select-Object -Last 1
$latestAttemptStatus = Get-BlockField $latestAttempt "status"
$latestAttemptTaskId = Get-BlockField $latestAttempt "task_id"
$terminalAttemptCount = @($attemptBlocks | Where-Object { @("done", "blocked", "cancelled") -contains (Get-BlockField $_ "status") }).Count
if ($terminalAttemptCount -lt 1) { Fail "task attempts lack terminal lifecycle example" }

$activeText = Get-FileText "docs/tasks/active.md"
$activeStatus = Get-H2Section -Content $activeText -Heading "Status"
$activeNext = Get-H2Section -Content $activeText -Heading "Next"
$activeUnverified = Get-H2Section -Content $activeText -Heading "Unverified"
$activeTaskId = Extract-FirstTaskId $activeText
$boardText = Get-FileText "docs/tasks/board.md"
$boardTaskMatch = [regex]::Match($boardText, '(?m)^-\s+task_id:\s*(TASK-\d{8}-[A-Za-z0-9-]+)\s*$')
$boardTaskId = ""
if ($boardTaskMatch.Success) { $boardTaskId = $boardTaskMatch.Groups[1].Value }
if (-not [string]::IsNullOrWhiteSpace($activeTaskId) -and -not [string]::IsNullOrWhiteSpace($boardTaskId) -and $activeTaskId -ne $boardTaskId) {
    Fail "active task id and board task id conflict: active=$activeTaskId board=$boardTaskId"
}
if (@("running", "review_needed") -contains $latestAttemptStatus -and -not [string]::IsNullOrWhiteSpace($latestAttemptTaskId) -and $latestAttemptTaskId -ne $activeTaskId) {
    Fail "latest open attempt does not match active task: attempt=$latestAttemptTaskId active=$activeTaskId"
}
if (@("running", "review_needed") -contains $latestAttemptStatus -and $activeStatus -match "completed|pushed|final claim") {
    Fail "latest attempt is open but active status claims completion"
}
if ($activeStatus -match "completed|pushed|final claim" -and ($activeUnverified -match "pending|unverified" -or $activeNext -match "commit|push|validate|eval|strict|diff")) {
    Fail "active task has final claim but still contains unfinished validation or push next action"
}

try {
    $recoverOutput = & (Join-Path $Root "scripts\codex.ps1") task recover
    $recoverText = ($recoverOutput -join "`n")
    if (-not [string]::IsNullOrWhiteSpace((Get-BlockField $latestAttempt "id")) -and $recoverText -notmatch [regex]::Escape((Get-BlockField $latestAttempt "id"))) {
        Fail "task recover does not include latest attempt id"
    }
    $latestNext = Get-BlockField $latestAttempt "next_action"
    if (@("running", "review_needed", "blocked") -contains $latestAttemptStatus -and -not [string]::IsNullOrWhiteSpace($latestNext) -and $recoverText -notmatch [regex]::Escape($latestNext)) {
        Fail "task recover does not include latest attempt next_action"
    }
    Pass "task attempts and recovery checked"
} catch {
    Fail "task recover failed: $($_.Exception.Message)"
}

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

$researchQueueText = Get-FileText "docs/knowledge/research/research-queue.md"
$runLogText = Get-FileText "docs/knowledge/research/run-log.md"
$queueBlocks = @(Get-LedgerBlocks $researchQueueText)
foreach ($field in @("id", "source", "question", "state", "evidence_quality", "review_gate", "run_log", "interruption_recovery", "user_authorization_boundary", "next_action", "rollback")) {
    if ($researchQueueText -notmatch "(?m)^-\s+" + [regex]::Escape($field) + "\s*:") {
        Fail "research queue missing field: $field"
    }
}
foreach ($needle in @("research enqueue", "research review-gate", "research run-log", "no background service", "unattended service")) {
    if ($researchQueueText -notmatch [regex]::Escape($needle)) {
        Fail "research queue missing policy or command text: $needle"
    }
}
$queueLifecycleProof = $false
foreach ($block in $queueBlocks) {
    $id = Get-BlockField $block "id"
    $state = Get-BlockField $block "state"
    $reviewGate = Get-BlockField $block "review_gate"
    $runLog = Get-BlockField $block "run_log"
    if (@("done", "blocked") -contains $state) {
        if ([string]::IsNullOrWhiteSpace($reviewGate)) {
            Fail "research queue item $id terminal state lacks review_gate"
        }
        if ([string]::IsNullOrWhiteSpace($runLog) -or -not (Test-ReferenceExists $runLog)) {
            Fail "research queue item $id has missing run_log path"
        }
        if ($runLogText -match [regex]::Escape($id) -and $runLogText -match "review-gate") {
            $queueLifecycleProof = $true
        }
    }
}
if (-not $queueLifecycleProof) { Fail "research queue lacks enqueue -> review_gate -> done/blocked lifecycle proof" }
Pass "research queue checked"

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
foreach ($needle in @("adopted_mechanism_default_load", "trigger_to_skill_eval_lesson_loop", "knowledge-promotion-lifecycle", "task-board-session-recovery", "research-queue-review-gate", "integration_tested")) {
    if ($skillPolicyText -notmatch [regex]::Escape($needle)) {
        Fail "skill use policy missing adopted mechanism rule: $needle"
    }
}
Pass "skill use policy checked"

$rootFiles = @("README.md", "AGENTS.md", "docs/core/index.md")
foreach ($file in $rootFiles) { [void](Require-Path $file) }
$readme = Get-FileText "README.md"
foreach ($needle in @("delivery-contract.md", "adoption-proof-standard.md", "external-adoptions.md", "cache status", "git status --short")) {
    if ($readme -notmatch [regex]::Escape($needle)) {
        Fail "README missing key entry: $needle"
    }
}
$agents = Get-FileText "AGENTS.md"
foreach ($needle in @("delivery-contract.md", "adoption-proof-standard.md", "skill-use-policy.md", "Serena")) {
    if ($agents -notmatch [regex]::Escape($needle)) {
        Fail "AGENTS missing key entry: $needle"
    }
}
$core = Get-FileText "docs/core/index.md"
foreach ($needle in @("delivery-contract.md", "adoption-proof-standard.md", "adoption-proof-fixtures.md", "docs/tasks/board.md", "Serena", "real-task-evals.md")) {
    if ($core -notmatch [regex]::Escape($needle)) {
        Fail "core index missing key entry: $needle"
    }
}
Pass "entry documents checked"

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
