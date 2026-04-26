param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$CodexHome = $(if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" })
)

$ErrorActionPreference = "Stop"

Write-Output "Automation audit"

$automationRoot = Join-Path $CodexHome "automations"
if (-not (Test-Path -LiteralPath $automationRoot)) {
    Write-Output "automation files: 0"
    Write-Output "Automation audit passed."
    return
}

$files = @(Get-ChildItem -Path $automationRoot -Recurse -Filter "automation.toml" -File -ErrorAction SilentlyContinue)
$errors = @()

foreach ($file in $files) {
    $content = Get-Content -LiteralPath $file.FullName -Raw

    $id = ""
    $kind = ""
    $status = ""
    $executionEnvironment = ""

    $idMatch = [regex]::Match($content, '(?m)^id\s*=\s*"([^"]*)"')
    if ($idMatch.Success) { $id = $idMatch.Groups[1].Value }
    $kindMatch = [regex]::Match($content, '(?m)^kind\s*=\s*"([^"]*)"')
    if ($kindMatch.Success) { $kind = $kindMatch.Groups[1].Value }
    $statusMatch = [regex]::Match($content, '(?m)^status\s*=\s*"([^"]*)"')
    if ($statusMatch.Success) { $status = $statusMatch.Groups[1].Value }
    $envMatch = [regex]::Match($content, '(?m)^execution_environment\s*=\s*"([^"]*)"')
    if ($envMatch.Success) { $executionEnvironment = $envMatch.Groups[1].Value }

    Write-Output ("- {0}: status={1}; kind={2}; environment={3}" -f $id, $status, $kind, $executionEnvironment)

    $isActiveCron = ($status -eq "ACTIVE" -and $kind -eq "cron")
    if ($isActiveCron -and $content -match "完整授权") {
        $errors += "$($file.FullName): active cron automation contains one-time full authorization language."
    }

    if ($isActiveCron -and $executionEnvironment -eq "local") {
        $isReadOnly = ($content -match "只读" -and $content -match "不要修改")
        if (-not $isReadOnly) {
            $errors += "$($file.FullName): active local cron automation is not explicitly read-only."
        }
    }

    if ($isActiveCron -and $content -match "保存凭据|保存密钥|账号密码|外部账号写入") {
        $errors += "$($file.FullName): active cron automation references credential or external-account write scope."
    }
}

Write-Output ("automation files: {0}" -f $files.Count)

if ($errors.Count -gt 0) {
    Write-Error ("Automation audit errors:`n" + ($errors -join "`n"))
}

Write-Output "Automation audit passed."
