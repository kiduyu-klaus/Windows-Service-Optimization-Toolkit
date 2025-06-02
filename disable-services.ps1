#Requires -RunAsAdministrator
# Disables unnecessary services found in All_Services_List_disabled.txt

$services = @(
    
    "AdvancedSystemCareService18"  # Service from IObit for system optimization

    "CCleanerPerformanceOptimizerService"  # Service from CCleaner for performance enhancement

    "CyberGhost8Service"  # VPN service from CyberGhost

    "bdvpnservice"  # Bitdefender VPN service

    "bdredline_agent"  # Bitdefender service for threat detection

    "ProductAgentService"  # Service associated with product updates and management for installed software

    "BluetoothUserService_64bf9"  # Bluetooth user service for managing Bluetooth devices

    "bthserv"  # Bluetooth Support Service

    "WFDSConMgrSvc"  # Windows Firewall Device Control Manager service

    "upnphost"  # Universal Plug and Play (UPnP) Host service

    "SSDPSRV"  # Simple Service Discovery Protocol service for network discovery of devices

    "NetPipeActivator"  # Net Pipe activation service, related to .NET remoting

    "NetTcpActivator"  # TCP activation service used for .NET applications

    "RasAuto"  # Remote Access Auto Connection Manager

    "diagsvc"  # Diagnostic Execution service for Windows diagnostics

    "DPS"  # Device Parameter Service

    "SDRSVC"  # Windows Backup service for system recovery and restoration

    "WdiServiceHost"  # Windows Diagnostic Infrastructure service host

    "WdiSystemHost"  # System host for Windows Diagnostic Infrastructure

    "wercplsupport"  # Windows Error Reporting Control Panel Support service

    "Sense"  # Windows sensing service for adaptive background functions

    "svsvc"  # An unknown service that might relate to various applications or features

    "com.docker.service"  # Docker service for container management

    "VBoxSDS"  # VirtualBox shared folder service

    "VSInstallerElevationService"  # Visual Studio Installer service for elevation management during installations

    "VSStandardCollectorService150"  # Visual Studio standard data collection service

    "OneSyncSvc_64bf9"  # Microsoft OneSync synchronization service for account data

    "UnistoreSvc_64bf9"  # User Store service for managing user data

    "UserDataSvc_64bf9"  # User Data Access service for applications

    "CDPSvc"  # Connected Devices Platform service for device connectivity

    "CDPUserSvc_64bf9"  # User service for Connected Devices Platform

    "BITS"  # Background Intelligent Transfer Service, used for background downloading

    "AppReadiness"  # Service for application readiness during startup or installation

    "AppIDSvc"  # Application Identity service for app verification in enterprise settings

    "MessagingService_64bf9"  # Messaging service for handling user messaging applications

    "NlaSvc"  # Network Location Awareness service for network configuration and management

    "GoogleChromeElevationService"  # Service for elevating privileges for Google Chrome processes

    "GoogleUpdaterInternalService135.0.7023.5"  # Internal Google Updater service for version 135.0.7023.5

    "GoogleUpdaterInternalService137.0.7115.0"  # Internal Google Updater service for version 137.0.7115.0

    "GoogleUpdaterInternalService138.0.7156.2"  # Internal Google Updater service for version 138.0.7156.2

    "GoogleUpdaterInternalService138.0.7194.0"  # Internal Google Updater service for version 138.0.7194.0

    "GoogleUpdaterService135.0.7023.5"  # Google Updater service for version 135.0.7023.5

    "GoogleUpdaterService137.0.7115.0"  # Google Updater service for version 137.0.7115.0

    "GoogleUpdaterService138.0.7156.2"  # Google Updater service for version 138.0.7156.2

    "GoogleUpdaterService138.0.7194.0"  # Google Updater service for version 138.0.7194.0
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
