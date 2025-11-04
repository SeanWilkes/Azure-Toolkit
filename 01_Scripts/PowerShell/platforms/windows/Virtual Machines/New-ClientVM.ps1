# ============================================
# New-ClientVM.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Creates Hyper-V Windows client VM wfh-lab-cl01 and mounts the OS ISO.
# ============================================

$VmName  = 'wfh-lab-cl01'
$VmPath  = "D:\HyperV\$VmName"
$VhdPath = "$VmPath\$VmName.vhdx"
$IsoPath = 'D:\WS-Toolkit\Windows 11.iso'
$Switch  = 'wfh-lab-intswitch'

New-Item -ItemType Directory -Path $VmPath -Force | Out-Null
New-VHD -Path $VhdPath -SizeBytes 64GB -Dynamic | Out-Null
New-VM -Name $VmName -Generation 2 -MemoryStartupBytes 4GB -VHDPath $VhdPath -Path $VmPath -SwitchName $Switch
Set-VMProcessor -VMName $VmName -Count 2
Set-VMDvdDrive -VMName $VmName -Path $IsoPath
Set-VM -Name $VmName -CheckpointType Standard
Start-VM $VmName
