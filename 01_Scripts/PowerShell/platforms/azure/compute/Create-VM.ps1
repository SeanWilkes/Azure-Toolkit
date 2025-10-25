# ============================================
# Create-VM.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Creates an Ubuntu VM in an existing lab VNet/subnet.
#              Validates prerequisites and fails fast with clear errors.
# ============================================

param(
    [string]$RgName   = "LAB-RG",
    [string]$Location = "eastus",
    [string]$VmName   = "wfhlabvm01",
    [string]$VnetName = "wfh-lab-vnet",
    [string]$Subnet   = "frontend",
    [string]$Size     = "Standard_B1s",
    [switch]$Preview
)

# 1) Look up network objects
$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $RgName -ErrorAction SilentlyContinue
if (-not $vnet) { throw "VNet '$VnetName' not found in RG '$RgName'. Create it before running this script." }

$subnetObj = $vnet.Subnets | Where-Object { $_.Name -eq $Subnet }
if (-not $subnetObj) { throw "Subnet '$Subnet' not found in VNet '$VnetName'." }

$nsg = Get-AzNetworkSecurityGroup -Name "wfh-lab-nsg-fe" -ResourceGroupName $RgName -ErrorAction SilentlyContinue
if (-not $nsg) { Write-Warning "NSG 'wfh-lab-nsg-fe' not found. VM will be created without explicit NSG on NIC." }

# 2) Create PIP and NIC
$nicName = "$VmName-nic"
$pipName = "$VmName-pip"

if ($Preview) {
    Write-Host "[Preview] Would create Public IP '$pipName' and NIC '$nicName' in subnet '$Subnet'."
} else {
    $pip = Get-AzPublicIpAddress -Name $pipName -ResourceGroupName $RgName -ErrorAction SilentlyContinue
    if (-not $pip) {
        $pip = New-AzPublicIpAddress -Name $pipName -ResourceGroupName $RgName -Location $Location `
              -AllocationMethod Dynamic -Sku Basic
    }

    $nic = Get-AzNetworkInterface -Name $nicName -ResourceGroupName $RgName -ErrorAction SilentlyContinue
    if (-not $nic) {
        $nicParams = @{
            Name                    = $nicName
            ResourceGroupName       = $RgName
            Location                = $Location
            SubnetId                = $subnetObj.Id
            PublicIpAddressId       = $pip.Id
        }
        if ($nsg) { $nicParams.NetworkSecurityGroupId = $nsg.Id }

        $nic = New-AzNetworkInterface @nicParams
    }
}

# 3) VM configuration
# Prompt for VM-local admin (not your Microsoft account)
$cred = Get-Credential -Message "Enter a username and password for the VM (local SSH user)"

$vmConfig =
    New-AzVMConfig -VMName $VmName -VMSize $Size |
    Set-AzVMOperatingSystem -Linux -ComputerName $VmName -Credential $cred |
    Set-AzVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Sku 20_04-lts -Version latest

if (-not $Preview) {
    $vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
}

$tags = @{
    Environment = "Lab"
    Owner       = "Sean"
    Project     = "Azure-Toolkit"
    CostCenter  = "Training"
    CreatedBy   = "PowerShell"
}

# 4) Deploy
if ($Preview) {
    Write-Host "[Preview] Would deploy VM '$VmName' in '$RgName' using NIC '$nicName'."
} else {
    New-AzVM -ResourceGroupName $RgName -Location $Location -VM $vmConfig -Tag $tags
    Write-Host "VM '$VmName' created. Check RG '$RgName' for VM/NIC/PIP/disk resources."
}
