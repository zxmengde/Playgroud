param(
    [string]$UserProfilePath = "",
    [switch]$Quiet,
    [switch]$PersistUser
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

if (-not $Quiet) {
    if ($PersistUser) {
        Write-Output "Git network environment repair completed for this process and user environment. Restart Codex before testing new shell sessions."
    } else {
        Write-Output "Git network environment repair completed for this process."
    }
}
