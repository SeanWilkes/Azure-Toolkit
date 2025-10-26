# ============================================
# Get-LabCostReport.ps1  (Lab Version)
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Retrieves recent cost data for LAB-RG using Consumption API.
# ============================================

param(
    [int]$Days = 7
)

# Lab constants
$SubscriptionName = "Azure subscription 1"
$ResourceGroup    = "LAB-RG"

# 1) Auth and context
Connect-AzAccount -ErrorAction Stop | Out-Null
Set-AzContext -Subscription $SubscriptionName -ErrorAction Stop | Out-Null
$subId = (Get-AzContext).Subscription.Id

# 2) Scope must be the full ARM path for the RG
$scope = "/subscriptions/$subId/resourceGroups/$ResourceGroup"

# 3) Pull usage for the window
$start = (Get-Date).Date.AddDays(-$Days)
$end   = (Get-Date).Date

$usage = Get-AzConsumptionUsageDetail `
    -Scope $scope `
    -StartDate $start `
    -EndDate $end `
    -ErrorAction Stop

# 4) Summaries
"Cost window: {0:d} to {1:d}  Scope: {2}" -f $start, $end, $scope

# By meter category
$usage |
  Group-Object MeterCategory |
  ForEach-Object {
    [pscustomobject]@{
      Category  = $_.Name
      TotalCost = ($_.Group | Measure-Object PretaxCost -Sum).Sum
    }
  } |
  Sort-Object TotalCost -Descending

# Uncomment to export:
# $out = Join-Path "D:\Azure-Toolkit\06_Logs\deployments" "CostReport_$($end.ToString('yyyyMMdd')).csv"
# $usage | Select UsageStart,UsageEnd,InstanceName,MeterCategory,Product,PretaxCost,Currency,ResourceGroupName |
#   Export-Csv -NoTypeInformation $out
# "Saved CSV: $out"
