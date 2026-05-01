param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$Path = ""
)

$ErrorActionPreference = "Stop"

function Add-ResultLine {
    param([string]$Level, [string]$Message)
    $script:results += ("{0} {1}" -f $Level, $Message)
}

function Fail {
    param([string]$Message)
    $script:hasFailure = $true
    Add-ResultLine -Level "FAIL" -Message $Message
}

function Warn {
    param([string]$Message)
    $script:hasWarning = $true
    Add-ResultLine -Level "WARN" -Message $Message
}

function Pass {
    param([string]$Message)
    Add-ResultLine -Level "PASS" -Message $Message
}

$requiredSkills = @(
    "playgroud-maintenance",
    "failure-promoter",
    "external-mechanism-researcher",
    "research-engineering-loop",
    "product-engineering-closer",
    "uiux-reviewer",
    "knowledge-curator",
    "tool-router",
    "finish-verifier"
)

$requiredSections = @(
    "## Trigger",
    "## When Not To Use",
    "## Read",
    "## Inputs",
    "## Output",
    "## Allowed Writes",
    "## Forbidden Writes",
    "## Evidence Requirements",
    "## Workflow",
    "## Verify",
    "## Pass Criteria",
    "## Fail Criteria",
    "## Example Invocation",
    "## Failure Modes"
)

$results = @()
$hasFailure = $false
$hasWarning = $false

if ([string]::IsNullOrWhiteSpace($Path)) {
    $skillRoot = Join-Path $Root ".agents\skills"
    $files = @(Get-ChildItem -Path $skillRoot -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)
} else {
    $item = Get-Item -LiteralPath $Path
    if ($item.PSIsContainer) {
        $files = @(Get-ChildItem -Path $item.FullName -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue)
    } else {
        $files = @($item)
    }
}

if ($files.Count -eq 0) {
    Fail "No SKILL.md files found for skill contract validation."
}

$skillNames = @()
foreach ($file in $files) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    $skillName = Split-Path -Leaf (Split-Path -Parent $file.FullName)
    $skillNames += $skillName

    foreach ($section in $requiredSections) {
        if ($content -notmatch [regex]::Escape($section)) {
            Fail "$skillName missing section $section"
        }
    }

    if ($content -notmatch '(?i)required files') { Fail "$skillName missing required files guidance" }
    if ($content -notmatch '(?i)allowed writes') { Fail "$skillName missing allowed writes guidance" }
    if ($content -notmatch '(?i)forbidden writes') { Fail "$skillName missing forbidden writes guidance" }
    if ($content -notmatch '(?i)evidence requirements') { Fail "$skillName missing evidence requirements guidance" }
    if ($content -notmatch '(?i)pass criteria') { Fail "$skillName missing pass criteria guidance" }
    if ($content -notmatch '(?i)fail criteria') { Fail "$skillName missing fail criteria guidance" }
    if ($content -match 'TODO|\[TODO') { Warn "$skillName still contains TODO marker" }
    Pass "$skillName"
}

foreach ($requiredSkill in $requiredSkills) {
    if ($skillNames -notcontains $requiredSkill) {
        Fail "missing required skill $requiredSkill"
    }
}

$results | ForEach-Object { Write-Output $_ }
if ($hasFailure) { exit 1 }
if ($hasWarning) { exit 2 }
exit 0
