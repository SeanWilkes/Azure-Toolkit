# ============================================
# Create-And-Tag-ResourceGroup.ps1
# Author: Sean Wilkes
# Description: Creates a new Resource Group named LAB-RG in East US 
#              and applies standard Azure Toolkit tags.
# ============================================

# PREVIEW
New-AzResourceGroup -Name LAB-RG -Location eastus -WhatIf
Set-AzResourceGroup -Name LAB-RG `
    -Tag @{
        Environment = "Lab"
        Owner       = "Sean"
        Project     = "Azure-Toolkit"
        CostCenter  = "Training"
        CreatedBy   = "PowerShell"
    } -WhatIf

# RUN
New-AzResourceGroup -Name LAB-RG -Location eastus
Set-AzResourceGroup -Name LAB-RG `
    -Tag @{
        Environment = "Lab"
        Owner       = "Sean"
        Project     = "Azure-Toolkit"
        CostCenter  = "Training"
        CreatedBy   = "PowerShell"
    }
