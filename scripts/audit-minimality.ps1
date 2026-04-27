param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$tracked = @(& git -C $Root ls-files)
$generatedRules = @(
    @{ Name = "workspace Codex generated state"; Pattern = '^\.codex/(?!hooks\.json$)' },
    @{ Name = "local cache"; Pattern = '^\.cache/' },
    @{ Name = "temporary files"; Pattern = '(^tmp/|/tmp/|\.tmp$)' },
    @{ Name = "runtime logs"; Pattern = '(^logs/|\.log$)' },
    @{ Name = "generated output"; Pattern = '^output/' },
    @{ Name = "Node dependencies"; Pattern = '(^|/)node_modules/' },
    @{ Name = "Python bytecode"; Pattern = '(__pycache__/|\.pyc$)' },
    @{ Name = "local environment"; Pattern = '(^|/)\.env(\.|$)' },
    @{ Name = "secret material"; Pattern = '(\.key$|\.pem$|^secrets/)' },
    @{ Name = "legacy repository skills"; Pattern = '^skills/' }
)

$trackedGenerated = @()
foreach ($file in $tracked) {
    $full = Join-Path $Root ($file -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $full)) { continue }
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

$coreFiles = @(Get-ChildItem -Path (Join-Path $Root "docs\core") -Filter "*.md" -File -ErrorAction SilentlyContinue)
$legacyCoreFiles = @($coreFiles | Where-Object { $_.Name -ne "index.md" })
$capFiles = @(Get-ChildItem -Path (Join-Path $Root "docs\capabilities") -Filter "*.md" -File -ErrorAction SilentlyContinue)
$legacyCapFiles = @($capFiles | Where-Object { $_.Name -ne "index.md" })

$archiveLegacyPath = Join-Path $Root "docs\archive\assistant-v1"
$outputPath = Join-Path $Root "output"
$skillFiles = @(Get-ChildItem -Path (Join-Path $Root ".agents\skills") -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)
$scriptFiles = @(Get-ChildItem -Path (Join-Path $Root "scripts") -Filter "*.ps1" -File -ErrorAction SilentlyContinue)
$trackedMarkdownFiles = @($tracked | Where-Object { $_ -match '\.md$' })

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

$failures = @()
if ($trackedGenerated.Count -gt 0) { $failures += "Generated, local-only, or legacy skill files are tracked." }
if ($legacyAssistantFiles.Count -gt 0) { $failures += "Legacy docs/assistant markdown files still exist outside index.md." }
if ($legacyCoreFiles.Count -gt 0) { $failures += "Legacy docs/core markdown files still exist outside index.md." }
if ($legacyCapFiles.Count -gt 0) { $failures += "Legacy docs/capabilities markdown files still exist outside index.md." }
if (Test-Path -LiteralPath $archiveLegacyPath) {
    $archiveFiles = @(Get-ChildItem -Path $archiveLegacyPath -Recurse -File -ErrorAction SilentlyContinue)
    if ($archiveFiles.Count -gt 0) { $failures += "Legacy assistant-v1 archive directory still has files." }
}

Write-Output "Minimality audit"
Write-Output ("tracked files: {0}" -f $tracked.Count)
Write-Output ("tracked markdown files: {0}" -f $trackedMarkdownFiles.Count)
Write-Output ("repository skill definitions: {0}" -f $skillFiles.Count)
Write-Output ("PowerShell scripts: {0}" -f $scriptFiles.Count)
Write-Output ("tracked generated/local-only/legacy files: {0}" -f $trackedGenerated.Count)
Write-Output ("legacy docs/assistant files: {0}" -f $legacyAssistantFiles.Count)
Write-Output ("legacy docs/core files: {0}" -f $legacyCoreFiles.Count)
Write-Output ("legacy docs/capabilities files: {0}" -f $legacyCapFiles.Count)
Write-Output ("tracked files larger than 1 MB: {0}" -f $largeTracked.Count)
Write-Output ("local output directory exists: {0}" -f (Test-Path -LiteralPath $outputPath))

if ($trackedGenerated.Count -gt 0) {
    Write-Output ""
    Write-Output "Tracked generated/local-only/legacy files"
    $trackedGenerated | ForEach-Object { Write-Output ("- {0} ({1})" -f $_.File, $_.Rule) }
}

if ($largeTracked.Count -gt 0) {
    Write-Output ""
    Write-Output "Large tracked files"
    $largeTracked | Sort-Object SizeMB -Descending | ForEach-Object {
        Write-Output ("- {0}: {1} MB" -f $_.File, $_.SizeMB)
    }
}

if ($failures.Count -gt 0) {
    throw ("Minimality audit failed: " + ($failures -join " "))
}

Write-Output "Minimality audit passed."
