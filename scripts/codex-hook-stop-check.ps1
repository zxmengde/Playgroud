param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "self-improvement-object-lib.ps1")

$messages = @()
$activePath = Join-Path $Root "docs\tasks\active.md"

if (-not (Test-Path -LiteralPath $activePath)) {
    $messages += "docs/tasks/active.md is missing."
} else {
    $active = Get-Content -LiteralPath $activePath -Raw -Encoding UTF8
    if ($active -match "old automation task|commit and push before finishing|提交和推送前需再次") {
        $messages += "Task state appears stale."
    }

    $unverified = Get-MarkdownSection -Content $active -Heading "Unverified"
    if (-not [string]::IsNullOrWhiteSpace($unverified) -and $unverified -notmatch '^\s*(无|none|n/a)\s*$') {
        $messages += "Task state still lists unverified work."
    }
}

$gitStatus = & git -C $Root status --short 2>$null
if (@($gitStatus | Where-Object { $_ -match '^\?\?|^ M|^M |^A |^ D|^D ' }).Count -gt 0) {
    $messages += "Working tree has local changes; final response should mention verification status."
}

$openHighImpact = @(
    Get-FailureObjects -Root $Root |
    Where-Object {
        @("captured", "triaged", "candidate") -contains $_.Data.status -and
        $_.Data.impact -eq "high"
    }
)
if ($openHighImpact.Count -gt 0) {
    $messages += "Open high-impact failures still exist."
}

if ($messages.Count -eq 0) {
    exit 0
}

@{
    continue = $true
    systemMessage = ($messages -join " ")
} | ConvertTo-Json -Compress -Depth 8
exit 0
