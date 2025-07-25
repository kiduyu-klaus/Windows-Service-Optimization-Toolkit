#Requires -RunAsAdministrator
# Reverses service optimization by restoring services to their default states

# Services that were DISABLED - restore to their typical default startup types
$servicesToRestore = @{
    "Fax" = "Manual"
    "RemoteRegistry" = "Disabled"        # This one typically stays disabled for security
    "bthserv" = "Manual"                 # Bluetooth Support Service
    "WMPNetworkSvc" = "Manual"           # Windows Media Player Network Sharing Service
    "MapsBroker" = "Automatic"           # Downloaded Maps Manager
    "DiagTrack" = "Automatic"            # Connected User Experiences and Telemetry
    "dmwappushservice" = "Manual"        # WAP Push message Routing
    "XblAuthManager" = "Manual"          # Xbox Live Auth Manager
    "XblGameSave" = "Manual"             # Xbox Live Game Save
    "XboxGipSvc" = "Manual"              # Xbox Accessory Management Service
    "XboxNetApiSvc" = "Manual"           # Xbox Live Networking Service
    "RemoteAccess" = "Disabled"          # Routing and Remote Access (typically disabled)
    "PeerDistSvc" = "Manual"             # BranchCache
    "icssvc" = "Manual"                  # Windows Mobile Hotspot Service
    "WSearch" = "Automatic"              # Windows Search (restore to automatic)
}

# Services that were set to MANUAL - restore to their typical default startup types
$servicesToRestoreFromManual = @{
    "Spooler" = "Automatic"              # Print Spooler
    "wuauserv" = "Manual"                # Windows Update (typically manual)
    "seclogon" = "Manual"                # Secondary Logon
    "CscService" = "Manual"              # Offline Files
    "SCardSvr" = "Manual"                # Smart Card
    "SCPolicySvc" = "Manual"             # Smart Card Removal Policy
    "TabletInputService" = "Manual"      # Touch Keyboard/Handwriting Panel
    "WbioSrvc" = "Manual"                # Windows Biometric Service
    "fdPHost" = "Manual"                 # Function Discovery Provider Host
    "FDResPub" = "Manual"                # Function Discovery Resource Publication
    "WlanSvc" = "Automatic"              # WLAN AutoConfig (restore to automatic)
}

# Initialize log file
$logPath = "$PSScriptRoot\ServiceRestorationLog.txt"
"=== Service Restoration Log - $(Get-Date) ===" | Out-File -FilePath $logPath

function Restore-Service {
    param (
        $service,
        [string]$targetStartupType
    )

    $logEntry = "[RESTORE] $($service.Name) ($($service.DisplayName))"

    try {
        # Set the startup type
        Set-Service -InputObject $service -StartupType $targetStartupType -ErrorAction Stop
        $logEntry += " - Set to $targetStartupType"

        # Start the service if it should be automatic and is currently stopped
        if ($targetStartupType -eq "Automatic" -and $service.Status -eq "Stopped") {
            Start-Service -InputObject $service -ErrorAction Stop
            $logEntry += " - Started"
        }

        $logEntry | Out-File -FilePath $logPath -Append
        Write-Host "✅ Restored: $($service.Name) to $targetStartupType"
    }
    catch {
        $errorMsg = "ERROR: Failed to restore '$($service.Name)' - $($_.Exception.Message)"
        $errorMsg | Out-File -FilePath $logPath -Append
        Write-Host "❌ $errorMsg" -ForegroundColor Red
    }
}

function Restore-ServiceWithLog {
    param (
        [string]$serviceName,
        [string]$targetStartupType
    )

    if ($serviceName.Contains("*")) {
        $matched = Get-Service | Where-Object { $_.Name -like $serviceName }
        foreach ($svc in $matched) {
            Restore-Service -service $svc -targetStartupType $targetStartupType
        }
    } else {
        try {
            $svc = Get-Service -Name $serviceName -ErrorAction Stop
            Restore-Service -service $svc -targetStartupType $targetStartupType
        } catch {
            $errorMsg = "ERROR: Service '$serviceName' not found or access denied."
            $errorMsg | Out-File -FilePath $logPath -Append
            Write-Host "❌ $errorMsg" -ForegroundColor Red
        }
    }
}

Write-Host "🔄 Starting service restoration process..." -ForegroundColor Yellow

# Restore services that were disabled
"`n=== Restoring Previously Disabled Services ===" | Out-File -FilePath $logPath -Append
Write-Host "`n📋 Restoring previously disabled services..."
foreach ($service in $servicesToRestore.GetEnumerator()) {
    Restore-ServiceWithLog -serviceName $service.Key -targetStartupType $service.Value
}

# Restore services that were set to manual
"`n=== Restoring Services from Manual to Default ===" | Out-File -FilePath $logPath -Append
Write-Host "`n📋 Restoring services from manual to default startup types..."
foreach ($service in $servicesToRestoreFromManual.GetEnumerator()) {
    Restore-ServiceWithLog -serviceName $service.Key -targetStartupType $service.Value
}

"`n=== Restoration Complete ===" | Out-File -FilePath $logPath -Append
Write-Host "`n✅ Service restoration complete!" -ForegroundColor Green
Write-Host "📄 See detailed log at: $logPath" -ForegroundColor Cyan

# Optional: Display summary
Write-Host "`n📊 Summary:" -ForegroundColor Yellow
Write-Host "- Restored $($servicesToRestore.Count) previously disabled services"
Write-Host "- Restored $($servicesToRestoreFromManual.Count) services from manual to default"
Write-Host "- Check the log file for any errors or detailed information"

