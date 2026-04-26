param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$proposalRoot = Join-Path $Root "docs\knowledge\system-improvement\proposals"
$requiredHeadings = @(
    "## 触发事实",
    "## 候选改动",
    "## 权限级别",
    "## 证据",
    "## 最小实现",
    "## 验证方式",
    "## 回退方式",
    "## 状态"
)

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
    foreach ($heading in $requiredHeadings) {
        if ($content -notlike "*$heading*") {
            $errors += "$($file.Name) missing heading: $heading"
        }
    }
}

Write-Output ("proposal files: {0}" -f $files.Count)

if ($errors.Count -gt 0) {
    Write-Error ("System improvement proposal errors:`n" + ($errors -join "`n"))
}

Write-Output "System improvement proposal audit passed."
