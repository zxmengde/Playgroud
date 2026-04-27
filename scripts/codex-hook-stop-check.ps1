param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$messages = @()
$activePath = Join-Path $Root "docs\tasks\active.md"
if (-not (Test-Path -LiteralPath $activePath)) {
    $messages += "docs/tasks/active.md is missing."
} else {
    $active = Get-Content -LiteralPath $activePath -Raw
    if ($active -match "old automation task|commit and push before finishing") {
        $messages += "Task state appears stale."
    }
}

$gitStatus = & git -C $Root status --short 2>$null
if (($gitStatus | Where-Object { $_ -match '^\?\?|^ M|^M |^A |^ D|^D ' }).Count -gt 0) {
    $messages += "Working tree has local changes; final response should mention validation status."
}

if ($messages.Count -eq 0) {
    Write-Output '{"continue":true}'
    exit 0
}

$result = @{
    continue = $true
    additional_context = ($messages -join " ")
} | ConvertTo-Json -Compress
Write-Output $result
exit 0
