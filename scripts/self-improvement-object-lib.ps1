Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:Utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Read-JsonYamlFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing object file: $Path"
    }

    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($raw)) {
        throw "Empty object file: $Path"
    }

    try {
        return $raw | ConvertFrom-Json
    } catch {
        throw "Invalid YAML/JSON-subset object file: $Path. $($_.Exception.Message)"
    }
}

function Write-JsonYamlFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][object]$Data
    )

    $json = $Data | ConvertTo-Json -Depth 32
    [System.IO.File]::WriteAllText($Path, $json + [Environment]::NewLine, $script:Utf8NoBom)
}

function Test-ObjectProperty {
    param(
        [Parameter(Mandatory = $true)][object]$Object,
        [Parameter(Mandatory = $true)][string]$Name
    )

    return [bool]($Object.PSObject.Properties.Name -contains $Name)
}

function Get-ObjectPropertyValue {
    param(
        [Parameter(Mandatory = $true)][object]$Object,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if (Test-ObjectProperty -Object $Object -Name $Name) {
        return $Object.$Name
    }

    return $null
}

function Normalize-FingerprintText {
    param(
        [AllowNull()][string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return "none"
    }

    $normalized = $Value.ToLowerInvariant()
    $normalized = $normalized -replace "\\", "/"
    $normalized = $normalized -replace '[0-9a-f]{7,40}', '<sha>'
    $normalized = $normalized -replace '\b\d{4}-\d{2}-\d{2}[t\s]\d{2}:\d{2}:\d{2}(?:\+\d{2}:\d{2}|z)?\b', '<timestamp>'
    $normalized = $normalized -replace '\b\d{4,}\b', '<n>'
    $normalized = $normalized -replace '\b[0-9a-f]{8}-[0-9a-f-]{27}\b', '<uuid>'
    $normalized = $normalized -replace ':\d{2,5}\b', ':<port>'
    $normalized = $normalized -replace '[\(\)\[\]''"`]+', ' '
    $normalized = $normalized -replace '\s+', ' '
    return $normalized.Trim()
}

function New-FailureFingerprint {
    param(
        [string]$Phase,
        [string]$Domain,
        [string]$RootCauseType,
        [string]$Summary,
        [string]$PrimaryPath,
        [string]$Tool
    )

    $tuple = @(
        (Normalize-FingerprintText $Phase),
        (Normalize-FingerprintText $Domain),
        (Normalize-FingerprintText $RootCauseType),
        (Normalize-FingerprintText $Summary),
        (Normalize-FingerprintText $PrimaryPath),
        (Normalize-FingerprintText $Tool)
    ) -join "|"

    $sha1 = [System.Security.Cryptography.SHA1]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($tuple)
        $hash = $sha1.ComputeHash($bytes)
        $hex = -join ($hash | ForEach-Object { $_.ToString("x2") })
        return $hex.Substring(0, 8)
    } finally {
        $sha1.Dispose()
    }
}

function Get-FailureDirectory {
    param([string]$Root)
    return Join-Path $Root "docs\knowledge\system-improvement\failures"
}

function Get-LessonDirectory {
    param([string]$Root)
    return Join-Path $Root "docs\knowledge\system-improvement\lessons"
}

function Get-RoutingPath {
    param([string]$Root)
    return Join-Path $Root "docs\knowledge\system-improvement\routing-v1.yaml"
}

function Get-ObjectFiles {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [string]$Filter = "*.yaml"
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    $item = Get-Item -LiteralPath $Path
    if ($item.PSIsContainer) {
        return @(Get-ChildItem -Path $item.FullName -Filter $Filter -File -ErrorAction SilentlyContinue | Sort-Object Name)
    }

    return @($item)
}

function Get-FailureObjects {
    param([string]$Root)

    $dir = Get-FailureDirectory -Root $Root
    $files = Get-ObjectFiles -Path $dir
    $rows = @()
    foreach ($file in $files) {
        $rows += [pscustomobject]@{
            Path = $file.FullName
            Data = Read-JsonYamlFile -Path $file.FullName
        }
    }
    return $rows
}

function Get-LessonObjects {
    param([string]$Root)

    $dir = Get-LessonDirectory -Root $Root
    $files = Get-ObjectFiles -Path $dir
    $rows = @()
    foreach ($file in $files) {
        $rows += [pscustomobject]@{
            Path = $file.FullName
            Data = Read-JsonYamlFile -Path $file.FullName
        }
    }
    return $rows
}

function Add-UniqueEvidenceValue {
    param(
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][System.Collections.ArrayList]$List,
        [AllowNull()][string]$Value,
        [int]$MaxLength = 400,
        [int]$MaxItems = 5
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return
    }

    $normalized = $Value.Trim()
    if ($normalized.Length -gt $MaxLength) {
        $normalized = $normalized.Substring(0, $MaxLength)
    }

    if ($List -contains $normalized) {
        return
    }

    if ($List.Count -lt $MaxItems) {
        [void]$List.Add($normalized)
    }
}

