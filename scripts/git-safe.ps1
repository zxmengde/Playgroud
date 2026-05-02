param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$GitArgs
)

$ErrorActionPreference = "Stop"

$repairScript = Join-Path $PSScriptRoot "lib\commands\repair-git-network-env.ps1"
if (Test-Path -LiteralPath $repairScript) {
    & $repairScript -Quiet
}

if ($GitArgs.Count -eq 0) {
    Write-Output "Usage: .\scripts\git-safe.ps1 <git arguments>"
    Write-Output "Example: .\scripts\git-safe.ps1 pull --ff-only"
    exit 2
}

& git @GitArgs
exit $LASTEXITCODE
