param(
    [Parameter(Mandatory=$true)][string]$Name,
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path "$PSScriptRoot\..").Path
$templatePath = Join-Path $root "templates\assistant\mcp-adoption-review.md"

if (-not (Test-Path -LiteralPath $templatePath)) {
    throw "Missing template: $templatePath"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $safe = ($Name -replace '[^\p{L}\p{Nd}]+','-').Trim('-')
    if ([string]::IsNullOrWhiteSpace($safe)) { $safe = "mcp-review" }
    $date = Get-Date -Format "yyyy-MM-dd"
    $OutputPath = Join-Path $root "docs\references\assistant\mcp-reviews\$date-$safe.md"
}

if (Test-Path -LiteralPath $OutputPath) {
    throw "Output already exists: $OutputPath"
}

$parent = Split-Path -Parent $OutputPath
if (-not [string]::IsNullOrWhiteSpace($parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
}

$content = Get-Content -LiteralPath $templatePath -Raw
$today = Get-Date -Format "yyyy-MM-dd"
$content = $content -replace "- 名称：", "- 名称：$Name"
$content = $content -replace "- 记录日期：", "- 记录日期：$today"
Set-Content -LiteralPath $OutputPath -Value $content -Encoding UTF8
Write-Output $OutputPath
