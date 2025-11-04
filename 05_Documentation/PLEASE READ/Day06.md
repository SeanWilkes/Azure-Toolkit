# Day 6 – Hybrid Integration via Azure Arc

## Objective
Connect on-prem VMs to Azure through Arc and confirm hybrid monitoring capability.

## Tasks Completed
- Deployed Windows 11 client `wfh-lab-cl01` (joined internal switch)
- Configured static IP `10.20.0.20/24`, gateway `10.20.0.1`, DNS `10.20.0.10`
- Resolved DNS and connectivity issues, restoring Internet access
- Created and ran Azure Arc onboarding script
- Installed and connected Azure Connected Machine Agent
- Verified connection through PowerShell and Azure Portal
- Prepared for policy assignments and Log Analytics integration

## Notes
- Saved checkpoint: `Day6-PostArcConnection`
- Next step (Day 7): Enable monitoring and automation via Log Analytics and Policy
