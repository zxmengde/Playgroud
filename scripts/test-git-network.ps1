param(
    [string]$Proxy = "http://127.0.0.1:7897",
    [string]$Remote = "origin",
    [int]$TimeoutSeconds = 15
)

$ErrorActionPreference = "Continue"

$repairScript = Join-Path $PSScriptRoot "repair-git-network-env.ps1"
if (Test-Path -LiteralPath $repairScript) {
    & $repairScript -Quiet
}

function Write-Step {
    param([string]$Name)
    Write-Output ""
    Write-Output "## $Name"
}

Write-Step "Git configuration"
$gitProxyConfig = & git config --show-origin --get-regexp "^(http|https)\..*proxy|^http\.proxy|^https\.proxy" 2>&1
if ($gitProxyConfig) {
    $gitProxyConfig | ForEach-Object { Write-Output $_ }
} else {
    Write-Output "No Git proxy config found."
}
$gitRemotes = & git remote -v 2>&1
$gitRemotes | ForEach-Object { Write-Output $_ }

Write-Step "Proxy endpoint"
try {
    $uri = [Uri]$Proxy
    $client = [System.Net.Sockets.TcpClient]::new()
    $async = $client.BeginConnect($uri.Host, $uri.Port, $null, $null)
    $ok = $async.AsyncWaitHandle.WaitOne($TimeoutSeconds * 1000, $false)
    if ($ok) {
        $client.EndConnect($async)
        Write-Output "Proxy TCP reachable: $($uri.Host):$($uri.Port)"
    } else {
        Write-Output "Proxy TCP timeout: $($uri.Host):$($uri.Port)"
    }
    $client.Close()
} catch {
    Write-Output "Proxy TCP check failed: $($_.Exception.Message)"
}

Write-Step "curl via proxy"
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
    $curlOutput = & curl.exe -I --max-time $TimeoutSeconds --proxy $Proxy https://github.com 2>&1
    $curlOutput | ForEach-Object { Write-Output $_ }
} else {
    Write-Output "curl.exe not found."
}

Write-Step "git ls-remote"
$gitRemoteOutput = & git ls-remote --heads $Remote 2>&1
$gitRemoteOutput | ForEach-Object { Write-Output $_ }

Write-Step "Interpretation"
Write-Output "If proxy TCP is unreachable, check whether Clash/Mihomo is listening on the configured port."
Write-Output "If proxy TCP works but git fails, check Git proxy config, credentials, DNS, and TLS backend."
Write-Output "If a normal terminal works but Codex does not, check Windows loopback exemption for the Codex package."
