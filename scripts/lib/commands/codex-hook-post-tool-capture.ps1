param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "..\self-improvement-object-lib.ps1")

$rawInput = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($rawInput)) {
    exit 0
}

try {
    $payload = $rawInput | ConvertFrom-Json
} catch {
    exit 0
}

$toolName = ""
$commandText = ""
$errorText = @()
$exitCode = $null

if ($payload.PSObject.Properties.Name -contains "tool_name") { $toolName = [string]$payload.tool_name }
if ($payload.PSObject.Properties.Name -contains "tool_input" -and $payload.tool_input.PSObject.Properties.Name -contains "command") {
    $commandText = [string]$payload.tool_input.command
}
if ($payload.PSObject.Properties.Name -contains "command" -and [string]::IsNullOrWhiteSpace($commandText)) {
    $commandText = [string]$payload.command
}
if ($payload.PSObject.Properties.Name -contains "tool_output") {
    if ($payload.tool_output.PSObject.Properties.Name -contains "exit_code") { $exitCode = $payload.tool_output.exit_code }
    foreach ($field in @("stderr", "stdout", "output")) {
        if ($payload.tool_output.PSObject.Properties.Name -contains $field -and -not [string]::IsNullOrWhiteSpace([string]$payload.tool_output.$field)) {
            $errorText += [string]$payload.tool_output.$field
        }
    }
}
if ($payload.PSObject.Properties.Name -contains "error" -and -not [string]::IsNullOrWhiteSpace([string]$payload.error)) {
    $errorText += [string]$payload.error
}

$joinedError = ($errorText -join "`n").Trim()
$normalizedCommand = $commandText.ToLowerInvariant()
$hardFailure = $false

if ($null -ne $exitCode -and ($exitCode -as [int]) -ne 0) {
    $hardFailure = $true
}
if ($joinedError -match 'Write-Error|Exception|FAILED|Traceback|not found|Cannot find path|Resource not accessible') {
    $hardFailure = $true
}

$noisePatterns = @(
    '^rg\s',
    '^select-string',
    '^findstr'
)
foreach ($pattern in $noisePatterns) {
    if ($normalizedCommand -match $pattern -and -not ($joinedError -match 'Write-Error|Exception|Cannot find path')) {
        $hardFailure = $false
    }
}

if (-not $hardFailure) {
    exit 0
}

$phase = "verify"
$domain = "self-improvement"
$rootCause = "verification-gap"
if ($normalizedCommand -match 'git') {
    $phase = "implement"
    $domain = "coding"
    $rootCause = "tool-choice"
}

$summary = "Command or validation failed: " + ($(if ([string]::IsNullOrWhiteSpace($toolName)) { "shell" } else { $toolName }))
$symptom = if ([string]::IsNullOrWhiteSpace($joinedError)) { $commandText } else { $joinedError }
$primaryPath = ""
if ($commandText -match '(docs[\\/][^ ''"`]+|scripts[\\/][^ ''"`]+|\.agents[\\/][^ ''"`]+)') {
    $primaryPath = ($Matches[1] -replace '\\', '/')
}

$taskRef = "active-task"
if (Test-Path -LiteralPath (Join-Path $Root "docs\tasks\active.md")) {
    $active = Get-Content -LiteralPath (Join-Path $Root "docs\tasks\active.md") -Raw -Encoding UTF8
    $goal = Get-MarkdownSection -Content $active -Heading "Goal"
    if (-not [string]::IsNullOrWhiteSpace($goal)) {
        $taskRef = (Normalize-FingerprintText $goal)
        if ($taskRef.Length -gt 128) {
            $taskRef = $taskRef.Substring(0, 128)
        }
    }
}

[void](New-OrUpdateFailureDraft -Root $Root -TaskRef $taskRef -Phase $phase -Domain $domain -Summary $summary -Symptom $symptom -Impact "medium" -RootCauseType $rootCause -Tool $(if ([string]::IsNullOrWhiteSpace($toolName)) { "shell" } else { $toolName }) -PrimaryPath $primaryPath -SourceWriter "hook" -SourceTrigger "post-tool-failure" -EvidenceFiles @($primaryPath) -EvidenceCommands @($commandText) -EvidenceOutputs @($joinedError))
exit 0
