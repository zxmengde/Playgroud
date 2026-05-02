param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"
& (Join-Path $PSScriptRoot "lib\commands\pre-commit-check.ps1") -Root $Root
exit $LASTEXITCODE
