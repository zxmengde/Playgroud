param(
    [string]$Proxy = "http://127.0.0.1:7897",
    [switch]$SkipGitProxy,
    [switch]$RunValidation
)

$ErrorActionPreference = "Stop"

$root = (Resolve-Path "$PSScriptRoot\..\..\..").Path

& (Join-Path $PSScriptRoot "repair-git-network-env.ps1") -Quiet

if (-not $SkipGitProxy) {
    & git -C $root config http.proxy $Proxy
    & git -C $root config https.proxy $Proxy
}

Write-Output "Codex environment setup completed."
Write-Output ("Workspace: {0}" -f $root)
if (-not $SkipGitProxy) {
    Write-Output ("Repository Git proxy: {0}" -f $Proxy)
}

if ($RunValidation) {
    & (Join-Path $PSScriptRoot "validate-system.ps1") -Root $root
}
