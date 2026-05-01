param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "self-improvement-object-lib.ps1")

& (Join-Path $PSScriptRoot "validate-routing-v1.ps1") -Root $Root | Out-Host
if ($LASTEXITCODE -eq 1) {
    throw "routing-selection: routing validator reported blocking errors."
}

$routing = Read-JsonYamlFile -Path (Get-RoutingPath -Root $Root)
$requiredSkillNames = @(
    "failure-promoter",
    "external-mechanism-researcher",
    "research-engineering-loop",
    "product-engineering-closer",
    "uiux-reviewer",
    "knowledge-curator",
    "tool-router",
    "finish-verifier"
)

foreach ($skillName in $requiredSkillNames) {
    $path = Join-Path $Root ".agents\skills\$skillName\SKILL.md"
    if (-not (Test-Path -LiteralPath $path)) {
        throw "routing-selection: missing routed skill $skillName."
    }
}

if (@($routing.routes).Count -lt 9) {
    throw "routing-selection: expected at least nine routes."
}

Write-Output "routing-selection: pass"
