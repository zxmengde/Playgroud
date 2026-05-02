param(
    [Parameter(Position = 0)]
    [string]$Command = "help",

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$RemainingArgs
)

$ErrorActionPreference = "Stop"
if ($null -eq $RemainingArgs) {
    $RemainingArgs = @()
}

$Root = (Resolve-Path "$PSScriptRoot\..").Path
$CommandRoot = Join-Path $PSScriptRoot "lib\commands"
$ObjectLib = Join-Path $PSScriptRoot "lib\self-improvement-object-lib.ps1"

if (Test-Path -LiteralPath $ObjectLib) {
    . $ObjectLib
}

function Get-CommandFile {
    param([Parameter(Mandatory = $true)][string]$Name)
    $path = Join-Path $CommandRoot $Name
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Command implementation missing: scripts/lib/commands/$Name"
    }
    return $path
}

function Invoke-RootCommand {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$CommandArgs = @()
    )
    $global:LASTEXITCODE = 0
    & (Get-CommandFile $Name) -Root $Root @CommandArgs
    if ($null -ne $LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    exit 0
}

function Invoke-PlainCommand {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$CommandArgs = @()
    )
    $global:LASTEXITCODE = 0
    & (Get-CommandFile $Name) @CommandArgs
    if ($null -ne $LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    exit 0
}

function Invoke-RootCommandNoExit {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$CommandArgs = @()
    )
    & (Get-CommandFile $Name) -Root $Root @CommandArgs
}

function Invoke-PlainCommandNoExit {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$CommandArgs = @()
    )
    & (Get-CommandFile $Name) @CommandArgs
}

function Get-Section {
    param(
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$Heading
    )
    $pattern = "(?ms)^## " + [regex]::Escape($Heading) + "\s*\r?\n(.*?)(?=^##\s|\z)"
    $match = [regex]::Match($Content, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ""
}

function Get-LedgerBlocks {
    param([Parameter(Mandatory = $true)][string]$RelativePath)

    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path)) { return @() }
    $content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    $blocks = @()
    foreach ($match in [regex]::Matches($content, "(?ms)^###\s+(.+?)\s*\r?\n(.*?)(?=^###\s|\z)")) {
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

function Show-Help {
    Write-Output "Usage: scripts/codex.ps1 <command> [subcommand]"
    Write-Output ""
    Write-Output "Commands:"
    Write-Output "  doctor              Run readiness checks"
    Write-Output "  audit               Run minimality, references, capability and config audits"
    Write-Output "  validate            Run system validation"
    Write-Output "  eval                Run agent evals"
    Write-Output "  hook <name>         Run project hook implementation"
    Write-Output "  task <name>         check | recover | board | attempt | archive"
    Write-Output "  knowledge <name>    check | new | promote | promotions | obsidian-dry-run"
    Write-Output "  research <name>     state | run-log | queue | enqueue | review-gate | smoke"
    Write-Output "  uiux <name>         smoke"
    Write-Output "  context <name>      budget | pack"
    Write-Output "  capability <name>   map | route <route-id>"
    Write-Output "  cache <name>        status | clean-external-repos"
    Write-Output "  setup <name>        git-hooks | environment"
    Write-Output "  git <args>          Run git through scripts/git-safe.ps1"
}

function Show-TaskRecovery {
    $path = Join-Path $Root "docs\tasks\active.md"
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing docs/tasks/active.md" }
    $content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    $attempts = @(Get-LedgerBlocks -RelativePath "docs\tasks\attempts.md")
    $latestAttempt = $attempts | Select-Object -Last 1
    Write-Output "Task recovery"
    foreach ($heading in @("Status", "Goal", "Next", "Recovery", "Blockers")) {
        Write-Output ""
        Write-Output ("## {0}" -f $heading)
        $section = Get-Section -Content $content -Heading $heading
        if ([string]::IsNullOrWhiteSpace($section)) { $section = "none" }
        Write-Output $section
    }
    if ($null -ne $latestAttempt) {
        Write-Output ""
        Write-Output "## Latest Attempt"
        foreach ($field in @("id", "task_id", "status", "checkpoint", "resume_summary", "next_action", "stale_after", "verification")) {
            if ($latestAttempt.fields.Contains($field)) {
                Write-Output ("{0}: {1}" -f $field, $latestAttempt.fields[$field])
            }
        }
    }
}

function Get-ArgValue {
    param(
        [string[]]$CommandArgs = @(),
        [Parameter(Mandatory = $true)][string]$Name,
        [string]$Default = ""
    )

    for ($i = 0; $i -lt $CommandArgs.Count; $i++) {
        if ($CommandArgs[$i] -eq "-$Name" -and ($i + 1) -lt $CommandArgs.Count) {
            return $CommandArgs[$i + 1]
        }
    }
    return $Default
}

function Append-LedgerBlock {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$Title,
        [Parameter(Mandatory = $true)][System.Collections.Specialized.OrderedDictionary]$Fields
    )

    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing ledger: $RelativePath"
    }
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("")
    $lines.Add(("### {0}" -f $Title))
    foreach ($key in $Fields.Keys) {
        $value = [string]$Fields[$key]
        if ([string]::IsNullOrWhiteSpace($value)) { $value = "unspecified" }
        $lines.Add(("- {0}: {1}" -f $key, $value))
    }
    Add-Content -LiteralPath $path -Value ($lines -join "`r`n") -Encoding UTF8
    Write-Output ("updated {0}: {1}" -f $RelativePath, $Title)
}

