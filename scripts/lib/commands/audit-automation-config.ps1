param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path,
    [string]$AutomationRoot = "$env:USERPROFILE\.codex\automations"
)

$ErrorActionPreference = "Stop"

function Get-RelativeRepoPath {
    param([string]$Candidate)

    $normalized = $Candidate.Trim().Trim('"').Trim("'").Replace("\", "/")
    if ($normalized.StartsWith("./")) {
        $normalized = $normalized.Substring(2)
    }
    return $normalized
}

Write-Output "Automation config audit"

if (-not (Test-Path -LiteralPath $AutomationRoot)) {
    Write-Output "automation files: 0"
    Write-Output "Automation config audit passed."
    return
}

$repoRootNormalized = (Resolve-Path $Root).Path.TrimEnd('\').ToLowerInvariant()
$files = @(Get-ChildItem -Path $AutomationRoot -Recurse -Filter "automation.toml" -File -ErrorAction SilentlyContinue)
$errors = @()

foreach ($file in $files) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $normalizedContent = $content.Replace("\\", "\").ToLowerInvariant()
    $isRepoAutomation = $normalizedContent.Contains($repoRootNormalized)
    if (-not $isRepoAutomation) {
        continue
    }

    $matches = [regex]::Matches($content, '(?<![A-Za-z0-9_.-])((?:AGENTS\.md|README\.md|docs/[A-Za-z0-9._/\-]+|scripts/[A-Za-z0-9._/\-]+|templates/[A-Za-z0-9._/\-]+))')
    foreach ($match in $matches) {
        $relative = Get-RelativeRepoPath -Candidate $match.Groups[1].Value
        if ([string]::IsNullOrWhiteSpace($relative)) {
            continue
        }
        $full = Join-Path $Root ($relative -replace '/', '\')
        if (-not (Test-Path -LiteralPath $full)) {
            $errors += "$($file.FullName): missing path reference $relative"
        }
    }
}

Write-Output ("automation files: {0}" -f $files.Count)

if ($errors.Count -gt 0) {
    Write-Error ("Automation config issues:`n" + ($errors -join "`n"))
}

Write-Output "Automation config audit passed."
