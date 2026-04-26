param(
    [string]$ConfigPath = "$env:USERPROFILE\.codex\config.toml",
    [string]$AllowlistPath = (Join-Path (Resolve-Path "$PSScriptRoot\..").Path "docs\references\assistant\mcp-allowlist.json")
)

$ErrorActionPreference = "Stop"

Write-Output "MCP config audit"

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    Write-Output "Config not found: $ConfigPath"
    return
}

$content = Get-Content -LiteralPath $ConfigPath -Raw
$pattern = '(?ms)^\[mcp_servers\.([^\]]+)\]\s*(.*?)(?=^\[|\z)'
$matches = [regex]::Matches($content, $pattern)
$allowlist = $null
if (Test-Path -LiteralPath $AllowlistPath) {
    $allowlist = Get-Content -LiteralPath $AllowlistPath -Raw | ConvertFrom-Json
}

if ($matches.Count -eq 0) {
    Write-Output "No MCP servers found."
    return
}

$unknown = @()
foreach ($match in $matches) {
    $name = $match.Groups[1].Value.Trim('"')
    $body = $match.Groups[2].Value
    $url = ""
    $command = ""
    $argsValue = ""
    $urlMatch = [regex]::Match($body, '(?m)^\s*url\s*=\s*"([^"]+)"')
    if ($urlMatch.Success) { $url = $urlMatch.Groups[1].Value }
    $commandMatch = [regex]::Match($body, '(?m)^\s*command\s*=\s*"([^"]+)"')
    if ($commandMatch.Success) { $command = $commandMatch.Groups[1].Value }
    $argsMatch = [regex]::Match($body, '(?m)^\s*args\s*=\s*(\[.*\])')
    if ($argsMatch.Success) { $argsValue = $argsMatch.Groups[1].Value }

    if (-not [string]::IsNullOrWhiteSpace($url)) {
        Write-Output ("- {0}: url={1}" -f $name, $url)
    } elseif (-not [string]::IsNullOrWhiteSpace($command)) {
        if ([string]::IsNullOrWhiteSpace($argsValue)) {
            Write-Output ("- {0}: command={1}" -f $name, $command)
        } else {
            Write-Output ("- {0}: command={1}; args={2}" -f $name, $command, $argsValue)
        }
    } else {
        Write-Output ("- {0}: no url or command found" -f $name)
    }

    if ($null -ne $allowlist -and ($allowlist.allowed -notcontains $name)) {
        $unknown += $name
    }
}

if ($unknown.Count -gt 0) {
    throw ("MCP servers not in allowlist: " + (($unknown | Select-Object -Unique) -join ", "))
}
