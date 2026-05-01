param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "self-improvement-object-lib.ps1")

function Add-ResultLine {
    param([string]$Level, [string]$Message)
    $script:results += ("{0} {1}" -f $Level, $Message)
}

function Fail {
    param([string]$Message)
    $script:hasFailure = $true
    Add-ResultLine -Level "FAIL" -Message $Message
}

function Warn {
    param([string]$Message)
    $script:hasWarning = $true
    Add-ResultLine -Level "WARN" -Message $Message
}

function Pass {
    param([string]$Message)
    Add-ResultLine -Level "PASS" -Message $Message
}

$results = @()
$hasFailure = $false
$hasWarning = $false

try {
    $routing = Read-JsonYamlFile -Path (Get-RoutingPath -Root $Root)
} catch {
    Fail $_.Exception.Message
    $results | ForEach-Object { Write-Output $_ }
    exit 1
}

$summary = Get-ActiveLoadSummary -Root $Root
$always = @($summary.always)

foreach ($requiredPath in @(
        "AGENTS.md",
        "docs/core/index.md",
        "docs/profile/user-model.md",
        "docs/profile/preference-map.md",
        "docs/tasks/active.md"
    )) {
    if ($always -notcontains $requiredPath) {
        Fail "active_load.always missing required path $requiredPath"
    }
}

foreach ($pathValue in $always) {
    if ($pathValue -match '^docs/archive/' -or $pathValue -match '2026-04-27-codex-self-improvement-report') {
        Fail "active_load.always includes archived or historical design artifact $pathValue"
    }
}

$activeLoadLines = 0
$activeLoadBytes = 0
foreach ($pathValue in $always) {
    $resolved = Join-Path $Root ($pathValue -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $resolved)) {
        Fail "active_load.always path missing: $pathValue"
        continue
    }

    $text = Get-Content -LiteralPath $resolved -Raw -Encoding UTF8
    $lineCount = ($text -split "\r?\n").Count
    $byteCount = [System.Text.Encoding]::UTF8.GetByteCount($text)
    $activeLoadLines += $lineCount
    $activeLoadBytes += $byteCount
    if ($lineCount -gt 260) {
        Warn "active_load file is large: $pathValue lines=$lineCount"
    }
}

if ($activeLoadLines -gt 700) {
    Fail "active_load total lines exceed budget: $activeLoadLines > 700"
}
if ($activeLoadBytes -gt 120000) {
    Fail "active_load total bytes exceed budget: $activeLoadBytes > 120000"
}

foreach ($failure in @($summary.open_failures)) {
    if (@($routing.active_load.exclude_statuses.failures) -contains $failure.status) {
        Fail "open failure summary includes excluded status $($failure.status)"
    }
    if ($failure.summary.Length -gt 80) {
        Warn "failure summary exceeds 80 characters: $($failure.id)"
    }
}

foreach ($lesson in @($summary.active_lessons)) {
    if (@($routing.active_load.exclude_statuses.lessons) -contains $lesson.status) {
        Fail "active lesson summary includes excluded status $($lesson.status)"
    }
    if ($lesson.title.Length -gt 90) {
        Warn "lesson summary exceeds 90 characters: $($lesson.id)"
    }
}

$retrievalOnly = @($summary.retrieval_only)
if ($retrievalOnly -notcontains "docs/archive/") { Fail "active_load retrieval_only_prefixes must include docs/archive/" }
if ($retrievalOnly -notcontains "docs/knowledge/items/") { Warn "active_load retrieval_only_prefixes does not include docs/knowledge/items/" }

Pass ("active_load always={0} lines={1} bytes={2} open_failures={3} active_lessons={4}" -f $always.Count, $activeLoadLines, $activeLoadBytes, @($summary.open_failures).Count, @($summary.active_lessons).Count)
$results | ForEach-Object { Write-Output $_ }
if ($hasFailure) { exit 1 }
if ($hasWarning) { exit 2 }
exit 0
