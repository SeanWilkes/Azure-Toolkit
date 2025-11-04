# Day 5 – Network and NAT Refinement

## Objective
Stabilize host network, confirm connectivity, and prepare for client VM deployment.

## Tasks Completed
- Validated `wfh-lab-nat` (10.20.0.0/24) functionality
- Ensured proper IP routing from DC01 → Host → Internet
- Tested `ping`, `nslookup`, and outbound access from DC01
- Verified internal and external switch bindings
- Cleaned adapter naming and ensured persistence through reboots

## Notes
- Host acts as NAT gateway (10.20.0.1)
- DC01 properly serving DNS resolution
- Saved checkpoint: `Day5-NetworkStable`
