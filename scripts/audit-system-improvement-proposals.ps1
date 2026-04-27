param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$proposalRoot = Join-Path $Root "docs\knowledge\system-improvement\proposals"

Write-Output "System improvement proposal audit"

if (-not (Test-Path -LiteralPath $proposalRoot)) {
    Write-Output "proposal files: 0"
    Write-Output "System improvement proposal audit passed."
    return
}

$files = @(Get-ChildItem -Path $proposalRoot -Filter "*.md" -File -ErrorAction SilentlyContinue)
$errors = @()

foreach ($file in $files) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $headingCount = ([regex]::Matches($content, '(?m)^##\s+')).Count
    if ($headingCount -lt 8) {
        $errors += "$($file.Name) has fewer than 8 section headings"
    }
    if ($content -notmatch "needs-confirmation|candidate|accepted|rejected|done") {
        $errors += "$($file.Name) missing machine-readable status word"
    }
}

Write-Output ("proposal files: {0}" -f $files.Count)

if ($errors.Count -gt 0) {
    Write-Error ("System improvement proposal errors:`n" + ($errors -join "`n"))
}

Write-Output "System improvement proposal audit passed."
