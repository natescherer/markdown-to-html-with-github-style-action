Write-Host "Beginning conversion..."

$Paths = $env:INPUT_PATH.split(",")

$QualifiedPaths = @()
foreach ($Path in $Paths) {
    $QualifiedPaths += "$env:GITHUB_WORKSPACE\$Path"
}

$ExpandedPaths = @()
foreach ($Path in $QualifiedPaths) {
    if (Test-Path -Path $Path -PathType Container) {
        $MarkdownFiles = Get-ChildItem -Path $Path -Include "*.md"
        foreach ($File in $MarkdownFiles) {
            $ExpandedPaths += $File.FullName
        }
    } else {
        $ExpandedPaths += $Path
    }
}

foreach ($Path in $ExpandedPaths) {
    [string]$Content = Get-Content -Path $Path -Raw
    $ContentArray = Get-Content -Path $Path
    $Title = ($ContentArray | Where-Object {$_ -like "# *"}).Replace("# ","")
    $ContentFormatted = [PSCustomObject]@{ "text" = $Content }

    $MDSplat = @{
        Uri = "https://api.github.com/markdown"
        Method = "POST"
        Headers = @{ Accept = "application/vnd.github.v3+json" }
        Body = ConvertTo-Json $ContentFormatted
    }
    $RenderedHtml = Invoke-RestMethod @MDSplat

    [string]$CssData = Get-Content -Path "$PSScriptRoot\..\misc\github-markdown.css" -Raw
    [string]$HtmlData = Get-Content -Path "$PSScriptRoot\..\misc\template.html" -Raw
    $HtmlData = $HtmlData.Replace("[content]", $RenderedHtml)
    $HtmlData = $HtmlData.Replace("[style]", $CssData)
    $HtmlData = $HtmlData.Replace("[title]", $Title)

    $OutputPath = ""
    if ($env:INPUT_OUTPUTPATH) {
        $OutputPath = Join-Path -Path $env:GITHUB_WORKSPACE -ChildPath $env:INPUT_OUTPUTPATH
    } else {
        $OutputPath = Split-Path -Path $Path -Parent
    }
    if ($env:INPUT_MATCHPATHSTRUCTURE -eq "true") {
        $UnqualifiedPath = $Path.replace($env:GITHUB_WORKSPACE,"")
        $OutputPath = Join-Path -Path $OutputPath -ChildPath (Split-Path -Path $UnqualifiedPath -Parent)
    }

    if (!(Test-Path -Path $OutputPath)) {
        New-Item -Path $OutputPath -ItemType Directory | Out-Null
    }

    $OutputFileName = (Split-Path -Path $Path -LeafBase) + ".html"

    $Output = Join-Path -Path $OutputPath -ChildPath $OutputFileName

    Out-File -InputObject $HtmlData -FilePath $Output -NoNewline
    Write-Host "$Output created!"
}

Write-Host "Done!"