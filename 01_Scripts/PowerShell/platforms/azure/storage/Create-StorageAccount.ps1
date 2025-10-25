# ============================================
# Create-StorageAccount.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Creates a Storage Account within LAB-RG 
#              using the Wilkes Family Holdings (wfh) identifier,
#              applies standard tags, and enables soft delete.
# ============================================

# PREVIEW
New-AzStorageAccount -ResourceGroupName LAB-RG `
    -Name wfhlabstorage10242025 `
    -Location eastus `
    -SkuName Standard_LRS `
    -Kind StorageV2 -WhatIf

# RUN
New-AzStorageAccount -ResourceGroupName LAB-RG `
    -Name wfhlabstorage10242025 `
    -Location eastus `
    -SkuName Standard_LRS `
    -Kind StorageV2

# Enable soft delete (blob retention 7 days)
Set-AzStorageBlobServiceProperty -ResourceGroupName LAB-RG `
    -AccountName wfhlabstorage10242025 `
    -EnableDeleteRetentionPolicy $true `
    -DeleteRetentionDays 7

# Apply standard tags to the resource group
Set-AzResourceGroup -Name LAB-RG `
    -Tag @{
        Environment = "Lab"
        Owner       = "Sean"
        Project     = "Azure-Toolkit"
        CostCenter  = "Training"
        CreatedBy   = "PowerShell"
    }
