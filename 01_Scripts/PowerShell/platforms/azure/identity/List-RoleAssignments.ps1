# ============================================
# List-RoleAssignments.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Lists all role assignments for the current subscription and LAB-RG.
# ============================================

# List all role assignments in subscription
Write-Host "=== Subscription-Level Role Assignments ==="
Get-AzRoleAssignment | Select DisplayName, RoleDefinitionName, Scope

# Filter for LAB-RG specifically
Write-Host "`n=== LAB-RG Role Assignments ==="
Get-AzRoleAssignment -ResourceGroupName "LAB-RG" |
  Select DisplayName, RoleDefinitionName, Scope
