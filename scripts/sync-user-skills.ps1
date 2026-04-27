param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$UserSkills = (Join-Path $env:USERPROFILE ".codex\skills")
)

$ErrorActionPreference = "Stop"

$repoSkillsRoot = Join-Path $Root "skills"
if (-not (Test-Path -LiteralPath $repoSkillsRoot)) {
    throw "Missing repository skills directory: $repoSkillsRoot"
}

New-Item -ItemType Directory -Path $UserSkills -Force | Out-Null

$retiredRepoSkills = @(
    "assistant-router",
    "execution-governor",
    "style-governor"
)
foreach ($name in $retiredRepoSkills) {
    $target = Join-Path $UserSkills $name
    if (Test-Path -LiteralPath $target) {
        $resolvedUserSkills = (Resolve-Path $UserSkills).Path
        $resolvedTarget = (Resolve-Path $target).Path
        if (-not $resolvedTarget.StartsWith($resolvedUserSkills, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove unexpected skill path: $resolvedTarget"
        }
        Remove-Item -LiteralPath $resolvedTarget -Recurse -Force
        Write-Output ("Removed retired skill: {0}" -f $name)
    }
}

$repoSkills = @(Get-ChildItem -Path $repoSkillsRoot -Directory -ErrorAction SilentlyContinue |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md") })
foreach ($repoSkill in $repoSkills) {
    $target = Join-Path $UserSkills $repoSkill.Name
    New-Item -ItemType Directory -Path $target -Force | Out-Null

    $repoFiles = @(Get-ChildItem -Path $repoSkill.FullName -Recurse -File -Include "SKILL.md" -ErrorAction SilentlyContinue)
    foreach ($repoFile in $repoFiles) {
        $relative = [System.IO.Path]::GetRelativePath($repoSkill.FullName, $repoFile.FullName)
        $targetFile = Join-Path $target $relative
        $targetDir = Split-Path -Parent $targetFile
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Copy-Item -LiteralPath $repoFile.FullName -Destination $targetFile -Force
    }

    $staleAgents = Join-Path $target "agents"
    if (Test-Path -LiteralPath $staleAgents) {
        $resolvedTarget = (Resolve-Path $target).Path
        $resolvedAgents = (Resolve-Path $staleAgents).Path
        if (-not $resolvedAgents.StartsWith($resolvedTarget, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove unexpected agents path: $resolvedAgents"
        }
        Remove-Item -LiteralPath $resolvedAgents -Recurse -Force
    }
    Write-Output ("Synced skill: {0}" -f $repoSkill.Name)
}

& (Join-Path $Root "scripts\audit-skill-sync.ps1") -Root $Root -UserSkills $UserSkills
