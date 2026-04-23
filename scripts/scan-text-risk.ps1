param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$textFiles = Get-ChildItem -Path $Root -Recurse -File -Include *.md,*.yaml,*.yml,*.ps1,*.json -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "\\.git\\" }

$hiddenPattern = "[\u200B-\u200F\u202A-\u202E\u2060-\u206F\uFEFF]"
$controlPattern = "[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]"
$hits = @()

foreach ($file in $textFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) {
        continue
    }

    if ($content -match $hiddenPattern) {
        $hits += "$($file.FullName): hidden Unicode control character"
    }

    if ($content -match $controlPattern) {
        $hits += "$($file.FullName): unexpected ASCII control character"
    }
}

if ($hits.Count -gt 0) {
    Write-Error ("Text risk scan failed:`n" + ($hits -join "`n"))
}

Write-Output "Text risk scan passed."
