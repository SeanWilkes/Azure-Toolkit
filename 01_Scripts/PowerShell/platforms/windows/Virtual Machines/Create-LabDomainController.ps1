# ============================================
# Create-LabDomainController.ps1 (Performance Tuned)
# ============================================

$VmName   = "wfh-lab-dc01"
$VmPath   = "D:\HyperV\$VmName"
$VhdPath  = "$VmPath\$VmName.vhdx"
$IsoPath  = "D:\WS-Toolkit\Windows Server 2022.iso"
$Switch   = "wfh-lab-intswitch"

# Create folder + VHD
New-Item -ItemType Directory -Force -Path $VmPath | Out-Null
New-VHD -Path $VhdPath -SizeBytes 80GB -Dynamic | Out-Null

# Create VM (Gen 2)
New-VM -Name $VmName `
       -MemoryStartupBytes 8GB `
       -Generation 2 `
       -VHDPath $VhdPath `
       -SwitchName $Switch | Out-Null

# Assign CPU and dynamic memory
Set-VMProcessor -VMName $VmName -Count 4
Set-VMMemory -VMName $VmName -DynamicMemoryEnabled $true -MinimumBytes 4GB -StartupBytes 8GB -MaximumBytes 16GB

# Mount ISO and set boot
Add-VMDvdDrive -VMName $VmName -Path $IsoPath
$dvd = Get-VMFirmware -VMName $VmName | Select-Object -ExpandProperty BootOrder | Where-Object {$_.Device -like "*DVD*"}
Set-VMFirmware -VMName $VmName -FirstBootDevice $dvd

# Start install
Start-VM -Name $VmName
