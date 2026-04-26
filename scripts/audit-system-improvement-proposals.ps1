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
$allowedCategories = @("memory", "skill", "config", "hook", "doc", "eval", "automation")

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
    $categoryMatch = [regex]::Match($content, '(?m)^-\s*分类：\s*([A-Za-z-]+)\s*$')
    if (-not $categoryMatch.Success) {
        $errors += "$($file.Name) missing category metadata."
    } elseif ($allowedCategories -notcontains $categoryMatch.Groups[1].Value) {
        $errors += "$($file.Name) invalid category: $($categoryMatch.Groups[1].Value)"
    }
}

Write-Output ("proposal files: {0}" -f $files.Count)

if ($errors.Count -gt 0) {
    Write-Error ("System improvement proposal errors:`n" + ($errors -join "`n"))
}

Write-Output "System improvement proposal audit passed."
