param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
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
    "docs\core\delivery-contract.md",
    "docs\core\tool-use-budget.md",
    "docs\core\skill-use-policy.md",
    "docs\core\context-modes.md",
    "docs\core\typed-object-registry.md",
    "docs\capabilities\index.md",
    "docs\capabilities\capability-map.yaml",
    "docs\capabilities\external-adoptions.md",
    "docs\profile\user-model.md",
    "docs\profile\preference-map.md",
    "docs\profile\intake-questionnaire.md",
    "docs\assistant\index.md",
    "docs\assistant\forbidden-terms.json",
    "docs\archive\assistant-v1-summary.md",
    "docs\knowledge\index.md",
    "docs\knowledge\research\index.md",
    "docs\knowledge\research\research-state.yaml",
    "docs\knowledge\research\run-log.md",
    "docs\knowledge\research\research-queue.md",
    "docs\knowledge\promotion-ledger.md",
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
    "docs\references\assistant\hook-risk-stdin-smoke.md",
    "docs\validation\real-task-evals.md",
    "docs\validation\v2-acceptance\index.md",
    "docs\validation\system-improvement\external-mechanism-review-sample.md",
    "docs\validation\system-improvement\research-memo-sample.md",
    "docs\validation\system-improvement\uiux-review-sample.md",
    "docs\validation\system-improvement\product-engineering-sample.md",
    "docs\knowledge\items",
    "docs\tasks\active.md",
    "docs\tasks\board.md",
    "docs\tasks\attempts.md",
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
    "scripts\codex.ps1",
    "scripts\pre-commit-check.ps1",
    "scripts\lib\commands\scan-text-risk.ps1",
    "scripts\lib\commands\check-task-state.ps1",
    "scripts\lib\commands\validate-knowledge-index.ps1",
    "scripts\lib\commands\check-finish-readiness.ps1",
    "scripts\lib\commands\validate-doc-structure.ps1",
    "scripts\lib\commands\validate-acceptance-records.ps1",
    "scripts\lib\commands\audit-skills.ps1",
    "scripts\lib\commands\audit-redundancy.ps1",
    "scripts\lib\commands\audit-profile-duplication.ps1",
    "scripts\lib\commands\audit-codex-capabilities.ps1",
    "scripts\lib\commands\audit-mcp-config.ps1",
    "scripts\lib\commands\audit-minimality.ps1",
    "scripts\lib\commands\audit-file-usage.ps1",
    "scripts\lib\commands\audit-active-references.ps1",
    "scripts\lib\commands\audit-system-improvement-proposals.ps1",
    "scripts\lib\commands\audit-automation-config.ps1",
    "scripts\lib\commands\audit-zotero-library.ps1",
    "scripts\lib\commands\audit-video-skill-readiness.ps1",
    "scripts\lib\commands\audit-serena-obsidian-readiness.ps1",
    "scripts\lib\commands\check-agent-readiness.ps1",
    "scripts\lib\commands\pre-commit-check.ps1",
    "scripts\lib\commands\run-agent-maintenance.ps1",
    "scripts\lib\commands\test-codex-runtime.ps1",
    "scripts\git-safe.ps1",
    "scripts\lib\commands\setup-codex-environment.ps1",
    "scripts\lib\commands\test-git-network.ps1",
    "scripts\lib\commands\validate-skills.ps1",
    "scripts\lib\commands\validate-failure-log.ps1",
    "scripts\lib\commands\validate-lessons.ps1",
    "scripts\lib\commands\validate-routing-v1.ps1",
    "scripts\lib\commands\validate-skill-contracts.ps1",
    "scripts\lib\commands\validate-active-load.ps1",
    "scripts\lib\commands\validate-delivery-system.ps1",
    "scripts\lib\self-improvement-object-lib.ps1",
    "scripts\lib\commands\codex-hook-risk-check.ps1",
    "scripts\lib\commands\codex-hook-session-start.ps1",
    "scripts\lib\commands\codex-hook-post-tool-capture.ps1",
    "scripts\lib\commands\codex-hook-stop-check.ps1",
    "scripts\lib\commands\eval-agent-system.ps1",
    "scripts\lib\commands\eval-repeat-failure-capture.ps1",
    "scripts\lib\commands\eval-lesson-promotion.ps1",
    "scripts\lib\commands\eval-routing-selection.ps1",
    "scripts\lib\commands\eval-task-quality.ps1",
    "scripts\lib\commands\eval-session-recovery.ps1",
    "scripts\lib\commands\eval-unverified-closeout-block.ps1"
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

& (Join-Path $Root "scripts\lib\commands\validate-skills.ps1") -Root $Root
Invoke-ExitAwareCheck -Label "validate-skill-contracts" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-skill-contracts.ps1") -Arguments @{ Root = $Root }
& (Join-Path $Root "scripts\lib\commands\audit-skills.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-redundancy.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-profile-duplication.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-minimality.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-file-usage.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-active-references.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-system-improvement-proposals.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-automation-config.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\audit-video-skill-readiness.ps1")
& (Join-Path $Root "scripts\lib\commands\audit-codex-capabilities.ps1") | Out-Null
& (Join-Path $Root "scripts\lib\commands\audit-mcp-config.ps1") | Out-Null
& (Join-Path $Root "scripts\lib\commands\check-agent-readiness.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\scan-text-risk.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\check-task-state.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\validate-knowledge-index.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\validate-doc-structure.ps1") -Root $Root
& (Join-Path $Root "scripts\lib\commands\validate-acceptance-records.ps1") -Root $Root
Invoke-ExitAwareCheck -Label "validate-failure-log" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-failure-log.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "validate-lessons" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-lessons.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "validate-routing-v1" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-routing-v1.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "validate-active-load" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-active-load.ps1") -Arguments @{ Root = $Root }
Invoke-ExitAwareCheck -Label "validate-delivery-system" -ScriptPath (Join-Path $Root "scripts\lib\commands\validate-delivery-system.ps1") -Arguments @{ Root = $Root }
& (Join-Path $Root "scripts\lib\commands\eval-agent-system.ps1") -Root $Root | Out-Null

Write-Output "System validation passed."
