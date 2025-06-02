#Requires -RunAsAdministrator
# Disables unnecessary services found in All_Services_List_disabled.txt

$services = @(
    "AdvancedSystemCareService18"
    "CCleanerPerformanceOptimizerService"
    "CyberGhost8Service"
    "bdvpnservice"
    "bdredline_agent"
    "ProductAgentService"
    "BluetoothUserService_64bf9"
    "bthserv"
    "WFDSConMgrSvc"
    "upnphost"
    "SSDPSRV"
    "NetPipeActivator"
    "NetTcpActivator"
    "RasAuto"
    "diagsvc"
    "DPS"
    "SDRSVC"
    "WdiServiceHost"
    "WdiSystemHost"
    "wercplsupport"
    "Sense"
    "svsvc"
    "com.docker.service"
    "VBoxSDS"
    "VSInstallerElevationService"
    "VSStandardCollectorService150"
    "OneSyncSvc_64bf9"
    "UnistoreSvc_64bf9"
    "UserDataSvc_64bf9"
    "CDPSvc"
    "CDPUserSvc_64bf9"
    "BITS"
    "AppReadiness"
    "AppIDSvc"
    "MessagingService_64bf9"
    "NlaSvc"
    "GoogleChromeElevationService"
    "GoogleUpdaterInternalService135.0.7023.5"
    "GoogleUpdaterInternalService137.0.7115.0"
    "GoogleUpdaterInternalService138.0.7156.2"
    "GoogleUpdaterInternalService138.0.7194.0"
    "GoogleUpdaterService135.0.7023.5"
    "GoogleUpdaterService137.0.7115.0"
    "GoogleUpdaterService138.0.7156.2"
    "GoogleUpdaterService138.0.7194.0"
)

$logFile = ".\disabled_services_log.txt"

foreach ($service in $services) {
    try {
        $svc = Get-Service -Name $service -ErrorAction Stop
        if ($svc.Status -ne 'Stopped') {
            Stop-Service -Name $service -Force -ErrorAction Stop
            Write-Output "Stopped $service" | Out-File -FilePath $logFile -Append
        }
        Set-Service -Name $service -StartupType Disabled -ErrorAction Stop
        Write-Output "Disabled $service" | Out-File -FilePath $logFile -Append
    } catch {
        Write-Output "Service $service not found or could not be modified." | Out-File -FilePath $logFile -Append
    }
}
Write-Output "Script complete. Check $logFile for details."
