param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$skillsRoot = Join-Path $Root "skills"
if (-not (Test-Path -LiteralPath $skillsRoot)) {
    Write-Output "No skills directory found."
    exit 0
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
        HasContext = [bool]($content -match '(?mi)(^##\s*(Context|上下文)|读取|read\s+)')
        HasOutput = [bool]($content -match '(?mi)(^##\s*(Output|产物)|产出|create or update)')
        HasVerification = [bool]($content -match '(?mi)(^##\s*(Verification|验证)|verify|检查)')
        HasPermissionBoundary = [bool]($content -match '(?mi)(确认|permission|ask before|external|账号|写入|删除|覆盖|download|cookies|login)')
        HasTodo = [bool]($content -match 'TODO|\[TODO')
        TooLong = [bool]($lines -gt 500)
    }
}

$rows | Sort-Object Skill | Format-Table -AutoSize

$issues = @()
foreach ($row in $rows) {
    if ($row.HasTodo) { $issues += "$($row.Skill): contains TODO placeholder" }
    if ($row.TooLong) { $issues += "$($row.Skill): exceeds 500 lines" }
    if (-not $row.HasContext) { $issues += "$($row.Skill): missing explicit context/read guidance" }
    if (-not $row.HasOutput) { $issues += "$($row.Skill): missing output guidance" }
    if (-not $row.HasVerification) { $issues += "$($row.Skill): missing verification guidance" }
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
