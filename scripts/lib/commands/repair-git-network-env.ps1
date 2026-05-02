param(
    [string]$UserProfilePath = "",
    [string]$Proxy = "",
    [switch]$Quiet,
    [switch]$PersistUser,
    [switch]$SkipProxyEnvironment
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($UserProfilePath)) {
    $UserProfilePath = [Environment]::GetEnvironmentVariable("USERPROFILE", "Process")
}
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

foreach ($name in $defaults.Keys) {
    $current = [Environment]::GetEnvironmentVariable($name, "Process")
    if ([string]::IsNullOrWhiteSpace($current)) {
        [Environment]::SetEnvironmentVariable($name, $defaults[$name], "Process")
        if (-not $Quiet) {
            Write-Output ("Set missing process env: {0}" -f $name)
        }
    }
    if ($PersistUser) {
        [Environment]::SetEnvironmentVariable($name, $defaults[$name], "User")
        if (-not $Quiet) {
            Write-Output ("Set user env: {0}" -f $name)
        }
    }
}

if ([string]::IsNullOrWhiteSpace($Proxy)) {
    $Proxy = (& git config --global --get http.proxy 2>$null)
}
if ([string]::IsNullOrWhiteSpace($Proxy)) {
    $Proxy = (& git config --get http.proxy 2>$null)
}

if (-not $SkipProxyEnvironment -and -not [string]::IsNullOrWhiteSpace($Proxy)) {
    $proxyValues = @(
        @("HTTP_PROXY", $Proxy),
        @("HTTPS_PROXY", $Proxy),
        @("ALL_PROXY", $Proxy),
        @("http_proxy", $Proxy),
        @("https_proxy", $Proxy),
        @("all_proxy", $Proxy),
        @("NO_PROXY", "localhost,127.0.0.1,::1"),
        @("no_proxy", "localhost,127.0.0.1,::1")
    )

    foreach ($entry in $proxyValues) {
        $name = $entry[0]
        $value = $entry[1]
        [Environment]::SetEnvironmentVariable($name, $value, "Process")
        if (-not $Quiet) {
            Write-Output ("Set process proxy env: {0}" -f $name)
        }
        if ($PersistUser) {
            [Environment]::SetEnvironmentVariable($name, $value, "User")
            if (-not $Quiet) {
                Write-Output ("Set user proxy env: {0}" -f $name)
            }
        }
    }
}

if (-not $Quiet) {
    if ($PersistUser) {
        Write-Output "Git network environment repair completed for this process and user environment. Restart Codex before testing new shell sessions."
    } else {
        Write-Output "Git network environment repair completed for this process."
    }
}
