# ============================================
# Link-Law-Auto.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Links Log Analytics workspace 'wfh-lab-law'
#              to Automation Account 'wfh-lab-auto'.
# ============================================

param(
  [string]$ResourceGroup = "LAB-RG",
  [string]$WorkspaceName = "wfh-lab-law",
  [string]$AutomationName = "wfh-lab-auto"
)

# Gather resources
$ws   = Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroup -Name $WorkspaceName -ErrorAction Stop
$auto = Get-AzAutomationAccount           -ResourceGroupName $ResourceGroup -Name $AutomationName -ErrorAction Stop

$linkedName = "Automation"
$linkedRid  = "$($ws.ResourceId)/linkedServices/$linkedName"
$body       = @{ resourceId = $auto.Id }

# RUN
New-AzResource -ResourceId $linkedRid -ApiVersion "2020-08-01" -Properties $body -Force | Out-Null
Write-Host "Linked '$WorkspaceName' to Automation Account '$AutomationName'."

# VERIFY
$check = Get-AzResource -ResourceId $linkedRid -ErrorAction Stop
$ok    = $check.Properties.resourceId -eq $auto.Id
Write-Host ("Verification: {0}" -f ($(if($ok){"SUCCESS"}else{"MISMATCH"})))
if (-not $ok) {
    Write-Host "Found: $($check.Properties.resourceId)"
    Write-Host "Expected: $($auto.Id)"
}
