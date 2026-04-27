param(
    [string]$CodexHome = "$env:USERPROFILE\.codex"
)

$ErrorActionPreference = "Stop"

function Get-RelativePathSafe {
    param(
        [string]$Base,
        [string]$Path
    )
    try {
        $fullBase = (Resolve-Path $Base).Path.TrimEnd('\')
        $fullPath = (Resolve-Path $Path).Path
        if ($fullPath.StartsWith($fullBase)) {
            return $fullPath.Substring($fullBase.Length + 1)
        }
        return $fullPath
    } catch {
        return $Path
    }
}

Write-Output "Codex capability audit"

if (-not (Test-Path -LiteralPath $CodexHome)) {
    Write-Output "Codex home not found: $CodexHome"
    return
}

$pluginCache = Join-Path $CodexHome "plugins\cache"
if (Test-Path -LiteralPath $pluginCache) {
    Write-Output ""
    Write-Output "Plugin cache"
    $pluginRoots = @(Get-ChildItem -Path $pluginCache -Directory -ErrorAction SilentlyContinue)
    foreach ($root in $pluginRoots) {
        $plugins = @(Get-ChildItem -Path $root.FullName -Directory -ErrorAction SilentlyContinue)
        foreach ($plugin in $plugins) {
            $skillFiles = @(Get-ChildItem -Path $plugin.FullName -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)
            $readmeFiles = @(Get-ChildItem -Path $plugin.FullName -Recurse -Filter "README.md" -File -ErrorAction SilentlyContinue)
            Write-Output ("- {0}/{1}: skills={2}; readmeFiles={3}" -f $root.Name, $plugin.Name, $skillFiles.Count, $readmeFiles.Count)
        }
    }
} else {
    Write-Output "Plugin cache not found."
}

$skillsDir = Join-Path $CodexHome "skills"
if (Test-Path -LiteralPath $skillsDir) {
    Write-Output ""
    Write-Output "User skills"
    $skills = @(Get-ChildItem -Path $skillsDir -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)
    foreach ($skill in $skills) {
        Write-Output ("- {0}" -f (Get-RelativePathSafe -Base $skillsDir -Path $skill.FullName))
    }
} else {
    Write-Output "User skills directory not found."
}

$workspaceCodex = Join-Path (Resolve-Path "$PSScriptRoot\..").Path ".codex"
if (Test-Path -LiteralPath $workspaceCodex) {
    Write-Output ""
    Write-Output "Workspace .codex directory exists. Treat it as local generated state unless a task explicitly requires versioning it."
}
