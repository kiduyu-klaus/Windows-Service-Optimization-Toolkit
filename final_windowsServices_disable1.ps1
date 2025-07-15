#Requires -RunAsAdministrator
# Disables unnecessary services for performance optimization

# Services to DISABLE completely (Safe to Disable + Rarely Needed)
$servicesToDisable = @(
    "Fax"
    "RemoteRegistry"
    "bthserv"           # Bluetooth Support Service (no Bluetooth devices)
    "WMPNetworkSvc"     # Windows Media Player Network Sharing Service
    "MapsBroker"        # Downloaded Maps Manager (if not using offline maps)
    "DiagTrack"         # Connected User Experiences and Telemetry
    "dmwappushservice"  # WAP Push message Routing
    "XblAuthManager"
    "XblGameSave"
    "XboxGipSvc"
    "XboxNetApiSvc"
    "RemoteAccess"      # Routing and Remote Access (home users)
    "PeerDistSvc"       # BranchCache (enterprise feature)
    "icssvc"            # Windows Mobile Hotspot Service
    "WSearch"           # Windows Search (disable if on SSD)
)


# Services to set to MANUAL (start only when needed)
$servicesToManual = @(
    "Spooler"           # Print Spooler (if you rarely print)
    "wuauserv"          # Windows Update (if you update manually)
    "seclogon"          # Secondary Logon
    "CscService"        # Offline Files
    "Smart Card"
    "SCPolicySvc"       # Smart Card Removal Policy
    "TabletInputService"# Touch Keyboard/Handwriting Panel (non-tablet)
    "WbioSrvc"          # Windows Biometric Service (no biometrics)
    "fdPHost"           # Function Discovery Provider Host
    "FDResPub"          # Function Discovery Resource Publication
    "WlanSvc"           # WLAN AutoConfig (if only using ethernet)
)


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