function New-OrUpdateFailureDraft {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$TaskRef,
        [string]$Phase = "unknown",
        [string]$Domain = "unknown",
        [Parameter(Mandatory = $true)][string]$Summary,
        [Parameter(Mandatory = $true)][string]$Symptom,
        [string]$Impact = "medium",
        [string]$RootCauseType = "unknown",
        [string]$Tool = "none",
        [string]$PrimaryPath = "",
        [string]$SourceWriter = "hook",
        [string]$SourceTrigger = "unknown",
        [string[]]$EvidenceFiles = @(),
        [string[]]$EvidenceCommands = @(),
        [string[]]$EvidenceOutputs = @(),
        [string]$ProposedLesson = "",
        [string]$ProposedTarget = "",
        [switch]$DoNotPromote
    )

    $fingerprint = New-FailureFingerprint -Phase $Phase -Domain $Domain -RootCauseType $RootCauseType -Summary $Summary -PrimaryPath $PrimaryPath -Tool $Tool
    $failureRows = Get-FailureObjects -Root $Root

    $cutoff = (Get-Date).AddHours(-24)
    $existing = $failureRows | Where-Object {
        $_.Data.fingerprint -eq $fingerprint -and
        @("captured", "triaged", "candidate") -contains $_.Data.status -and
        [datetimeoffset]$_.Data.created_at -ge $cutoff
    } | Select-Object -First 1

    if ($existing) {
        $data = $existing.Data
        $files = [System.Collections.ArrayList]::new()
        $commands = [System.Collections.ArrayList]::new()
        $outputs = [System.Collections.ArrayList]::new()

        foreach ($value in @($data.evidence.files)) { Add-UniqueEvidenceValue -List $files -Value $value -MaxLength 180 -MaxItems 10 }
        foreach ($value in @($data.evidence.commands)) { Add-UniqueEvidenceValue -List $commands -Value $value -MaxLength 200 -MaxItems 5 }
        foreach ($value in @($data.evidence.outputs)) { Add-UniqueEvidenceValue -List $outputs -Value $value -MaxLength 400 -MaxItems 5 }
        foreach ($value in $EvidenceFiles) { Add-UniqueEvidenceValue -List $files -Value $value -MaxLength 180 -MaxItems 10 }
        foreach ($value in $EvidenceCommands) { Add-UniqueEvidenceValue -List $commands -Value $value -MaxLength 200 -MaxItems 5 }
        foreach ($value in $EvidenceOutputs) { Add-UniqueEvidenceValue -List $outputs -Value $value -MaxLength 400 -MaxItems 5 }

        $data.occurrences = [int]($data.occurrences + 1)
        $data.evidence.files = @($files)
        $data.evidence.commands = @($commands)
        $data.evidence.outputs = @($outputs)
        if ($SourceWriter -ne "hook" -and -not [string]::IsNullOrWhiteSpace($ProposedLesson)) {
            $data.proposed_lesson = $ProposedLesson
        }
        if ($SourceWriter -ne "hook" -and -not [string]::IsNullOrWhiteSpace($ProposedTarget)) {
            $data.proposed_target = $ProposedTarget
        }
        if ($DoNotPromote.IsPresent) {
            $data.do_not_promote = $true
        }
        Write-JsonYamlFile -Path $existing.Path -Data $data
        return [pscustomobject]@{ Path = $existing.Path; Data = $data; Created = $false }
    }

    $now = [datetimeoffset]::Now
    $id = "FAIL-{0}-{1}" -f $now.ToString("yyyyMMdd-HHmmss"), $fingerprint.Substring(0, 6)
    $path = Join-Path (Get-FailureDirectory -Root $Root) ($id + ".yaml")

    $files = [System.Collections.ArrayList]::new()
    $commands = [System.Collections.ArrayList]::new()
    $outputs = [System.Collections.ArrayList]::new()
    foreach ($value in $EvidenceFiles) { Add-UniqueEvidenceValue -List $files -Value $value -MaxLength 180 -MaxItems 10 }
    foreach ($value in $EvidenceCommands) { Add-UniqueEvidenceValue -List $commands -Value $value -MaxLength 200 -MaxItems 5 }
    foreach ($value in $EvidenceOutputs) { Add-UniqueEvidenceValue -List $outputs -Value $value -MaxLength 400 -MaxItems 5 }

    $data = [ordered]@{
        schema_version = 1
        id = $id
        created_at = $now.ToString("o")
        task_ref = $TaskRef
        phase = $Phase
        domain = $Domain
        summary = $Summary
        symptom = $Symptom
        impact = $Impact
        root_cause_type = $RootCauseType
        fingerprint = $fingerprint
        status = "captured"
        source = [ordered]@{
            writer = $SourceWriter
            trigger = $SourceTrigger
        }
        evidence = [ordered]@{
            files = @($files)
            commands = @($commands)
            outputs = @($outputs)
        }
        occurrences = 1
        related_failures = @()
        tool = $Tool
        primary_path = $PrimaryPath
        do_not_promote = $DoNotPromote.IsPresent
    }

    if ($SourceWriter -ne "hook" -and -not [string]::IsNullOrWhiteSpace($ProposedLesson)) {
        $data.proposed_lesson = $ProposedLesson
    }
    if ($SourceWriter -ne "hook" -and -not [string]::IsNullOrWhiteSpace($ProposedTarget)) {
        $data.proposed_target = $ProposedTarget
    }

    Write-JsonYamlFile -Path $path -Data $data
    return [pscustomobject]@{ Path = $path; Data = $data; Created = $true }
}

