param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$required = @(
    "AGENTS.md",
    "docs\profile\user-model.md",
    "docs\profile\intake-questionnaire.md",
    "docs\assistant\overview.md",
    "docs\assistant\alignment-audit.md",
    "docs\assistant\agent-capability-improvement.md",
    "docs\assistant\memory-model.md",
    "docs\assistant\pre-finish-check.md",
    "docs\assistant\skill-quality-standard.md",
    "docs\assistant\third-party-skill-evaluation.md",
    "docs\assistant\preferences.md",
    "docs\assistant\execution-contract.md",
    "docs\assistant\intent-interview.md",
    "docs\assistant\permissions.md",
    "docs\assistant\tool-registry.md",
    "docs\assistant\harness-log.md",
    "docs\knowledge\index.md",
    "docs\knowledge\items",
    "docs\tasks\active.md",
    "docs\tasks\done.md",
    "docs\tasks\blocked.md",
    "templates\knowledge\knowledge-item.md",
    "scripts\validate-skills.ps1"
)

$missing = @()
foreach ($path in $required) {
    $full = Join-Path $Root $path
    if (-not (Test-Path -LiteralPath $full)) {
        $missing += $path
    }
}

if ($missing.Count -gt 0) {
    Write-Error ("Missing required paths: " + ($missing -join ", "))
}

$forbiddenPath = Join-Path $Root "docs\assistant\forbidden-terms.json"
$forbidden = @()
if (Test-Path -LiteralPath $forbiddenPath) {
    $forbidden = (Get-Content -LiteralPath $forbiddenPath -Raw | ConvertFrom-Json).terms
}
$textFiles = Get-ChildItem -Path $Root -Recurse -File -Include *.md,*.yaml,*.yml,*.ps1 -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "\\.git\\" }

$hits = @()
foreach ($file in $textFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
    foreach ($term in $forbidden) {
        if ($content -like "*$term*") {
            $hits += "$($file.FullName): $term"
        }
    }
}

if ($hits.Count -gt 0) {
    Write-Error ("Forbidden terms found:`n" + ($hits -join "`n"))
}

$secretPatterns = @(
    "sk-[A-Za-z0-9_-]{16,}",
    "ghp_[A-Za-z0-9_]{20,}",
    "github_pat_[A-Za-z0-9_]{20,}",
    "xox[baprs]-[A-Za-z0-9-]{10,}"
)

$secretHits = @()
foreach ($file in $textFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
    foreach ($pattern in $secretPatterns) {
        if ($content -match $pattern) {
            $secretHits += $file.FullName
        }
    }
}

if ($secretHits.Count -gt 0) {
    Write-Error ("Potential secrets found in: " + (($secretHits | Select-Object -Unique) -join ", "))
}

& (Join-Path $Root "scripts\validate-skills.ps1") -Root $Root

Write-Output "System validation passed."
