# ============================================
# Connect-VMToLogAnalytics.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Installs the correct Azure Monitor agent for the VM OS
#              and links it to the Log Analytics workspace.
# ============================================

$ResourceGroup = "LAB-RG"
$VmName        = "wfhlabvm01"
$WorkspaceName = "wfh-lab-law"

$vm        = Get-AzVM -ResourceGroupName $ResourceGroup -Name $VmName -Status
$osType    = $vm.StorageProfile.OsDisk.OsType  # Windows or Linux
$workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroup -Name $WorkspaceName

if ($osType -eq "Linux") {
    $extName = "AzureMonitorLinuxAgent"
    $type    = "AzureMonitorLinuxAgent"
} else {
    $extName = "AzureMonitorWindowsAgent"
    $type    = "AzureMonitorWindowsAgent"
}

# Remove opposite agent if present
$opposite = if ($extName -eq "AzureMonitorLinuxAgent") { "AzureMonitorWindowsAgent" } else { "AzureMonitorLinuxAgent" }
Get-AzVMExtension -ResourceGroupName $ResourceGroup -VMName $VmName -Name $opposite -ErrorAction SilentlyContinue |
  ForEach-Object { Remove-AzVMExtension -ResourceGroupName $ResourceGroup -VMName $VmName -Name $opposite -Force }

# Install the correct agent
Set-AzVMExtension -ResourceGroupName $ResourceGroup -VMName $VmName `
  -Name $extName -Publisher "Microsoft.Azure.Monitor" `
  -Type $type -TypeHandlerVersion "1.0" `
  -SettingString ("{`"workspaceId`":`"$($workspace.CustomerId)`"}")
