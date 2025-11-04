# Day 4 – VM Infrastructure Setup

## Objective
Create and configure Hyper-V networking and the first domain controller.

## Tasks Completed
- Created the following switches:
  - `wfh-lab-extswitch` (External – mapped to Wi-Fi adapter)
  - `wfh-lab-intswitch` (Internal – lab network)
- Installed Windows Server 2022 on `wfh-lab-dc01`
- Assigned static IP `10.20.0.10/24`, gateway `10.20.0.1`, DNS self-referencing
- Configured NAT on host using PowerShell for Internet passthrough
- Verified DNS and Internet access from DC01

## Notes
- DC01 functioning as main DNS for the lab
- Saved checkpoint: `Day4-PostDCSetup`
