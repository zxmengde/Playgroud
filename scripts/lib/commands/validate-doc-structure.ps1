param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"

$required = @(
    "docs\core\index.md",
    "docs\core\delivery-contract.md",
    "docs\core\tool-use-budget.md",
    "docs\core\skill-use-policy.md",
    "docs\core\context-modes.md",
    "docs\core\typed-object-registry.md",
    "docs\assistant\index.md",
    "docs\references\assistant",
    "docs\archive\assistant-v1-summary.md",
    "docs\capabilities\index.md",
    "docs\capabilities\capability-map.yaml",
    "docs\capabilities\external-adoptions.md",
    "docs\references\assistant\external-capability-radar.md",
    "docs\references\assistant\external-mechanism-transfer.md",
    "docs\references\assistant\codex-app-settings.md",
    "docs\references\assistant\plugin-mcp-availability.md",
    "docs\references\assistant\mcp-capability-plan.md",
    "docs\references\assistant\agent-benchmark-integration.md",
    "docs\knowledge\system-improvement\harness-log.md",
    "docs\knowledge\system-improvement\2026-04-28-codex-self-improvement-final-report.md",
    "docs\knowledge\system-improvement\routing-v1.yaml",
    "docs\knowledge\system-improvement\failures",
    "docs\knowledge\system-improvement\lessons",
    "docs\knowledge\system-improvement\skill-audit.md",
    "docs\knowledge\research\research-state.yaml",
    "docs\knowledge\research\run-log.md",
    "docs\knowledge\research\research-queue.md",
    ".agents\skills\playgroud-maintenance\SKILL.md",
    ".agents\skills\failure-promoter\SKILL.md",
    ".agents\skills\external-mechanism-researcher\SKILL.md",
    ".agents\skills\research-engineering-loop\SKILL.md",
    ".agents\skills\product-engineering-closer\SKILL.md",
    ".agents\skills\uiux-reviewer\SKILL.md",
    ".agents\skills\knowledge-curator\SKILL.md",
    ".agents\skills\tool-router\SKILL.md",
    ".agents\skills\finish-verifier\SKILL.md",
    "docs\workflows\self-improvement.md",
    "docs\workflows\product.md",
    "docs\workflows\uiux.md",
    "docs\validation\real-task-evals.md",
    "docs\tasks\board.md",
    "docs\references\assistant\hook-risk-stdin-smoke.md",
    ".codex\hooks.json"
)

$missing = @()
foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $path))) {
        $missing += $path
    }
}
if ($missing.Count -gt 0) {
    throw ("Missing document structure paths: " + ($missing -join ", "))
}

$coreMarkdown = @(Get-ChildItem -Path (Join-Path $Root "docs\core") -Filter "*.md" -File -ErrorAction SilentlyContinue)
$allowedCoreMarkdown = @("index.md", "delivery-contract.md", "tool-use-budget.md", "skill-use-policy.md", "context-modes.md", "typed-object-registry.md")
$unexpectedCore = @($coreMarkdown | Where-Object { $allowedCoreMarkdown -notcontains $_.Name })
if ($unexpectedCore.Count -gt 0) {
    throw ("Unexpected docs/core markdown files: " + (($unexpectedCore | Select-Object -ExpandProperty Name) -join ", "))
}

$capMarkdown = @(Get-ChildItem -Path (Join-Path $Root "docs\capabilities") -Filter "*.md" -File -ErrorAction SilentlyContinue)
$allowedCapMarkdown = @("index.md", "external-adoptions.md")
$unexpectedCaps = @($capMarkdown | Where-Object { $allowedCapMarkdown -notcontains $_.Name })
if ($unexpectedCaps.Count -gt 0) {
    throw ("Unexpected docs/capabilities markdown files: " + (($unexpectedCaps | Select-Object -ExpandProperty Name) -join ", "))
}

$assistantDir = Join-Path $Root "docs\assistant"
$unexpectedAssistantMarkdown = @(Get-ChildItem -Path $assistantDir -Filter "*.md" -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne "index.md" })
if ($unexpectedAssistantMarkdown.Count -gt 0) {
    throw ("Unexpected docs/assistant markdown files: " + (($unexpectedAssistantMarkdown | Select-Object -ExpandProperty Name) -join ", "))
}

$legacySkills = Join-Path $Root "skills"
if (Test-Path -LiteralPath $legacySkills) {
    $legacyFiles = @(Get-ChildItem -Path $legacySkills -Recurse -File -ErrorAction SilentlyContinue)
    if ($legacyFiles.Count -gt 0) {
        throw "Legacy repository skills directory still contains files."
    }
}

Write-Output "Document structure check passed."
