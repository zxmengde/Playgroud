param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$safe = ($Name.ToLowerInvariant() -replace '[^a-z0-9\u4e00-\u9fa5-]+', '-').Trim('-')
if ([string]::IsNullOrWhiteSpace($safe)) {
    throw "Name does not contain usable characters."
}

$date = Get-Date -Format "yyyy-MM-dd"
$template = Join-Path $Root "templates\assistant\system-improvement-proposal.md"
$proposalRoot = Join-Path $Root "docs\knowledge\system-improvement\proposals"
$output = Join-Path $proposalRoot "$date-$safe.md"

if (-not (Test-Path -LiteralPath $template)) {
    throw "Missing template: $template"
}

New-Item -ItemType Directory -Path $proposalRoot -Force | Out-Null
if (Test-Path -LiteralPath $output) {
    throw "Proposal already exists: $output"
}

$content = Get-Content -LiteralPath $template -Raw
$content = $content.Replace("{{date}}", $date).Replace("{{name}}", $Name)
Set-Content -LiteralPath $output -Value $content -Encoding UTF8

Write-Output $output
