#Requires -RunAsAdministrator
# Disables unnecessary services found in All_Services_List.txt

# Set your folder path
$logDir = "C:\Users\klaus_k\Documents\GitHub\Windows-Service-Optimization-Toolkit\Logs"
$logPath = "$logDir\service_disable_log.txt"

# Make sure the Logs folder exists
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force
}
$services = @(
    "AJRouter"
    "ALG"
    "autotimesvc"
    "BDESVC"
    "BluetoothUserService_81850b"
    "BthAvctpSvc"
    "CaptureService_81850b"
    "cbdhsvc_81850b"
    "diagnosticshub.standardcollector.service"
    "DiagTrack"
    "dmwappushservice"
    "DoSvc"
    "edgeupdate"
    "edgeupdatem"
    "EntAppSvc"
    "fhsvc"
    "BraveElevationService"
    "BluetoothUserService_627c6"
    "brave"
    "bravem"
    "BTAGService"
    "GoogleChromeElevationService"
    "GoogleUpdaterInternalService138.0.7194.0"
    "GoogleUpdaterInternalService140.0.7272.0"
    "GoogleUpdaterService138.0.7194.0"
    "GoogleUpdaterService140.0.7272.0"
    "MicrosoftEdgeElevationService"
    "SQLWriter"
    "PrintWorkflowUserSvc_627c6"
    "gupdate"
    "gupdatem"
    "iphlpsvc"
    "lfsvc"
    "LicenseManager"
    "lmhosts"
    "MapsBroker"
    "MessagingService_81850b"
    "MicrosoftEdgeElevationService"
    "MSDTC"
    "NetTcpPortSharing"
    "PcaSvc"
    "PhoneSvc"
    "QWAVE"
    "RasMan"
    "RetailDemo"
    "RmSvc"
    "ScDeviceEnum"
    "SCardSvr"
    "SCPolicySvc"
    "seclogon"
    "SharedAccess"
    "Spooler"
    "stisvc"
    "SysMain"
    "tapisrv"
    "TrkWks"
    "WbioSrvc"
    "WerSvc"
    "wisvc"
    "WMPNetworkSvc"
    "WPDBusEnum"
    "WpcMonSvc"
    "WSearch"
    "XblAuthManager"
    "XblGameSave"
    "XboxGipSvc"
    "XboxNetApiSvc"
)


foreach ($service in $services) {
    try {
        $svc = Get-Service -Name $service -ErrorAction Stop
        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        if ($svc.Status -ne 'Stopped') {
            Stop-Service -Name $service -Force -ErrorAction Stop
            Write-Output "$time - Stopped $service" | Out-File -FilePath $logPath -Append
        }
        Set-Service -Name $service -StartupType Disabled -ErrorAction Stop
        Write-Output "$time - Disabled $service" | Out-File -FilePath $logPath -Append
    } catch {
        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Output "$time - Service $service not found or could not be disabled." | Out-File -FilePath $logPath -Append
    }
}

Write-Output "✅ Service disabling complete. See $logPath for details."