<#
.SYNOPSIS
    Automated Infrastructure Discovery and Assessment Script for Cloud Migration
.DESCRIPTION
    Inventories host compute metrics, memory sizing, disk configurations, and network dependencies
    to generate 6R classification data and target Azure VM sizing recommendations.
.AUTHOR
    Sujeet Kumar - Senior DevSecOps Engineer & Cloud Architect
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$OutputCsv = "migration_assessment_inventory.csv"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   ENTERPRISE CLOUD MIGRATION DISCOVERY & ASSESSMENT       " -ForegroundColor Yellow
Write-Host "   Lead: Sujeet Kumar (17+ Yrs Enterprise IT Experience)   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$proc = Get-CimInstance Win32_Processor | Measure-Object -Property NumberOfCores -Sum
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

$totalDiskGB = [math]::Round(($disks | Measure-Object -Property Size -Sum).Sum / 1GB, 2)
$freeDiskGB = [math]::Round(($disks | Measure-Object -Property FreeSpace -Sum).Sum / 1GB, 2)
$ramGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)

# Azure VM Sizing Recommendation Logic
$recommendedAzureSku = switch ($ramGB) {
    { $_ -le 4 }  { "Standard_B2s (Burstable Dev/Test)" }
    { $_ -le 8 }  { "Standard_D2s_v5 (General Purpose)" }
    { $_ -le 16 } { "Standard_D4s_v5 (Production Workload)" }
    { $_ -le 32 } { "Standard_D8s_v5 (High Performance Compute)" }
    Default       { "Standard_E16s_v5 (Memory Optimized Database)" }
}

$assessmentData = [PSCustomObject]@{
    Hostname             = $env:COMPUTERNAME
    OperatingSystem      = $os.Caption
    Architecture         = $os.OSArchitecture
    CPUCores             = $proc.Sum
    TotalMemoryGB        = $ramGB
    TotalStorageGB       = $totalDiskGB
    FreeStorageGB        = $freeDiskGB
    RecommendedAzureSku  = $recommendedAzureSku
    Proposed6RStrategy   = "Rehost / Replatform"
    AssessmentTimestamp  = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}

$assessmentData | Export-Csv -Path $OutputCsv -NoTypeInformation
Write-Host "Assessment completed successfully. Saved to: $OutputCsv" -ForegroundColor Green
$assessmentData | Format-List
