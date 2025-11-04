# ============================================
# Connect-VMToLogAnalytics.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Installs and connects the Azure Connected Machine Agent
#              (Arc agent) to the LAB-RG in EastUS2 and links it with
#              the Log Analytics workspace (wfh-lab-law).
# ============================================

$AgentUrl = "https://aka.ms/AzureConnectedMachineAgent"
$Installer = "$env:TEMP\AzureConnectedMachineAgent.msi"

Invoke-WebRequest -Uri $AgentUrl -OutFile $Installer
Start-Process msiexec.exe -ArgumentList "/i `"$Installer`" /qn" -Wait

# Replace these placeholders with your real IDs
$TenantId = "e737db3d-0a46-4b15-84b6-212694e0f81d"
$SubscriptionId = "064aadfd-ffbe-475a-a4d1-09b5b6589dd2"
$ResourceGroup = "LAB-RG"
$Region = "eastus2"

Start-Process powershell -ArgumentList "-NoExit", "azcmagent connect --resource-group $ResourceGroup --tenant-id $TenantId --subscription-id $SubscriptionId --location $Region" 


