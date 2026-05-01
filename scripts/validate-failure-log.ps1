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
        [string]$Field,
        [int]$MinLength,
        [int]$MaxLength,
        [switch]$AllowEmpty
    )

    if ($null -eq $Value) {
        return $false
    }

    if (-not ($Value -is [string])) {
        return $false
    }

    if (-not $AllowEmpty.IsPresent -and [string]::IsNullOrWhiteSpace($Value)) {
        return $false
    }

    if ($Value.Length -lt $MinLength -or $Value.Length -gt $MaxLength) {
        return $false
    }

    return $true
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

$failureEnums = @{
    phase = @("unknown", "interview", "research", "design", "implement", "verify", "review", "capture")
    domain = @("unknown", "self-improvement", "coding", "research", "product", "uiux", "knowledge", "remote")
    impact = @("low", "medium", "high")
    root_cause_type = @("unknown", "routing", "tool-choice", "missing-context", "verification-gap", "unsafe-default", "weak-memory", "other")
    status = @("captured", "triaged", "candidate", "suppressed", "rejected", "closed")
    source_writer = @("hook", "codex", "eval", "human")
    proposed_target = @("memory", "skill", "hook", "eval", "workflow", "MCP", "none")
    close_reason = @("promoted", "duplicate", "one-off", "external", "abandoned", "superseded")
}

$results = @()
$hasFailure = $false
$hasWarning = $false

if ([string]::IsNullOrWhiteSpace($Path)) {
    $Path = Get-FailureDirectory -Root $Root
}

$files = Get-ObjectFiles -Path $Path
if ($files.Count -eq 0) {
    Fail "No failure files found under $Path"
}

$openFingerprints = @{}

