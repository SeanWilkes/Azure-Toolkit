### \# 01\_Scripts – Structure



##### Scripts are organized by \*\*language\*\* → \*\*platform\*\* → \*\*function\*\*.



###### \- \*\*Platforms\*\* = where the script runs or targets:

&nbsp; - `windows/` – host admin tasks (services, registry, scheduler)

&nbsp; - `azure/` – Az PowerShell / Azure CLI tasks (RGs, VNets, VMs)

&nbsp; - `linux/` – Bash automation on Linux hosts

&nbsp; - `github/` – Git/GitHub maintenance, CI helpers

&nbsp; - `crossplatform/` – Python that runs anywhere



###### \- \*\*Functions\*\* = what the script does:

&nbsp; - `compute/`, `identity/`, `networking/`, `resource-groups/`, `maintenance/`, etc.



This keeps intent clear:

> “PowerShell script for \*\*Azure\*\* \*\*networking\*\*” → `01\_Scripts/PowerShell/platforms/azure/networking/...`



