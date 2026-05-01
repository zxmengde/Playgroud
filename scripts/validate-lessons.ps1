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

function Validate-StringField {
    param(
        [object]$Value,
        [int]$MinLength,
        [int]$MaxLength
    )

    if (-not ($Value -is [string])) { return $false }
    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    return ($Value.Length -ge $MinLength -and $Value.Length -le $MaxLength)
}

function Test-WholeNumberInRange {
    param(
        [object]$Value,
        [int]$Min,
        [int]$Max
    )

    if ($null -eq $Value) { return $false }
    if ($Value -isnot [ValueType]) { return $false }
    try {
        $number = [int64]$Value
    } catch {
        return $false
    }
    return ($number -ge $Min -and $number -le $Max)
}

$lessonEnums = @{
    impact = @("low", "medium", "high")
    target = @("memory", "skill", "hook", "eval", "workflow", "MCP")
    status = @("candidate", "under_review", "accepted", "promoted", "verified", "rejected", "deprecated", "rolled_back", "expired")
    owner = @("codex", "human")
    reviewer = @("codex", "human")
    decision = @("accept", "reject", "defer")
    applied_by = @("none", "codex", "human")
    verifier = @("codex", "eval", "human")
    rejection_reason = @("insufficient-evidence", "one-off", "covered-existing", "no-verifier", "too-broad", "stale")
    deprecated_reason = @("superseded", "no-longer-relevant", "false-positive", "stack-changed")
}

$results = @()
$hasFailure = $false
$hasWarning = $false

if ([string]::IsNullOrWhiteSpace($Path)) {
    $Path = Get-LessonDirectory -Root $Root
}

$files = Get-ObjectFiles -Path $Path
if ($files.Count -eq 0) {
    Fail "No lesson files found under $Path"
}

$failureIds = @{}
foreach ($row in (Get-FailureObjects -Root $Root)) {
    $failureIds[$row.Data.id] = $row.Path
}

