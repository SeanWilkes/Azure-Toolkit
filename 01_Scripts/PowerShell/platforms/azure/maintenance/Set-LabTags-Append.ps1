# ============================================
# Set-LabTags-Append.ps1 (LAB-RG scope)
# ============================================
$rgName = "LAB-RG"
$scope  = (Get-AzResourceGroup -Name $rgName).ResourceId
$append = Get-AzPolicyDefinition -Builtin | Where-Object DisplayName -eq "Append tag and its value to resources"

$tags = @{
  Environment = "Lab"
  Owner       = "Sean"
  Project     = "Azure-Toolkit"
  CostCenter  = "Training"
  CreatedBy   = "Policy"
}

foreach ($k in $tags.Keys) {
  $name = "WFH-Append-$k"
  New-AzPolicyAssignment -Name $name -DisplayName $name `
    -Scope $scope -PolicyDefinition $append `
    -PolicyParameterObject @{ tagName = $k; tagValue = $tags[$k] } `
    -ErrorAction SilentlyContinue | Out-Null
}
