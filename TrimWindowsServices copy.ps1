#Requires -RunAsAdministrator
# Disables unnecessary services found in All_Services_List.txt

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
    "FontCache"
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
        if ($svc.Status -ne 'Stopped') {
            Stop-Service -Name $service -Force -ErrorAction Stop
            Write-Output "Stopped $service" | Out-File -FilePath ".\log.txt" -Append
        }
        Set-Service -Name $service -StartupType Disabled -ErrorAction Stop
        Write-Output "Disabled $service" | Out-File -FilePath ".\log.txt" -Append
    } catch {
        Write-Output "Service $service not found or could not be disabled." | Out-File -FilePath ".\log.txt" -Append
    }
}
