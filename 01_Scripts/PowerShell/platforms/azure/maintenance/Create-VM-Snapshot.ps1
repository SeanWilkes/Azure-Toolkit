# ============================================
# Create-VM-Snapshot.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Creates a snapshot of the lab VM’s OS disk
#              for backup or rollback before major changes.
# ============================================

param(
    [string]$ResourceGroup = "LAB-RG",
    [string]$VmName = "wfhlabvm01",
    [switch]$Preview
)

# Get the OS disk
$vm = Get-AzVM -ResourceGroupName $ResourceGroup -Name $VmName
$osDiskName = $vm.StorageProfile.OsDisk.Name
$osDisk = Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $osDiskName

# Define snapshot name and config
$snapshotName = "$($VmName)-snapshot-$(Get-Date -Format yyyyMMddHHmm)"
$snapshotConfig = New-AzSnapshotConfig -SourceUri $osDisk.Id `
    -Location $vm.Location -CreateOption Copy

# Preview or create snapshot
if ($Preview) {
    Write-Host "[Preview] Would create snapshot '$snapshotName' in '$($vm.Location)'."
} else {
    New-AzSnapshot -Snapshot $snapshotConfig -SnapshotName $snapshotName -ResourceGroupName $ResourceGroup
    Write-Host "Snapshot '$snapshotName' created successfully."
}
