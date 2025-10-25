# ============================================
# Manage-LabVM.md
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Reference guide for managing Azure lab virtual machines 
#              using PowerShell commands.
# Last Updated: 2025-10-25
# ============================================

## Purpose
This guide outlines how to stop, start, and verify the state of a lab VM in Azure 
to reduce compute costs during non-use hours.

---

## Commands Overview

### Check VM Status
```powershell
Get-AzVM -ResourceGroupName LAB-RG -Name wfhlabvm01 -Status |
  Select-Object -ExpandProperty Statuses |
  Where-Object { $_.Code -match "PowerState" }
Stop VM
Deallocates the VM, preventing compute charges.

powershell
Copy code
Stop-AzVM -ResourceGroupName LAB-RG -Name wfhlabvm01 -Force
Start VM
Restarts the VM and makes it available again.

powershell
Copy code
Start-AzVM -ResourceGroupName LAB-RG -Name wfhlabvm01
Combined Script Execution
powershell
Copy code
cd D:\Azure-Toolkit\01_Scripts\PowerShell\platforms\azure\compute
.\Manage-LabVM.ps1
Task Scheduler Automation
To automate daily start/stop:

Stop Script: use Manage-LabVM.ps1 with a -Preview dry run first.

Task Scheduler:

Program/script: powershell.exe

Add arguments:

arduino
Copy code
-File "D:\Azure-Toolkit\01_Scripts\PowerShell\platforms\azure\compute\Manage-LabVM.ps1"
Tags Alignment
All lab VMs should include these tags for governance and tracking:

ini
Copy code
Environment = Lab
Owner = Sean
Project = Azure-Toolkit
CostCenter = Training
CreatedBy = PowerShell