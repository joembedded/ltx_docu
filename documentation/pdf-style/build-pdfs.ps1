[CmdletBinding()]
param(
    [string[]] $Source,
    [string] $OutputDirectory = "output/pdf"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$sourceRoot = Join-Path $repoRoot "pdf"
$outputRoot = Join-Path $repoRoot $OutputDirectory
$defaultsFile = Join-Path $PSScriptRoot "geoprecision.yaml"
$templateFile = Join-Path $PSScriptRoot "geoprecision.tex"
$assetRoot = Join-Path $PSScriptRoot "assets"

$pandoc = Get-Command pandoc -ErrorAction Stop
$null = Get-Command xelatex -ErrorAction Stop
New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null

if ($Source) {
    $sourceFiles = foreach ($item in $Source) {
        Get-Item (Join-Path $repoRoot $item)
    }
}
else {
    $sourceFiles = Get-ChildItem -LiteralPath $sourceRoot -Filter "*.md" -File | Sort-Object Name
}

if (-not $sourceFiles) {
    throw "Keine Markdown-Quellen in '$sourceRoot' gefunden."
}

Push-Location $repoRoot
try {
    foreach ($sourceFile in $sourceFiles) {
        $targetFile = Join-Path $outputRoot ($sourceFile.BaseName + ".pdf")
        $resourcePath = "$repoRoot;$($sourceFile.DirectoryName);$assetRoot"
        $sourceText = Get-Content -Raw -Encoding UTF8 $sourceFile.FullName
        $coverMatch = [regex]::Match($sourceText, '(?m)^cover-image:\s*["'']?([^\r\n"'']+)["'']?\s*$')
        if (-not $coverMatch.Success) {
            throw "In '$($sourceFile.Name)' fehlt das Metadatenfeld 'cover-image'."
        }
        $coverPath = $coverMatch.Groups[1].Value.Trim()
        if (-not [System.IO.Path]::IsPathRooted($coverPath)) {
            $coverPath = Join-Path $repoRoot $coverPath
        }
        $coverPath = (Resolve-Path $coverPath).Path.Replace('\', '/')
        $logoPath = (Resolve-Path (Join-Path $assetRoot "geoprecision-logo.png")).Path.Replace('\', '/')
        Write-Host "Baue $($sourceFile.Name) -> $targetFile"
        & $pandoc.Source `
            $sourceFile.FullName `
            --defaults $defaultsFile `
            --template $templateFile `
            --resource-path $resourcePath `
            --metadata "logo-image=$logoPath" `
            --metadata "cover-image=$coverPath" `
            --syntax-highlighting=none `
            --output $targetFile
        if ($LASTEXITCODE -ne 0) {
            throw "Pandoc ist für '$($sourceFile.FullName)' mit Exit-Code $LASTEXITCODE fehlgeschlagen."
        }
    }
}
finally {
    Pop-Location
}

Write-Host "Fertig: $($sourceFiles.Count) PDF-Datei(en) in '$outputRoot'."
