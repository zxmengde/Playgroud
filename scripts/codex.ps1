param(
    [Parameter(Position = 0)]
    [string]$Command = "help",

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$RemainingArgs
)

$ErrorActionPreference = "Stop"
if ($null -eq $RemainingArgs) { $RemainingArgs = @() }

$Root = (Resolve-Path "$PSScriptRoot\..").Path

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