foreach ($file in $files) {
    try {
        $data = Read-JsonYamlFile -Path $file.FullName
    } catch {
        Fail $_.Exception.Message
        continue
    }

    $prefix = $file.Name
    $requiredFields = @(
        "schema_version", "id", "created_at", "updated_at", "title", "problem_statement",
        "source_failures", "evidence_summary", "recurrence", "impact", "candidate_rule",
        "why_not_one_off", "recommended_target", "status", "owner"
    )
    foreach ($field in $requiredFields) {
        if (-not (Test-ObjectProperty -Object $data -Name $field)) {
            Fail "$prefix missing required field: $field"
        }
    }

    if ($data.schema_version -ne 1) { Fail "$prefix schema_version must equal 1" }
    if (-not ($data.id -is [string]) -or $data.id -notmatch '^LESSON-[a-z0-9-]{8,64}$') { Fail "$prefix invalid lesson id" }
    if ($file.Name -ne ($data.id + ".yaml")) { Fail "$prefix file name must equal id.yaml" }
    try { [void][datetimeoffset]$data.created_at } catch { Fail "$prefix invalid created_at" }
    try { [void][datetimeoffset]$data.updated_at } catch { Fail "$prefix invalid updated_at" }

    if (-not (Validate-StringField -Value $data.title -MinLength 1 -MaxLength 100)) { Fail "$prefix invalid title" }
    if (-not (Validate-StringField -Value $data.problem_statement -MinLength 1 -MaxLength 220)) { Fail "$prefix invalid problem_statement" }
    if (-not (Validate-StringField -Value $data.evidence_summary -MinLength 1 -MaxLength 500)) { Fail "$prefix invalid evidence_summary" }
    if (-not (Validate-StringField -Value $data.candidate_rule -MinLength 1 -MaxLength 240)) { Fail "$prefix invalid candidate_rule" }
    if (-not (Validate-StringField -Value $data.why_not_one_off -MinLength 1 -MaxLength 240)) { Fail "$prefix invalid why_not_one_off" }
    if (-not (Test-WholeNumberInRange -Value $data.recurrence -Min 1 -Max 99)) { Fail "$prefix invalid recurrence" }
    if ($lessonEnums.impact -notcontains $data.impact) { Fail "$prefix invalid impact '$($data.impact)'" }
    if ($lessonEnums.target -notcontains $data.recommended_target) { Fail "$prefix invalid recommended_target '$($data.recommended_target)'" }
    if ($lessonEnums.status -notcontains $data.status) { Fail "$prefix invalid status '$($data.status)'" }
    if ($lessonEnums.owner -notcontains $data.owner) { Fail "$prefix invalid owner '$($data.owner)'" }

    $sourceFailures = @($data.source_failures)
    if ($sourceFailures.Count -lt 1 -or $sourceFailures.Count -gt 20) {
        Fail "$prefix source_failures count must be 1..20"
    }
    foreach ($sourceFailure in $sourceFailures) {
        if (-not ($sourceFailure -is [string]) -or $sourceFailure -notmatch '^FAIL-\d{8}-\d{6}-[a-f0-9]{6}$') {
            Fail "$prefix source_failures contains invalid id '$sourceFailure'"
            continue
        }
        if (-not $failureIds.ContainsKey($sourceFailure)) {
            Fail "$prefix source_failures contains missing failure id $sourceFailure"
        }
    }

    $status = $data.status
    $hasReview = Test-ObjectProperty -Object $data -Name "review"
    if (@("accepted", "promoted", "verified") -contains $status -and -not $hasReview) {
        Fail "$prefix status=$status requires review"
    }

    if ($hasReview) {
        $review = $data.review
        if (-not (Test-ObjectProperty -Object $review -Name "reviewed_at")) { Fail "$prefix review.reviewed_at missing" } else { try { [void][datetimeoffset]$review.reviewed_at } catch { Fail "$prefix invalid review.reviewed_at" } }
        if (-not (Test-ObjectProperty -Object $review -Name "reviewer") -or $lessonEnums.reviewer -notcontains $review.reviewer) { Fail "$prefix invalid review.reviewer" }
        if (-not (Test-ObjectProperty -Object $review -Name "decision") -or $lessonEnums.decision -notcontains $review.decision) { Fail "$prefix invalid review.decision" }
        if (-not (Test-ObjectProperty -Object $review -Name "rationale") -or -not (Validate-StringField -Value $review.rationale -MinLength 1 -MaxLength 500)) { Fail "$prefix invalid review.rationale" }
        if (-not (Test-ObjectProperty -Object $review -Name "target") -or $lessonEnums.target -notcontains $review.target) { Fail "$prefix invalid review.target" }
        if ($review.target -ne $data.recommended_target) { Warn "$prefix review.target differs from recommended_target" }
        if (-not (Test-ObjectProperty -Object $review -Name "verification_plan")) { Fail "$prefix review.verification_plan missing" } else {
            $checks = @($review.verification_plan.checks)
            if ($checks.Count -lt 1 -or $checks.Count -gt 10) { Fail "$prefix verification_plan.checks must contain 1..10 items" }
        }
        if (-not (Test-ObjectProperty -Object $review -Name "rollback_plan") -or -not (Validate-StringField -Value $review.rollback_plan -MinLength 1 -MaxLength 240)) { Fail "$prefix invalid review.rollback_plan" }
        if (Test-ObjectProperty -Object $review -Name "expiry_review_at") {
            try {
                $expiry = [datetimeoffset]$review.expiry_review_at
                if ($expiry -lt [datetimeoffset]::Now -and @("accepted", "promoted") -contains $status) {
                    Warn "$prefix review expiry is in the past"
                }
            } catch {
                Fail "$prefix invalid review.expiry_review_at"
            }
        }
    }

    if (Test-ObjectProperty -Object $data -Name "promotion") {
        $promotion = $data.promotion
        if ((Test-ObjectProperty -Object $promotion -Name "target") -and $lessonEnums.target -notcontains $promotion.target) { Fail "$prefix invalid promotion.target" }
        if ((Test-ObjectProperty -Object $promotion -Name "applied_by") -and $lessonEnums.applied_by -notcontains $promotion.applied_by) { Fail "$prefix invalid promotion.applied_by" }
        if ((Test-ObjectProperty -Object $promotion -Name "verifier") -and $lessonEnums.verifier -notcontains $promotion.verifier) { Fail "$prefix invalid promotion.verifier" }
        if (Test-ObjectProperty -Object $promotion -Name "applied_at") { try { [void][datetimeoffset]$promotion.applied_at } catch { Fail "$prefix invalid promotion.applied_at" } }
        if (Test-ObjectProperty -Object $promotion -Name "verified_at") { try { [void][datetimeoffset]$promotion.verified_at } catch { Fail "$prefix invalid promotion.verified_at" } }

        if (@("promoted", "verified") -contains $status) {
            if (-not (Test-ObjectProperty -Object $promotion -Name "target")) { Fail "$prefix status=$status requires promotion.target" }
            if (-not (Test-ObjectProperty -Object $promotion -Name "target_path")) { Fail "$prefix status=$status requires promotion.target_path" }
            if (-not (Test-ObjectProperty -Object $promotion -Name "applied_by")) { Fail "$prefix status=$status requires promotion.applied_by" }
            if (-not (Test-ObjectProperty -Object $promotion -Name "applied_at")) { Fail "$prefix status=$status requires promotion.applied_at" }
            if (Test-ObjectProperty -Object $promotion -Name "target_path") {
                $targetPath = $promotion.target_path
                if ($targetPath -notlike 'external://*') {
                    $resolvedTarget = Join-Path $Root ($targetPath -replace '/', [System.IO.Path]::DirectorySeparatorChar)
                    if (-not (Test-Path -LiteralPath $resolvedTarget)) {
                        Fail "$prefix promoted or verified lesson target_path does not exist: $targetPath"
                    }
                }
            }
        }

        if ($status -eq "verified") {
            if (-not (Test-ObjectProperty -Object $promotion -Name "verifier")) { Fail "$prefix status=verified requires promotion.verifier" }
            if (-not (Test-ObjectProperty -Object $promotion -Name "verified_at")) { Fail "$prefix status=verified requires promotion.verified_at" }
        }
    } elseif (@("promoted", "verified") -contains $status) {
        Fail "$prefix status=$status requires promotion block"
    }

    if ($status -eq "rejected") {
        if (-not (Test-ObjectProperty -Object $data -Name "rejection_reason") -or $lessonEnums.rejection_reason -notcontains $data.rejection_reason) {
            Fail "$prefix status=rejected requires valid rejection_reason"
        }
    }
    if ($status -eq "deprecated") {
        if (-not (Test-ObjectProperty -Object $data -Name "deprecated_reason") -or $lessonEnums.deprecated_reason -notcontains $data.deprecated_reason) {
            Fail "$prefix status=deprecated requires valid deprecated_reason"
        }
    }
    if ($status -eq "rolled_back") {
        if (-not (Test-ObjectProperty -Object $data -Name "rolled_back_reason") -or -not (Validate-StringField -Value $data.rolled_back_reason -MinLength 1 -MaxLength 240)) {
            Fail "$prefix status=rolled_back requires rolled_back_reason"
        }
    }
    if ($status -eq "expired" -and $hasReview -and -not (Test-ObjectProperty -Object $data.review -Name "expiry_review_at")) {
        Warn "$prefix expired lesson should carry review.expiry_review_at"
    }

    Pass $prefix
}

$results | ForEach-Object { Write-Output $_ }
if ($hasFailure) { exit 1 }
if ($hasWarning) { exit 2 }
exit 0