function Show-TaskBoard {
    Get-Content -LiteralPath (Join-Path $Root "docs\tasks\board.md") -Raw -Encoding UTF8
}

function Add-TaskAttempt {
    param([string[]]$CommandArgs = @())

    $id = Get-ArgValue -CommandArgs $CommandArgs -Name "Id"
    if ([string]::IsNullOrWhiteSpace($id)) { throw "Task attempt -Id is required." }
    $taskId = Get-ArgValue -CommandArgs $CommandArgs -Name "TaskId" -Default "unspecified"
    $status = Get-ArgValue -CommandArgs $CommandArgs -Name "Status" -Default "running"
    if (@("running", "review_needed", "blocked", "done", "cancelled") -notcontains $status) {
        throw "Invalid task attempt status: $status"
    }

    $fields = [ordered]@{
        id = $id
        task_id = $taskId
        status = $status
        checkpoint = Get-ArgValue -CommandArgs $CommandArgs -Name "Checkpoint" -Default "unspecified"
        resume_summary = Get-ArgValue -CommandArgs $CommandArgs -Name "ResumeSummary" -Default "unspecified"
        next_action = Get-ArgValue -CommandArgs $CommandArgs -Name "NextAction" -Default "unspecified"
        stale_after = Get-ArgValue -CommandArgs $CommandArgs -Name "StaleAfter" -Default "unspecified"
        verification = Get-ArgValue -CommandArgs $CommandArgs -Name "Verification" -Default "unspecified"
        rollback = Get-ArgValue -CommandArgs $CommandArgs -Name "Rollback" -Default "git revert"
        updated_at = (Get-Date).ToString("s")
    }
    Append-LedgerBlock -RelativePath "docs\tasks\attempts.md" -Title $id -Fields $fields
}

function Show-ContextPack {
    if (-not (Get-Command Get-ActiveLoadSummary -ErrorAction SilentlyContinue)) {
        throw "Active load helper is unavailable."
    }
    $summary = Get-ActiveLoadSummary -Root $Root
    Write-Output "Context pack"
    Write-Output ""
    Write-Output "Always load:"
    @($summary.always) | ForEach-Object { Write-Output ("- {0}" -f $_) }
    Write-Output ""
    Write-Output "Open failures:"
    if (@($summary.open_failures).Count -eq 0) {
        Write-Output "- none"
    } else {
        @($summary.open_failures) | ForEach-Object { Write-Output ("- {0}: {1}" -f $_.id, $_.summary) }
    }
    Write-Output ""
    Write-Output "Active lessons:"
    if (@($summary.active_lessons).Count -eq 0) {
        Write-Output "- none"
    } else {
        @($summary.active_lessons) | ForEach-Object { Write-Output ("- {0}: {1}" -f $_.id, $_.title) }
    }
}

