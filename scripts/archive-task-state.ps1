param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$Title = "Archived task",
    [switch]$IncludeFull
)

$ErrorActionPreference = "Stop"

$activePath = Join-Path $Root "docs\tasks\active.md"
$donePath = Join-Path $Root "docs\tasks\done.md"
if (-not (Test-Path -LiteralPath $activePath)) {
    throw "Missing docs/tasks/active.md"
}

$active = Get-Content -LiteralPath $activePath -Raw
$date = Get-Date -Format "yyyy-MM-dd"

function Get-MarkdownSection {
    param(
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$Heading
    )

    $pattern = "(?ms)^" + [regex]::Escape($Heading) + "\s*\r?\n(.*?)(?=^##\s|\z)"
    $match = [regex]::Match($Content, $pattern)
    if (-not $match.Success) { return "" }
    return $match.Groups[1].Value.Trim()
}

function Compress-Section {
    param(
        [string]$Text,
        [int]$MaxLength = 500
    )

    $flat = (($Text -split "\r?\n") | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join " "
    $flat = $flat.Trim()
    if ($flat.Length -gt $MaxLength) {
        return ($flat.Substring(0, $MaxLength).TrimEnd() + "...")
    }
    if ([string]::IsNullOrWhiteSpace($flat)) { return "无" }
    return $flat
}

$goal = Compress-Section -Text (Get-MarkdownSection -Content $active -Heading "## Goal") -MaxLength 500
$unverified = Compress-Section -Text (Get-MarkdownSection -Content $active -Heading "## Unverified") -MaxLength 260
$blockers = Compress-Section -Text (Get-MarkdownSection -Content $active -Heading "## Blockers") -MaxLength 260
$next = Compress-Section -Text (Get-MarkdownSection -Content $active -Heading "## Next") -MaxLength 360

$entry = @"

## $date - $Title

Archived from `docs/tasks/active.md`.

- Goal: $goal
- Unverified: $unverified
- Blockers: $blockers
- Next: $next
"@

if ($IncludeFull.IsPresent) {
    $entry += @"

Full active task snapshot:

```markdown
$active
```
"@
}

Add-Content -LiteralPath $donePath -Value $entry -Encoding UTF8
Write-Output "Archived active task to docs/tasks/done.md"
