param(
    [Parameter(Position = 0)]
    [string]$Command = "help",

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$RemainingArgs
)

$ErrorActionPreference = "Stop"
if ($null -eq $RemainingArgs) { $RemainingArgs = @() }

$Root = (Resolve-Path "$PSScriptRoot\..").Path
$Runtime = Join-Path $Root ".runtime"

function Ensure-Directory {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

function Get-CommandPath {
    param([Parameter(Mandatory = $true)][string[]]$Names)
    foreach ($name in $Names) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    return $null
}

function Read-JsonState {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    try { return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json }
    catch { return $null }
}

function Write-JsonState {
    param([Parameter(Mandatory = $true)][string]$Path, [Parameter(Mandatory = $true)]$Data)
    Ensure-Directory (Split-Path $Path -Parent)
    $Data | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Test-RunningPid {
    param([object]$PidValue)
    if ($null -eq $PidValue) { return $false }
    try {
        $pidInt = [int]$PidValue
        return $null -ne (Get-Process -Id $pidInt -ErrorAction SilentlyContinue)
    } catch {
        return $false
    }
}

function Stop-StateProcess {
    param([Parameter(Mandatory = $true)][string]$StatePath)
    $state = Read-JsonState $StatePath
    if (-not $state) {
        Write-Output "not running"
        return
    }
    if (Test-RunningPid $state.pid) {
        Stop-Process -Id ([int]$state.pid) -Force
        Write-Output ("stopped pid={0}" -f $state.pid)
    } else {
        Write-Output ("stale pid={0}" -f $state.pid)
    }
    Remove-Item -LiteralPath $StatePath -Force -ErrorAction SilentlyContinue
}

function Read-RepoFile {
    param([Parameter(Mandatory = $true)][string]$RelativePath)
    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing file: $RelativePath" }
    Get-Content -LiteralPath $path -Raw -Encoding UTF8
}

function Get-Section {
    param([string]$Content, [string]$Heading)
    $pattern = "(?ms)^##\s+" + [regex]::Escape($Heading) + "\s*\r?\n(.*?)(?=^##\s|\z)"
    $match = [regex]::Match($Content, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ""
}

function Get-ArgValue {
    param([string[]]$Tokens, [string]$Name, [string]$Default = "")
    for ($i = 0; $i -lt $Tokens.Count; $i++) {
        if ($Tokens[$i] -eq "-$Name" -and ($i + 1) -lt $Tokens.Count) { return $Tokens[$i + 1] }
    }
    return $Default
}

function Get-LedgerBlocks {
    param([string]$RelativePath)
    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path)) { return @() }
    $text = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    $blocks = @()
    foreach ($match in [regex]::Matches($text, "(?ms)^###\s+(.+?)\s*\r?\n(.*?)(?=^###\s|\z)")) {
        $fields = [ordered]@{}
        foreach ($line in ($match.Groups[2].Value -split "\r?\n")) {
            $fieldMatch = [regex]::Match($line, "^\s*-\s+([^:]+):\s*(.*)\s*$")
            if ($fieldMatch.Success) { $fields[$fieldMatch.Groups[1].Value.Trim()] = $fieldMatch.Groups[2].Value.Trim() }
        }
        $blocks += [pscustomobject]@{ title = $match.Groups[1].Value.Trim(); fields = $fields }
    }
    return $blocks
}

function Append-LedgerBlock {
    param([string]$RelativePath, [string]$Title, [System.Collections.IDictionary]$Fields)
    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing ledger: $RelativePath" }
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("")
    $lines.Add("### $Title")
    foreach ($key in $Fields.Keys) {
        $value = [string]$Fields[$key]
        if ([string]::IsNullOrWhiteSpace($value)) { $value = "unspecified" }
        $lines.Add("- ${key}: $value")
    }
    Add-Content -LiteralPath $path -Value ($lines -join "`r`n") -Encoding UTF8
    Write-Output "updated ${RelativePath}: $Title"
}

function Update-LedgerBlockFields {
    param([string]$RelativePath, [string]$Title, [System.Collections.IDictionary]$Fields)
    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing ledger: $RelativePath" }
    $text = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    $pattern = "(?ms)^###\s+" + [regex]::Escape($Title) + "\s*\r?\n(.*?)(?=^###\s|\z)"
    $match = [regex]::Match($text, $pattern)
    if (-not $match.Success) { return $false }

    $body = $match.Groups[1].Value.TrimEnd()
    foreach ($key in $Fields.Keys) {
        $value = [string]$Fields[$key]
        if ([string]::IsNullOrWhiteSpace($value)) { $value = "unspecified" }
        $linePattern = "(?m)^-\s+" + [regex]::Escape($key) + ":\s*.*$"
        $newLine = "- ${key}: $value"
        if ([regex]::IsMatch($body, $linePattern)) {
            $body = [regex]::Replace($body, $linePattern, $newLine, 1)
        } else {
            $body = $body.TrimEnd() + "`r`n" + $newLine
        }
    }

    $replacement = "### $Title`r`n$body`r`n`r`n"
    $updated = $text.Substring(0, $match.Index) + $replacement + $text.Substring($match.Index + $match.Length)
    Set-Content -LiteralPath $path -Value $updated.TrimEnd() -Encoding UTF8
    return $true
}

function Show-Help {
    Write-Output "Usage: .\scripts\codex.ps1 <command> [subcommand]"
    Write-Output ""
    Write-Output "Core commands:"
    Write-Output "  task board"
    Write-Output "  task recover"
    Write-Output "  task attempt -Id ATT-YYYYMMDD-001 -TaskId TASK-YYYYMMDD-name -Status running|review_needed|blocked|done|cancelled"
    Write-Output "  knowledge promote -Id KP-YYYYMMDD-001 -Source <text> -Status raw_note|curated_note|verified_knowledge|archived|superseded"
    Write-Output "  knowledge promotions"
    Write-Output "  research queue"
    Write-Output "  research enqueue -Id RQ-YYYYMMDD-001 -Question <text> -State queued|running|review_needed|blocked|done|cancelled"
    Write-Output "  research review-gate -Id RQ-YYYYMMDD-001 -Decision review_needed|blocked|done"
    Write-Output "  research run-log"
    Write-Output "  vibe start|stop|status"
    Write-Output "  aris install|update"
    Write-Output "  aris watchdog start|stop|status|register|unregister"
    Write-Output "  capability map"
    Write-Output "  git <args>"
}

function Show-TaskBoard {
    Read-RepoFile "docs\tasks\board.md"
}

function Show-TaskRecovery {
    $active = Read-RepoFile "docs\tasks\active.md"
    $attempts = @(Get-LedgerBlocks "docs\tasks\attempts.md")
    $latest = $attempts | Select-Object -Last 1
    Write-Output "Task recovery"
    foreach ($heading in @("Status", "Goal", "Next", "Recovery", "Blockers")) {
        Write-Output ""
        Write-Output "## $heading"
        $section = Get-Section -Content $active -Heading $heading
        if ([string]::IsNullOrWhiteSpace($section)) { $section = "none" }
        Write-Output $section
    }
    if ($latest) {
        Write-Output ""
        Write-Output "## Latest Attempt"
        foreach ($field in @("id", "task_id", "status", "checkpoint", "resume_summary", "next_action", "stale_after")) {
            if ($latest.fields.Contains($field)) { Write-Output ("{0}: {1}" -f $field, $latest.fields[$field]) }
        }
    }
}

function Add-TaskAttempt {
    param([string[]]$Tokens)
    $id = Get-ArgValue $Tokens "Id"
    if ([string]::IsNullOrWhiteSpace($id)) { throw "task attempt requires -Id" }
    $status = Get-ArgValue $Tokens "Status" "running"
    if (@("running", "review_needed", "blocked", "done", "cancelled") -notcontains $status) { throw "Invalid task status: $status" }
    Append-LedgerBlock "docs\tasks\attempts.md" $id ([ordered]@{
        id = $id
        task_id = Get-ArgValue $Tokens "TaskId" "unspecified"
        status = $status
        checkpoint = Get-ArgValue $Tokens "Checkpoint" "unspecified"
        resume_summary = Get-ArgValue $Tokens "ResumeSummary" "unspecified"
        next_action = Get-ArgValue $Tokens "NextAction" "unspecified"
        stale_after = Get-ArgValue $Tokens "StaleAfter" "unspecified"
        updated_at = (Get-Date).ToString("s")
    })
}

function Add-KnowledgePromotion {
    param([string[]]$Tokens)
    $id = Get-ArgValue $Tokens "Id"
    if ([string]::IsNullOrWhiteSpace($id)) { throw "knowledge promote requires -Id" }
    $status = Get-ArgValue $Tokens "Status" "curated_note"
    if (@("raw_note", "curated_note", "verified_knowledge", "archived", "superseded") -notcontains $status) { throw "Invalid knowledge status: $status" }
    Append-LedgerBlock "docs\knowledge\promotion-ledger.md" $id ([ordered]@{
        id = $id
        source = Get-ArgValue $Tokens "Source" "unspecified"
        status = $status
        target = Get-ArgValue $Tokens "Target" "repository"
        evidence = Get-ArgValue $Tokens "Evidence" "unspecified"
        next_action = Get-ArgValue $Tokens "NextAction" "unspecified"
        updated_at = (Get-Date).ToString("s")
    })
}

function Add-ResearchQueueItem {
    param([string[]]$Tokens)
    $id = Get-ArgValue $Tokens "Id"
    if ([string]::IsNullOrWhiteSpace($id)) { throw "research enqueue requires -Id" }
    $state = Get-ArgValue $Tokens "State" "queued"
    if (@("queued", "running", "review_needed", "blocked", "done", "cancelled") -notcontains $state) { throw "Invalid research state: $state" }
    Append-LedgerBlock "docs\knowledge\research-queue.md" $id ([ordered]@{
        id = $id
        source = Get-ArgValue $Tokens "Source" "manual"
        question = Get-ArgValue $Tokens "Question" "unspecified"
        state = $state
        evidence = Get-ArgValue $Tokens "Evidence" "unspecified"
        review_gate = Get-ArgValue $Tokens "ReviewGate" "manual review before claim"
        next_action = Get-ArgValue $Tokens "NextAction" "review queue"
        updated_at = (Get-Date).ToString("s")
    })
}

function Add-ResearchReviewGate {
    param([string[]]$Tokens)
    $id = Get-ArgValue $Tokens "Id"
    if ([string]::IsNullOrWhiteSpace($id)) { throw "research review-gate requires -Id" }
    $decision = Get-ArgValue $Tokens "Decision" "review_needed"
    if (@("review_needed", "blocked", "done") -notcontains $decision) { throw "Invalid review decision: $decision" }
    $evidence = Get-ArgValue $Tokens "Evidence" "unspecified"
    $nextAction = Get-ArgValue $Tokens "NextAction" "manual review"
    Append-LedgerBlock "docs\knowledge\research-run-log.md" "review-gate $id" ([ordered]@{
        id = $id
        decision = $decision
        evidence = $evidence
        reviewer = Get-ArgValue $Tokens "Reviewer" "codex"
        next_action = $nextAction
        updated_at = (Get-Date).ToString("s")
    })
    $updated = Update-LedgerBlockFields "docs\knowledge\research-queue.md" $id ([ordered]@{
        state = $decision
        evidence = $evidence
        review_gate = "decision: $decision"
        next_action = $nextAction
        updated_at = (Get-Date).ToString("s")
    })
    if ($updated) { Write-Output "updated docs\knowledge\research-queue.md: $id state=$decision" }
}

function Get-VibeRuntime {
    $dir = Join-Path $Runtime "vibe-kanban"
    Ensure-Directory $dir
    return [pscustomobject]@{
        dir = $dir
        state = Join-Path $dir "state.json"
        stdout = Join-Path $dir "stdout.log"
        stderr = Join-Path $dir "stderr.log"
    }
}

function Start-VibeKanban {
    param([string[]]$Tokens)
    $paths = Get-VibeRuntime
    $state = Read-JsonState $paths.state
    if ($state -and (Test-RunningPid $state.pid)) {
        Write-Output ("vibe-kanban already running: pid={0} url={1}" -f $state.pid, $state.url)
        return
    }
    $npx = Get-CommandPath @("npx.cmd", "npx")
    if (-not $npx) { throw "npx is required to run original vibe-kanban." }

    $port = Get-ArgValue $Tokens "Port" "3210"
    $hostName = Get-ArgValue $Tokens "Host" "127.0.0.1"
    $oldPort = $env:PORT
    $oldHost = $env:HOST
    try {
        $env:PORT = $port
        $env:HOST = $hostName
        $proc = Start-Process -FilePath $npx `
            -ArgumentList @("--yes", "vibe-kanban") `
            -WorkingDirectory $Root `
            -RedirectStandardOutput $paths.stdout `
            -RedirectStandardError $paths.stderr `
            -WindowStyle Hidden `
            -PassThru
    } finally {
        $env:PORT = $oldPort
        $env:HOST = $oldHost
    }

    $url = "http://${hostName}:${port}"
    Write-JsonState $paths.state ([ordered]@{
        pid = $proc.Id
        command = "npx --yes vibe-kanban"
        url = $url
        host = $hostName
        port = $port
        stdout = $paths.stdout
        stderr = $paths.stderr
        started_at = (Get-Date).ToString("s")
    })
    Write-Output ("vibe-kanban started: pid={0} url={1}" -f $proc.Id, $url)
}

function Show-VibeKanbanStatus {
    $paths = Get-VibeRuntime
    $state = Read-JsonState $paths.state
    if (-not $state) {
        Write-Output "vibe-kanban: stopped"
        return
    }
    $running = Test-RunningPid $state.pid
    Write-Output ("vibe-kanban: {0}" -f ($(if ($running) { "running" } else { "stale" })))
    Write-Output ("pid: {0}" -f $state.pid)
    Write-Output ("url: {0}" -f $state.url)
    Write-Output ("stdout: {0}" -f $state.stdout)
    Write-Output ("stderr: {0}" -f $state.stderr)
}

function Stop-VibeKanban {
    $paths = Get-VibeRuntime
    Stop-StateProcess $paths.state
}

function Get-ArisRuntime {
    $dir = Join-Path $Runtime "aris"
    $repo = Join-Path $dir "Auto-claude-code-research-in-sleep"
    $watchdogBase = Join-Path $dir "watchdog"
    Ensure-Directory $dir
    return [pscustomobject]@{
        dir = $dir
        repo = $repo
        watchdogBase = $watchdogBase
        state = Join-Path $dir "watchdog-state.json"
        stdout = Join-Path $dir "watchdog-stdout.log"
        stderr = Join-Path $dir "watchdog-stderr.log"
    }
}

function Install-ArisOriginal {
    $paths = Get-ArisRuntime
    if (Test-Path -LiteralPath (Join-Path $paths.repo ".git")) {
        Write-Output ("ARIS already installed: {0}" -f $paths.repo)
        return
    }
    $git = Get-CommandPath @("git.exe", "git")
    if (-not $git) { throw "git is required to clone ARIS." }
    & $git clone https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep.git $paths.repo
    if ($LASTEXITCODE -ne 0) { throw "ARIS clone failed." }
    Write-Output ("ARIS installed: {0}" -f $paths.repo)
}

function Update-ArisOriginal {
    $paths = Get-ArisRuntime
    if (-not (Test-Path -LiteralPath (Join-Path $paths.repo ".git"))) {
        Install-ArisOriginal
        return
    }
    & git -C $paths.repo pull --ff-only
    if ($LASTEXITCODE -ne 0) { throw "ARIS update failed." }
}

function Get-ArisPython {
    $python = Get-CommandPath @("python.exe", "python", "py.exe", "py")
    if (-not $python) { throw "Python is required to run ARIS watchdog." }
    return $python
}

function Get-ArisWatchdogScript {
    $paths = Get-ArisRuntime
    $script = Join-Path $paths.repo "tools\watchdog.py"
    if (-not (Test-Path -LiteralPath $script)) {
        Install-ArisOriginal
    }
    if (-not (Test-Path -LiteralPath $script)) { throw "Missing ARIS watchdog.py after install." }
    return $script
}

function Start-ArisWatchdog {
    param([string[]]$Tokens)
    $paths = Get-ArisRuntime
    $state = Read-JsonState $paths.state
    if ($state -and (Test-RunningPid $state.pid)) {
        Write-Output ("ARIS watchdog already running: pid={0} base={1}" -f $state.pid, $state.base_dir)
        return
    }
    $python = Get-ArisPython
    $script = Get-ArisWatchdogScript
    $interval = Get-ArgValue $Tokens "Interval" "60"
    Ensure-Directory $paths.watchdogBase
    $proc = Start-Process -FilePath $python `
        -ArgumentList @($script, "--base-dir", $paths.watchdogBase, "--interval", $interval) `
        -WorkingDirectory $Root `
        -RedirectStandardOutput $paths.stdout `
        -RedirectStandardError $paths.stderr `
        -WindowStyle Hidden `
        -PassThru
    Write-JsonState $paths.state ([ordered]@{
        pid = $proc.Id
        command = "python watchdog.py --base-dir <runtime> --interval $interval"
        base_dir = $paths.watchdogBase
        stdout = $paths.stdout
        stderr = $paths.stderr
        started_at = (Get-Date).ToString("s")
    })
    Write-Output ("ARIS watchdog started: pid={0} base={1}" -f $proc.Id, $paths.watchdogBase)
}

function Show-ArisWatchdogStatus {
    $paths = Get-ArisRuntime
    $state = Read-JsonState $paths.state
    if ($state -and (Test-RunningPid $state.pid)) {
        Write-Output ("ARIS watchdog: running pid={0}" -f $state.pid)
    } elseif ($state) {
        Write-Output ("ARIS watchdog: stale pid={0}" -f $state.pid)
    } else {
        Write-Output "ARIS watchdog: stopped"
    }
    $python = Get-ArisPython
    $script = Get-ArisWatchdogScript
    & $python $script --base-dir $paths.watchdogBase --status
}

function Stop-ArisWatchdog {
    $paths = Get-ArisRuntime
    Stop-StateProcess $paths.state
}

function Register-ArisWatchdogTask {
    param([string[]]$Tokens)
    $paths = Get-ArisRuntime
    $python = Get-ArisPython
    $script = Get-ArisWatchdogScript
    $json = Get-ArgValue $Tokens "Json"
    if ([string]::IsNullOrWhiteSpace($json)) {
        $name = Get-ArgValue $Tokens "Name"
        $type = Get-ArgValue $Tokens "Type"
        $session = Get-ArgValue $Tokens "Session"
        if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($type) -or [string]::IsNullOrWhiteSpace($session)) {
            throw "aris watchdog register requires -Json or -Name -Type -Session."
        }
        $task = [ordered]@{
            name = $name
            type = $type
            session = $session
            session_type = Get-ArgValue $Tokens "SessionType" "screen"
        }
        $targetPath = Get-ArgValue $Tokens "TargetPath"
        if (-not [string]::IsNullOrWhiteSpace($targetPath)) { $task.target_path = $targetPath }
        $gpus = Get-ArgValue $Tokens "Gpus"
        if (-not [string]::IsNullOrWhiteSpace($gpus)) {
            $task.gpus = @($gpus -split "," | ForEach-Object { [int]($_.Trim()) })
        }
        $json = ($task | ConvertTo-Json -Compress -Depth 8)
    }
    & $python $script --base-dir $paths.watchdogBase --register $json
}

