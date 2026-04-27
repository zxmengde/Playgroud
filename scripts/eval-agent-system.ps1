param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

Write-Output "Agent system eval"

$obsolete = @(
    "docs\archive\assistant-v1-summary.md",
    "docs\user-guide.md",
    "docs\references\assistant\agent-capability-improvement.md",
    "docs\references\assistant\agent-tool-landscape.md",
    "docs\references\assistant\agent-benchmark-integration.md",
    "docs\references\assistant\personal-agent-operating-model.md",
    "docs\references\assistant\intent-interview.md",
    "docs\references\assistant\skill-quality-standard.md",
    "docs\knowledge\items\2026-04-22-harness-engineering-personal-system.md",
    "docs\knowledge\items\2026-04-23-agent-harness-skills-research.md",
    "docs\knowledge\items\2026-04-23-agent-tool-landscape-windows-automation.md",
    "docs\knowledge\items\2026-04-23-agent-security-model-research.md",
    "docs\knowledge\items\2026-04-23-long-task-automation-evaluation-research.md",
    "docs\knowledge\items\2026-04-23-personalized-agent-operating-model-research.md"
)

$requiredMechanisms = @(
    "scripts\audit-active-references.ps1",
    "scripts\audit-automations.ps1",
    "scripts\audit-skill-sync.ps1",
    "scripts\audit-system-improvement-proposals.ps1",
    "scripts\pre-commit-check.ps1",
    "scripts\sync-user-skills.ps1",
    "docs\references\assistant\self-improvement-loop.md",
    "docs\validation\v2-acceptance\self-improvement-loop.md",
    "docs\references\assistant\mcp-allowlist.json"
)

$errors = @()
foreach ($path in $obsolete) {
    if (Test-Path -LiteralPath (Join-Path $Root $path)) {
        $errors += "Obsolete path still exists: $path"
    }
}

foreach ($path in $requiredMechanisms) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $path))) {
        $errors += "Required mechanism missing: $path"
    }
}

if ($errors.Count -gt 0) {
    throw ("Agent system eval failed:`n" + ($errors -join "`n"))
}

& (Join-Path $Root "scripts\audit-automations.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-skill-sync.ps1") -Root $Root
& (Join-Path $Root "scripts\audit-system-improvement-proposals.ps1") -Root $Root

Write-Output "Agent system eval passed."
