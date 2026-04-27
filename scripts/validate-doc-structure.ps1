param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$required = @(
    "docs\core\index.md",
    "docs\assistant\index.md",
    "docs\references\assistant",
    "docs\archive\assistant-v1-summary.md",
    "docs\capabilities\index.md",
    "docs\references\assistant\external-capability-radar.md",
    "docs\references\assistant\external-mechanism-transfer.md",
    "docs\references\assistant\codex-app-settings.md",
    "docs\references\assistant\plugin-mcp-availability.md",
    "docs\references\assistant\mcp-capability-plan.md",
    "docs\references\assistant\agent-benchmark-integration.md",
    "docs\knowledge\system-improvement\harness-log.md",
    "docs\knowledge\system-improvement\skill-audit.md",
    ".agents\skills\playgroud-maintenance\SKILL.md",
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
$unexpectedCore = @($coreMarkdown | Where-Object { $_.Name -ne "index.md" })
if ($unexpectedCore.Count -gt 0) {
    throw ("Unexpected docs/core markdown files: " + (($unexpectedCore | Select-Object -ExpandProperty Name) -join ", "))
}

$capMarkdown = @(Get-ChildItem -Path (Join-Path $Root "docs\capabilities") -Filter "*.md" -File -ErrorAction SilentlyContinue)
$unexpectedCaps = @($capMarkdown | Where-Object { $_.Name -ne "index.md" })
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
