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
        [string[]]$Args = @()
    )
    $global:LASTEXITCODE = 0
    & (Get-CommandFile $Name) -Root $Root @Args
    if ($null -ne $LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    exit 0
}

function Invoke-PlainCommand {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$Args = @()
    )
    $global:LASTEXITCODE = 0
    & (Get-CommandFile $Name) @Args
    if ($null -ne $LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    exit 0
}

function Invoke-RootCommandNoExit {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$Args = @()
    )
    & (Get-CommandFile $Name) -Root $Root @Args
}

function Invoke-PlainCommandNoExit {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$Args = @()
    )
    & (Get-CommandFile $Name) @Args
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

function Show-Help {
    Write-Output "Usage: scripts/codex.ps1 <command> [subcommand]"
    Write-Output ""
    Write-Output "Commands:"
    Write-Output "  doctor              Run readiness checks"
    Write-Output "  audit               Run minimality, references, capability and config audits"
    Write-Output "  validate            Run system validation"
    Write-Output "  eval                Run agent evals"
    Write-Output "  hook <name>         Run project hook implementation"
    Write-Output "  task <name>         check | recover | archive"
    Write-Output "  knowledge <name>    check | new | obsidian-dry-run"
    Write-Output "  research <name>     state | run-log | smoke"
    Write-Output "  uiux <name>         smoke"
    Write-Output "  context <name>      budget | pack"
    Write-Output "  capability <name>   map | route <route-id>"
    Write-Output "  setup <name>        git-hooks | environment"
}

function Show-TaskRecovery {
    $path = Join-Path $Root "docs\tasks\active.md"
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing docs/tasks/active.md" }
    $content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    Write-Output "Task recovery"
    foreach ($heading in @("Status", "Goal", "Next", "Recovery", "Blockers")) {
        Write-Output ""
        Write-Output ("## {0}" -f $heading)
        $section = Get-Section -Content $content -Heading $heading
        if ([string]::IsNullOrWhiteSpace($section)) { $section = "none" }
        Write-Output $section
    }
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
    Invoke-RootCommandNoExit "eval-research-memo-quality.ps1"
    Write-Output "research smoke: pass"
}

function Invoke-UiuxSmoke {
    $sample = Join-Path $Root "docs\validation\system-improvement\uiux-review-sample.md"
    if (-not (Test-Path -LiteralPath $sample)) { throw "Missing UI/UX sample." }
    Invoke-RootCommandNoExit "eval-uiux-review-quality.ps1"
    Write-Output "uiux smoke: pass"
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
        Write-Output ("- {0}: {1}; entry={2}" -f $_.id, $_.status, $_.entry_command)
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

switch ($Command.ToLowerInvariant()) {
    "help" { Show-Help }
    "doctor" { Invoke-RootCommand "check-agent-readiness.ps1" $RemainingArgs }
    "readiness" { Invoke-RootCommand "check-agent-readiness.ps1" $RemainingArgs }
    "audit" {
        if ($RemainingArgs.Count -gt 0) {
            $name = $RemainingArgs[0]
            $args = @($RemainingArgs | Select-Object -Skip 1)
            switch ($name) {
                "minimality" { Invoke-RootCommand "audit-minimality.ps1" $args }
                "usage" { Invoke-RootCommand "audit-file-usage.ps1" $args }
                "references" { Invoke-RootCommand "audit-active-references.ps1" $args }
                "capabilities" { Invoke-PlainCommand "audit-codex-capabilities.ps1" $args }
                "mcp" { Invoke-PlainCommand "audit-mcp-config.ps1" $args }
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
            $scriptName = "eval-$name.ps1"
            Invoke-RootCommand $scriptName (@($RemainingArgs | Select-Object -Skip 1))
        } else {
            Invoke-RootCommand "eval-agent-system.ps1"
        }
    }
    "hook" {
        if ($RemainingArgs.Count -eq 0) { throw "Hook name is required." }
        $hook = $RemainingArgs[0]
        $args = @($RemainingArgs | Select-Object -Skip 1)
        switch ($hook) {
            "risk" { Invoke-PlainCommand "codex-hook-risk-check.ps1" $args }
            "session-start" { Invoke-RootCommand "codex-hook-session-start.ps1" $args }
            "post-tool-capture" { Invoke-RootCommand "codex-hook-post-tool-capture.ps1" $args }
            "stop-check" { Invoke-RootCommand "codex-hook-stop-check.ps1" $args }
            default { throw "Unknown hook: $hook" }
        }
    }
    "task" {
        if ($RemainingArgs.Count -eq 0) { Invoke-RootCommand "check-task-state.ps1" }
        $task = $RemainingArgs[0]
        $args = @($RemainingArgs | Select-Object -Skip 1)
        switch ($task) {
            "check" { Invoke-RootCommand "check-task-state.ps1" $args }
            "recover" { Show-TaskRecovery }
            "archive" { Invoke-RootCommand "archive-task-state.ps1" $args }
            default { throw "Unknown task subcommand: $task" }
        }
    }
    "knowledge" {
        if ($RemainingArgs.Count -eq 0) { Invoke-RootCommand "validate-knowledge-index.ps1" }
        $name = $RemainingArgs[0]
        $args = @($RemainingArgs | Select-Object -Skip 1)
        switch ($name) {
            "check" { Invoke-RootCommand "validate-knowledge-index.ps1" $args }
            "new" { Invoke-PlainCommand "new-knowledge-item.ps1" $args }
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
    "setup" {
        if ($RemainingArgs.Count -eq 0) { throw "Setup subcommand is required." }
        $name = $RemainingArgs[0]
        $args = @($RemainingArgs | Select-Object -Skip 1)
        switch ($name) {
            "git-hooks" { Invoke-RootCommand "install-git-hooks.ps1" $args }
            "environment" { Invoke-PlainCommand "setup-codex-environment.ps1" $args }
            default { throw "Unknown setup subcommand: $name" }
        }
    }
    "git" {
        & (Join-Path $PSScriptRoot "git-safe.ps1") @RemainingArgs
        exit $LASTEXITCODE
    }
    default { throw "Unknown command: $Command. Run scripts/codex.ps1 help." }
}