function Invoke-ResearchSmoke {
    $statePath = Join-Path $Root "docs\knowledge\research\research-state.yaml"
    $logPath = Join-Path $Root "docs\knowledge\research\run-log.md"
    if (-not (Test-Path -LiteralPath $statePath)) { throw "Missing research state: docs/knowledge/research/research-state.yaml" }
    if (-not (Test-Path -LiteralPath $logPath)) { throw "Missing research run log: docs/knowledge/research/run-log.md" }
    $state = Read-JsonYamlFile -Path $statePath
    foreach ($required in @("question", "hypotheses", "experiments", "evidence_gaps", "next_review")) {
        if (-not ($state.PSObject.Properties.Name -contains $required)) {
            throw "research-state missing field: $required"
        }
    }
    Invoke-RootCommandNoExit -Name "eval-task-quality.ps1" -CommandArgs @("research-memo-quality")
    Write-Output "research smoke: pass"
}

function Invoke-UiuxSmoke {
    $sample = Join-Path $Root "docs\validation\system-improvement\uiux-review-sample.md"
    if (-not (Test-Path -LiteralPath $sample)) { throw "Missing UI/UX sample." }
    Invoke-RootCommandNoExit -Name "eval-task-quality.ps1" -CommandArgs @("uiux-review-quality")
    Write-Output "uiux smoke: pass"
}

function Add-KnowledgePromotion {
    param([string[]]$CommandArgs = @())

    $id = Get-ArgValue -CommandArgs $CommandArgs -Name "Id"
    if ([string]::IsNullOrWhiteSpace($id)) { throw "Knowledge promote -Id is required." }
    $status = Get-ArgValue -CommandArgs $CommandArgs -Name "Status" -Default "curated_note"
    if (@("raw_note", "curated_note", "verified_knowledge", "archived", "superseded") -notcontains $status) {
        throw "Invalid knowledge promotion status: $status"
    }
    $target = Get-ArgValue -CommandArgs $CommandArgs -Name "Target" -Default "repository"
    if (@("repository", "obsidian_ready", "archive") -notcontains $target) {
        throw "Invalid knowledge promotion target: $target"
    }

    $fields = [ordered]@{
        id = $id
        source = Get-ArgValue -CommandArgs $CommandArgs -Name "Source" -Default "unspecified"
        status = $status
        target = $target
        evidence = Get-ArgValue -CommandArgs $CommandArgs -Name "Evidence" -Default "unspecified"
        verification = Get-ArgValue -CommandArgs $CommandArgs -Name "Verification" -Default "scripts/codex.ps1 knowledge check"
        rollback = Get-ArgValue -CommandArgs $CommandArgs -Name "Rollback" -Default "git revert"
        next_action = Get-ArgValue -CommandArgs $CommandArgs -Name "NextAction" -Default "unspecified"
        updated_at = (Get-Date).ToString("s")
    }
    Append-LedgerBlock -RelativePath "docs\knowledge\promotion-ledger.md" -Title $id -Fields $fields
}

function Show-KnowledgePromotions {
    Get-Content -LiteralPath (Join-Path $Root "docs\knowledge\promotion-ledger.md") -Raw -Encoding UTF8
}

function Show-ResearchQueue {
    Get-Content -LiteralPath (Join-Path $Root "docs\knowledge\research\research-queue.md") -Raw -Encoding UTF8
}

function Add-ResearchQueueItem {
    param([string[]]$CommandArgs = @())

    $id = Get-ArgValue -CommandArgs $CommandArgs -Name "Id"
    if ([string]::IsNullOrWhiteSpace($id)) { throw "Research enqueue -Id is required." }
    $state = Get-ArgValue -CommandArgs $CommandArgs -Name "State" -Default "queued"
    if (@("queued", "running", "review_needed", "blocked", "done", "cancelled") -notcontains $state) {
        throw "Invalid research queue state: $state"
    }

    $fields = [ordered]@{
        id = $id
        source = Get-ArgValue -CommandArgs $CommandArgs -Name "Source" -Default "manual"
        question = Get-ArgValue -CommandArgs $CommandArgs -Name "Question" -Default "unspecified"
        state = $state
        evidence_quality = Get-ArgValue -CommandArgs $CommandArgs -Name "EvidenceQuality" -Default "unchecked"
        review_gate = Get-ArgValue -CommandArgs $CommandArgs -Name "ReviewGate" -Default "manual review before claim"
        run_log = Get-ArgValue -CommandArgs $CommandArgs -Name "RunLog" -Default "docs/knowledge/research/run-log.md"
        interruption_recovery = Get-ArgValue -CommandArgs $CommandArgs -Name "InterruptionRecovery" -Default "use queue item and run log"
        user_authorization_boundary = Get-ArgValue -CommandArgs $CommandArgs -Name "Authorization" -Default "no external write"
        next_action = Get-ArgValue -CommandArgs $CommandArgs -Name "NextAction" -Default "review queue"
        rollback = Get-ArgValue -CommandArgs $CommandArgs -Name "Rollback" -Default "git revert"
        updated_at = (Get-Date).ToString("s")
    }
    Append-LedgerBlock -RelativePath "docs\knowledge\research\research-queue.md" -Title $id -Fields $fields
}

