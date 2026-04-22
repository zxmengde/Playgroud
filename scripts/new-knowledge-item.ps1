param(
    [Parameter(Mandatory=$true)][string]$Title,
    [string]$Type = "note"
)

$ErrorActionPreference = "Stop"
$root = Resolve-Path "$PSScriptRoot\.."
$safe = ($Title -replace '[^\p{L}\p{Nd}]+','-').Trim('-')
if ([string]::IsNullOrWhiteSpace($safe)) {
    $safe = "item"
}

$date = Get-Date -Format "yyyy-MM-dd"
$target = Join-Path $root "docs\knowledge\items\$date-$safe.md"
if (Test-Path -LiteralPath $target) {
    throw "Knowledge item already exists: $target"
}

$template = Get-Content -LiteralPath (Join-Path $root "templates\knowledge\knowledge-item.md") -Raw
$content = $template -replace "title:\s*", "title: $Title" -replace "type:\s*", "type: $Type"
Set-Content -LiteralPath $target -Value $content -Encoding UTF8
Write-Output $target
