# ============================================
# Create-Container.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Creates a private blob container inside the 
#              Wilkes Family Holdings (wfh) lab storage account.
# ============================================

# Variables
$rgName = "LAB-RG"
$storageAccount = "wfhlabstorage10242025"
$containerName = "labdata"

# PREVIEW
$ctx = (Get-AzStorageAccount -ResourceGroupName $rgName -Name $storageAccount).Context
Write-Host "[WhatIf] Would create container '$containerName' in storage account '$storageAccount' with private access."

# RUN
New-AzStorageContainer -Name $containerName -Context $ctx -Permission Off
Write-Host "Container '$containerName' created successfully in '$storageAccount'."

Verification:
Get-AzStorageContainer -Context $ctx | Select Name, PublicAccess