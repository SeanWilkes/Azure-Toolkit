# ============================================
# Connect-VMToLogAnalytics.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Validates the Azure Monitor agent for the VM OS
#              and links it to the Log Analytics workspace.
# ============================================

Get-AzVMExtension -ResourceGroupName LAB-RG -VMName wfhlabvm01 | Select Name, ProvisioningState
