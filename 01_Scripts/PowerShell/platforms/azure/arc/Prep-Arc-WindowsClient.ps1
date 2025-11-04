# ============================================
# Prep-Arc-WindowsClient.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Preps wfh-lab-cl01 for Azure Arc onboarding:
#   - Verifies IP/DNS/gateway and time sync
#   - Ensures TLS 1.2 and PowerShell 5+
#   - Opens minimal inbound ICMP (useful for tests)
#   - Tests reachability to key Arc endpoints
#   - (Optional) Downloads the Connected Machine Agent MSI
# ============================================

# ----- Config (edit if lab addressing changes) -----
$ExpectedIP     = '10.20.0.20'
$ExpectedGW     = '10.20.0.1'
$ExpectedDNS    = '10.20.0.10'
$LogRoot        = 'D:\Azure-Toolkit\06_Logs\arc'

$DownloadAgent  = $true
$AgentMsiUrl    = 'https://gbl.his.arc.azure.com/azcmagent/latest/AzureConnectedMachineAgent.msi'
$AgentMsiPath   = 'C:\Windows\AzureConnectedMachineAgent\temp\AzureConnectedMachineAgent.msi'

# (for your connect step later)
$TenantId       = 'e737db3d-0a46-4b15-84b6-212694e0f81d'
$SubscriptionId = '064aadfd-ffbe-475a-a4d1-09b5b6589dd2'
$ResourceGroup  = 'LAB-RG'
$Region         = 'eastus2'
# ---------------------------------------------------

Write-Host "== Azure Arc Prep (wfh-lab-cl01) ==" -ForegroundColor Cyan

# Create log folder + transcript
New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null
$Log = Join-Path $LogRoot ("prep-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".log")
Start-Transcript -Path $Log -Append | Out-Null

# Helpers
function Show-Result { param($Name, [bool]$Ok)
    if ($Ok) { Write-Host ("{0,-32} : OK"   -f $Name) -ForegroundColor Green }
    else     { Write-Host ("{0,-32} : FAIL" -f $Name) -ForegroundColor Red   }
}

# 0) Requirements
if ($PSVersionTable.PSVersion.Major -lt 5) {
    throw "PowerShell 5+ required. Current: $($PSVersionTable.PSVersion)"
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 1) Network sanity
$nic = Get-NetAdapter | Where-Object Status -eq Up | Select-Object -First 1
$ip4 = Get-NetIPAddress -InterfaceAlias $nic.Name -AddressFamily IPv4 | Where-Object IPAddress -NotLike '169.*'

Write-Host "Interface: $($nic.Name)  IPv4: $($ip4.IPAddress)  GW: $($ip4.DefaultGateway)" -ForegroundColor Yellow

Show-Result "IPv4 address ($ExpectedIP)" ($ip4.IPAddress -eq $ExpectedIP)
Show-Result "Default gateway ($ExpectedGW)" ($ip4.DefaultGateway -eq $ExpectedGW)

$dnsNow = (Get-DnsClientServerAddress -InterfaceAlias $nic.Name -AddressFamily IPv4).ServerAddresses
Show-Result "DNS server ($ExpectedDNS)" ($dnsNow -contains $ExpectedDNS)

# 2) Time sync (auth can fail if skewed)
w32tm /resync | Out-Null
Start-Sleep 1
w32tm /query /status | Out-Null
Show-Result "Time service queried" $true

# 3) Minimal firewall for testing ICMP
New-NetFirewallRule -DisplayName "ICMPv4 Echo In (CL01)" -Protocol ICMPv4 -Direction Inbound -Action Allow -ErrorAction SilentlyContinue | Out-Null
Show-Result "ICMPv4 inbound rule" $true

# 4) Connectivity tests
$ok = $true

# ping gateway
$gwOk = Test-Connection -ComputerName $ExpectedGW -Count 2 -Quiet
Show-Result "Ping gateway ($ExpectedGW)" $gwOk
$ok = $ok -and $gwOk

# DNS TCP/53 to DC
$dnsTcp = Test-NetConnection -ComputerName $ExpectedDNS -Port 53 -WarningAction SilentlyContinue
$dnsOk  = ($dnsTcp.TcpTestSucceeded -eq $true)
Show-Result "DNS TCP/53 to $ExpectedDNS" $dnsOk
$ok = $ok -and $dnsOk

# Public DNS 1.1.1.1 TCP/53 (through NAT)
$pubDns = Test-NetConnection -ComputerName 1.1.1.1 -Port 53 -WarningAction SilentlyContinue
$pubOk  = ($pubDns.TcpTestSucceeded -eq $true)
Show-Result "Public DNS 1.1.1.1 TCP/53" $pubOk
$ok = $ok -and $pubOk

# Arc endpoints HTTPS
$login = Test-NetConnection -ComputerName login.microsoftonline.com -Port 443 -WarningAction SilentlyContinue
$his   = Test-NetConnection -ComputerName gbl.his.arc.azure.com     -Port 443 -WarningAction SilentlyContinue
$loginOk = ($login.TcpTestSucceeded -eq $true)
$hisOk   = ($his.TcpTestSucceeded   -eq $true)
Show-Result "login.microsoftonline.com 443" $loginOk
Show-Result "gbl.his.arc.azure.com 443"     $hisOk
$ok = $ok -and $loginOk -and $hisOk

# 5) Optional download of agent (no install yet)
if ($DownloadAgent) {
    $agentDir = Split-Path $AgentMsiPath -Parent
    New-Item -Path $agentDir -ItemType Directory -Force | Out-Null
    try {
        Invoke-WebRequest -Uri $AgentMsiUrl -OutFile $AgentMsiPath -UseBasicParsing
        Show-Result "Download Arc agent MSI" $true
    } catch {
        Show-Result "Download Arc agent MSI" $false
        Write-Warning $_.Exception.Message
    }
}

# 6) Print the exact connect command you’ll run after MSI install
$connect = @"
NEXT STEP (run elevated after installing the MSI):

`"$env:ProgramW6432\AzureConnectedMachineAgent\azcmagent.exe`" connect `
  --resource-group $ResourceGroup `
  --tenant-id $TenantId `
  --subscription-id $SubscriptionId `
  --location $Region
"@
Write-Host $connect -ForegroundColor Yellow

if (-not $ok) {
    Write-Warning "One or more connectivity checks failed. Fix those before running azcmagent connect."
} else {
    Write-Host "All checks passed. Ready to install agent + connect to Arc." -ForegroundColor Green
}

Stop-Transcript | Out-Null
