param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom

function Get-MarkdownSection {
    param(
        [string]$Content,
        [string]$Heading
    )

    $pattern = "(?ms)^##\s+$([regex]::Escape($Heading))\s*\r?\n(.*?)(?=^##\s+|\z)"
    $match = [regex]::Match($Content, $pattern)
    if ($match.Success) {
        return $match.Groups[1].Value.Trim()
    }
    return ""
}

function Get-RecentHarnessLines {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    $rows = @(Get-Content -LiteralPath $Path -Encoding UTF8 | Where-Object { $_ -match '^\|\s*\d{4}-\d{2}-\d{2}\s*\|' })
    $items = @()
    foreach ($row in ($rows | Select-Object -Last 3)) {
        $parts = $row -split '\|'
        if ($parts.Count -lt 7) {
            continue
        }
        $items += ("- {0}: {1} -> {2} [{3}]" -f $parts[1].Trim(), $parts[2].Trim(), $parts[4].Trim(), $parts[6].Trim())
    }
    return $items
}

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

$proposalRoot = Join-Path $Root "docs\knowledge\system-improvement\proposals"
$proposalSummary = @()
if (Test-Path -LiteralPath $proposalRoot) {
    $proposalSummary = @(Get-ChildItem -Path $proposalRoot -Filter "*.md" -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 3 |
        ForEach-Object { "- $($_.BaseName)" })
}

$harnessPath = Join-Path $Root "docs\knowledge\system-improvement\harness-log.md"
$harnessSummary = Get-RecentHarnessLines -Path $harnessPath

$lines = @(
    "Playgroud session context",
    "",
    "Git snapshot:",
    $gitSummary
)

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

if ($harnessSummary.Count -gt 0) {
    $lines += ""
    $lines += "Recent system lessons:"
    $lines += $harnessSummary
}

if ($proposalSummary.Count -gt 0) {
    $lines += ""
    $lines += "Open system proposals:"
    $lines += $proposalSummary
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
} | ConvertTo-Json -Compress -Depth 6
