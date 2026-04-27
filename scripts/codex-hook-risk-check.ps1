param()

$ErrorActionPreference = "Stop"

$rawInput = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($rawInput)) {
    exit 0
}

$commandText = $rawInput
try {
    $payload = $rawInput | ConvertFrom-Json -Depth 10
    if ($null -ne $payload.tool_input -and $null -ne $payload.tool_input.command) {
        $commandText = [string]$payload.tool_input.command
    }
} catch {
    $commandText = $rawInput
}

if ([string]::IsNullOrWhiteSpace($commandText)) {
    exit 0
}

$lower = $commandText.ToLowerInvariant()

$alwaysBlocked = @(
    "git reset --hard",
    "git clean -fd",
    "git checkout --",
    "set-executionpolicy",
    "invoke-expression",
    "iex ",
    "format-volume",
    "cipher /w"
)

foreach ($pattern in $alwaysBlocked) {
    if ($lower.Contains($pattern)) {
        $reason = "Blocked by Playgroud hook: command is outside the trusted high-autonomy boundary."
        @{
            hookSpecificOutput = @{
                hookEventName = "PreToolUse"
                permissionDecision = "deny"
                permissionDecisionReason = $reason
            }
        } | ConvertTo-Json -Compress
        exit 0
    }
}

$destructive = $lower.Contains("remove-item -recurse") -or $lower.Contains("rm -rf")
$trustedWorkspace = $lower.Contains("d:\code\playgroud") -or $lower.Contains(".\") -or $lower.Contains("./")
$outsideWorkspaceHints = @(
    "c:\users\",
    "$($env:USERPROFILE)".ToLowerInvariant(),
    "~\",
    "~/",
    "c:\windows",
    "c:\program files",
    "..\",
    "../"
)

if ($destructive) {
    foreach ($hint in $outsideWorkspaceHints) {
        if ($lower.Contains($hint)) {
            $reason = "Blocked by Playgroud hook: destructive command appears to target outside the trusted workspace."
            @{
                hookSpecificOutput = @{
                    hookEventName = "PreToolUse"
                    permissionDecision = "deny"
                    permissionDecisionReason = $reason
                }
            } | ConvertTo-Json -Compress
            exit 0
        }
    }

    if (-not $trustedWorkspace) {
        $reason = "Blocked by Playgroud hook: destructive command needs an explicit trusted workspace path or relative path."
        @{
            hookSpecificOutput = @{
                hookEventName = "PreToolUse"
                permissionDecision = "deny"
                permissionDecisionReason = $reason
            }
        } | ConvertTo-Json -Compress
        exit 0
    }
}
exit 0
