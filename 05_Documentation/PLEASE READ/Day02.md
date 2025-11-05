# Day 2 – Governance and Automation

## Objective
Implement tagging, automation, and cost visibility controls to establish governance and operational consistency across all lab resources.

## Tasks Completed
- Created **Automation Account**: `wfh-lab-auto`
- Created **Log Analytics Workspace**: `wfh-lab-law`
- Applied built-in Azure Policy: *Append a tag and its value to resources*
- Configured tag policy automation via PowerShell (`Set-LabTags-Append.ps1`)
- Deployed and validated tag propagation across all existing resources
- Attempted cost reporting via **Az.Consumption** and **Cost Management APIs**
- Linked automation scripts for `Start_Stop-VM.ps1` and `Verify-Container-And-Blobs.ps1`
- Pushed updated scripts to GitHub repo under:  
  `D:\Azure-Toolkit\01_Scripts\PowerShell\platforms\azure\`

## Notes
- Tags applied globally:
  - `Environment: Lab`
  - `Owner: Sean`
  - `Project: Azure-Toolkit`
  - `CostCenter: Training`
  - `CreatedBy: Policy`
- Automation Runbooks validated manually (Run Now)
- Cost report PowerShell module deprecated — no impact to workflow
- Saved checkpoint: `Day2-GovernanceStable`
