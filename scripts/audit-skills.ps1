param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$skillsRoot = Join-Path $Root ".agents\skills"
if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "Missing repository skills directory: .agents/skills"
}

$rows = @()
$skillFiles = Get-ChildItem -Path $skillsRoot -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue

foreach ($file in $skillFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $lines = ($content -split "`n").Count
    $description = ""
    if ($content -match "(?m)^description:\s*(.+)$") {
        $description = $Matches[1].Trim()
    }

    $rows += [PSCustomObject]@{
        Skill = Split-Path -Leaf (Split-Path -Parent $file.FullName)
        Lines = $lines
        DescriptionLength = $description.Length
        HasRead = [bool]($content -match '(?mi)^##\s*Read')
        HasOutput = [bool]($content -match '(?mi)^##\s*Output')
        HasVerify = [bool]($content -match '(?mi)^##\s*Verify')
        HasPermissionBoundary = [bool]($content -match '(?mi)(ask before|external account|sensitive|delete|overwrite|permission|MCP)')
        HasTodo = [bool]($content -match 'TODO|\[TODO')
        TooLong = [bool]($lines -gt 500)
    }
}

$rows | Sort-Object Skill | Format-Table -AutoSize

$issues = @()
foreach ($row in $rows) {
    if ($row.HasTodo) { $issues += "$($row.Skill): contains TODO placeholder" }
    if ($row.TooLong) { $issues += "$($row.Skill): exceeds 500 lines" }
    if (-not $row.HasRead) { $issues += "$($row.Skill): missing Read guidance" }
    if (-not $row.HasOutput) { $issues += "$($row.Skill): missing Output guidance" }
    if (-not $row.HasVerify) { $issues += "$($row.Skill): missing Verify guidance" }
}

if ($issues.Count -gt 0) {
    Write-Output ""
    Write-Output "Skill audit warnings:"
    $issues | ForEach-Object { Write-Output "- $_" }
} else {
    Write-Output ""
    Write-Output "Skill audit passed without structural warnings."
}

exit 0
