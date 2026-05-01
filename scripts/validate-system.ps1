param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

function Invoke-ExitAwareCheck {
    param(
        [Parameter(Mandatory = $true)][string]$Label,
        [Parameter(Mandatory = $true)][string]$ScriptPath,
        [hashtable]$Arguments = @{}
    )

    & $ScriptPath @Arguments
    $exitCode = $LASTEXITCODE
    if ($exitCode -eq 1) {
        throw "$Label failed."
    }
    if ($exitCode -eq 2) {
        Write-Warning "$Label reported warnings."
    }
}

$required = @(
    "AGENTS.md",
    "README.md",
    ".codex\hooks.json",
    "docs\core\index.md",
    "docs\capabilities\index.md",
    "docs\profile\user-model.md",
    "docs\profile\preference-map.md",
    "docs\profile\intake-questionnaire.md",
    "docs\assistant\index.md",
    "docs\assistant\forbidden-terms.json",
    "docs\archive\assistant-v1-summary.md",
    "docs\knowledge\index.md",
    "docs\knowledge\research\index.md",
    "docs\knowledge\project\index.md",
    "docs\knowledge\web-source\index.md",
    "docs\knowledge\system-improvement\index.md",
    "docs\knowledge\system-improvement\harness-log.md",
    "docs\knowledge\system-improvement\2026-04-28-codex-self-improvement-final-report.md",
    "docs\knowledge\system-improvement\routing-v1.yaml",
    "docs\knowledge\system-improvement\failures\FAIL-20260427-210500-a1c201.yaml",
    "docs\knowledge\system-improvement\failures\FAIL-20260427-213000-b77d42.yaml",
    "docs\knowledge\system-improvement\lessons\LESSON-self-improvement-not-just-hygiene.yaml",
    "docs\knowledge\system-improvement\lessons\LESSON-external-scoring-needs-mechanism-evidence.yaml",
    "docs\references\assistant\external-capability-radar.md",
    "docs\references\assistant\external-mechanism-transfer.md",
    "docs\references\assistant\mcp-allowlist.json",
    "docs\references\assistant\mcp-capability-plan.md",
    "docs\references\assistant\plugin-mcp-availability.md",
    "docs\references\assistant\codex-app-settings.md",
    "docs\validation\v2-acceptance\index.md",
    "docs\validation\system-improvement\external-mechanism-review-sample.md",
    "docs\validation\system-improvement\research-memo-sample.md",
    "docs\validation\system-improvement\uiux-review-sample.md",
    "docs\validation\system-improvement\product-engineering-sample.md",
    "docs\knowledge\items",
    "docs\tasks\active.md",
    "docs\tasks\done.md",
    "docs\tasks\blocked.md",
    "docs\workflows\coding.md",
    "docs\workflows\research.md",
    "docs\workflows\knowledge.md",
    "docs\workflows\literature-zotero.md",
    "docs\workflows\web.md",
    "docs\workflows\video.md",
    "docs\workflows\office.md",
    "docs\workflows\self-improvement.md",
    "docs\workflows\product.md",
    "docs\workflows\uiux.md",
    ".agents\skills\playgroud-maintenance\SKILL.md",
    ".agents\skills\failure-promoter\SKILL.md",
    ".agents\skills\external-mechanism-researcher\SKILL.md",
    ".agents\skills\research-engineering-loop\SKILL.md",
    ".agents\skills\product-engineering-closer\SKILL.md",
    ".agents\skills\uiux-reviewer\SKILL.md",
    ".agents\skills\knowledge-curator\SKILL.md",
    ".agents\skills\tool-router\SKILL.md",
    ".agents\skills\finish-verifier\SKILL.md",
    "templates\knowledge\knowledge-item.md",
    "templates\profile\preference-note.md",
    "templates\research\citation-checklist.md",
    "templates\web\source-note.md",
    "templates\assistant\automation-review.md",
    "templates\assistant\long-task-state.md",
    "templates\assistant\system-improvement-proposal.md",
    "templates\assistant\skill-adoption-review.md",
    "templates\assistant\mcp-adoption-review.md",
    "scripts\scan-text-risk.ps1",
    "scripts\check-task-state.ps1",
    "scripts\validate-knowledge-index.ps1",
    "scripts\check-finish-readiness.ps1",
    "scripts\validate-doc-structure.ps1",
    "scripts\validate-acceptance-records.ps1",
    "scripts\audit-skills.ps1",
    "scripts\audit-redundancy.ps1",
    "scripts\audit-profile-duplication.ps1",
    "scripts\audit-codex-capabilities.ps1",
    "scripts\audit-mcp-config.ps1",
    "scripts\audit-minimality.ps1",
    "scripts\audit-file-usage.ps1",
    "scripts\audit-active-references.ps1",
    "scripts\audit-system-improvement-proposals.ps1",
    "scripts\audit-automation-config.ps1",
    "scripts\audit-zotero-library.ps1",
    "scripts\audit-video-skill-readiness.ps1",
    "scripts\audit-serena-obsidian-readiness.ps1",
    "scripts\check-agent-readiness.ps1",
    "scripts\pre-commit-check.ps1",
    "scripts\run-agent-maintenance.ps1",
    "scripts\test-codex-runtime.ps1",
    "scripts\git-safe.ps1",
    "scripts\setup-codex-environment.ps1",
    "scripts\test-git-network.ps1",
    "scripts\validate-skills.ps1",
    "scripts\validate-failure-log.ps1",
    "scripts\validate-lessons.ps1",
    "scripts\validate-routing-v1.ps1",
    "scripts\validate-skill-contracts.ps1",
    "scripts\validate-active-load.ps1",
    "scripts\self-improvement-object-lib.ps1",
    "scripts\codex-hook-risk-check.ps1",
    "scripts\codex-hook-session-start.ps1",
    "scripts\codex-hook-post-tool-capture.ps1",
    "scripts\codex-hook-stop-check.ps1",
    "scripts\eval-agent-system.ps1",
    "scripts\eval-repeat-failure-capture.ps1",
    "scripts\eval-lesson-promotion.ps1",
    "scripts\eval-routing-selection.ps1",
    "scripts\eval-external-mechanism-review-check.ps1",
    "scripts\eval-research-memo-quality.ps1",
    "scripts\eval-uiux-review-quality.ps1",
    "scripts\eval-session-recovery.ps1",
    "scripts\eval-unverified-closeout-block.ps1",
    "scripts\eval-product-engineering-closeout.ps1"
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

$trackedAndUntracked = @(& git -C $Root -c core.quotePath=false ls-files --cached --others --exclude-standard)
$textFiles = foreach ($path in $trackedAndUntracked) {
    if ($path -notmatch '\.(md|yaml|yml|ps1|json)$') {
        continue
    }
    $full = Join-Path $Root ($path -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (Test-Path -LiteralPath $full) {
        Get-Item -LiteralPath $full
    }
}

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
Invoke-ExitAwareCheck -Label "validate-skill-contracts" -ScriptPath (Join-Path $Root "scripts\validate-skill-contracts.ps1") -Arguments @{ Root = $Root }
& (Join-Path $Root "scripts\audit-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-redundancy.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-profile-duplication.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-minimality.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-file-usage.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-active-references.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-system-improvement-proposals.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-automation-config.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-video-skill-readiness.ps1")
& (Join-Path $Root "scripts\audit-serena-obsidian-readiness.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-codex-capabilities.ps1") | Out-Null
& (Join-Path $Root "scripts\audit-mcp-config.ps1") | Out-Null
& (Join-Path $Root "scripts\check-agent-readiness.ps1") -Root $Root
& (Join-Path $Root "scripts\scan-text-risk.ps1") -Root $Root
& (Join-Path $Root "scripts\check-task-state.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-knowledge-index.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-doc-structure.ps1") -Root $Root
& (Join-Path $Root "scripts\validate-acceptance-records.ps1") -Root $Root
Invoke-ExitAwareCheck -Label "validate-failure-log" -ScriptPath (Join-Path $Root "scripts\validate-failure-log.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "validate-lessons" -ScriptPath (Join-Path $Root "scripts\validate-lessons.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "validate-routing-v1" -ScriptPath (Join-Path $Root "scripts\validate-routing-v1.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "validate-active-load" -ScriptPath (Join-Path $Root "scripts\validate-active-load.ps1") -Arguments @{ Root = $Root }
& (Join-Path $Root "scripts\eval-agent-system.ps1") -Root $Root | Out-Null

Write-Output "System validation passed."
