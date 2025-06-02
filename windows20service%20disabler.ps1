#Requires -RunAsAdministrator

# Purpose: Disables non-essential services to improve system performance

# WARNING: Always create a restore point before running this script!

### --- CONFIGURATION --- ###

$servicesToDisable = @(

    # Windows Services Safe to Disable
    "OneSyncSvc_64bf9",           # Microsoft account sync
    "TabletInputService",         # Touch keyboard (if no tablet/touchscreen)
    "W3SVC",                      # IIS Web Publishing (if not running a server)
    "WAS",                        # Web App Activation (dependent on W3SVC)
    "WdiServiceHost",             # Diagnostics
    "WdiSystemHost",              # Diagnostics
    "TimeBrokerSvc",             # UWP app task scheduler
    "WpnUserService_64bf9"        # Push notifications (UWP)
)

$servicesToManual = @(
    "CyberGhost8Service",         # VPN – start only when needed
    "Spooler",                    # Print Spooler – manual is safer
    "WerSvc",                     # Windows Error Reporting – rarely needed
    "DPS",                        # Diagnostic Policy Service – only when troubleshooting
    "SecurityHealthService",      # Windows Security GUI – manual OK if using 3rd-party AV
    "VaultSvc",                   # Credential Manager – manual if not using mapped drives
    "WinHttpAutoProxySvc",        # Proxy auto-detection – manual for home users
    "WAS"                         # Leave as manual unless W3SVC is needed
)


### --- EXECUTION --- ###

$logPath = ".\log_final.txt"

function Log-Message {
    param([string]$message)
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
    Write-Host $message
}

# Initialize log
Log-Message "=== SERVICE OPTIMIZATION STARTED ==="
Log-Message "System: $($env:COMPUTERNAME)"
Log-Message "OS: $((Get-CimInstance Win32_OperatingSystem).Caption)"

# Safety check
if (-not (Test-Path "$env:SystemDrive\Windows")) {
    Log-Message "ERROR: This script must run on a Windows system!"
    exit 1
}

# User confirmation
$confirmation = Read-Host "This will modify system services. Create a restore point first! Continue? (Y/N)"
if ($confirmation -ne 'Y') {
    Log-Message "Aborted by user."
    exit
}

# Process services
function Optimize-Services {
    param(
        [string[]]$services,
        [string]$action,
        [string]$startupType
    )
    foreach ($serviceName in $services) {
        try {
            # Handle wildcards
            if ($serviceName -like "*`**") {
                $pattern = $serviceName.TrimEnd('*')
                $matchedServices = Get-Service | Where-Object { $_.Name -like "$pattern*" }
                if (-not $matchedServices) {
                    Log-Message "[SKIPPED] No services match pattern: $serviceName"
                    continue
                }
            }
            else {
                $matchedServices = @(Get-Service -Name $serviceName -ErrorAction SilentlyContinue)
                if (-not $matchedServices) {
                    Log-Message "[SKIPPED] Service not found: $serviceName"
                    continue
                }
            }

            foreach ($service in $matchedServices) {
                # Skip protected services
                if ($service.Name -in @("CryptSvc", "DcomLaunch", "Dhcp", "Dnscache", "LanmanServer", "LSM")) {
                    Log-Message "[PROTECTED] Skipping critical service: $($service.Name)"
                    continue
                }
                # Stop if running
                if ($service.Status -ne 'Stopped') {
                    Stop-Service -Name $service.Name -Force -ErrorAction Stop
                    Log-Message "[STOPPED] $($service.Name) ($($service.DisplayName))"
                }
                # Change startup type
                Set-Service -Name $service.Name -StartupType $startupType -ErrorAction Stop
                Log-Message "[$action] $($service.Name) → $startupType"
            }
        } catch {
            Log-Message "[ERROR] Failed to process ${serviceName}: $($_.Exception.Message)"

        }
    }
}

# Execute optimizations
Log-Message "`n=== DISABLING NON-ESSENTIAL SERVICES ==="
Optimize-Services -services $servicesToDisable -action "DISABLE" -startupType "Disabled"
Log-Message "`n=== SETTING SERVICES TO MANUAL START ==="
Optimize-Services -services $servicesToManual -action "MANUAL" -startupType "Manual"

# Completion
Log-Message "`n=== OPTIMIZATION COMPLETE ==="
Log-Message "Log saved to: $logPath"
Write-Host "`nReview the log file before rebooting: $logPath" -ForegroundColor Cyan