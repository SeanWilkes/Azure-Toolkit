# ============================================
# Verify-RBAC.ps1
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Verifies Azure AD group membership and role assignments.
# ============================================

# Confirm group membership
Get-AzADGroupMember -GroupDisplayName "Lab Admins" |
  Select DisplayName, UserPrincipalName

# Confirm role assignments in LAB-RG
Get-AzRoleAssignment -ResourceGroupName "LAB-RG" |
  Select DisplayName, RoleDefinitionName, Scope
