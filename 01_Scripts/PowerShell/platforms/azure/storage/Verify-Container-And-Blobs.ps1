# ============================================
# Verify-Container-And-Blobs.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Verifies a storage container exists, lists containers/blobs,
#              and optionally uploads/downloads a test file.
# ============================================

param(
    [string]$RgName        = "LAB-RG",
    [string]$StorageName   = "wfhlabstorage10242025",
    [string]$ContainerName = "labdata",
    [string]$LocalTestFile = "$env:TEMP\lab-test.txt",
    [switch]$Preview
)

# Context
$ctx = (Get-AzStorageAccount -ResourceGroupName $RgName -Name $StorageName).Context

# 1) List containers
Write-Host "Containers in ${StorageName}:"
Get-AzStorageContainer -Context $ctx | Select-Object Name, PublicAccess

# 2) Verify target container
$container = Get-AzStorageContainer -Name $ContainerName -Context $ctx -ErrorAction SilentlyContinue
if (-not $container) { throw "Container '$ContainerName' not found." }

# 3) List blobs in the container
Write-Host "`nBlobs in '$ContainerName':"
Get-AzStorageBlob -Container $ContainerName -Context $ctx | Select-Object Name, Length, LastModified

# 4) Create a local test file (idempotent)
if (-not (Test-Path $LocalTestFile)) {
    "Hello from Azure Toolkit $(Get-Date -Format s)" | Out-File -Encoding UTF8 $LocalTestFile
}

# 5) Upload (no -WhatIf support on this cmdlet; simulate preview)
if ($Preview) {
    Write-Host "[Preview] Would upload '$LocalTestFile' to container '$ContainerName'."
} else {
    Set-AzStorageBlobContent -File $LocalTestFile -Container $ContainerName -Context $ctx -Force | Out-Null
    Write-Host "Uploaded '$LocalTestFile' to '$ContainerName'."
}

# 6) Download back to a temp path to validate round-trip
$downloadPath = Join-Path $env:TEMP "lab-test-download.txt"
if ($Preview) {
    Write-Host "[Preview] Would download '$(Split-Path $LocalTestFile -Leaf)' to '$downloadPath'."
} else {
    Get-AzStorageBlobContent -Container $ContainerName -Blob (Split-Path $LocalTestFile -Leaf) `
        -Destination $downloadPath -Context $ctx -Force | Out-Null
    Write-Host "Downloaded blob to '$downloadPath'."
}