function Add-ResearchReviewGate {
    param([string[]]$CommandArgs = @())

    $id = Get-ArgValue -CommandArgs $CommandArgs -Name "Id"
    if ([string]::IsNullOrWhiteSpace($id)) { throw "Research review-gate -Id is required." }
    $fields = [ordered]@{
        id = $id
        decision = Get-ArgValue -CommandArgs $CommandArgs -Name "Decision" -Default "review_needed"
        evidence_quality = Get-ArgValue -CommandArgs $CommandArgs -Name "EvidenceQuality" -Default "unchecked"
        reviewer = Get-ArgValue -CommandArgs $CommandArgs -Name "Reviewer" -Default "codex"
        next_action = Get-ArgValue -CommandArgs $CommandArgs -Name "NextAction" -Default "manual review"
        updated_at = (Get-Date).ToString("s")
    }
    Append-LedgerBlock -RelativePath "docs\knowledge\research\run-log.md" -Title ("review-gate " + $id) -Fields $fields
}

function Invoke-ObsidianDryRun {
    $cmd = Get-Command obsidian -ErrorAction SilentlyContinue
    if ($null -eq $cmd) { throw "obsidian CLI is not available." }
    Write-Output ("obsidian: {0}" -f $cmd.Source)
    $vaultCount = & obsidian vaults total
    Write-Output ("vaults total: {0}" -f ($vaultCount -join " "))
    $searchCount = & obsidian vault=790d1fd6473f4a93 search query="Zotero" total
    Write-Output ("dry-run search count: {0}" -f ($searchCount -join " "))
    Write-Output "knowledge obsidian dry-run: pass"
}

function Show-CapabilityMap {
    $path = Join-Path $Root "docs\capabilities\capability-map.yaml"
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing docs/capabilities/capability-map.yaml" }
    $map = Read-JsonYamlFile -Path $path
    Write-Output ("capabilities: {0}" -f @($map.capabilities).Count)
    @($map.capabilities) | ForEach-Object {
        Write-Output ("- {0}: {1}; entry={2}" -f $_.id, $_.maturity_status, $_.user_visible_entry)
    }
}

function Show-Route {
    param([string]$RouteId)
    if ([string]::IsNullOrWhiteSpace($RouteId)) { throw "Route id is required." }
    $routing = Read-JsonYamlFile -Path (Join-Path $Root "docs\knowledge\system-improvement\routing-v1.yaml")
    $route = @($routing.routes | Where-Object { $_.id -eq $RouteId }) | Select-Object -First 1
    if ($null -eq $route) { throw "Route not found: $RouteId" }
    Write-Output ("route: {0}" -f $route.id)
    Write-Output ("domain: {0}" -f $route.domain)
    Write-Output ("phase: {0}" -f $route.phase)
    Write-Output ("skills: {0}" -f (@($route.recommended_skills) -join ", "))
    Write-Output ("mcps: {0}" -f (@($route.recommended_mcps) -join ", "))
}

function Get-ExternalRepoCachePath {
    return (Join-Path $Root ".cache\external-repos")
}

function Show-CacheStatus {
    $path = Get-ExternalRepoCachePath
    Write-Output "Cache status"
    Write-Output ("external_repos_path: {0}" -f $path)
    if (-not (Test-Path -LiteralPath $path)) {
        Write-Output "external_repos_state: absent"
        Write-Output "external_repos_files: 0"
        Write-Output "external_repos_directories: 0"
        return
    }

    $files = @(Get-ChildItem -LiteralPath $path -Recurse -File -Force -ErrorAction SilentlyContinue)
    $dirs = @(Get-ChildItem -LiteralPath $path -Recurse -Directory -Force -ErrorAction SilentlyContinue)
    Write-Output "external_repos_state: present"
    Write-Output ("external_repos_files: {0}" -f $files.Count)
    Write-Output ("external_repos_directories: {0}" -f $dirs.Count)
}

