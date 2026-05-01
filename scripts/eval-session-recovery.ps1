param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$raw = & (Join-Path $PSScriptRoot "codex-hook-session-start.ps1") -Root $Root
if ($LASTEXITCODE -ne 0) {
    throw "session-recovery: session start hook failed."
}

$payload = $raw | ConvertFrom-Json
$context = [string]$payload.hookSpecificOutput.additionalContext

foreach ($marker in @(
        "Playgroud session context",
        "Active goal:",
        "Immediate next:",
        "Recent open failures:",
        "Active lessons:"
    )) {
    if ($context -notlike "*$marker*") {
        throw "session-recovery: missing session marker '$marker'."
    }
}

if ($context -like "*2026-04-27-codex-self-improvement-report.md*") {
    throw "session-recovery: historical phase report must not appear in default load summary."
}

Write-Output "session-recovery: pass"
