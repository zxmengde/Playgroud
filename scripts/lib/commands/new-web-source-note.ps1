param(
    [Parameter(Mandatory=$true)][string]$Url,
    [string]$Title = "",
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
$templatePath = Join-Path $root "templates\web\source-note.md"

if (-not (Test-Path -LiteralPath $templatePath)) {
    throw "Missing template: $templatePath"
}

if ([string]::IsNullOrWhiteSpace($Title)) {
    $Title = "web-source"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $safe = ($Title -replace '[^\p{L}\p{Nd}]+','-').Trim('-')
    if ([string]::IsNullOrWhiteSpace($safe)) { $safe = "web-source" }
    $date = Get-Date -Format "yyyy-MM-dd"
    $OutputPath = Join-Path $root "output\$date-$safe-web-source.md"
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
$content = $content -replace "- URL：", "- URL：$Url"
$content = $content -replace "- 标题：", "- 标题：$Title"
$content = $content -replace "- 访问日期：", "- 访问日期：$today"
Set-Content -LiteralPath $OutputPath -Value $content -Encoding UTF8
Write-Output $OutputPath
