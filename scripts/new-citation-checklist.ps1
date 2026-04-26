param(
    [Parameter(Mandatory=$true)][string]$Title,
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path "$PSScriptRoot\..").Path
$templatePath = Join-Path $root "templates\research\citation-checklist.md"

if (-not (Test-Path -LiteralPath $templatePath)) {
    throw "Missing template: $templatePath"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $safe = ($Title -replace '[^\p{L}\p{Nd}]+','-').Trim('-')
    if ([string]::IsNullOrWhiteSpace($safe)) { $safe = "citation-checklist" }
    $date = Get-Date -Format "yyyy-MM-dd"
    $OutputPath = Join-Path $root "output\$date-$safe-citation-checklist.md"
}

if (Test-Path -LiteralPath $OutputPath) {
    throw "Output already exists: $OutputPath"
}

$parent = Split-Path -Parent $OutputPath
if (-not [string]::IsNullOrWhiteSpace($parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
}

$content = Get-Content -LiteralPath $templatePath -Raw
$content = $content -replace "## 任务", "## 任务`n`n$Title"
Set-Content -LiteralPath $OutputPath -Value $content -Encoding UTF8
Write-Output $OutputPath

