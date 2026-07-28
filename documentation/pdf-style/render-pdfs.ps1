[CmdletBinding()]
param(
    [string] $InputDirectory = "output/pdf",
    [string] $OutputDirectory = "tmp/pdfs/rendered",
    [uint32] $Width = 1240
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$inputRoot = (Resolve-Path (Join-Path $repoRoot $InputDirectory)).Path
$outputRoot = Join-Path $repoRoot $OutputDirectory
$cacheRoot = Join-Path (Split-Path $outputRoot -Parent) "render-cache"
New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null
New-Item -ItemType Directory -Force -Path $cacheRoot | Out-Null
Get-ChildItem -LiteralPath $cacheRoot -Filter "*.pdf" -File | Remove-Item -Force

Add-Type -AssemblyName System.Runtime.WindowsRuntime
[Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Pdf.PdfPageRenderOptions, Windows.Data.Pdf, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime] | Out-Null

$asTaskMethods = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object Name -eq "AsTask"
$operationMethod = $asTaskMethods | Where-Object {
    $_.IsGenericMethod -and
    $_.GetGenericArguments().Count -eq 1 -and
    $_.GetParameters().Count -eq 1 -and
    $_.ReturnType.IsGenericType
} | Select-Object -First 1
$actionMethod = $asTaskMethods | Where-Object {
    -not $_.IsGenericMethod -and
    $_.GetParameters().Count -eq 1
} | Select-Object -First 1

function Wait-WinRtOperation {
    param($Operation, [Type] $ResultType)
    $task = $operationMethod.MakeGenericMethod($ResultType).Invoke($null, @($Operation))
    $task.GetAwaiter().GetResult()
}

function Wait-WinRtAction {
    param($Operation)
    $task = $actionMethod.Invoke($null, @($Operation))
    $null = $task.GetAwaiter().GetResult()
}

$pdfFiles = Get-ChildItem -LiteralPath $inputRoot -Filter "*.pdf" -File | Sort-Object Name
foreach ($pdfFile in $pdfFiles) {
    $contentHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $pdfFile.FullName).Hash.Substring(0, 12).ToLowerInvariant()
    $renderSource = Join-Path $cacheRoot ("{0}-{1}.pdf" -f $pdfFile.BaseName, $contentHash)
    Copy-Item -LiteralPath $pdfFile.FullName -Destination $renderSource -Force
    $storageFile = Wait-WinRtOperation ([Windows.Storage.StorageFile]::GetFileFromPathAsync($renderSource)) ([Windows.Storage.StorageFile])
    $document = Wait-WinRtOperation ([Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($storageFile)) ([Windows.Data.Pdf.PdfDocument])
    Write-Host "$($pdfFile.Name): $($document.PageCount) Seiten"
    Get-ChildItem -LiteralPath $outputRoot -Filter "$($pdfFile.BaseName)-page-*.png" -File | Remove-Item -Force

    for ($pageIndex = 0; $pageIndex -lt $document.PageCount; $pageIndex++) {
        $page = $document.GetPage($pageIndex)
        try {
            $dimensions = $page.Dimensions
            Write-Verbose ("Seite {0}: MediaBox={1}; CropBox={2}" -f ($pageIndex + 1), $dimensions.MediaBox, $dimensions.CropBox)
            $stream = [Windows.Storage.Streams.InMemoryRandomAccessStream]::new()
            try {
                $options = [Windows.Data.Pdf.PdfPageRenderOptions]::new()
                $options.DestinationWidth = $Width
                Wait-WinRtAction ($page.RenderToStreamAsync($stream, $options))
                $stream.Seek(0)
                $inputStream = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead($stream)
                try {
                    $target = Join-Path $outputRoot ("{0}-page-{1:D2}.png" -f $pdfFile.BaseName, ($pageIndex + 1))
                    $fileStream = [System.IO.File]::Create($target)
                    try {
                        $inputStream.CopyTo($fileStream)
                    }
                    finally {
                        $fileStream.Dispose()
                    }
                }
                finally {
                    $inputStream.Dispose()
                }
            }
            finally {
                $stream.Dispose()
            }
        }
        finally {
            $page.Dispose()
        }
    }
}

Write-Host "Renderings: $outputRoot"
