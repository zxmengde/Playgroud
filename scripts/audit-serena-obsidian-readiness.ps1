param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$CodexConfigPath = "$env:USERPROFILE\.codex\config.toml",
    [string]$ObsidianCliPath = "$env:LOCALAPPDATA\Programs\Obsidian\Obsidian.com",
    [int]$SerenaPort = 9121
)

$ErrorActionPreference = "Stop"

function Require-Command {
    param([string]$Name)
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($null -eq $cmd) {
        throw "Missing command: $Name"
    }
    return $cmd
}

Write-Output "Serena/Obsidian readiness audit"

$serenaCmd = Require-Command -Name "serena"
$obsidianCmd = Require-Command -Name "obsidian"
Write-Output ("- serena: {0}" -f $serenaCmd.Source)
Write-Output ("- obsidian: {0}" -f $obsidianCmd.Source)

if (-not (Test-Path -LiteralPath $CodexConfigPath)) {
    throw "Missing Codex config: $CodexConfigPath"
}
$config = Get-Content -LiteralPath $CodexConfigPath -Raw
if ($config -notmatch '(?ms)^\[mcp_servers\.serena\]\s*(.*?command\s*=\s*"serena")') {
    throw "Codex config does not contain a Serena MCP entry."
}
Write-Output "- codex config: serena entry present"

$serenaVersion = & serena --version
Write-Output ("- serena version: {0}" -f ($serenaVersion -join " "))

$obsidianVersion = & $ObsidianCliPath version
Write-Output ("- obsidian version: {0}" -f ($obsidianVersion -join " "))

$vaultCount = & obsidian vaults total
Write-Output ("- obsidian vaults total: {0}" -f ($vaultCount -join " "))

$searchCount = & obsidian vault=790d1fd6473f4a93 search query="Zotero" total
Write-Output ("- obsidian search sample count: {0}" -f ($searchCount -join " "))

$smokeRead = & obsidian vault=530512f0c6c3c99b read path="Codex/obsidian-cli-smoke.md"
if (($smokeRead -join "`n") -notmatch "Codex smoke") {
    throw "Obsidian smoke note read did not return expected content."
}
Write-Output "- obsidian write smoke note readable"

$nativePreference = $null
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $nativePreference = $global:PSNativeCommandUseErrorActionPreference
    $global:PSNativeCommandUseErrorActionPreference = $false
}

$serverProcess = $null
try {
    $serverProcess = Start-Process -FilePath "serena" -ArgumentList @("start-mcp-server", "--transport", "streamable-http", "--port", "$SerenaPort", "--context", "codex", "--project", $Root) -WindowStyle Hidden -PassThru
    $ready = $false
    for ($i = 0; $i -lt 20; $i++) {
        Start-Sleep -Seconds 1
        try {
            $tcp = Test-NetConnection -ComputerName 127.0.0.1 -Port $SerenaPort -WarningAction SilentlyContinue
            if ($tcp.TcpTestSucceeded) {
                $ready = $true
                break
            }
        } catch {
        }
    }
    if (-not $ready) {
        throw "Serena MCP server did not open port $SerenaPort."
    }
    Write-Output ("- serena mcp http smoke: port {0} open" -f $SerenaPort)
} finally {
    if ($null -ne $nativePreference) {
        $global:PSNativeCommandUseErrorActionPreference = $nativePreference
    }
    if ($null -ne $serverProcess -and -not $serverProcess.HasExited) {
        Stop-Process -Id $serverProcess.Id -Force
    }
}

Write-Output "Serena/Obsidian readiness audit passed."
