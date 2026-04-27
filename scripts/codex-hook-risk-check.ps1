param()

$ErrorActionPreference = "Stop"

$inputText = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputText)) {
    Write-Output '{"continue":true}'
    exit 0
}

$lower = $inputText.ToLowerInvariant()
$risky = @(
    "remove-item -recurse",
    "rm -rf",
    "git reset --hard",
    "git clean -fd",
    "set-executionpolicy",
    "invoke-expression",
    "iex "
)

foreach ($pattern in $risky) {
    if ($lower.Contains($pattern)) {
        $reason = "Blocked by Playgroud hook: command requires explicit review before execution."
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
