param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
. (Join-Path $PSScriptRoot "..\self-improvement-object-lib.ps1")

$gitSummary = (& git -C $Root status --short --branch 2>$null) -join "`n"
if ([string]::IsNullOrWhiteSpace($gitSummary)) {
    $gitSummary = "git status unavailable"
}

$activePath = Join-Path $Root "docs\tasks\active.md"
$goal = ""
$next = ""
$recovery = ""
if (Test-Path -LiteralPath $activePath) {
    $active = Get-Content -LiteralPath $activePath -Raw -Encoding UTF8
    $goal = Get-MarkdownSection -Content $active -Heading "Goal"
    $next = Get-MarkdownSection -Content $active -Heading "Next"
    $recovery = Get-MarkdownSection -Content $active -Heading "Recovery"
}

$activeLoad = Get-ActiveLoadSummary -Root $Root
$lines = @(
    "Playgroud session context",
    "",
    "Git snapshot:",
    $gitSummary,
    "",
    "Always load:"
)
foreach ($entry in @($activeLoad.always)) {
    $lines += "- $entry"
}

if (-not [string]::IsNullOrWhiteSpace($goal)) {
    $lines += ""
    $lines += "Active goal:"
    $lines += $goal
}

if (-not [string]::IsNullOrWhiteSpace($next)) {
    $lines += ""
    $lines += "Immediate next:"
    $lines += $next
}

$lines += ""
$lines += "Recent open failures:"
if (@($activeLoad.open_failures).Count -eq 0) {
    $lines += "- none"
} else {
    $lines += @($activeLoad.open_failures | ForEach-Object {
            "- {0} [{1}/{2}] {3}" -f $_.id, $_.impact, $_.status, $_.summary
        })
}

$lines += ""
$lines += "Active lessons:"
if (@($activeLoad.active_lessons).Count -eq 0) {
    $lines += "- none"
} else {
    $lines += @($activeLoad.active_lessons | ForEach-Object {
            "- {0} [{1}] {2}" -f $_.id, $_.status, $_.title
        })
}

$lines += ""
$lines += "Retrieval only:"
$lines += @($activeLoad.retrieval_only | ForEach-Object { "- $_" })

try {
    $serenaConfigured = $false
    $codexConfigPath = "$env:USERPROFILE\.codex\config.toml"
    if (Test-Path -LiteralPath $codexConfigPath) {
        $codexConfig = Get-Content -LiteralPath $codexConfigPath -Raw -Encoding UTF8
        $serenaConfigured = $codexConfig -match '(?ms)^\[mcp_servers\.serena\]'
    }
    $obsidianReady = [bool](Get-Command obsidian -ErrorAction SilentlyContinue)
    if ($serenaConfigured -or $obsidianReady) {
        $lines += ""
        $lines += "External knowledge and code tools:"
        if ($serenaConfigured) {
            $lines += "- Serena configured. For code tasks, activate the current directory as project using Serena."
        }
        if ($obsidianReady) {
            $lines += "- Obsidian CLI available. Use vault ids or names for read/search/write operations."
        }
    }
} catch {
}

if (-not [string]::IsNullOrWhiteSpace($recovery)) {
    $lines += ""
    $lines += "Recovery entry:"
    $lines += $recovery
}

@{
    hookSpecificOutput = @{
        hookEventName = "SessionStart"
        additionalContext = ($lines -join "`n").Trim()
    }
} | ConvertTo-Json -Compress -Depth 8