function Get-MarkdownSection {
    param(
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$Heading
    )

    $pattern = "(?ms)^##\s+$([regex]::Escape($Heading))\s*\r?\n(.*?)(?=^##\s+|\z)"
    $match = [regex]::Match($Content, $pattern)
    if ($match.Success) {
        return $match.Groups[1].Value.Trim()
    }
    return ""
}

function Get-ActiveLoadConfig {
    param([string]$Root)

    $routingPath = Get-RoutingPath -Root $Root
    if (-not (Test-Path -LiteralPath $routingPath)) {
        return $null
    }

    $routing = Read-JsonYamlFile -Path $routingPath
    return $routing.active_load
}

function Get-FailureSummaryPriority {
    param([string]$Impact, [string]$Status)

    $impactWeight = @{ high = 3; medium = 2; low = 1 }
    $statusWeight = @{ candidate = 3; triaged = 2; captured = 1 }
    return ([int]($impactWeight[$Impact])) * 10 + [int]($statusWeight[$Status])
}

function Get-LessonSummaryPriority {
    param([string]$Status)
    $statusWeight = @{ under_review = 4; accepted = 3; promoted = 2; verified = 1 }
    return [int]($statusWeight[$Status])
}

function Get-OpenFailureSummaries {
    param([string]$Root)

    $config = Get-ActiveLoadConfig -Root $Root
    if ($null -eq $config) {
        return @()
    }

    $failureConfig = $config.summary.failures
    $allowedStatuses = @($failureConfig.statuses)
    $maxItems = [int]$failureConfig.max_items
    $minImpact = @($failureConfig.minimum_impacts)

    $rows = foreach ($row in (Get-FailureObjects -Root $Root)) {
        $data = $row.Data
        if ($allowedStatuses -notcontains $data.status) { continue }
        if ($minImpact -notcontains $data.impact) { continue }
        [pscustomobject]@{
            id = $data.id
            phase = $data.phase
            domain = $data.domain
            impact = $data.impact
            status = $data.status
            summary = $data.summary
            created_at = $data.created_at
            priority = Get-FailureSummaryPriority -Impact $data.impact -Status $data.status
        }
    }

    return @(
        $rows |
        Sort-Object @{ Expression = "priority"; Descending = $true }, @{ Expression = { [datetimeoffset]$_.created_at }; Descending = $true } |
        Select-Object -First $maxItems
    )
}

function Get-ActiveLessonSummaries {
    param([string]$Root)

    $config = Get-ActiveLoadConfig -Root $Root
    if ($null -eq $config) {
        return @()
    }

    $lessonConfig = $config.summary.lessons
    $allowedStatuses = @($lessonConfig.statuses)
    $maxItems = [int]$lessonConfig.max_items
    $cutoff = (Get-Date).AddDays(-[int]$lessonConfig.max_age_days)

    $rows = foreach ($row in (Get-LessonObjects -Root $Root)) {
        $data = $row.Data
        if ($allowedStatuses -notcontains $data.status) { continue }
        if ([datetimeoffset]$data.updated_at -lt $cutoff) { continue }
        [pscustomobject]@{
            id = $data.id
            target = $data.recommended_target
            status = $data.status
            title = $data.title
            updated_at = $data.updated_at
            priority = Get-LessonSummaryPriority -Status $data.status
        }
    }

    return @(
        $rows |
        Sort-Object @{ Expression = "priority"; Descending = $true }, @{ Expression = { [datetimeoffset]$_.updated_at }; Descending = $true } |
        Select-Object -First $maxItems
    )
}

function Get-ActiveLoadSummary {
    param([string]$Root)

    $config = Get-ActiveLoadConfig -Root $Root
    if ($null -eq $config) {
        return [pscustomobject]@{
            always = @()
            open_failures = @()
            active_lessons = @()
            retrieval_only = @()
        }
    }

    return [pscustomobject]@{
        always = @($config.always)
        open_failures = @(Get-OpenFailureSummaries -Root $Root)
        active_lessons = @(Get-ActiveLessonSummaries -Root $Root)
        retrieval_only = @($config.retrieval_only_prefixes)
    }
}
