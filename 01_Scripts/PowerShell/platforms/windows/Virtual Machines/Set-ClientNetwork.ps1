# ============================================
# Set-ClientNetwork.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Sets static IP, gateway, and DNS for wfh-lab-cl01 prior to domain join.
# ============================================

$If = (Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1).Name
New-NetIPAddress -InterfaceAlias $If -IPAddress 10.20.0.20 -PrefixLength 24 -DefaultGateway 10.20.0.1 -ErrorAction SilentlyContinue | Out-Null
Set-DnsClientServerAddress -InterfaceAlias $If -ServerAddresses 10.20.0.10

# Verify connectivity
ping 10.20.0.10
nslookup wfh.lab 10.20.0.10
