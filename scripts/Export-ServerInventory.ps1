<#
.SYNOPSIS
    Discovers local host CPU, RAM, and Disk to recommend Azure VM sizing.
#>
param(
    [string]$OutputFile = "server_inventory.csv"
)

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$proc = Get-CimInstance Win32_Processor | Measure-Object -Property NumberOfCores -Sum
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

$ramGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
$totalDiskGB = [math]::Round(($disks | Measure-Object -Property Size -Sum).Sum / 1GB, 2)

$recommendedSku = if ($ramGB -le 8) { "Standard_D2s_v5" } elseif ($ramGB -le 16) { "Standard_D4s_v5" } else { "Standard_D8s_v5" }

[PSCustomObject]@{
    ServerName       = $env:COMPUTERNAME
    OS               = $os.Caption
    CPUCores         = $proc.Sum
    RAM_GB           = $ramGB
    Disk_GB          = $totalDiskGB
    RecommendedAzure = $recommendedSku
} | Export-Csv -Path $OutputFile -NoTypeInformation

Write-Host "Inventory exported to $OutputFile" -ForegroundColor Green
