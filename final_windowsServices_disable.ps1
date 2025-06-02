#Requires -RunAsAdministrator
# Disables unnecessary services for performance optimization

# Services to DISABLE completely (Safe to Disable + Rarely Needed)
$servicesToDisable = @(
    # Non-Essential Third-Party Services
    "AdvancedSystemCareService18",
    "bdredline_agent",
    "bdvpnservice",
    "CCleanerPerformanceOptimizerService",
    "CyberGhost8Service",
    "GoogleChromeElevationService",
    "GoogleUpdater*",  # Wildcard to catch all versions
    "IObitUnSvr",
    "PlexUpdateService",
    "VBoxSDS",
    "WindscribeService",

    # Windows Services Rarely Needed
    "bthserv",  # Bluetooth Support Service
    "CDPSvc",   # Connected Devices Platform
    "CDPUserSvc_64bf9",
    "diagsvc",  # Diagnostic Execution Service
    "Fax",
    "MapsBroker",
    "RemoteRegistry",
    "WSearch",  # Windows Search (disable if on SSD)
    "WaaSMedicSvc",  # Windows Update Medic
    "SDRSVC"    # Windows Backup
)

# Services to set to MANUAL (start only when needed)
$servicesToManual = @(
    "Spooler",      # Print Spooler
    "WerSvc",       # Windows Error Reporting
    "WinDefend",    # Windows Defender (if using third-party AV)
    "wuauserv"      # Windows Update (set to manual if you want manual updates)
)
any service from the list above can be disabled or set to manual based on your system requirements.?
# Initialize log file
$logPath = "$PSScriptRoot\ServiceOptimizationLog.txt"
"=== Service Optimization Log - $(Get-Date) ===" | Out-File -FilePath $logPath

function Process-Service {
    param (
        $service,
        [string]$action,
        [string]$startupType
    )

    $logEntry = "[$action] $($service.Name) ($($service.DisplayName))"

    if ($service.Status -ne 'Stopped' -and $action -eq "DISABLE") {
        Stop-Service -InputObject $service -Force -ErrorAction Stop
        $logEntry += " - Stopped"
    }

    Set-Service -InputObject $service -StartupType $startupType -ErrorAction Stop
    $logEntry += " - Set to $startupType"

    $logEntry | Out-File -FilePath $logPath -Append
}

function Set-ServiceWithLog {
    param (
        [string]$serviceName,
        [string]$action,
        [string]$startupType
    )

    if ($serviceName.Contains("*")) {
        $matched = Get-Service | Where-Object { $_.Name -like $serviceName }
        foreach ($svc in $matched) {
            Process-Service -service $svc -action $action -startupType $startupType
        }
    } else {
        try {
            $svc = Get-Service -Name $serviceName -ErrorAction Stop
            Process-Service -service $svc -action $action -startupType $startupType
        } catch {
            "ERROR: Service '$serviceName' not found or access denied." | Out-File -FilePath $logPath -Append
        }
    }
}

# Disable services
"`n=== Disabling Unnecessary Services ===" | Out-File -FilePath $logPath -Append
foreach ($service in $servicesToDisable) {
    Set-ServiceWithLog -serviceName $service -action "DISABLE" -startupType "Disabled"
}

# Set others to manual
"`n=== Setting Services to Manual Start ===" | Out-File -FilePath $logPath -Append
foreach ($service in $servicesToManual) {
    Set-ServiceWithLog -serviceName $service -action "MANUAL" -startupType "Manual"
}

"`n=== Optimization Complete ===" | Out-File -FilePath $logPath -Append
Write-Host "✅ Service optimization complete. See log at $logPath"
