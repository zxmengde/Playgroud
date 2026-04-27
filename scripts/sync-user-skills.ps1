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

$repoSkills = @(Get-ChildItem -Path $repoSkillsRoot -Directory -ErrorAction SilentlyContinue)
foreach ($repoSkill in $repoSkills) {
    $target = Join-Path $UserSkills $repoSkill.Name
    New-Item -ItemType Directory -Path $target -Force | Out-Null

    $repoFiles = @(Get-ChildItem -Path $repoSkill.FullName -Recurse -File -Include "SKILL.md", "*.yaml", "*.yml" -ErrorAction SilentlyContinue)
    foreach ($repoFile in $repoFiles) {
        $relative = [System.IO.Path]::GetRelativePath($repoSkill.FullName, $repoFile.FullName)
        $targetFile = Join-Path $target $relative
        $targetDir = Split-Path -Parent $targetFile
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Copy-Item -LiteralPath $repoFile.FullName -Destination $targetFile -Force
    }
    Write-Output ("Synced skill: {0}" -f $repoSkill.Name)
}

& (Join-Path $Root "scripts\audit-skill-sync.ps1") -Root $Root -UserSkills $UserSkills
