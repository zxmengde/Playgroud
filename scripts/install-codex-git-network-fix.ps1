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

$defaults = @{
    SystemRoot = "C:\Windows"
    WINDIR = "C:\Windows"
    ComSpec = "C:\Windows\System32\cmd.exe"
    APPDATA = (Join-Path $UserProfilePath "AppData\Roaming")
    LOCALAPPDATA = (Join-Path $UserProfilePath "AppData\Local")
    ProgramData = "C:\ProgramData"
    USERPROFILE = $UserProfilePath
}

if (-not $SetUserEnvironment -and -not $SetGlobalGitProxy) {
    Write-Output "This script performs persistent user-level changes only when flags are provided."
    Write-Output "Planned user environment values:"
    foreach ($name in ($defaults.Keys | Sort-Object)) {
        Write-Output ("- {0}={1}" -f $name, $defaults[$name])
    }
    Write-Output ("Planned global Git proxy: {0}" -f $Proxy)
    Write-Output "Run only after user confirmation:"
    Write-Output ".\scripts\install-codex-git-network-fix.ps1 -SetUserEnvironment -SetGlobalGitProxy"
    exit 0
}

if ($SetUserEnvironment) {
    foreach ($name in ($defaults.Keys | Sort-Object)) {
        [Environment]::SetEnvironmentVariable($name, $defaults[$name], "User")
        Write-Output ("Set user environment: {0}" -f $name)
    }
}

if ($SetGlobalGitProxy) {
    & git config --global http.proxy $Proxy
    & git config --global https.proxy $Proxy
    Write-Output ("Set global Git proxy: {0}" -f $Proxy)
}

Write-Output "Persistent Git network fix completed. Restart Codex before testing new shell sessions."
