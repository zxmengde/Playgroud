param(
    [string]$ConfigPath = "$env:USERPROFILE\.codex\config.toml",
    [string]$AllowlistPath = (Join-Path (Resolve-Path "$PSScriptRoot\..\..\..").Path "docs\references\assistant\mcp-allowlist.json")
)

$ErrorActionPreference = "Stop"

Write-Output "MCP config audit"

$allowlist = @{
    required = @()
    recommended = @()
    blocked = @()
}
if (Test-Path -LiteralPath $AllowlistPath) {
    $json = Get-Content -LiteralPath $AllowlistPath -Raw | ConvertFrom-Json
    $allowlist.required = @($json.required)
    $allowlist.recommended = @($json.recommended)
    $allowlist.blocked = @($json.blocked)
}

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    if ($allowlist.required.Count -gt 0) {
        throw "Config not found and required MCP servers exist: $ConfigPath"
    }
    Write-Output "Config not found: $ConfigPath"
    return
}

$content = Get-Content -LiteralPath $ConfigPath -Raw
$pattern = '(?ms)^\[mcp_servers\.([^\]]+)\]\s*(.*?)(?=^\[|\z)'
$matches = [regex]::Matches($content, $pattern)
if ($matches.Count -eq 0) {
    if ($allowlist.required.Count -gt 0) {
        throw "No MCP servers found, but required MCP servers are configured in allowlist."
    }
    Write-Output "No MCP servers found."
    return
}

$seen = @()
$unknown = @()
$blocked = @()
foreach ($match in $matches) {
    $name = $match.Groups[1].Value.Trim('"')
    $seen += $name
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

    $known = @($allowlist.required + $allowlist.recommended)
    if ($known -notcontains $name) {
        $unknown += $name
    }
    if ($allowlist.blocked -contains $name) {
        $blocked += $name
    }
}

$missingRequired = @($allowlist.required | Where-Object { $seen -notcontains $_ })
$missingRecommended = @($allowlist.recommended | Where-Object { $seen -notcontains $_ })

if ($missingRecommended.Count -gt 0) {
    Write-Output ("Recommended MCP servers not found: " + (($missingRecommended | Select-Object -Unique) -join ", "))
}
if ($missingRequired.Count -gt 0) {
    throw ("Required MCP servers not found: " + (($missingRequired | Select-Object -Unique) -join ", "))
}
if ($blocked.Count -gt 0) {
    throw ("Blocked MCP servers configured: " + (($blocked | Select-Object -Unique) -join ", "))
}
if ($unknown.Count -gt 0) {
    throw ("MCP servers not in allowlist: " + (($unknown | Select-Object -Unique) -join ", "))
}

Write-Output "MCP config audit passed."
