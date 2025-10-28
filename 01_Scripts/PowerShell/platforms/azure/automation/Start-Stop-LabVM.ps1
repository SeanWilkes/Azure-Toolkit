# ============================================
# Start-Stop-LabVM (Runbook)
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Starts or stops the lab VM (wfhlabvm01) within LAB-RG.
# ============================================

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Start", "Stop")]
    [string]$Action
)

# Lab variables
$ResourceGroup = "LAB-RG"
$VmName        = "wfhlabvm01"
$Location      = "EastUS2"

try {
    if ($Action -eq "Start") {
        Write-Output "Attempting to start VM '$VmName' in resource group '$ResourceGroup'..."
        Start-AzVM -ResourceGroupName $ResourceGroup -Name $VmName -ErrorAction Stop
        Write-Output "VM '$VmName' started successfully."
    }
    elseif ($Action -eq "Stop") {
        Write-Output "Attempting to stop VM '$VmName' in resource group '$ResourceGroup'..."
        Stop-AzVM -ResourceGroupName $ResourceGroup -Name $VmName -Force -ErrorAction Stop
        Write-Output "VM '$VmName' stopped successfully."
    }
}
catch {
    Write-Output "Operation failed for VM '$VmName'."
    Write-Output "Error details: $($_.Exception.Message)"
}
