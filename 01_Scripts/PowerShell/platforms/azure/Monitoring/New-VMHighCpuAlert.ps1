a# ============================================
# New-VMHighCpuAlert.ps1 (Lab Version)
# Author: Sean Wilkes  |  GitHub: SeanWilkes
# Description: Creates an Action Group and a VM CPU > 80% alert for 5 minutes.
# ============================================

$ResourceGroup = "LAB-RG"
$VmName        = "wfhlabvm01"
$AgName        = "wfh-lab-ag"
$AgShort       = "wfhAG"
$EmailTo       = "seanwilkes87@gmail.com"
$AlertName     = "wfh-cpu-high"

# Ensure VM exists and get its ARM id
$vm    = Get-AzVM -ResourceGroupName $ResourceGroup -Name $VmName -ErrorAction Stop
$scope = $vm.Id

# Create or update Action Group (idempotent)
$ag = Get-AzActionGroup -ResourceGroupName $ResourceGroup -Name $AgName -ErrorAction SilentlyContinue
if (-not $ag) {
    $ag = New-AzActionGroup -ResourceGroupName $ResourceGroup -Name $AgName -ShortName $AgShort `
        -EmailReceiver @(@{ Name = "SeanEmail"; EmailAddress = $EmailTo })
} else {
    # Ensure email receiver present
    $hasEmail = $ag.EmailReceivers | Where-Object { $_.EmailAddress -eq $EmailTo }
    if (-not $hasEmail) {
        $ag = Set-AzActionGroup -ResourceGroupName $ResourceGroup -Name $AgName `
            -EmailReceiver @(@{ Name = "SeanEmail"; EmailAddress = $EmailTo })
    }
}

# Create metric alert (VM host metric: Percentage CPU)
$crit = New-AzMetricAlertRuleV2Criteria -MetricName "Percentage CPU" `
    -TimeAggregation Average -Operator GreaterThan -Threshold 80

# If it exists, replace it for clean runs
$existing = Get-AzMetricAlertRuleV2 -ResourceGroupName $ResourceGroup -Name $AlertName -ErrorAction SilentlyContinue
if ($existing) { Remove-AzMetricAlertRuleV2 -ResourceGroupName $ResourceGroup -Name $AlertName -Force }

New-AzMetricAlertRuleV2 -Name $AlertName -ResourceGroupName $ResourceGroup `
  -TargetResourceId $scope `
  -WindowSize (New-TimeSpan -Minutes 5) `
  -Frequency (New-TimeSpan -Minutes 1) `
  -Condition $crit -Severity 3 `
  -ActionGroupId $ag.Id `
  -Description "CPU > 80% (avg) for 5 min on $VmName" `
  -AutoMitigate:$false | Out-Null

Write-Host "Action Group: $($ag.Name)"
Write-Host "Alert created: $AlertName targeting $VmName"
