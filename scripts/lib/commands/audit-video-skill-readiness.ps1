param(
    [string]$CodexHome = "$env:USERPROFILE\.codex"
)

$ErrorActionPreference = "Stop"

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Test-PythonImport {
    param([string]$Module)
    if (-not (Test-CommandExists "python")) {
        return $false
    }
    & python -c "import $Module" *> $null
    return ($LASTEXITCODE -eq 0)
}

Write-Output "Video skill readiness audit"

if (-not (Test-Path -LiteralPath $CodexHome)) {
    throw "Codex home not found: $CodexHome"
}

$skillsRoot = Join-Path $CodexHome "skills"
$required = @{
    "bilibili-video-evidence" = @(
        "SKILL.md",
        "README.md",
        "skill.manifest.json",
        "scripts\bilibili_subtitle_to_md.py",
        "scripts\bilibili_audio_asr_to_srt.py",
        "scripts\capture_bilibili_screenshot.js",
        "references\asr-fallback.md",
        "references\implementation.md"
    )
    "video-note-writer" = @(
        "SKILL.md",
        "README.md",
        "skill.manifest.json",
        "references\output-template.md",
        "references\verification-checklist.md"
    )
}

$missing = @()
foreach ($skillName in $required.Keys) {
    $skillRoot = Join-Path $skillsRoot $skillName
    foreach ($relative in $required[$skillName]) {
        $path = Join-Path $skillRoot $relative
        if (-not (Test-Path -LiteralPath $path)) {
            $missing += "$skillName\$relative"
        }
    }
}

if ($missing.Count -gt 0) {
    Write-Output ""
    Write-Output "Missing required video skill files"
    $missing | ForEach-Object { Write-Output ("- {0}" -f $_) }
    throw "Bilibili video skills are not ready."
}

Write-Output "- bilibili-video-evidence: installed"
Write-Output "- video-note-writer: installed"

$toolWarnings = @()
if (Test-CommandExists "python") {
    Write-Output "- python: available"
} else {
    throw "python is required for Bilibili subtitle extraction."
}

if (Test-PythonImport "requests") {
    Write-Output "- python module requests: available"
} else {
    throw "python module requests is required for Bilibili subtitle extraction."
}

if (Test-CommandExists "node") {
    Write-Output "- node: available"
} else {
    $toolWarnings += "node not found; PNG frame capture is unavailable."
}

if (Test-CommandExists "ffmpeg") {
    Write-Output "- ffmpeg: available"
} else {
    $toolWarnings += "ffmpeg not found; local ASR fallback and audio extraction are unavailable."
}

if (Test-CommandExists "yt-dlp") {
    Write-Output "- yt-dlp: available"
} else {
    $toolWarnings += "yt-dlp not found; course-note workflows that rely on it need separate setup."
}

if (Test-PythonImport "faster_whisper") {
    Write-Output "- python module faster_whisper: available"
} else {
    $toolWarnings += "python module faster_whisper not found; local ASR fallback needs separate setup."
}

if ($toolWarnings.Count -gt 0) {
    Write-Output ""
    Write-Output "Optional capability warnings"
    $toolWarnings | ForEach-Object { Write-Output ("- {0}" -f $_) }
}

Write-Output ""
Write-Output "Video skill readiness audit completed."
