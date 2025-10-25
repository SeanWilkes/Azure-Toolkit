# ============================================
# Azure Toolkit Naming Conventions
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Standard naming structure for resources created under
#              the Wilkes Holdings tenant and Azure Toolkit lab environment.
# Last Updated: 2025-10-24
# ============================================

## Purpose
Consistent naming ensures clarity, discoverability, and automation compatibility 
across development, testing, and production environments.  
All Azure resources created by team members should follow this convention to 
support governance, billing, and lifecycle management.

---

## Global Format
[tenant/brand prefix][project/purpose]-[date or region]
Example: wfhdevvm-eastus01
Breakdown: wfm(William Frankford Hamilton)dev(development)vm(virtual machine)-eastus01(data region)

---

## Naming Rules
- Use **lowercase letters and numbers only** (Azure enforces this for several services).  
- Avoid spaces, underscores, or special characters.  
- Keep total length under **24 characters** when possible.  
- Use concise resource identifiers (`vm`, `rg`, `vnet`, `storage`, `pip`, etc.).  
- Include a short date stamp or region code when global uniqueness is required.

---

## Tenant and Project Prefixes
| Prefix | Meaning |
|---------|----------|
| **wh** | wfh (tenant) |
| **amp** | Apex Managed Projects |
| **nex** | NextEdge Solutions |
| **sol** | Solentra Cloud Services |

---

## Common Resource Patterns
| Resource Type | Example Name | Notes |
|----------------|---------------|-------|
| Resource Group | `wfhlabrg10242025` | Ends with `rg` |
| Virtual Network | `wfhlabvnet10242025` | Ends with `vnet` |
| Virtual Machine | `wfhlabvm10242025` | Ends with `vm` |
| Storage Account | `wfhlabstorage10242025` | Ends with `storage` |
| Public IP | `whlabpip10242025` | Ends with `pip` |
| Network Security Group | `whlabnsg10242025` | Ends with `nsg` |

---

## Tag Alignment
All resources created under these conventions should include the standard tag set:
Environment = Lab
Owner = Sean Wilkes
Project = Azure-Toolkit
CostCenter = Training
CreatedBy = PowerShell


---

## Example Resource Set
| Resource | Example Name | Region |
|-----------|---------------|--------|
| Resource Group | `wfhlabrg10242025` | East US |
| Storage Account | `wfhlabstorage10242025` | East US |
| Virtual Network | `wfhlabvnet10242025` | East US |
| VM | `wfhlabvm10242025` | East US |
| NSG | `wfhlabnsg10242025` | East US |

---

## Notes
- Update this document whenever new resource types or environments are introduced.  
- Keep prefixes consistent across teams and subscriptions.  
- Use tags in conjunction with naming for maximum searchability and automation control.