foreach ($file in $files) {
    try {
        $data = Read-JsonYamlFile -Path $file.FullName
    } catch {
        Fail $_.Exception.Message
        continue
    }

    $prefix = $file.Name
    $requiredFields = @(
        "schema_version", "id", "created_at", "task_ref", "phase", "domain", "summary",
        "symptom", "impact", "root_cause_type", "fingerprint", "status", "source", "evidence"
    )
    foreach ($field in $requiredFields) {
        if (-not (Test-ObjectProperty -Object $data -Name $field)) {
            Fail "$prefix missing required field: $field"
        }
    }

    if ($data.schema_version -ne 1) { Fail "$prefix schema_version must equal 1" }
    if (-not ($data.id -is [string]) -or $data.id -notmatch '^FAIL-\d{8}-\d{6}-[a-f0-9]{6}$') { Fail "$prefix invalid id format" }
    if (-not ($data.fingerprint -is [string]) -or $data.fingerprint -notmatch '^[a-f0-9]{8}$') { Fail "$prefix invalid fingerprint format" }
    if (($data.id -split '-')[-1] -ne $data.fingerprint.Substring(0, 6)) { Fail "$prefix id suffix must equal fingerprint prefix" }
    if ($file.Name -ne ($data.id + ".yaml")) { Fail "$prefix file name must equal id.yaml" }

    try { [void][datetimeoffset]$data.created_at } catch { Fail "$prefix invalid created_at" }
    if (-not (Validate-StringField -Value $data.task_ref -Field "task_ref" -MinLength 1 -MaxLength 128)) { Fail "$prefix invalid task_ref" }
    if (-not (Validate-StringField -Value $data.summary -Field "summary" -MinLength 1 -MaxLength 160)) { Fail "$prefix invalid summary" }
    if (-not (Validate-StringField -Value $data.symptom -Field "symptom" -MinLength 1 -MaxLength 240)) { Fail "$prefix invalid symptom" }
    if ($failureEnums.phase -notcontains $data.phase) { Fail "$prefix invalid phase '$($data.phase)'" }
    if ($failureEnums.domain -notcontains $data.domain) { Fail "$prefix invalid domain '$($data.domain)'" }
    if ($failureEnums.impact -notcontains $data.impact) { Fail "$prefix invalid impact '$($data.impact)'" }
    if ($failureEnums.root_cause_type -notcontains $data.root_cause_type) { Fail "$prefix invalid root_cause_type '$($data.root_cause_type)'" }
    if ($failureEnums.status -notcontains $data.status) { Fail "$prefix invalid status '$($data.status)'" }

    if (-not (Test-ObjectProperty -Object $data.source -Name "writer") -or $failureEnums.source_writer -notcontains $data.source.writer) {
        Fail "$prefix invalid source.writer"
    }
    if (-not (Test-ObjectProperty -Object $data.source -Name "trigger") -or -not (Validate-StringField -Value $data.source.trigger -Field "source.trigger" -MinLength 1 -MaxLength 80)) {
        Fail "$prefix invalid source.trigger"
    }

    if (-not (Test-ObjectProperty -Object $data.evidence -Name "files")) { Fail "$prefix evidence.files missing" }
    if (-not (Test-ObjectProperty -Object $data.evidence -Name "commands")) { Fail "$prefix evidence.commands missing" }
    if (-not (Test-ObjectProperty -Object $data.evidence -Name "outputs")) { Fail "$prefix evidence.outputs missing" }

    foreach ($evidenceField in @(
            @{ Name = "files"; MaxItems = 10; MaxLength = 180 },
            @{ Name = "commands"; MaxItems = 5; MaxLength = 200 },
            @{ Name = "outputs"; MaxItems = 5; MaxLength = 400 }
        )) {
        $values = @($data.evidence.($evidenceField.Name))
        if ($values.Count -gt $evidenceField.MaxItems) {
            Fail "$prefix evidence.$($evidenceField.Name) exceeds $($evidenceField.MaxItems) items"
        }
        $combinedLength = 0
        foreach ($value in $values) {
            if (-not ($value -is [string])) {
                Fail "$prefix evidence.$($evidenceField.Name) must contain strings only"
                continue
            }
            if ($value.Length -gt $evidenceField.MaxLength) {
                Fail "$prefix evidence.$($evidenceField.Name) item exceeds $($evidenceField.MaxLength) characters"
            }
            $combinedLength += $value.Length
        }
        if ($combinedLength -gt 2000) {
            Fail "$prefix evidence.$($evidenceField.Name) combined length exceeds 2000 characters"
        }
    }

    if (Test-ObjectProperty -Object $data -Name "occurrences") {
        if (-not (Test-WholeNumberInRange -Value $data.occurrences -Min 1 -Max 99)) {
            Fail "$prefix invalid occurrences"
        }
    }

    if ($data.source.writer -eq "hook") {
        if (Test-ObjectProperty -Object $data -Name "proposed_target") { Fail "$prefix hook-authored draft cannot set proposed_target" }
        if (Test-ObjectProperty -Object $data -Name "proposed_lesson") { Fail "$prefix hook-authored draft cannot set proposed_lesson" }
    }

    if ((Test-ObjectProperty -Object $data -Name "proposed_target") -and $failureEnums.proposed_target -notcontains $data.proposed_target) {
        Fail "$prefix invalid proposed_target '$($data.proposed_target)'"
    }

    switch ($data.status) {
        "captured" {
            if (Test-ObjectProperty -Object $data -Name "close_reason") { Fail "$prefix captured failure cannot have close_reason" }
        }
        "triaged" { }
        "candidate" {
            if (-not (Test-ObjectProperty -Object $data -Name "proposed_target")) {
                Fail "$prefix candidate failure requires proposed_target"
            }
        }
        "suppressed" {
            if (-not (Test-ObjectProperty -Object $data -Name "suppress_reason") -or -not (Validate-StringField -Value $data.suppress_reason -Field "suppress_reason" -MinLength 1 -MaxLength 160)) {
                Fail "$prefix suppressed failure requires suppress_reason"
            }
        }
        "rejected" {
            if (-not (Test-ObjectProperty -Object $data -Name "close_reason")) {
                Fail "$prefix rejected failure requires close_reason"
            }
        }
        "closed" {
            if (-not (Test-ObjectProperty -Object $data -Name "close_reason")) { Fail "$prefix status=closed requires close_reason" }
            if (-not (Test-ObjectProperty -Object $data -Name "closed_at")) { Fail "$prefix status=closed requires closed_at" }
            if ((Test-ObjectProperty -Object $data -Name "close_reason") -and $failureEnums.close_reason -notcontains $data.close_reason) {
                Fail "$prefix invalid close_reason '$($data.close_reason)'"
            }
            if (Test-ObjectProperty -Object $data -Name "closed_at") {
                try { [void][datetimeoffset]$data.closed_at } catch { Fail "$prefix invalid closed_at" }
            }
        }
    }

    if (@("captured", "triaged", "candidate") -contains $data.status) {
        if (-not $openFingerprints.ContainsKey($data.fingerprint)) {
            $openFingerprints[$data.fingerprint] = @()
        }
        $openFingerprints[$data.fingerprint] += $prefix
    }

    Pass $prefix
}

foreach ($entry in $openFingerprints.GetEnumerator()) {
    if ($entry.Value.Count -gt 1) {
        Warn ("duplicate open fingerprint {0}: {1}" -f $entry.Key, ($entry.Value -join ", "))
    }
}

$results | ForEach-Object { Write-Output $_ }
if ($hasFailure) { exit 1 }
if ($hasWarning) { exit 2 }
exit 0
