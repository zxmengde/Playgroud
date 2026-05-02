param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..\..").Path,
    [string]$ValidatorPath = ""
)

$ErrorActionPreference = "Stop"

$skillRoots = @(
    (Join-Path $Root ".agents\skills")
)

$skillFiles = @()
foreach ($skillRoot in $skillRoots) {
    if (Test-Path -LiteralPath $skillRoot) {
        $skillFiles += Get-ChildItem -Path $skillRoot -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue
    }
}

if ($skillFiles.Count -eq 0) {
    throw "No repository skills found under .agents/skills."
}

if ([string]::IsNullOrWhiteSpace($ValidatorPath)) {
    $candidate = Join-Path $env:USERPROFILE ".codex\skills\.system\skill-creator\scripts\quick_validate.py"
    if (Test-Path -LiteralPath $candidate) {
        $ValidatorPath = $candidate
    }
}

$errors = @()
foreach ($file in $skillFiles) {
    $lines = Get-Content -LiteralPath $file.FullName
    if ($lines.Count -lt 4 -or $lines[0] -ne "---") {
        $errors += "$($file.FullName): missing YAML frontmatter"
        continue
    }

    $end = -1
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -eq "---") {
            $end = $i
            break
        }
    }
    if ($end -lt 0) {
        $errors += "$($file.FullName): unclosed YAML frontmatter"
        continue
    }

    $frontmatter = $lines[1..($end - 1)]
    $name = ""
    $description = ""
    foreach ($line in $frontmatter) {
        if ($line -match "^name:\s*(.+)$") {
            $name = $Matches[1].Trim().Trim('"')
        }
        if ($line -match "^description:\s*(.+)$") {
            $description = $Matches[1].Trim().Trim('"')
        }
    }

    if ([string]::IsNullOrWhiteSpace($name)) {
        $errors += "$($file.FullName): missing name"
    } elseif ($name.Length -gt 64 -or $name -notmatch "^[a-z0-9-]+$") {
        $errors += "$($file.FullName): invalid name '$name'"
    }

    if ([string]::IsNullOrWhiteSpace($description)) {
        $errors += "$($file.FullName): missing description"
    } elseif ($description.Length -gt 1024) {
        $errors += "$($file.FullName): description exceeds 1024 characters"
    } elseif ($description -match "<[^>]+>") {
        $errors += "$($file.FullName): description contains XML or HTML-like tags"
    }

    if ($lines.Count -gt 500) {
        $errors += "$($file.FullName): SKILL.md exceeds 500 lines"
    }
}

if ($errors.Count -gt 0) {
    Write-Error ("Skill metadata validation failed:`n" + ($errors -join "`n"))
}

if (-not [string]::IsNullOrWhiteSpace($ValidatorPath) -and (Test-Path -LiteralPath $ValidatorPath)) {
    foreach ($file in $skillFiles) {
        $skillDir = Split-Path -Parent $file.FullName
        $previousPythonUtf8 = $env:PYTHONUTF8
        $env:PYTHONUTF8 = "1"
        python -X utf8 $ValidatorPath $skillDir | Out-Host
        $env:PYTHONUTF8 = $previousPythonUtf8
        if ($LASTEXITCODE -ne 0) {
            throw "quick_validate.py failed for $skillDir"
        }
    }
} else {
    Write-Warning "quick_validate.py not found; skipped external skill validation."
}

Write-Output "Repository skill validation passed."
