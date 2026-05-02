param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path,
    [string]$Proxy = "",
    [switch]$SkipNetwork
)

$ErrorActionPreference = "Continue"

$repairScript = Join-Path $PSScriptRoot "repair-git-network-env.ps1"
if (Test-Path -LiteralPath $repairScript) {
    if ([string]::IsNullOrWhiteSpace($Proxy)) {
        & $repairScript -Quiet
    } else {
        & $repairScript -Quiet -Proxy $Proxy
    }
}

function Write-Step {
    param([string]$Name)
    Write-Output ""
    Write-Output "## $Name"
}

function Write-CommandResult {
    param(
        [string]$Name,
        [scriptblock]$Command
    )

    Write-Output ""
    Write-Output ("### {0}" -f $Name)
    try {
        $output = & $Command 2>&1
        $output | ForEach-Object { Write-Output $_ }
        Write-Output ("exitCode={0}" -f $LASTEXITCODE)
    } catch {
        Write-Output ("failed: {0}" -f $_.Exception.Message)
    }
}

Write-Output "Codex runtime audit"

Write-Step "Environment"
foreach ($name in @("SystemRoot", "WINDIR", "ComSpec", "APPDATA", "LOCALAPPDATA", "ProgramData", "USERPROFILE", "HTTP_PROXY", "HTTPS_PROXY", "ALL_PROXY", "NO_PROXY")) {
    $value = [Environment]::GetEnvironmentVariable($name, "Process")
    if ([string]::IsNullOrWhiteSpace($value)) {
        Write-Output ("{0}=<missing>" -f $name)
    } else {
        Write-Output ("{0}={1}" -f $name, $value)
    }
}

Write-Step "Executables"
foreach ($name in @("git", "python", "node", "npm", "npx")) {
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Output ("{0}={1}" -f $name, $cmd.Source)
    } else {
        Write-Output ("{0}=<missing>" -f $name)
    }
}

Write-Step "Versions"
Write-CommandResult "git" { git --version }
Write-CommandResult "python" { python --version }
Write-CommandResult "node" { node --version }
Write-CommandResult "npm" { npm --version }
Write-CommandResult "npx" { npx --version }

if (-not $SkipNetwork) {
    Write-Step "Network-backed package checks"
    Write-CommandResult "npm sequential-thinking package" { npm view @modelcontextprotocol/server-sequential-thinking version }
    Write-CommandResult "skill list" { python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\list-skills.py" --format json }
}

Write-Output ""
Write-Output "Codex runtime audit completed."
