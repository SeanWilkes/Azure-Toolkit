# ============================================
# Create-Network.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Creates a lab VNet with two subnets and NSGs.
# ============================================

param(
    [string]$RgName = "LAB-RG",
    [string]$Location = "eastus",
    [string]$VnetName = "wfh-lab-vnet",
    [string]$AddrSpace = "10.10.0.0/16",
    [string]$SubnetFE = "frontend",
    [string]$SubnetFEAddr = "10.10.1.0/24",
    [string]$SubnetBE = "backend",
    [string]$SubnetBEAddr = "10.10.2.0/24",
    [string]$NsgFE = "wfh-lab-nsg-fe",
    [string]$NsgBE = "wfh-lab-nsg-be",
    [switch]$Preview
)

# NSGs
if ($Preview) {
    New-AzNetworkSecurityGroup -Name $NsgFE -ResourceGroupName $RgName -Location $Location -WhatIf
    New-AzNetworkSecurityGroup -Name $NsgBE -ResourceGroupName $RgName -Location $Location -WhatIf
} else {
    $null = New-AzNetworkSecurityGroup -Name $NsgFE -ResourceGroupName $RgName -Location $Location -ErrorAction SilentlyContinue
    $null = New-AzNetworkSecurityGroup -Name $NsgBE -ResourceGroupName $RgName -Location $Location -ErrorAction SilentlyContinue
}

# Allow SSH to frontend (adjust to RDP 3389 if you use Windows VM later)
if (-not $Preview) {
    $nsg = Get-AzNetworkSecurityGroup -Name $NsgFE -ResourceGroupName $RgName
    if (-not ($nsg.SecurityRules | Where-Object Name -eq "Allow-SSH")) {
        $nsg | Add-AzNetworkSecurityRuleConfig -Name "Allow-SSH" -Protocol Tcp -Direction Inbound `
            -Priority 1000 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * `
            -DestinationPortRange 22 -Access Allow | Set-AzNetworkSecurityGroup | Out-Null
    }
} else {
    Write-Host "[WhatIf] Would add Allow-SSH rule to $NsgFE"
}

# VNet + subnets
if ($Preview) {
    New-AzVirtualNetwork -Name $VnetName -ResourceGroupName $RgName -Location $Location -AddressPrefix $AddrSpace -WhatIf
    Write-Host "[WhatIf] Would add subnets $SubnetFE ($SubnetFEAddr) and $SubnetBE ($SubnetBEAddr) with NSG associations."
} else {
    $vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $RgName -ErrorAction SilentlyContinue
    if (-not $vnet) {
        $vnet = New-AzVirtualNetwork -Name $VnetName -ResourceGroupName $RgName -Location $Location -AddressPrefix $AddrSpace
    }
    $nsgFEobj = Get-AzNetworkSecurityGroup -Name $NsgFE -ResourceGroupName $RgName
    $nsgBEobj = Get-AzNetworkSecurityGroup -Name $NsgBE -ResourceGroupName $RgName

    if (-not ($vnet.Subnets | Where-Object Name -eq $SubnetFE)) {
        $vnet = Add-AzVirtualNetworkSubnetConfig -Name $SubnetFE -AddressPrefix $SubnetFEAddr -VirtualNetwork $vnet -NetworkSecurityGroup $nsgFEobj
    }
    if (-not ($vnet.Subnets | Where-Object Name -eq $SubnetBE)) {
        $vnet = Add-AzVirtualNetworkSubnetConfig -Name $SubnetBE -AddressPrefix $SubnetBEAddr -VirtualNetwork $vnet -NetworkSecurityGroup $nsgBEobj
    }
    $vnet | Set-AzVirtualNetwork | Out-Null
    Write-Host "VNet '$VnetName' ready with subnets '$SubnetFE' and '$SubnetBE'."
}
