# ============================================
# Create-LogAnalytics.ps1 (Lab Version)
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Creates the Log Analytics Workspace for LAB-RG.
# ============================================

$rgName   = "LAB-RG"
$lawName  = "wfh-lab-law"
$location = "EastUS2"

# PREVIEW
New-AzOperationalInsightsWorkspace -ResourceGroupName $rgName `
    -Name $lawName -Location $location -Sku "PerGB2018" -WhatIf

# RUN
New-AzOperationalInsightsWorkspace -ResourceGroupName $rgName `
    -Name $lawName -Location $location -Sku "PerGB2018"

