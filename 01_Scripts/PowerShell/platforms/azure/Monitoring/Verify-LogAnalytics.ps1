# ============================================
# Verify-LogAnalytics.ps1 (Lab Version)
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Verifies the Log Analytics Workspace for LAB-RG.
# ============================================



#Confirmation
Get-AzOperationalInsightsWorkspace -ResourceGroupName LAB-RG | Select Name, Location, CustomerId