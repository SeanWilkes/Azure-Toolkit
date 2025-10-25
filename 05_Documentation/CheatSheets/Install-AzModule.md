# ============================================
# Installing and Configuring the Az PowerShell Module
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Setup guide for enabling Azure PowerShell commands (Az module)
#              in a local lab environment for Azure Toolkit.
# Last Updated: 2025-10-25
# ============================================

## Purpose
The Az PowerShell module provides the cmdlets required to interact with Azure 
services directly from PowerShell — including `Connect-AzAccount`, `New-AzResourceGroup`,
and other automation commands used in this toolkit.

---

## Steps to Install

### 1. Use TLS 1.2
Ensures secure communication with PowerShell Gallery.

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
2. Enable Script Execution for Current User
Allows local scripts to run safely.

powershell
Copy code
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
3. Verify the NuGet Provider is Available
This provider is required for downloading packages from the PowerShell Gallery.

powershell
Copy code
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
4. Install the Az Module
Installs all Azure PowerShell components for the current user.

powershell
Copy code
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
5. Import the Accounts Module
Ensures that account management cmdlets are loaded in the current session.

powershell
Copy code
Import-Module Az.Accounts
6. Verify Installation
Lists installed Az modules and their versions.

powershell
Copy code
Get-Module Az* -ListAvailable | Select Name, Version
7. Sign In to Azure
Connects your PowerShell session to Azure.

powershell
Copy code
Connect-AzAccount
A browser window will open — sign in using your Azure account credentials.

Troubleshooting
If Connect-AzAccount Still Fails
powershell
Copy code
Import-Module Az.Accounts -Force
Connect-AzAccount
If You Have Legacy AzureRM Installed
powershell
Copy code
Get-Module -ListAvailable AzureRM
Uninstall-AzureRm
Optional (Verify Context After Login)
powershell
Copy code
Get-AzContext