function Unregister-ArisWatchdogTask {
    param([string[]]$Tokens)
    $name = Get-ArgValue $Tokens "Name"
    if ([string]::IsNullOrWhiteSpace($name)) { throw "aris watchdog unregister requires -Name." }
    $paths = Get-ArisRuntime
    $python = Get-ArisPython
    $script = Get-ArisWatchdogScript
    & $python $script --base-dir $paths.watchdogBase --unregister $name
}

switch ($Command.ToLowerInvariant()) {
    "help" { Show-Help }
    "task" {
        $sub = if ($RemainingArgs.Count -gt 0) { $RemainingArgs[0] } else { "board" }
        $tokens = @($RemainingArgs | Select-Object -Skip 1)
        switch ($sub) {
            "board" { Show-TaskBoard }
            "recover" { Show-TaskRecovery }
            "attempt" { Add-TaskAttempt $tokens }
            default { throw "Unknown task subcommand: $sub" }
        }
    }
    "knowledge" {
        $sub = if ($RemainingArgs.Count -gt 0) { $RemainingArgs[0] } else { "promotions" }
        $tokens = @($RemainingArgs | Select-Object -Skip 1)
        switch ($sub) {
            "promote" { Add-KnowledgePromotion $tokens }
            "promotions" { Read-RepoFile "docs\knowledge\promotion-ledger.md" }
            default { throw "Unknown knowledge subcommand: $sub" }
        }
    }
    "research" {
        $sub = if ($RemainingArgs.Count -gt 0) { $RemainingArgs[0] } else { "queue" }
        $tokens = @($RemainingArgs | Select-Object -Skip 1)
        switch ($sub) {
            "queue" { Read-RepoFile "docs\knowledge\research-queue.md" }
            "run-log" { Read-RepoFile "docs\knowledge\research-run-log.md" }
            "enqueue" { Add-ResearchQueueItem $tokens }
            "review-gate" { Add-ResearchReviewGate $tokens }
            default { throw "Unknown research subcommand: $sub" }
        }
    }
    "vibe" {
        $sub = if ($RemainingArgs.Count -gt 0) { $RemainingArgs[0] } else { "status" }
        $tokens = @($RemainingArgs | Select-Object -Skip 1)
        switch ($sub) {
            "start" { Start-VibeKanban $tokens }
            "status" { Show-VibeKanbanStatus }
            "stop" { Stop-VibeKanban }
            default { throw "Unknown vibe subcommand: $sub" }
        }
    }
    "aris" {
        $sub = if ($RemainingArgs.Count -gt 0) { $RemainingArgs[0] } else { "status" }
        $tokens = @($RemainingArgs | Select-Object -Skip 1)
        switch ($sub) {
            "install" { Install-ArisOriginal }
            "update" { Update-ArisOriginal }
            "status" { Show-ArisWatchdogStatus }
            "watchdog" {
                $watchSub = if ($tokens.Count -gt 0) { $tokens[0] } else { "status" }
                $watchTokens = @($tokens | Select-Object -Skip 1)
                switch ($watchSub) {
                    "start" { Start-ArisWatchdog $watchTokens }
                    "status" { Show-ArisWatchdogStatus }
                    "stop" { Stop-ArisWatchdog }
                    "register" { Register-ArisWatchdogTask $watchTokens }
                    "unregister" { Unregister-ArisWatchdogTask $watchTokens }
                    default { throw "Unknown aris watchdog subcommand: $watchSub" }
                }
            }
            default { throw "Unknown aris subcommand: $sub" }
        }
    }
    "capability" {
        $sub = if ($RemainingArgs.Count -gt 0) { $RemainingArgs[0] } else { "map" }
        if ($sub -ne "map") { throw "Only capability map is available." }
        Read-RepoFile "docs\capabilities.md"
    }
    "git" {
        & (Join-Path $PSScriptRoot "git-safe.ps1") @RemainingArgs
        exit $LASTEXITCODE
    }
    default { throw "Unknown command: $Command. Run .\scripts\codex.ps1 help." }
}
