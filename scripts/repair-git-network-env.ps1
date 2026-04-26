param(
    [string]$UserProfilePath = "C:\Users\mengde",
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

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
}

if (-not $Quiet) {
    Write-Output "Git network environment repair completed for this process."
}
