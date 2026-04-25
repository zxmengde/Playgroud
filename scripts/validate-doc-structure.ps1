param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$required = @(
    "docs\core\identity-and-goal.md",
    "docs\core\permission-boundary.md",
    "docs\core\execution-loop.md",
    "docs\core\memory-state.md",
    "docs\core\finish-readiness.md",
    "docs\references\assistant",
    "docs\archive\assistant-v1",
    "docs\capabilities\index.md",
    "docs\capabilities\gap-review.md",
    "docs\knowledge\system-improvement\harness-log.md",
    "docs\knowledge\system-improvement\skill-audit.md"
)

$missing = @()
foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $path))) {
        $missing += $path
    }
}

if ($missing.Count -gt 0) {
    throw ("Missing v2 document structure paths: " + ($missing -join ", "))
}

$stubs = @(
    @{ Legacy = "docs\assistant\agent-capability-improvement.md"; Target = "docs/references/assistant/agent-capability-improvement.md" },
    @{ Legacy = "docs\assistant\agent-tool-landscape.md"; Target = "docs/references/assistant/agent-tool-landscape.md" },
    @{ Legacy = "docs\assistant\alignment-audit.md"; Target = "docs/archive/assistant-v1/alignment-audit.md" },
    @{ Legacy = "docs\assistant\automation-policy.md"; Target = "docs/references/assistant/automation-policy.md" },
    @{ Legacy = "docs\assistant\capability-gap-review.md"; Target = "docs/capabilities/gap-review.md" },
    @{ Legacy = "docs\assistant\cost-control.md"; Target = "docs/references/assistant/cost-control.md" },
    @{ Legacy = "docs\assistant\execution-contract.md"; Target = "docs/archive/assistant-v1/execution-contract.md" },
    @{ Legacy = "docs\assistant\git-network-troubleshooting.md"; Target = "docs/references/assistant/git-network-troubleshooting.md" },
    @{ Legacy = "docs\assistant\harness-log.md"; Target = "docs/knowledge/system-improvement/harness-log.md" },
    @{ Legacy = "docs\assistant\intent-interview.md"; Target = "docs/references/assistant/intent-interview.md" },
    @{ Legacy = "docs\assistant\long-task-quality.md"; Target = "docs/archive/assistant-v1/long-task-quality.md" },
    @{ Legacy = "docs\assistant\memory-model.md"; Target = "docs/archive/assistant-v1/memory-model.md" },
    @{ Legacy = "docs\assistant\overview.md"; Target = "docs/archive/assistant-v1/overview.md" },
    @{ Legacy = "docs\assistant\permissions.md"; Target = "docs/archive/assistant-v1/permissions.md" },
    @{ Legacy = "docs\assistant\personal-agent-operating-model.md"; Target = "docs/references/assistant/personal-agent-operating-model.md" },
    @{ Legacy = "docs\assistant\pre-finish-check.md"; Target = "docs/archive/assistant-v1/pre-finish-check.md" },
    @{ Legacy = "docs\assistant\preferences.md"; Target = "docs/archive/assistant-v1/preferences.md" },
    @{ Legacy = "docs\assistant\security-model.md"; Target = "docs/archive/assistant-v1/security-model.md" },
    @{ Legacy = "docs\assistant\skill-audit.md"; Target = "docs/knowledge/system-improvement/skill-audit.md" },
    @{ Legacy = "docs\assistant\skill-quality-standard.md"; Target = "docs/references/assistant/skill-quality-standard.md" },
    @{ Legacy = "docs\assistant\third-party-skill-evaluation.md"; Target = "docs/references/assistant/third-party-skill-evaluation.md" },
    @{ Legacy = "docs\assistant\tool-registry.md"; Target = "docs/references/assistant/tool-registry.md" }
)

$errors = @()
foreach ($stub in $stubs) {
    $legacyPath = Join-Path $Root $stub.Legacy
    $targetPath = Join-Path $Root ($stub.Target -replace "/", "\")
    if (-not (Test-Path -LiteralPath $legacyPath)) {
        $errors += "Missing legacy stub: $($stub.Legacy)"
        continue
    }
    if (-not (Test-Path -LiteralPath $targetPath)) {
        $errors += "Missing migrated target: $($stub.Target)"
        continue
    }
    $content = Get-Content -LiteralPath $legacyPath -Raw
    if (($content -notlike "*v1*") -or ($content -notlike "*$($stub.Target)*")) {
        $errors += "Legacy stub does not point to migrated target: $($stub.Legacy)"
    }
}

if ($errors.Count -gt 0) {
    throw ("Document structure errors:`n" + ($errors -join "`n"))
}

Write-Output "Document structure check passed."

