param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"

$assistantFiles = @(Get-ChildItem -Path (Join-Path $Root "docs\assistant") -Filter "*.md" -File -ErrorAction SilentlyContinue)
$coreFiles = @(Get-ChildItem -Path (Join-Path $Root "docs\core") -Filter "*.md" -File -ErrorAction SilentlyContinue)
$capFiles = @(Get-ChildItem -Path (Join-Path $Root "docs\capabilities") -Filter "*.md" -File -ErrorAction SilentlyContinue)
$legacySkillFiles = @(Get-ChildItem -Path (Join-Path $Root "skills") -Recurse -File -ErrorAction SilentlyContinue)
$repoSkillFiles = @(Get-ChildItem -Path (Join-Path $Root ".agents\skills") -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)
$outputFiles = @(Get-ChildItem -Path (Join-Path $Root "output") -Recurse -File -ErrorAction SilentlyContinue)

Write-Output "Redundancy audit"
Write-Output ("docs/assistant markdown files: {0}" -f $assistantFiles.Count)
Write-Output ("docs/core markdown files: {0}" -f $coreFiles.Count)
Write-Output ("docs/capabilities markdown files: {0}" -f $capFiles.Count)
Write-Output ("legacy skills files: {0}" -f $legacySkillFiles.Count)
Write-Output ("repository skill definitions: {0}" -f $repoSkillFiles.Count)
Write-Output ("output files: {0}" -f $outputFiles.Count)
Write-Output "No files were changed."
