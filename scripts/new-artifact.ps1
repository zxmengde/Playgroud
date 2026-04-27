param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("knowledge-item", "citation-checklist", "web-source-note", "mcp-adoption-review", "system-improvement-proposal")]
    [string]$Type,
    [string]$Name = "",
    [string]$Title = "",
    [string]$Url = "",
    [string]$KnowledgeType = "note",
    [ValidateSet("memory", "skill", "config", "hook", "doc", "eval", "automation")]
    [string]$Category = "doc",
    [string]$OutputPath = "",
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

function Get-RequiredText {
    param(
        [string]$Value,
        [string]$Fallback,
        [string]$Label
    )

    if (-not [string]::IsNullOrWhiteSpace($Value)) {
        return $Value
    }
    if (-not [string]::IsNullOrWhiteSpace($Fallback)) {
        return $Fallback
    }
    throw "$Label is required for artifact type '$Type'."
}

function Get-SafeSlug {
    param([string]$Value)

    $safe = ($Value.ToLowerInvariant() -replace '[^\p{L}\p{Nd}]+', '-').Trim('-')
    if ([string]::IsNullOrWhiteSpace($safe)) {
        throw "Name or title does not contain usable characters."
    }
    return $safe
}

function Resolve-OutputPath {
    param(
        [string]$Path,
        [string]$DefaultPath
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $DefaultPath
    }
    if ([System.IO.Path]::IsPathRooted($Path)) {
        return $Path
    }
    return (Join-Path $Root $Path)
}

function Assert-Template {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing template: $Path"
    }
}

function Write-NewArtifact {
    param(
        [string]$Path,
        [string]$Content
    )

    if (Test-Path -LiteralPath $Path) {
        throw "Output already exists: $Path"
    }

    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
    Write-Output $Path
}

$date = Get-Date -Format "yyyy-MM-dd"

switch ($Type) {
    "knowledge-item" {
        $itemTitle = Get-RequiredText -Value $Title -Fallback $Name -Label "Title or Name"
        $safe = Get-SafeSlug -Value $itemTitle
        $templatePath = Join-Path $Root "templates\knowledge\knowledge-item.md"
        Assert-Template -Path $templatePath

        $defaultOutput = Join-Path $Root "docs\knowledge\items\$date-$safe.md"
        $output = Resolve-OutputPath -Path $OutputPath -DefaultPath $defaultOutput
        $content = Get-Content -LiteralPath $templatePath -Raw
        $content = $content -replace "(?m)^title:\s*$", ("title: " + $itemTitle.Replace('$', '$$'))
        $content = $content -replace "(?m)^type:\s*$", ("type: " + $KnowledgeType.Replace('$', '$$'))
        Write-NewArtifact -Path $output -Content $content
        break
    }

    "citation-checklist" {
        $itemTitle = Get-RequiredText -Value $Title -Fallback $Name -Label "Title or Name"
        $safe = Get-SafeSlug -Value $itemTitle
        $templatePath = Join-Path $Root "templates\research\citation-checklist.md"
        Assert-Template -Path $templatePath

        $defaultOutput = Join-Path $Root "output\$date-$safe-citation-checklist.md"
        $output = Resolve-OutputPath -Path $OutputPath -DefaultPath $defaultOutput
        $content = Get-Content -LiteralPath $templatePath -Raw
        $content = $content.Replace("## 任务", "## 任务`n`n$itemTitle")
        Write-NewArtifact -Path $output -Content $content
        break
    }

    "web-source-note" {
        if ([string]::IsNullOrWhiteSpace($Url)) {
            throw "Url is required for artifact type '$Type'."
        }
        $itemTitle = $Title
        if ([string]::IsNullOrWhiteSpace($itemTitle)) {
            $itemTitle = $Name
        }
        if ([string]::IsNullOrWhiteSpace($itemTitle)) {
            $itemTitle = "web-source"
        }

        $safe = Get-SafeSlug -Value $itemTitle
        $templatePath = Join-Path $Root "templates\web\source-note.md"
        Assert-Template -Path $templatePath

        $defaultOutput = Join-Path $Root "output\$date-$safe-web-source.md"
        $output = Resolve-OutputPath -Path $OutputPath -DefaultPath $defaultOutput
        $content = Get-Content -LiteralPath $templatePath -Raw
        $content = $content.Replace("- URL：", "- URL：$Url")
        $content = $content.Replace("- 标题：", "- 标题：$itemTitle")
        $content = $content.Replace("- 访问日期：", "- 访问日期：$date")
        Write-NewArtifact -Path $output -Content $content
        break
    }

    "mcp-adoption-review" {
        $itemName = Get-RequiredText -Value $Name -Fallback $Title -Label "Name or Title"
        $safe = Get-SafeSlug -Value $itemName
        $templatePath = Join-Path $Root "templates\assistant\mcp-adoption-review.md"
        Assert-Template -Path $templatePath

        $defaultOutput = Join-Path $Root "docs\references\assistant\mcp-reviews\$date-$safe.md"
        $output = Resolve-OutputPath -Path $OutputPath -DefaultPath $defaultOutput
        $content = Get-Content -LiteralPath $templatePath -Raw
        $content = $content.Replace("- 名称：", "- 名称：$itemName")
        $content = $content.Replace("- 记录日期：", "- 记录日期：$date")
        Write-NewArtifact -Path $output -Content $content
        break
    }

    "system-improvement-proposal" {
        $itemName = Get-RequiredText -Value $Name -Fallback $Title -Label "Name or Title"
        $safe = Get-SafeSlug -Value $itemName
        $templatePath = Join-Path $Root "templates\assistant\system-improvement-proposal.md"
        Assert-Template -Path $templatePath

        $defaultOutput = Join-Path $Root "docs\knowledge\system-improvement\proposals\$date-$safe.md"
        $output = Resolve-OutputPath -Path $OutputPath -DefaultPath $defaultOutput
        $content = Get-Content -LiteralPath $templatePath -Raw
        $content = $content.Replace("{{date}}", $date).Replace("{{name}}", $itemName).Replace("{{category}}", $Category)
        Write-NewArtifact -Path $output -Content $content
        break
    }
}
