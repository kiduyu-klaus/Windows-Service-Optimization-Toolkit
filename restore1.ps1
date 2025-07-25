#Requires -RunAsAdministrator
# Reverses service disabling by restoring services to their default startup types

# Set your folder path
$logDir = "C:\cracks\Tricks\Windows-Service-Optimization-Toolkit-master\Logs"
$logPath = "$logDir\service_restore_log.txt"

# Ensure the Logs folder exists
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force
}

# Services with their typical Windows default startup types
$servicesToRestore = @{
    "AJRouter" = "Manual"
    "ALG" = "Manual"
    "autotimesvc" = "Manual"
    "BDESVC" = "Manual"
    "BluetoothUserService_81850b" = "Manual"
    "BthAvctpSvc" = "Manual"
    "CaptureService_81850b" = "Manual"
    "cbdhsvc_81850b" = "Manual"
    "diagnosticshub.standardcollector.service" = "Manual"
    "DiagTrack" = "Automatic"
    "dmwappushservice" = "Manual"
    "DoSvc" = "Manual"
    "edgeupdate" = "Manual"
    "edgeupdatem" = "Manual"
    "EntAppSvc" = "Manual"
    "fhsvc" = "Manual"
    "FontCache" = "Automatic"
    "gupdate" = "Automatic"
    "gupdatem" = "Manual"
    "iphlpsvc" = "Automatic"
    "lfsvc" = "Manual"
    "LicenseManager" = "Manual"
    "lmhosts" = "Manual"
    "MapsBroker" = "Automatic"
    "MessagingService_81850b" = "Manual"
    "MicrosoftEdgeElevationService" = "Manual"
    "MSDTC" = "Manual"
    "NetTcpPortSharing" = "Disabled"
    "PcaSvc" = "Manual"
    "PhoneSvc" = "Manual"
    "QWAVE" = "Manual"
    "RasMan" = "Manual"
    "RetailDemo" = "Manual"
    "RmSvc" = "Manual"
    "ScDeviceEnum" = "Manual"
    "SCardSvr" = "Manual"
    "SCPolicySvc" = "Manual"
    "seclogon" = "Manual"
    "SharedAccess" = "Manual"
    "Spooler" = "Automatic"
    "stisvc" = "Manual"
    "SysMain" = "Automatic"
    "tapisrv" = "Manual"
    "TrkWks" = "Automatic"
    "WbioSrvc" = "Manual"
    "WerSvc" = "Manual"
    "wisvc" = "Manual"
    "WMPNetworkSvc" = "Manual"
    "WPDBusEnum" = "Manual"
    "WpcMonSvc" = "Manual"
    "WSearch" = "Automatic"
    "XblAuthManager" = "Manual"
    "XblGameSave" = "Manual"
    "XboxGipSvc" = "Manual"
    "XboxNetApiSvc" = "Manual"
}

Write-Host "🔄 Starting service restoration process..." -ForegroundColor Yellow
$time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output "$time - Starting service restoration process" | Out-File -FilePath $logPath

$successCount = 0
$errorCount = 0

foreach ($service in $servicesToRestore.GetEnumerator()) {
    try {
        $svc = Get-Service -Name $service.Key -ErrorAction Stop
        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $currentStartupType = (Get-CimInstance -ClassName Win32_Service -Filter "Name='$($service.Key)'").StartMode

        if ($service.Value -eq "Disabled") {
            # Use sc.exe because Set-Service does not support Disabled in all versions
            sc.exe config $($service.Key) start= disabled | Out-Null
            Write-Output "$time - Set $($service.Key) startup type from $currentStartupType to Disabled" | Out-File -FilePath $logPath -Append
        }
        else {
            Set-Service -Name $service.Key -StartupType $service.Value -ErrorAction Stop
            Write-Output "$time - Set $($service.Key) startup type from $currentStartupType to $($service.Value)" | Out-File -FilePath $logPath -Append
        }

        if ($service.Value -eq "Automatic" -and $svc.Status -eq "Stopped") {
            try {
                Start-Service -Name $service.Key -ErrorAction Stop
                Write-Output "$time - Started $($service.Key)" | Out-File -FilePath $logPath -Append
                Write-Host "✅ Restored and started: $($service.Key)" -ForegroundColor Green
            }
            catch {
                Write-Output "$time - Failed to start $($service.Key): $($_.Exception.Message)" | Out-File -FilePath $logPath -Append
                Write-Host "⚠️  Restored but failed to start: $($service.Key)" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "✅ Restored: $($service.Key) to $($service.Value)" -ForegroundColor Green
        }

        $successCount++
    }
    catch {
        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $errorMsg = "Service $($service.Key) not found or could not be restored: $($_.Exception.Message)"
        Write-Output "$time - $errorMsg" | Out-File -FilePath $logPath -Append
        Write-Host "❌ $errorMsg" -ForegroundColor Red
        $errorCount++
    }
}

$time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output "$time - Service restoration complete. Success: $successCount, Errors: $errorCount" | Out-File -FilePath $logPath -Append

Write-Host "`n📊 Restoration Summary:" -ForegroundColor Yellow
Write-Host "✅ Successfully restored: $successCount services" -ForegroundColor Green
Write-Host "❌ Errors encountered: $errorCount services" -ForegroundColor Red
Write-Host "📄 Detailed log saved to: $logPath" -ForegroundColor Cyan

Write-Host "`n⚠️  IMPORTANT NOTES:" -ForegroundColor Yellow
Write-Host "• Some services may require a system restart to function properly"
Write-Host "• Services set to 'Automatic' have been started if they were stopped"
Write-Host "• Check the log file for detailed information about each service"
Write-Host "• Consider restarting your computer to ensure all changes take effect"

Write-Output "✅ Service restoration complete. See $logPath for details."
