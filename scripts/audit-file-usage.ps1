param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

function Convert-ToRepoPath {
    param([string]$Path)
    return ([System.IO.Path]::GetRelativePath($Root, $Path) -replace "\\", "/")
}

$tracked = @(& git -C $Root ls-files)
$textFiles = @(Get-ChildItem -Path $Root -Recurse -File -Include *.md,*.ps1,*.json,*.yaml,*.yml -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "\\.git\\" })

$combined = ""
foreach ($file in $textFiles) {
    $rel = Convert-ToRepoPath $file.FullName
    $combined += "`n<!-- $rel -->`n"
    $combined += Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
}

$excluded = @(
    "AGENTS.md",
    "README.md",
    ".gitignore",
    "docs/tasks/active.md",
    "docs/tasks/done.md",
    "docs/tasks/blocked.md",
    "docs/knowledge/index.md",
    "docs/knowledge/system-improvement/index.md",
    "docs/knowledge/research/index.md",
    "docs/knowledge/project/index.md",
    "docs/knowledge/web-source/index.md",
    "docs/assistant/forbidden-terms.json"
)

$candidates = @()
foreach ($file in $tracked) {
    if ($excluded -contains $file) { continue }
    if ($file -notmatch '\.(md|ps1|json|yaml|yml)$') { continue }
    if (-not (Test-Path -LiteralPath (Join-Path $Root ($file -replace '/', [System.IO.Path]::DirectorySeparatorChar)))) { continue }
    if ($file -match '^docs/knowledge/items/') { continue }
    if ($file -match '^docs/archive/') { continue }

    $escaped = [regex]::Escape($file)
    $backslashPath = $file.Replace("/", "\")
    $backslash = [regex]::Escape($backslashPath)
    $hits = [regex]::Matches($combined, "($escaped|$backslash)").Count
    if ($hits -le 1) {
        $candidates += $file
    }
}

Write-Output "File usage audit"
Write-Output ("tracked text files checked: {0}" -f (($tracked | Where-Object { $_ -match '\.(md|ps1|json|yaml|yml)$' }).Count))
Write-Output ("low-reference candidates: {0}" -f $candidates.Count)
foreach ($candidate in ($candidates | Sort-Object)) {
    Write-Output ("- {0}" -f $candidate)
}
Write-Output "File usage audit completed."
