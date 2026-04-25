param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$required = @(
    "AGENTS.md",
    "docs\core\identity-and-goal.md",
    "docs\core\permission-boundary.md",
    "docs\core\execution-loop.md",
    "docs\core\memory-state.md",
    "docs\core\finish-readiness.md",
    "docs\capabilities\index.md",
    "docs\profile\user-model.md",
    "docs\profile\preference-map.md",
    "docs\profile\intake-questionnaire.md",
    "docs\assistant\overview.md",
    "docs\assistant\alignment-audit.md",
    "docs\assistant\agent-capability-improvement.md",
    "docs\assistant\capability-gap-review.md",
    "docs\assistant\agent-tool-landscape.md",
    "docs\assistant\automation-policy.md",
    "docs\assistant\cost-control.md",
    "docs\assistant\long-task-quality.md",
    "docs\assistant\personal-agent-operating-model.md",
    "docs\assistant\memory-model.md",
    "docs\assistant\pre-finish-check.md",
    "docs\assistant\skill-quality-standard.md",
    "docs\assistant\skill-audit.md",
    "docs\assistant\third-party-skill-evaluation.md",
    "docs\assistant\git-network-troubleshooting.md",
    "docs\assistant\preferences.md",
    "docs\assistant\execution-contract.md",
    "docs\assistant\intent-interview.md",
    "docs\assistant\permissions.md",
    "docs\assistant\security-model.md",
    "docs\assistant\tool-registry.md",
    "docs\assistant\harness-log.md",
    "docs\knowledge\index.md",
    "docs\knowledge\research\index.md",
    "docs\knowledge\project\index.md",
    "docs\knowledge\web-source\index.md",
    "docs\knowledge\system-improvement\index.md",
    "docs\validation\v2-acceptance\index.md",
    "docs\knowledge\items",
    "docs\tasks\active.md",
    "docs\tasks\done.md",
    "docs\tasks\blocked.md",
    "docs\workflows\literature-zotero.md",
    "docs\workflows\video.md",
    "templates\knowledge\knowledge-item.md",
    "templates\profile\preference-note.md",
    "templates\research\citation-checklist.md",
    "templates\web\source-note.md",
    "templates\assistant\automation-review.md",
    "templates\assistant\long-task-state.md",
    "templates\assistant\skill-adoption-review.md",
    "scripts\scan-text-risk.ps1",
    "scripts\check-task-state.ps1",
    "scripts\validate-knowledge-index.ps1",
    "scripts\check-finish-readiness.ps1",
    "scripts\validate-doc-structure.ps1",
    "scripts\validate-acceptance-records.ps1",
    "scripts\new-citation-checklist.ps1",
    "scripts\new-web-source-note.ps1",
    "scripts\check-ppt-text-extract.ps1",
    "scripts\audit-skills.ps1",
    "scripts\test-git-network.ps1",
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
    "(?<![A-Za-z0-9])sk-[A-Za-z0-9_-]{16,}",
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
& (Join-Path $Root "scripts\audit-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\scan-text-risk.ps1") -Root $Root
& (Join-Path $Root "scripts\check-task-state.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-knowledge-index.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-doc-structure.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-acceptance-records.ps1") -Root $Root

Write-Output "System validation passed."
