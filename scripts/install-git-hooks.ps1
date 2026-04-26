param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$gitDirOutput = & git -C $Root rev-parse --git-dir
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($gitDirOutput)) {
    throw "Unable to resolve .git directory."
}

$gitDir = $gitDirOutput.Trim()
if (-not [System.IO.Path]::IsPathRooted($gitDir)) {
    $gitDir = Join-Path $Root $gitDir
}
$gitDir = (Resolve-Path $gitDir).Path

$hooksDir = Join-Path $gitDir "hooks"
New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null

$preCommit = Join-Path $hooksDir "pre-commit"
$scriptPath = (Join-Path $Root "scripts\pre-commit-check.ps1") -replace "\\", "/"
$shell = "powershell.exe"
if (Get-Command "pwsh.exe" -ErrorAction SilentlyContinue) {
    $shell = "pwsh.exe"
}
$content = @"
#!/bin/sh
$shell -NoProfile -ExecutionPolicy Bypass -File "$scriptPath"
"@

Set-Content -LiteralPath $preCommit -Value $content -Encoding ASCII
Write-Output "Installed Git pre-commit hook: $preCommit"
