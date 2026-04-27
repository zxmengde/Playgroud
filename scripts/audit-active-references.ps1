param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$includeRoots = @(
    "AGENTS.md",
    "README.md",
    ".agents",
    ".codex\hooks.json",
    "docs\assistant",
    "docs\capabilities",
    "docs\core",
    "docs\profile",
    "docs\references",
    "docs\tasks\active.md",
    "docs\validation",
    "docs\workflows",
    "templates"
)

$files = @()
foreach ($rel in $includeRoots) {
    $path = Join-Path $Root $rel
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $item = Get-Item -LiteralPath $path
    if ($item.PSIsContainer) {
        $files += Get-ChildItem -Path $item.FullName -Recurse -File -Include *.md,*.ps1,*.json,*.yaml,*.yml -ErrorAction SilentlyContinue
    } else {
        $files += $item
    }
}

$prefixPattern = '(AGENTS\.md|README\.md|\.agents[\\/][A-Za-z0-9_.\\/\-]+|\.codex[\\/]hooks\.json|docs[\\/][A-Za-z0-9_.\\/\-]+|scripts[\\/][A-Za-z0-9_.\\/\-]+|templates[\\/][A-Za-z0-9_.\\/\-]+)'
$skipPattern = '(\*|YYYY|<|>|\$|~|\{|\}|\[|\]|\.\.\.|^docs[\\/]knowledge[\\/]items[\\/]YYYY)'
$historicalReferences = @(
    "docs/archive/assistant-v1/",
    "docs\archive\assistant-v1",
    "skills/personal-work-assistant",
    "skills\personal-work-assistant",
    "skills/bilibili-video-evidence",
    "skills\bilibili-video-evidence",
    "skills/video-note-writer",
    "skills\video-note-writer"
)

$missing = @()
$checked = New-Object System.Collections.Generic.HashSet[string]

foreach ($file in ($files | Sort-Object FullName -Unique)) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
    if ([string]::IsNullOrWhiteSpace($content)) { continue }

    foreach ($match in [regex]::Matches($content, $prefixPattern)) {
        $lineStart = $content.LastIndexOf("`n", [Math]::Max(0, $match.Index - 1))
        if ($lineStart -lt 0) { $lineStart = 0 } else { $lineStart += 1 }
        $linePrefix = $content.Substring($lineStart, $match.Index - $lineStart)
        if ($linePrefix -match 'https?://\S*$') { continue }

        $candidate = $match.Value.Trim().Trim('`').Trim("'").Trim('"')
        $candidate = $candidate.TrimEnd('.', ',', ';', ':', ')')
        $candidate = ($candidate -split '#')[0]
        if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
        if ($candidate -match $skipPattern) { continue }
        if ($historicalReferences -contains $candidate) { continue }
        if (-not $checked.Add(("{0}|{1}" -f $file.FullName, $candidate))) { continue }

        $fsPath = Join-Path $Root ($candidate -replace '/', [System.IO.Path]::DirectorySeparatorChar)
        if (-not (Test-Path -LiteralPath $fsPath)) {
            $missing += [pscustomobject]@{
                Source = $file.FullName.Substring($Root.Length + 1)
                Reference = $candidate
            }
        }
    }
}

Write-Output "Active reference audit"
Write-Output ("files scanned: {0}" -f ($files | Sort-Object FullName -Unique).Count)
Write-Output ("unique references checked: {0}" -f $checked.Count)
Write-Output ("missing active references: {0}" -f $missing.Count)

if ($missing.Count -gt 0) {
    $missing | Sort-Object Source, Reference | ForEach-Object {
        Write-Output ("- {0}: {1}" -f $_.Source, $_.Reference)
    }
    throw "Active reference audit failed."
}

Write-Output "Active reference audit passed."
