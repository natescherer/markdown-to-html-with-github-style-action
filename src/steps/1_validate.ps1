if (($env:INPUT_MATCHPATHSTRUCTURE -eq "true") -and ($null -eq $env:INPUT_OUTPUTPATH)) {
    Write-Host "You cannot use 'matchpathstructure' without mode 'outputpath'."
    throw "Input validation error."
}