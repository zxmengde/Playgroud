param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$Title = "Archived task"
)

$ErrorActionPreference = "Stop"

$activePath = Join-Path $Root "docs\tasks\active.md"
$donePath = Join-Path $Root "docs\tasks\done.md"
if (-not (Test-Path -LiteralPath $activePath)) {
    throw "Missing docs/tasks/active.md"
}

$active = Get-Content -LiteralPath $activePath -Raw
$date = Get-Date -Format "yyyy-MM-dd"
$entry = @"

## $date - $Title

Archived from `docs/tasks/active.md`.

```markdown
$active
```
"@

Add-Content -LiteralPath $donePath -Value $entry -Encoding UTF8
Write-Output "Archived active task to docs/tasks/done.md"
