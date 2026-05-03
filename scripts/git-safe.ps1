param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$GitArgs
)

$ErrorActionPreference = "Stop"

if ($GitArgs.Count -eq 0) {
    Write-Output "Usage: .\scripts\git-safe.ps1 <git arguments>"
    exit 2
}

& git @GitArgs
exit $LASTEXITCODE
