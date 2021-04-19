Write-Host "Beginning conversion..."

$Paths = $env:INPUTWORKAROUND_PATH.split(",")

foreach ($Path in $Paths) {
    $FullPath = "$env:GITHUB_WORKSPACE\$Path"
    Write-Host "Converting '$FullPath'..."

    [string]$Content = Get-Content -Path $FullPath -Raw
    $ContentArray = Get-Content -Path $FullPath
    $Title = ($ContentArray | Where-Object {$_ -like "# *"}).Replace("# ","")
    $ContentFormatted = [PSCustomObject]@{ "text" = $Content }

    $MDSplat = @{
        Uri = "https://api.github.com/markdown"
        Method = "POST"
        Headers = @{ Accept = "application/vnd.github.v3+json" }
        Body = ConvertTo-Json $ContentFormatted
    }
    $RenderedHtml = Invoke-RestMethod @MDSplat

    [string]$CssData = Get-Content -Path "$PSScriptRoot\github-markdown.css" -Raw
    [string]$HtmlData = Get-Content -Path "$PSScriptRoot\template.html" -Raw
    $HtmlData = $HtmlData.Replace("[content]", $RenderedHtml)
    $HtmlData = $HtmlData.Replace("[style]", $CssData)
    $HtmlData = $HtmlData.Replace("[title]", $Title)

    $OutputPath = ""
    if ($env:INPUTWORKAROUND_OUTPUTPATH) {
        $OutputPath = Join-Path -Path $env:GITHUB_WORKSPACE -ChildPath $env:INPUTWORKAROUND_OUTPUTPATH
    } else {
        $OutputPath = Split-Path -Path $FullPath -Parent
    }
    if ($env:INPUTWORKAROUND_MATCHPATHSTRUCTURE -eq "true") {
        $OutputPath = Join-Path -Path $OutputPath -ChildPath (Split-Path -Path $Path -Parent)
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