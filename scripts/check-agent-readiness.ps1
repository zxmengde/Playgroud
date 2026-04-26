param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

$warnings = @()
function Add-WarningLine {
    param([string]$Message)
    $script:warnings += $Message
}

Write-Output "Agent readiness checks"

Write-Output ""
Write-Output "## Minimality"
& (Join-Path $Root "scripts\audit-minimality.ps1") -Root $Root

Write-Output ""
Write-Output "## MCP configuration"
$mcpOutput = & (Join-Path $Root "scripts\audit-mcp-config.ps1")
$mcpOutput | ForEach-Object { Write-Output $_ }
foreach ($name in @("context7", "openaiDeveloperDocs", "sequentialThinking")) {
    if (($mcpOutput | Where-Object { $_ -like "*$name*" }).Count -eq 0) {
        Add-WarningLine ("MCP server not found in config: {0}" -f $name)
    }
}

Write-Output ""
Write-Output "## Runtime"
& (Join-Path $Root "scripts\test-codex-runtime.ps1") -Root $Root -SkipNetwork

Write-Output ""
Write-Output "## Video skills"
& (Join-Path $Root "scripts\audit-video-skill-readiness.ps1")

Write-Output ""
Write-Output "## Task state markers"
$activePath = Join-Path $Root "docs\tasks\active.md"
if (Test-Path -LiteralPath $activePath) {
    $active = Get-Content -LiteralPath $activePath -Raw
    foreach ($marker in @("当前目标", "已读来源", "已执行命令", "产物", "未验证判断", "阻塞", "反迎合审查")) {
        if ($active -notlike "*$marker*") {
            Add-WarningLine ("Active task state is missing marker: {0}" -f $marker)
        }
    }
} else {
    Add-WarningLine "docs/tasks/active.md is missing."
}

if ($warnings.Count -gt 0) {
    Write-Output ""
    Write-Output "## Warnings"
    $warnings | ForEach-Object { Write-Output ("- {0}" -f $_) }
    if ($Strict) {
        throw "Agent readiness warnings exist in strict mode."
    }
}

Write-Output ""
Write-Output "Agent readiness check completed."
