param()

$ErrorActionPreference = "Stop"

$stdinText = [Console]::In.ReadToEnd()
$pipelineText = ($input | Out-String)

if ([string]::IsNullOrWhiteSpace($stdinText)) {
    $inputText = $pipelineText
} else {
    $inputText = $stdinText
}

if ([string]::IsNullOrWhiteSpace($inputText)) {
    Write-Output '{"continue":true}'
    exit 0
}

$lower = $inputText.ToLowerInvariant()

$alwaysBlocked = @(
    "git reset --hard",
    "git clean -fd",
    "set-executionpolicy",
    "invoke-expression",
    "iex ",
    "format-volume",
    "cipher /w"
)

foreach ($pattern in $alwaysBlocked) {
    if ($lower.Contains($pattern)) {
        $reason = "Blocked by Playgroud hook: command is outside the trusted high-autonomy boundary."
        $result = @{
            continue = $false
            block_reason = $reason
        } | ConvertTo-Json -Compress
        Write-Output $result
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
            $result = @{
                continue = $false
                block_reason = $reason
            } | ConvertTo-Json -Compress
            Write-Output $result
            exit 0
        }
    }

    if (-not $trustedWorkspace) {
        $reason = "Blocked by Playgroud hook: destructive command needs an explicit trusted workspace path or relative path."
        $result = @{
            continue = $false
            block_reason = $reason
        } | ConvertTo-Json -Compress
        Write-Output $result
        exit 0
    }
}

Write-Output '{"continue":true}'
exit 0
