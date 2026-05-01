param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$trackedAndUntracked = @(& git -C $Root -c core.quotePath=false ls-files --cached --others --exclude-standard)
$textFiles = foreach ($path in $trackedAndUntracked) {
    if ($path -notmatch '\.(md|yaml|yml|ps1|json)$') {
        continue
    }
    $full = Join-Path $Root ($path -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    if (Test-Path -LiteralPath $full) {
        Get-Item -LiteralPath $full
    }
}

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
