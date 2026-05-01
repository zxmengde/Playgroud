param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

function Convert-ToRepoPath {
    param([string]$Path)
    $fullRoot = (Resolve-Path $Root).Path.TrimEnd('\')
    $fullPath = (Resolve-Path $Path).Path
    if ($fullPath.StartsWith($fullRoot)) {
        return ($fullPath.Substring($fullRoot.Length + 1) -replace "\\", "/")
    }
    return ($fullPath -replace "\\", "/")
}

$tracked = @(& git -C $Root -c core.quotePath=false ls-files)
$trackedText = @($tracked | Where-Object { $_ -match '\.(md|ps1|json|yaml|yml)$' })
$textFiles = foreach ($file in $trackedText) {
    $full = Join-Path $Root ($file -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (Test-Path -LiteralPath $full) {
        Get-Item -LiteralPath $full
    }
}

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
    ".codex/hooks.json",
    "docs/tasks/active.md",
    "docs/tasks/done.md",
    "docs/tasks/blocked.md",
    "docs/Codex 自我改进报告.md",
    "docs/knowledge/index.md",
    "docs/knowledge/system-improvement/index.md",
    "docs/knowledge/research/index.md",
    "docs/knowledge/project/index.md",
    "docs/knowledge/web-source/index.md",
    "docs/assistant/forbidden-terms.json"
)

$candidates = @()
foreach ($file in $tracked) {
    $full = Join-Path $Root ($file -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $full)) { continue }
    if ($excluded -contains $file) { continue }
    if ($file -match '^docs/Codex .+\.md$') { continue }
    if ($file -notmatch '\.(md|ps1|json|yaml|yml)$') { continue }
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
Write-Output ("tracked text files checked: {0}" -f $trackedText.Count)
Write-Output ("low-reference candidates: {0}" -f $candidates.Count)
foreach ($candidate in ($candidates | Sort-Object)) {
    Write-Output ("- {0}" -f $candidate)
}
Write-Output "File usage audit completed."