function Clear-ExternalRepoCache {
    $path = Get-ExternalRepoCachePath
    if (-not (Test-Path -LiteralPath $path)) {
        Write-Output "external repo cache already absent"
        return
    }

    $resolvedRoot = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\')
    $resolvedTarget = (Resolve-Path -LiteralPath $path).Path.TrimEnd('\')
    if (-not ($resolvedTarget.StartsWith($resolvedRoot, [System.StringComparison]::OrdinalIgnoreCase))) {
        throw "Refusing to delete outside repository: $resolvedTarget"
    }
    if ($resolvedTarget -notlike "*\.cache\external-repos") {
        throw "Refusing to delete unexpected cache path: $resolvedTarget"
    }

    Remove-Item -LiteralPath $resolvedTarget -Recurse -Force
    Write-Output "external repo cache removed"
}

switch ($Command.ToLowerInvariant()) {
    "help" { Show-Help }
    "doctor" { Invoke-RootCommand "check-agent-readiness.ps1" $RemainingArgs }
    "readiness" { Invoke-RootCommand "check-agent-readiness.ps1" $RemainingArgs }
    "audit" {
        if ($RemainingArgs.Count -gt 0) {
            $name = $RemainingArgs[0]
            $subArgs = @($RemainingArgs | Select-Object -Skip 1)
            switch ($name) {
                "minimality" { Invoke-RootCommand "audit-minimality.ps1" $subArgs }
                "usage" { Invoke-RootCommand "audit-file-usage.ps1" $subArgs }
                "references" { Invoke-RootCommand "audit-active-references.ps1" $subArgs }
                "capabilities" { Invoke-PlainCommand "audit-codex-capabilities.ps1" $subArgs }
                "mcp" { Invoke-PlainCommand "audit-mcp-config.ps1" $subArgs }
                "mcp-readiness" { Invoke-RootCommand "audit-serena-obsidian-readiness.ps1" $subArgs }
                default { throw "Unknown audit subcommand: $name" }
            }
        }
        Invoke-RootCommandNoExit "audit-minimality.ps1"
        Invoke-RootCommandNoExit "audit-file-usage.ps1"
        Invoke-RootCommandNoExit "audit-active-references.ps1"
        Invoke-PlainCommandNoExit "audit-codex-capabilities.ps1"
        Invoke-PlainCommandNoExit "audit-mcp-config.ps1"
        Invoke-RootCommandNoExit "audit-automation-config.ps1"
        Write-Output "audit suite: pass"
    }
    "validate" { Invoke-RootCommand "validate-system.ps1" $RemainingArgs }
    "eval" {
        if ($RemainingArgs.Count -gt 0 -and $RemainingArgs[0] -eq "failure-loop") {
            Invoke-RootCommandNoExit "eval-repeat-failure-capture.ps1"
            Invoke-RootCommandNoExit "eval-lesson-promotion.ps1"
            Write-Output "failure-loop eval: pass"
        } elseif ($RemainingArgs.Count -gt 0) {
            $name = $RemainingArgs[0]
            if (@("external-mechanism-review-check", "research-memo-quality", "uiux-review-quality", "product-engineering-closeout") -contains $name) {
                Invoke-RootCommand -Name "eval-task-quality.ps1" -CommandArgs @($name)
            } else {
                $scriptName = "eval-$name.ps1"
                Invoke-RootCommand $scriptName (@($RemainingArgs | Select-Object -Skip 1))
            }
        } else {
            Invoke-RootCommand "eval-agent-system.ps1"
        }
    }
    "hook" {
        if ($RemainingArgs.Count -eq 0) { throw "Hook name is required." }
        $hook = $RemainingArgs[0]
        $subArgs = @($RemainingArgs | Select-Object -Skip 1)
        switch ($hook) {
            "risk" { Invoke-PlainCommand "codex-hook-risk-check.ps1" $subArgs }
            "session-start" { Invoke-RootCommand "codex-hook-session-start.ps1" $subArgs }
            "post-tool-capture" { Invoke-RootCommand "codex-hook-post-tool-capture.ps1" $subArgs }
            "stop-check" { Invoke-RootCommand "codex-hook-stop-check.ps1" $subArgs }
            default { throw "Unknown hook: $hook" }
        }
    }
    "task" {
        if ($RemainingArgs.Count -eq 0) { Invoke-RootCommand "check-task-state.ps1" }
        $task = $RemainingArgs[0]
        $subArgs = @($RemainingArgs | Select-Object -Skip 1)
        switch ($task) {
            "check" { Invoke-RootCommand "check-task-state.ps1" $subArgs }
            "recover" { Show-TaskRecovery }
            "board" { Show-TaskBoard }
            "attempt" { Add-TaskAttempt -CommandArgs $subArgs }
            "archive" { Invoke-RootCommand "archive-task-state.ps1" $subArgs }
            default { throw "Unknown task subcommand: $task" }
        }
    }
    "knowledge" {
        if ($RemainingArgs.Count -eq 0) { Invoke-RootCommand "validate-knowledge-index.ps1" }
        $name = $RemainingArgs[0]
        $subArgs = @($RemainingArgs | Select-Object -Skip 1)
        switch ($name) {
            "check" { Invoke-RootCommand "validate-knowledge-index.ps1" $subArgs }
            "new" { Invoke-PlainCommand "new-knowledge-item.ps1" $subArgs }
            "promote" { Add-KnowledgePromotion -CommandArgs $subArgs }
            "promotions" { Show-KnowledgePromotions }
            "obsidian-dry-run" { Invoke-ObsidianDryRun }
            default { throw "Unknown knowledge subcommand: $name" }
        }
    }
    "research" {
        if ($RemainingArgs.Count -eq 0) { Invoke-ResearchSmoke }
        $name = $RemainingArgs[0]
        switch ($name) {
            "state" { Get-Content -LiteralPath (Join-Path $Root "docs\knowledge\research\research-state.yaml") -Raw -Encoding UTF8 }
            "run-log" { Get-Content -LiteralPath (Join-Path $Root "docs\knowledge\research\run-log.md") -Raw -Encoding UTF8 }
            "queue" { Show-ResearchQueue }
            "enqueue" { Add-ResearchQueueItem -CommandArgs (@($RemainingArgs | Select-Object -Skip 1)) }
            "review-gate" { Add-ResearchReviewGate -CommandArgs (@($RemainingArgs | Select-Object -Skip 1)) }
            "smoke" { Invoke-ResearchSmoke }
            default { throw "Unknown research subcommand: $name" }
        }
    }
    "uiux" {
        if ($RemainingArgs.Count -eq 0 -or $RemainingArgs[0] -eq "smoke") { Invoke-UiuxSmoke } else { throw "Unknown uiux subcommand: $($RemainingArgs[0])" }
    }
    "context" {
        if ($RemainingArgs.Count -eq 0) { Invoke-RootCommand "validate-active-load.ps1" }
        switch ($RemainingArgs[0]) {
            "budget" { Invoke-RootCommand "validate-active-load.ps1" (@($RemainingArgs | Select-Object -Skip 1)) }
            "pack" { Show-ContextPack }
            default { throw "Unknown context subcommand: $($RemainingArgs[0])" }
        }
    }
    "capability" {
        if ($RemainingArgs.Count -eq 0 -or $RemainingArgs[0] -eq "map") { Show-CapabilityMap }
        elseif ($RemainingArgs[0] -eq "route") { Show-Route -RouteId $RemainingArgs[1] }
        else { throw "Unknown capability subcommand: $($RemainingArgs[0])" }
    }
    "cache" {
        if ($RemainingArgs.Count -eq 0 -or $RemainingArgs[0] -eq "status") { Show-CacheStatus }
        elseif ($RemainingArgs[0] -eq "clean-external-repos") { Clear-ExternalRepoCache }
        else { throw "Unknown cache subcommand: $($RemainingArgs[0])" }
    }
    "setup" {
        if ($RemainingArgs.Count -eq 0) { throw "Setup subcommand is required." }
        $name = $RemainingArgs[0]
        $subArgs = @($RemainingArgs | Select-Object -Skip 1)
        switch ($name) {
            "git-hooks" { Invoke-RootCommand "install-git-hooks.ps1" $subArgs }
            "environment" { Invoke-PlainCommand "setup-codex-environment.ps1" $subArgs }
            default { throw "Unknown setup subcommand: $name" }
        }
    }
    "git" {
        & (Join-Path $PSScriptRoot "git-safe.ps1") @RemainingArgs
        exit $LASTEXITCODE
    }
    default { throw "Unknown command: $Command. Run scripts/codex.ps1 help." }
}
