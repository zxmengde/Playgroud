param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

function To-RepoPath {
    param([string]$Path)
    return ($Path -replace "\\", "/")
}

$tracked = @(& git -C $Root ls-files)
$generatedRules = @(
    @{ Name = "workspace Codex state"; Pattern = '^\.codex/' },
    @{ Name = "local cache"; Pattern = '^\.cache/' },
    @{ Name = "temporary files"; Pattern = '(^tmp/|/tmp/|\.tmp$)' },
    @{ Name = "runtime logs"; Pattern = '(^logs/|\.log$)' },
    @{ Name = "generated output"; Pattern = '^output/' },
    @{ Name = "Node dependencies"; Pattern = '(^|/)node_modules/' },
    @{ Name = "Python bytecode"; Pattern = '(__pycache__/|\.pyc$)' },
    @{ Name = "local environment"; Pattern = '(^|/)\.env(\.|$)' },
    @{ Name = "secret material"; Pattern = '(\.key$|\.pem$|^secrets/)' }
)

$trackedGenerated = @()
foreach ($file in $tracked) {
    foreach ($rule in $generatedRules) {
        if ($file -match $rule.Pattern) {
            $trackedGenerated += [pscustomobject]@{
                File = $file
                Rule = $rule.Name
            }
        }
    }
}

$assistantFiles = @()
$assistantDir = Join-Path $Root "docs\assistant"
if (Test-Path -LiteralPath $assistantDir) {
    $assistantFiles = @(Get-ChildItem -Path $assistantDir -Filter "*.md" -File -ErrorAction SilentlyContinue)
}
$legacyAssistantFiles = @($assistantFiles | Where-Object { $_.Name -ne "index.md" })

$legacySkillPath = Join-Path $Root "skills\personal-work-assistant"
$archiveLegacyPath = Join-Path $Root "docs\archive\assistant-v1"
$outputPath = Join-Path $Root "output"

$skillFiles = @(Get-ChildItem -Path (Join-Path $Root "skills") -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)
$scriptFiles = @(Get-ChildItem -Path (Join-Path $Root "scripts") -Filter "*.ps1" -File -ErrorAction SilentlyContinue)
$markdownFiles = @(Get-ChildItem -Path $Root -Recurse -Filter "*.md" -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch "\\.git\\" })

$largeTracked = @()
foreach ($file in $tracked) {
    $full = Join-Path $Root ($file -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (Test-Path -LiteralPath $full) {
        $item = Get-Item -LiteralPath $full
        if ($item.Length -gt 1MB) {
            $largeTracked += [pscustomobject]@{
                File = $file
                SizeMB = [math]::Round($item.Length / 1MB, 2)
            }
        }
    }
}

$duplicateHashes = @()
$hashes = @{}
foreach ($file in $tracked) {
    $full = Join-Path $Root ($file -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $full)) { continue }
    $item = Get-Item -LiteralPath $full
    if ($item.Length -eq 0 -or $item.Length -gt 512KB) { continue }
    $hash = (Get-FileHash -LiteralPath $full -Algorithm SHA256).Hash
    if (-not $hashes.ContainsKey($hash)) {
        $hashes[$hash] = @()
    }
    $hashes[$hash] += $file
}
foreach ($hash in $hashes.Keys) {
    if ($hashes[$hash].Count -gt 1) {
        $duplicateHashes += ,@($hashes[$hash])
    }
}

$failures = @()
if ($trackedGenerated.Count -gt 0) {
    $failures += "Generated or local-only files are tracked."
}
if ($legacyAssistantFiles.Count -gt 0) {
    $failures += "Legacy docs/assistant markdown files still exist outside index.md."
}
if (Test-Path -LiteralPath $legacySkillPath) {
    $failures += "Legacy personal-work-assistant skill still exists."
}
if (Test-Path -LiteralPath $archiveLegacyPath) {
    $archiveFiles = @(Get-ChildItem -Path $archiveLegacyPath -Recurse -File -ErrorAction SilentlyContinue)
    if ($archiveFiles.Count -gt 0) {
        $failures += "Legacy assistant-v1 archive directory still has files."
    }
}

Write-Output "Minimality audit"
Write-Output ("tracked files: {0}" -f $tracked.Count)
Write-Output ("markdown files: {0}" -f $markdownFiles.Count)
Write-Output ("skill definitions: {0}" -f $skillFiles.Count)
Write-Output ("PowerShell scripts: {0}" -f $scriptFiles.Count)
Write-Output ("tracked generated/local-only files: {0}" -f $trackedGenerated.Count)
Write-Output ("legacy docs/assistant files: {0}" -f $legacyAssistantFiles.Count)
Write-Output ("legacy personal-work-assistant skill exists: {0}" -f (Test-Path -LiteralPath $legacySkillPath))
Write-Output ("tracked files larger than 1 MB: {0}" -f $largeTracked.Count)
Write-Output ("duplicate small-file content groups: {0}" -f $duplicateHashes.Count)
Write-Output ("local output directory exists: {0}" -f (Test-Path -LiteralPath $outputPath))

if ($trackedGenerated.Count -gt 0) {
    Write-Output ""
    Write-Output "Tracked generated/local-only files"
    $trackedGenerated | ForEach-Object { Write-Output ("- {0} ({1})" -f $_.File, $_.Rule) }
}

if ($largeTracked.Count -gt 0) {
    Write-Output ""
    Write-Output "Large tracked files"
    $largeTracked | Sort-Object SizeMB -Descending | ForEach-Object {
        Write-Output ("- {0}: {1} MB" -f $_.File, $_.SizeMB)
    }
}

if ($duplicateHashes.Count -gt 0) {
    Write-Output ""
    Write-Output "Duplicate small-file groups"
    foreach ($group in $duplicateHashes) {
        Write-Output ("- " + ($group -join ", "))
    }
}

if ($failures.Count -gt 0) {
    throw ("Minimality audit failed: " + ($failures -join " "))
}

Write-Output "Minimality audit passed."
