param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$required = @(
    "AGENTS.md",
    "docs\core\index.md",
    "docs\capabilities\index.md",
    "docs\profile\user-model.md",
    "docs\profile\preference-map.md",
    "docs\profile\intake-questionnaire.md",
    "docs\assistant\forbidden-terms.json",
    "docs\knowledge\index.md",
    "docs\references\assistant\external-capability-radar.md",
    "docs\references\assistant\mcp-allowlist.json",
    "docs\validation\v2-acceptance.md",
    "docs\knowledge\items",
    "docs\tasks\active.md",
    "docs\workflows\literature-zotero.md",
    "docs\workflows\video.md",
    "docs\references\assistant\index.md",
    "docs\references\assistant\self-improvement-loop.md",
    "templates\knowledge\knowledge-item.md",
    "templates\profile\preference-note.md",
    "templates\research\citation-checklist.md",
    "templates\web\source-note.md",
    "templates\assistant\system-improvement-proposal.md",
    "templates\assistant\mcp-adoption-review.md",
    "scripts\scan-text-risk.ps1",
    "scripts\check-task-state.ps1",
    "scripts\validate-knowledge-index.ps1",
    "scripts\check-finish-readiness.ps1",
    "scripts\validate-doc-structure.ps1",
    "scripts\validate-acceptance-records.ps1",
    "scripts\new-artifact.ps1",
    "scripts\check-ppt-text-extract.ps1",
    "scripts\audit-skills.ps1",
    "scripts\audit-redundancy.ps1",
    "scripts\audit-codex-capabilities.ps1",
    "scripts\audit-mcp-config.ps1",
    "scripts\audit-automations.ps1",
    "scripts\audit-skill-sync.ps1",
    "scripts\sync-user-skills.ps1",
    "scripts\eval-agent-system.ps1",
    "scripts\audit-minimality.ps1",
    "scripts\audit-file-usage.ps1",
    "scripts\audit-active-references.ps1",
    "scripts\audit-system-improvement-proposals.ps1",
    "scripts\audit-zotero-library.ps1",
    "scripts\audit-video-skill-readiness.ps1",
    "scripts\check-agent-readiness.ps1",
    "scripts\pre-commit-check.ps1",
    "scripts\install-git-hooks.ps1",
    "scripts\run-agent-maintenance.ps1",
    "scripts\test-codex-runtime.ps1",
    "scripts\git-safe.ps1",
    "scripts\setup-codex-environment.ps1",
    "scripts\install-codex-git-network-fix.ps1",
    "scripts\test-git-network.ps1",
    "scripts\repair-git-network-env.ps1",
    "scripts\validate-skills.ps1",
    "docs\references\assistant\tool-registry.md"
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
& (Join-Path $Root "scripts\audit-redundancy.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-minimality.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-file-usage.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-active-references.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-system-improvement-proposals.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-video-skill-readiness.ps1")
& (Join-Path $Root "scripts\audit-codex-capabilities.ps1") | Out-Null
& (Join-Path $Root "scripts\audit-mcp-config.ps1") | Out-Null
& (Join-Path $Root "scripts\audit-automations.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-skill-sync.ps1") -Root $Root
& (Join-Path $Root "scripts\check-agent-readiness.ps1") -Root $Root -Strict
& (Join-Path $Root "scripts\scan-text-risk.ps1") -Root $Root
& (Join-Path $Root "scripts\check-task-state.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-knowledge-index.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-doc-structure.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-acceptance-records.ps1") -Root $Root
& (Join-Path $Root "scripts\eval-agent-system.ps1") -Root $Root

Write-Output "System validation passed."
