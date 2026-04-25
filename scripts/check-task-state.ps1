param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$path = Join-Path $Root "docs\tasks\active.md"
if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing task state file: $path"
}

$content = Get-Content -LiteralPath $path -Raw
$requiredHeadings = @(
    "# 当前任务",
    "## 当前目标",
    "## 已读来源",
    "## 已执行命令",
    "## 产物",
    "## 未验证判断",
    "## 阻塞",
    "## 下一步",
    "## 恢复入口",
    "## 反迎合审查"
)

$missing = @()
foreach ($heading in $requiredHeadings) {
    if ($content -notlike "*$heading*") {
        $missing += $heading
    }
}

if ($missing.Count -gt 0) {
    throw ("Task state missing required headings: " + ($missing -join ", "))
}

Write-Output "Task state check passed."

