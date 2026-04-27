param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$UserSkills = (Join-Path $env:USERPROFILE ".codex\skills")
)

$ErrorActionPreference = "Stop"

Write-Output "Skill sync audit"

$repoSkills = @(Get-ChildItem -Path (Join-Path $Root "skills") -Directory -ErrorAction SilentlyContinue)
if ($repoSkills.Count -eq 0) {
    Write-Output "repo skills: 0"
    Write-Output "Skill sync audit passed."
    return
}

if (-not (Test-Path -LiteralPath $UserSkills)) {
    Write-Output "user skills directory not found; sync audit skipped."
    Write-Output "Skill sync audit passed."
    return
}

$errors = @()
foreach ($repoSkill in $repoSkills) {
    $name = $repoSkill.Name
    $userSkill = Join-Path $UserSkills $name
    if (-not (Test-Path -LiteralPath $userSkill)) {
        $errors += "$name missing from user skills."
        continue
    }

    $repoFiles = @(Get-ChildItem -Path $repoSkill.FullName -Recurse -File -Include "SKILL.md", "*.yaml", "*.yml" -ErrorAction SilentlyContinue)
    foreach ($repoFile in $repoFiles) {
        $relative = [System.IO.Path]::GetRelativePath($repoSkill.FullName, $repoFile.FullName)
        $userFile = Join-Path $userSkill $relative
        if (-not (Test-Path -LiteralPath $userFile)) {
            $errors += "$name/$relative missing from user skills."
            continue
        }
        $repoHash = (Get-FileHash -LiteralPath $repoFile.FullName -Algorithm SHA256).Hash
        $userHash = (Get-FileHash -LiteralPath $userFile -Algorithm SHA256).Hash
        if ($repoHash -ne $userHash) {
            $errors += "$name/$relative differs from repository copy."
        }
    }
}

Write-Output ("repo skills: {0}" -f $repoSkills.Count)

if ($errors.Count -gt 0) {
    Write-Error ("Skill sync errors:`n" + ($errors -join "`n"))
}

Write-Output "Skill sync audit passed."
