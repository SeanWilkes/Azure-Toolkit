# ============================================
# Verify-Link-Law-Auto.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Links Log Analytics workspace 'wfh-lab-law'
#              to Automation Account 'wfh-lab-auto'.
# ============================================

# Verify that the Automation Account is linked to the workspace
$ResourceGroup = "LAB-RG"
$WorkspaceName = "wfh-lab-law"

Get-AzResource -ResourceGroupName $ResourceGroup `
  | Where-Object { $_.ResourceId -like "*$WorkspaceName/linkedServices/Automation*" } `
  | Select-Object Name, ResourceType, ResourceId
