# Day 3 – Azure Groundwork

## Objective
Establish the foundational Azure environment for hybrid integration.

## Tasks Completed
- Created resource group `LAB-RG` (Region: East US 2)
- Deployed baseline components:
  - `wfh-lab-vnet` (primary virtual network)
  - `wfh-lab-law` (Log Analytics Workspace)
  - `wfh-lab-auto` (Automation Account)
  - `wfh-lab-ag` and `wfh-lab-alerts` (Action Groups)
- Verified resource linkages and baseline permissions
- Documented naming conventions (prefix: `wfh-lab-`)

## Notes
- Subscription: Azure subscription 1
- Tenant ID: e737db3d-0a46-4b15-84b6-212694e0f81d
- Everything built to align with later hybrid Arc deployment
