param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

function Get-TextOrEmpty {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        return (Get-Content -LiteralPath $Path -Raw -ErrorAction SilentlyContinue)
    }
    return ""
}

$assistantDir = Join-Path $Root "docs\assistant"
$archiveDir = Join-Path $Root "docs\archive\assistant-v1"
$outputDir = Join-Path $Root "output"
$skillDir = Join-Path $Root "skills"
$legacySkillDir = Join-Path $Root "skills\personal-work-assistant"

$assistantFiles = @(Get-ChildItem -Path $assistantDir -Filter "*.md" -File -ErrorAction SilentlyContinue)
$legacyAssistantFiles = @($assistantFiles | Where-Object { $_.Name -ne "index.md" })
$compatStubs = @()
foreach ($file in $legacyAssistantFiles) {
    $content = Get-TextOrEmpty -Path $file.FullName
    if (($content -like "*v1*") -and ($content -like "*迁移*")) {
        $compatStubs += $file
    }
}

$archiveFiles = @(Get-ChildItem -Path $archiveDir -Filter "*.md" -File -ErrorAction SilentlyContinue)
$outputFiles = @(Get-ChildItem -Path $outputDir -Recurse -File -ErrorAction SilentlyContinue)
$skillFiles = @(Get-ChildItem -Path $skillDir -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)

$profileCandidates = @(
    "docs\profile\user-model.md",
    "docs\profile\preference-map.md"
)
$existingProfileCandidates = @()
foreach ($rel in $profileCandidates) {
    if (Test-Path -LiteralPath (Join-Path $Root $rel)) {
        $existingProfileCandidates += $rel
    }
}
$validateSystem = Get-TextOrEmpty -Path (Join-Path $Root "scripts\validate-system.ps1")
$validateDoc = Get-TextOrEmpty -Path (Join-Path $Root "scripts\validate-doc-structure.ps1")
$assistantReferences = @()
foreach ($file in $legacyAssistantFiles) {
    $rel = "docs\assistant\$($file.Name)"
    if (($validateSystem -like "*$rel*") -or ($validateDoc -like "*$rel*")) {
        $assistantReferences += $rel
    }
}

Write-Output "Redundancy audit"
Write-Output ("docs/assistant markdown files: {0}" -f $assistantFiles.Count)
Write-Output ("legacy compatibility stubs: {0}" -f $compatStubs.Count)
Write-Output ("legacy stubs referenced by validation scripts: {0}" -f $assistantReferences.Count)
Write-Output ("archive assistant-v1 markdown files: {0}" -f $archiveFiles.Count)
Write-Output ("output files: {0}" -f $outputFiles.Count)
Write-Output ("skill definitions: {0}" -f $skillFiles.Count)
Write-Output ("profile/preference candidate files: {0}" -f $existingProfileCandidates.Count)
Write-Output ("legacy personal-work-assistant skill exists: {0}" -f (Test-Path -LiteralPath $legacySkillDir))

if ($assistantReferences.Count -gt 0) {
    Write-Output "Validation still depends on legacy stubs. Do not delete them without updating scripts."
}

if ($existingProfileCandidates.Count -gt 2) {
    Write-Output "Profile information may have duplicate maintenance points:"
    foreach ($rel in $existingProfileCandidates) {
        Write-Output ("- {0}" -f $rel)
    }
} else {
    Write-Output "Profile duplicate maintenance point reduced: only profile and preference map remain."
}

Write-Output "No files were changed."
