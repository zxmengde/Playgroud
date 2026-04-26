param(
    [string]$ConfigPath = "$env:USERPROFILE\.codex\config.toml"
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

if ($matches.Count -eq 0) {
    Write-Output "No MCP servers found."
    return
}

foreach ($match in $matches) {
    $name = $match.Groups[1].Value.Trim('"')
    $body = $match.Groups[2].Value
    $url = ""
    $command = ""
    $urlMatch = [regex]::Match($body, '(?m)^\s*url\s*=\s*"([^"]+)"')
    if ($urlMatch.Success) { $url = $urlMatch.Groups[1].Value }
    $commandMatch = [regex]::Match($body, '(?m)^\s*command\s*=\s*"([^"]+)"')
    if ($commandMatch.Success) { $command = $commandMatch.Groups[1].Value }

    if (-not [string]::IsNullOrWhiteSpace($url)) {
        Write-Output ("- {0}: url={1}" -f $name, $url)
    } elseif (-not [string]::IsNullOrWhiteSpace($command)) {
        Write-Output ("- {0}: command={1}" -f $name, $command)
    } else {
        Write-Output ("- {0}: no url or command found" -f $name)
    }
}
