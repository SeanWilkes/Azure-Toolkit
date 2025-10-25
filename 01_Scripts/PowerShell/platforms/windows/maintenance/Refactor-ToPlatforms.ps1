<#
.SYNOPSIS
  Repository-safe version: same behavior using a relative base.
#>

param(
  [string]$BasePath = ".\Azure-Toolkit",
  [switch]$WhatIf
)

function Ensure-Dir { param([string]$Path) if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Path $Path | Out-Null } }

$map = @(
  @{ Src = "01_Scripts\PowerShell\compute";        Dst = "01_Scripts\PowerShell\platforms\windows\compute" },
  @{ Src = "01_Scripts\PowerShell\identity";       Dst = "01_Scripts\PowerShell\platforms\windows\identity" },
  @{ Src = "01_Scripts\PowerShell\networking";     Dst = "01_Scripts\PowerShell\platforms\windows\networking" },
  @{ Src = "01_Scripts\PowerShell\maintenance";    Dst = "01_Scripts\PowerShell\platforms\windows\maintenance" },
  @{ Src = "01_Scripts\PowerShell\resource-groups";Dst = "01_Scripts\PowerShell\platforms\azure\resource-groups" },

  @{ Src = "01_Scripts\Bash\compute";              Dst = "01_Scripts\Bash\platforms\linux\compute" },
  @{ Src = "01_Scripts\Bash\identity";             Dst = "01_Scripts\Bash\platforms\linux\identity" },
  @{ Src = "01_Scripts\Bash\networking";           Dst = "01_Scripts\Bash\platforms\linux\networking" },
  @{ Src = "01_Scripts\Bash\maintenance";          Dst = "01_Scripts\Bash\platforms\linux\maintenance" },
  @{ Src = "01_Scripts\Bash\resource-groups";      Dst = "01_Scripts\Bash\platforms\azure\resource-groups" }
)

foreach ($entry in $map) {
  $src = Join-Path $BasePath $entry.Src
  $dst = Join-Path $BasePath $entry.Dst

  if (-not (Test-Path $src)) { Write-Host "Skip: source not found -> $src"; continue }

  Ensure-Dir -Path $dst

  Get-ChildItem -Path $src -Recurse -File -Force | ForEach-Object {
    $rel = $_.FullName.Substring($src.Length).TrimStart('\')
    $target = Join-Path $dst $rel
    Ensure-Dir -Path (Split-Path $target -Parent)

    if ($WhatIf) { Write-Host "[WhatIf] Move $($_.FullName) -> $target" }
    else { Move-Item -Path $_.FullName -Destination $target -Force }
  }

  if (-not $WhatIf) {
    Get-ChildItem -Path $src -Recurse -Directory -Force |
      Sort-Object FullName -Descending |
      ForEach-Object { if (-not (Get-ChildItem -Path $_.FullName -Force)) { Remove-Item -Path $_.FullName -Force } }

    if (-not (Get-ChildItem -Path $src -Force)) { Remove-Item -Path $src -Force; Write-Host "Removed: $src" }
  }
}

Write-Host "Refactor complete."
