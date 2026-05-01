param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$Path = ""
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "self-improvement-object-lib.ps1")

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

if ([string]::IsNullOrWhiteSpace($Path)) {
    $Path = Get-RoutingPath -Root $Root
}

$results = @()
$hasFailure = $false
$hasWarning = $false

try {
    $routing = Read-JsonYamlFile -Path $Path
} catch {
    Fail $_.Exception.Message
    $results | ForEach-Object { Write-Output $_ }
    exit 1
}

if ($routing.schema_version -ne 1) { Fail "routing-v1 schema_version must equal 1" }
try { [void][datetimeoffset]$routing.updated_at } catch { Fail "routing-v1 updated_at is invalid" }

foreach ($field in @("active_load", "external_triggers", "routes")) {
    if (-not (Test-ObjectProperty -Object $routing -Name $field)) {
        Fail "routing-v1 missing top-level field: $field"
    }
}

$requiredRouteIds = @(
    "self-improvement-triage",
    "external-mechanism-research",
    "research-engineering",
    "product-engineering",
    "coding-with-serena",
    "uiux-review",
    "knowledge-capture",
    "finish-verification",
    "remote-or-long-running-task"
)

$allowedPhases = @("recover", "triage", "research", "design", "implement", "review", "capture", "verify", "operate")
$allowedDomains = @("system", "self-improvement", "research", "product", "coding", "uiux", "knowledge", "remote")
$routeIds = @()

foreach ($route in @($routing.routes)) {
    foreach ($field in @("id", "phase", "domain", "trigger", "recommended_skills", "recommended_mcps", "forbidden_tools", "minimum_context", "required_outputs", "verification", "counterexamples")) {
        if (-not (Test-ObjectProperty -Object $route -Name $field)) {
            Fail "route missing field $field"
        }
    }

    $routeIds += $route.id
    if ($allowedPhases -notcontains $route.phase) { Fail "route $($route.id) has invalid phase $($route.phase)" }
    if ($allowedDomains -notcontains $route.domain) { Fail "route $($route.id) has invalid domain $($route.domain)" }
    if (-not (Test-ObjectProperty -Object $route.trigger -Name "any_of") -or @($route.trigger.any_of).Count -lt 1) {
        Fail "route $($route.id) requires trigger.any_of"
    }
    foreach ($arrayField in @("recommended_skills", "recommended_mcps", "forbidden_tools", "minimum_context", "required_outputs", "verification", "counterexamples")) {
        $values = @($route.$arrayField)
        if ($values.Count -lt 1 -and $arrayField -ne "recommended_mcps") {
            Fail "route $($route.id) requires non-empty $arrayField"
        }
        if ($values.Count -eq 0 -and $arrayField -eq "forbidden_tools") {
            Warn "route $($route.id) has no forbidden_tools"
        }
    }

    foreach ($skill in @($route.recommended_skills)) {
        $skillPath = Join-Path $Root ".agents\skills\$skill\SKILL.md"
        if (-not (Test-Path -LiteralPath $skillPath)) {
            Fail "route $($route.id) references missing skill $skill"
        }
    }
}

foreach ($requiredRouteId in $requiredRouteIds) {
    if ($routeIds -notcontains $requiredRouteId) {
        Fail "routing-v1 missing required route id $requiredRouteId"
    }
}

$duplicateRouteIds = @($routeIds | Group-Object | Where-Object { $_.Count -gt 1 })
if ($duplicateRouteIds.Count -gt 0) {
    Fail "routing-v1 contains duplicate route ids"
}

$activeLoad = $routing.active_load
foreach ($field in @("always", "summary", "retrieval_only_prefixes", "exclude_statuses")) {
    if (-not (Test-ObjectProperty -Object $activeLoad -Name $field)) {
        Fail "active_load missing field $field"
    }
}

foreach ($pathValue in @($activeLoad.always)) {
    $resolved = Join-Path $Root ($pathValue -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $resolved)) {
        Fail "active_load always path missing: $pathValue"
    }
}

if (-not (Test-ObjectProperty -Object $activeLoad.summary -Name "failures")) { Fail "active_load.summary.failures missing" }
if (-not (Test-ObjectProperty -Object $activeLoad.summary -Name "lessons")) { Fail "active_load.summary.lessons missing" }

$failureSummary = $activeLoad.summary.failures
$lessonSummary = $activeLoad.summary.lessons
if ([int]$failureSummary.max_items -lt 1) { Fail "active_load.summary.failures.max_items must be >= 1" }
if ([int]$lessonSummary.max_items -lt 1) { Fail "active_load.summary.lessons.max_items must be >= 1" }
if ([int]$lessonSummary.max_age_days -lt 1) { Fail "active_load.summary.lessons.max_age_days must be >= 1" }

$excludeStatuses = $activeLoad.exclude_statuses
foreach ($status in @($excludeStatuses.failures)) {
    if ($failureSummary.statuses -contains $status) {
        Fail "active_load summary includes excluded failure status $status"
    }
}
foreach ($status in @($excludeStatuses.lessons)) {
    if ($lessonSummary.statuses -contains $status) {
        Fail "active_load summary includes excluded lesson status $status"
    }
}

$externalTriggers = $routing.external_triggers
foreach ($field in @("allowed_creates", "forbidden_writes", "human_confirmed", "source_fields")) {
    if (-not (Test-ObjectProperty -Object $externalTriggers -Name $field)) {
        Fail "external_triggers missing field $field"
    }
}
if (-not (Test-ObjectProperty -Object $externalTriggers.source_fields -Name "origin")) { Fail "external_triggers.source_fields.origin missing" }
if (-not (Test-ObjectProperty -Object $externalTriggers.source_fields -Name "writer")) { Fail "external_triggers.source_fields.writer missing" }

Pass "routing-v1"
$results | ForEach-Object { Write-Output $_ }
if ($hasFailure) { exit 1 }
if ($hasWarning) { exit 2 }
exit 0
