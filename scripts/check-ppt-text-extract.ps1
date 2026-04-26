param(
    [Parameter(Mandatory=$true)][string]$Path,
    [int]$MaxTextItemsPerSlide = 35
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path "$PSScriptRoot\..").Path
$fullPath = if ([System.IO.Path]::IsPathRooted($Path)) { $Path } else { Join-Path $root $Path }

if (-not (Test-Path -LiteralPath $fullPath)) {
    throw "PPT text extract JSON not found: $fullPath"
}

$slides = Get-Content -LiteralPath $fullPath -Raw | ConvertFrom-Json
$warnings = @()

foreach ($slide in $slides) {
    $items = @($slide.items)
    if ($items.Count -eq 0) {
        $warnings += "Slide $($slide.slide): no text items."
    }
    if ($items.Count -gt $MaxTextItemsPerSlide) {
        $warnings += "Slide $($slide.slide): $($items.Count) text items exceeds $MaxTextItemsPerSlide."
    }
    $longItems = $items | Where-Object { $_.text.Length -gt 180 }
    foreach ($item in $longItems) {
        $warnings += "Slide $($slide.slide) $($item.shape): long text may need layout review."
    }
}

if ($warnings.Count -gt 0) {
    Write-Output "PPT text extract check completed with warnings:"
    $warnings | ForEach-Object { Write-Output "- $_" }
} else {
    Write-Output "PPT text extract check passed."
}

