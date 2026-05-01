param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$tempRoot = Join-Path $env:TEMP ("playgroud-closeout-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force (Join-Path $tempRoot "docs\tasks") | Out-Null

try {
    $nativePreference = $null
    if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
        $nativePreference = $global:PSNativeCommandUseErrorActionPreference
        $global:PSNativeCommandUseErrorActionPreference = $false
    }

    & git -C $tempRoot init *> $null
    $activePath = Join-Path $tempRoot "docs\tasks\active.md"
    @"
# Active Task

## Goal

stop hook eval

## Read Sources

- none

## Commands

- none

## Artifacts

- none

## Unverified

- validator pending

## Blockers

none

## Next

none

## Recovery

none

## Anti-Sycophancy

- Literal-only
- Real-goal
- User-premise
- Unverified-claims
"@ | Set-Content -LiteralPath $activePath -Encoding UTF8

    & git -C $tempRoot -c core.autocrlf=false -c core.safecrlf=false add . *> $null
    & git -C $tempRoot -c core.autocrlf=false -c core.safecrlf=false -c user.name="Codex" -c user.email="codex@example.invalid" commit -m "init" *> $null

    Add-Content -LiteralPath $activePath -Value "`n# dirty" -Encoding UTF8

    $raw = & (Join-Path $PSScriptRoot "codex-hook-stop-check.ps1") -Root $tempRoot
    if ($LASTEXITCODE -ne 0) {
        throw "unverified-closeout-block: stop hook script failed."
    }
    if ([string]::IsNullOrWhiteSpace($raw)) {
        throw "unverified-closeout-block: expected stop hook output for a dirty repo with unverified work."
    }

    $payload = $raw | ConvertFrom-Json
    if (-not $payload.continue) {
        throw "unverified-closeout-block: stop hook payload missing continue=true."
    }
    if ([string]::IsNullOrWhiteSpace([string]$payload.systemMessage)) {
        throw "unverified-closeout-block: stop hook payload missing systemMessage."
    }

    Write-Output "unverified-closeout-block: pass"
} finally {
    if ($null -ne $nativePreference) {
        $global:PSNativeCommandUseErrorActionPreference = $nativePreference
    }
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -Recurse -Force $tempRoot
    }
}
