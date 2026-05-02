param(
    [string]$UserProfilePath = "",
    [string]$Proxy = "http://127.0.0.1:7897",
    [switch]$SetUserEnvironment,
    [switch]$SetGlobalGitProxy
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($UserProfilePath)) {
    $UserProfilePath = [Environment]::GetEnvironmentVariable("USERPROFILE", "User")
}
if ([string]::IsNullOrWhiteSpace($UserProfilePath)) {
    $UserProfilePath = "C:\Users\mengde"
}

$defaults = @(
    @("SystemRoot", "C:\Windows"),
    @("WINDIR", "C:\Windows"),
    @("ComSpec", "C:\Windows\System32\cmd.exe"),
    @("APPDATA", (Join-Path $UserProfilePath "AppData\Roaming")),
    @("LOCALAPPDATA", (Join-Path $UserProfilePath "AppData\Local")),
    @("ProgramData", "C:\ProgramData"),
    @("USERPROFILE", $UserProfilePath),
    @("HTTP_PROXY", $Proxy),
    @("HTTPS_PROXY", $Proxy),
    @("ALL_PROXY", $Proxy),
    @("http_proxy", $Proxy),
    @("https_proxy", $Proxy),
    @("all_proxy", $Proxy),
    @("NO_PROXY", "localhost,127.0.0.1,::1"),
    @("no_proxy", "localhost,127.0.0.1,::1")
)

if (-not $SetUserEnvironment -and -not $SetGlobalGitProxy) {
    Write-Output "This script performs persistent user-level changes only when flags are provided."
    Write-Output "Planned user environment values:"
    foreach ($entry in $defaults) {
        Write-Output ("- {0}={1}" -f $entry[0], $entry[1])
    }
    Write-Output ("Planned global Git proxy: {0}" -f $Proxy)
    Write-Output "Run only after user confirmation:"
    Write-Output ".\scripts\lib\commands\install-codex-git-network-fix.ps1 -SetUserEnvironment -SetGlobalGitProxy"
    exit 0
}

if ($SetUserEnvironment) {
    foreach ($entry in $defaults) {
        $name = $entry[0]
        $value = $entry[1]
        [Environment]::SetEnvironmentVariable($name, $value, "User")
        Write-Output ("Set user environment: {0}" -f $name)
    }
}

if ($SetGlobalGitProxy) {
    & git config --global http.proxy $Proxy
    & git config --global https.proxy $Proxy
    Write-Output ("Set global Git proxy: {0}" -f $Proxy)
}

Write-Output "Persistent Git network fix completed. Restart Codex before testing new shell sessions."
