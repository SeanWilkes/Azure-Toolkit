# ============================================
# Join-ClientToDomain.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Joins wfh-lab-cl01 to the wfh.lab domain using domain admin credentials.
# ============================================

$Domain = 'wfh.lab'
$Credential = Get-Credential "$($Domain.Split('.')[0])\Administrator"

Add-Computer -DomainName $Domain -Credential $Credential -Force
Restart-Computer
