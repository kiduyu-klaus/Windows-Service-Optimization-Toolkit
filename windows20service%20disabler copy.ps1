#Requires -RunAsAdministrator
# "test service" and "core svc test" means potentially needed to work 
# WIP SCRIPT!

$services = @(
    "diagnosticshub.standardcollector.service"     # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                    # Diagnostics Tracking Service
    "dmwappushservice"                             # WAP Push Message Routing Service (see known issues)
    "lfsvc"                                        # Geolocation Service
    "MapsBroker"                                   # Downloaded Maps Manager
    "NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
    "RemoteAccess"                                 # Routing and Remote Access
    "RemoteRegistry"                               # Remote Registry
    "SharedAccess"                                 # Internet Connection Sharing (ICS)
    "TrkWks"                                       # Distributed Link Tracking Client
    "WbioSrvc"                                     # Windows Biometric Service (required for Fingerprint reader / facial detection)
    #"WlanSvc"                                     # WLAN AutoConfig, can break WIFI
    "WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
    #"wscsvc"                                      # Windows Security Center Service
    "WSearch"                                      # Windows Search
    "XblAuthManager"                               # Xbox Live Auth Manager
    "XblGameSave"                                  # Xbox Live Game Save Service
    "XboxNetApiSvc"                                # Xbox Live Networking Service
    "XboxGipSvc"                                   #Disables Xbox Accessory Management Service
    #"ndu" # test                                  # Windows Network Data Usage Monitor
    "WerSvc"                                       #disables windows error reporting
    "Spooler"                                      #Disables your printer
    "Fax"                                          #Disables fax
    "fhsvc"                                        #Disables fax histroy
    "gupdate"                                      #Disables google update
    "gupdatem"                                     #Disable another google update
    "stisvc"                                       #Disables Windows Image Acquisition (WIA)
    "AJRouter"                                     #Disables (needed for AllJoyn Router Service)
    "MSDTC"                                        # Disables Distributed Transaction Coordinator
    "WpcMonSvc"                                    #Disables Parental Controls
    "PhoneSvc"                                     #Disables Phone Service(Manages the telephony state on the device)
   # "PrintNotify"                                  #Disables Windows printer notifications and extentions
    "PcaSvc"                                       #Disables Program Compatibility Assistant Service
    "WPDBusEnum"                                   #Disables Portable Device Enumerator Service
    "LicenseManager"                               #Disable LicenseManager(Windows store may not work properly)
    "seclogon"                                     #Disables  Secondary Logon(disables other credentials only password will work)
    "SysMain"                                      #Disables sysmain
    "lmhosts"                                      #Disables TCP/IP NetBIOS Helper
    "wisvc"                                        #Disables Windows Insider program(Windows Insider will not work)
    "FontCache"                                    #Disables Windows font cache
    "RetailDemo"                                   #Disables RetailDemo whic is often used when showing your device
    "ALG"                                          #Disables Application Layer Gateway Service(Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
    "SCardSvr"                                     #Disables Windows smart card, most home users don't need it, businesses may need it however
    "SCPolicySvc"                                  #Allows the system to be configured to lock the user desktop upon smart card removal.
    "ScDeviceEnum"                                 #Creates software device nodes for all smart card readers accessible to a given session. If this service is disabled, WinRT APIs will not be able to enumerate smart card readers.
    "MessagingService_34048"                       # Service supporting text messaging and related functionality.
    "wlidsvc"                                      #Enables user sign-in through Microsoft account identity services.  If you loged in using a microsft account, while setting up Windows your pc will likely break
    "EntAppSvc"                                    #Disables enterprise application management. Home users likely don't need this.
    "BthAvctpSvc"                                  #Disables AVCTP service (if you use  Bluetooth Audio Device or Wireless Headphones. then don't disable this)
    #"FrameServer"                                 #Zoom won't work,Disables Windows Camera Frame Server(this allows multiple clients to access video frames from camera devices.)
    "Browser"                                      #Disables computer browser
    "BthAvctpSvc"                                  #AVCTP service (This is Audio Video Control Transport Protocol service.)
    "BDESVC"                                       #Disables bitlocker
    "iphlpsvc"                                     #Disables ipv6 but most websites don't use ipv6 they use ipv4     
    "edgeupdate"                                   #Disables one of edge's update service
    "MicrosoftEdgeElevationService"                #Disables one of edge's  service 
    "edgeupdatem"                                  #Disbales another one of update service (disables edgeupdatem)                          
    "SEMgrSvc"                                     #Disables Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
    #"PNRPsvc"                                     #Disables peer Name Resolution Protocol ( some peer-to-peer and collaborative applications, such as Remote Assistance, may not function, Discord will still work)
    #"p2psvc"                                      #Disbales Peer Name Resolution Protocol(nables multi-party communication using Peer-to-Peer Grouping.  If disabled, some applications, such as HomeGroup, may not function. Discord will still work)
    #"p2pimsvc"                                    #Disables Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly.Discord will still work)
    "PerfHost"                                     #Disables  remote users and 64-bit processes to query performance .
    "BcastDVRUserService_48486de"                  #Disables GameDVR and Broadcast   is used for Game Recordings and Live Broadcasts
    "CaptureService_48486de"                       #Disables ptional screen capture functionality for applications that call the Windows.Graphics.Capture API.  
    "cbdhsvc_48486de"                              #Disables   cbdhsvc_48486de (clipboard service it disables)
    "BluetoothUserService_48486de"                 #disbales BluetoothUserService_48486de (The Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session.)
  # "WpnService"    test service                  #Disables WpnService (Push Notifications may not work )
    "DoSvc"                                        #Performs content delivery optimization tasks, mainly for windows updates.
    "RtkBtManServ"                                 #Disables Realtek Bluetooth Device Manager Service
    "QWAVE"                                        #Disables Quality Windows Audio Video Experience (audio and video might sound worse)
    "SNMPTrap"                                     #Receives trap messages generated by local or remote Simple Network Management Protocol (SNMP) agents and forwards the messages to SNMP management programs running on this computer. If this service is stopped, SNMP-based programs on this computer will not receive SNMP trap messages. If this service is disabled, any services that explicitly depend on it will fail to start.
    "SECOMNService"                                #Sound Research SECOMN Service
    #"WpnUserService_34048"  #core svc test        #Required by WpnService, allows for notifications from other apps
    "AMD External Events Utility"                  # Placeholder
    "cbdhsvc_34048"                                # Disables the windows clipboard
    "autotimesvc"                                  # This service sets time based on NITZ messages from a Mobile Network
    #"TimeBrokerSvc"  # not reccomended to disabler# Windows UWP(Microsft store apps) will stop working. Coordinates execution of background work for WinRT application. If this service is stopped or disabled, then background work might not be triggered.
    "TokenBroker"                                  # This service is used by Web Account Manager to provide single-sign-on to apps and services.
    "RmSvc"                                        # Radio Management and Airplane Mode Service
    "RtkAudioUniversalService"                     # Realtek Audio Universal Service
    "SensorDataService"                            # Delivers data from a variety of sensors
    #"OneSyncSvc_34048"                             # May be named differently. This service synchronizes mail, contacts, calendar and various other user data. Mail and other applications dependent on this functionality will not work properly when this service is not running.
    #"OneSyncSvc"
    "EventLog"                                    # This service manages events and event logs. 
    "tzautoupdate"                                 # Automatically sets the system time zone.
    "SynTPEnhService"                              # Synaptics TouchPad Enhancements Service
    #"TermService"  # test service                 # Allows users to connect interactively to a remote computer. Remote Desktop and Remote Desktop Session Host Server depend on this service.  To prevent remote use of this computer, clear the checkboxes on the Remote tab of the System properties control panel item.
    #"SessionEnv"  # test service                  # Remote Desktop Configuration service (RDCS) is responsible for all Remote Desktop Services and Remote Desktop related configuration and session maintenance activities that require SYSTEM context. These include per-session temporary folders, RD themes, and RD certificates.
    "RasMan"                                       # Manages dial-up and virtual private network (VPN) connections from your computer to the Internet or other remote networks. If this service is disabled, any services that explicitly depend on it will fail to start."
    "BcastDVRUserService_34048"                    # This user service is used for Game Recordings and Live Broadcasts
    "PenService_34048"                             # Digital pen service. All digital pens will fail to work
    #  "NPSMSvc_34048"  test service               # Provides support for the Now Playing feature.
    #   "DPS"                                      # The Diagnostic Policy Service enables problem detection, troubleshooting and resolution for Windows components. If this service is stopped, diagnostics will no longer function.
    "tapisrv"                                      # Provides Telephony API (TAPI) support for programs that control telephony devices on the local computer and, through the LAN, on servers that are also running the service.
    # HP services
    "HPAppHelperCap"                                #Disable HPAppHelperCap(used by hp software; safe to remove)
    "HPDiagsCap"                                    #Disable HPDiagsCap(used by hp software; safe to remove)
    "HPNetworkCap"                                  #Disable HPNetworkCap(used by hp software; safe to remove)
    "HPSysInfoCap"                                  #Disable HPSysInfoCap(used by hp software; safe to remove)
    "HpTouchpointAnalyticsService"                  #Disable HpTouchpointAnalyticsService(used by hp software; safe to remove)
   
    #hyper-v services
     "HvHost"                                       #Manages and supports Hyper-V virtualization services
    "vmickvpexchange"                               #Facilitates communication between the host and virtual machines
    "vmicguestinterface"                            #Provides network communication for guest virtual machines
    "vmicshutdown"                                  #Allows for proper shutdown coordination between host and virtual machines
    "vmicheartbeat"                                 #Monitors the heartbeat status of virtual machines for health monitoring
    "vmicvmsession"                                 #Manages sessions between the host and virtual machines
    "vmicrdv"                                       #Handles Remote Desktop Virtualization
    "vmictimesync"                                  #Ensures time synchronization between the host and virtual machines.
    # Dell services can somone with a dell latop conform these are the names?
    "SupportAssistAgent"                            #Automated support and system health monitoring for Dell Computer
    "DellUpService"                                 #Manages Dell driver and software updates for Dell Computer
    "DataVault"                                     #Provides data protection and management features for Dell computer
    "DellCustomerConnect"                           #Offers promotions and deals for Dell computer
    "Dell.Foundation.Agent"                         #Supports other Dell software functionalities for Dell computer
    "nosGetPlusHelper"                              #Handles software delivery and installation process for Dell computer
    
    #Lenovo can someone with a dell conform these are the names?
    "LSCNotify"                                     #Collects data for for Lenovo computer
    "LnvAgent"                                      #Provides system updates and support For Lenovo computers
    "Lenovo.Modern.ImController.PluginHost.CompanionApp" # Part of Lenovo Vantage for system management.
    "Lenovo.Modern.ImController.PluginHost.Device"  # Handles device-related functions in Lenovo Vantage.
    "Lenovo.Modern.ImController"                    #Manages system settings and updates.
    "LenovoUtility"                                 #Offers various utility functions for Lenovo devices.
    # Services which cannot be disabled

#    "Themes"                                   # This disables all Personalization setting  
#    "AppXSvc"                                  # https://answers.microsoft.com/en-us/windows/forum/all/whats-the-point-that-when-you-disable-the-state/50dea8b0-50a0-4404-83e2-b70277520973
#    "RpcSs"                                    #The RPCSS service is the Service Control Manager for COM and DCOM servers. It performs object activations requests, object exporter resolutions and distributed garbage collection for COM and DCOM servers. If this service is stopped or disabled, programs using COM or DCOM will not function properly. It is strongly recommended that you have the RPCSS service running.
#    "RpcEptMapper"                             #The RPCSS service is the Service Control Manager for COM and DCOM servers. It performs object activations requests, object exporter resolutions and distributed garbage collection for COM and DCOM servers. If this service is stopped or disabled, programs using COM or DCOM will not function properly. It is strongly recommended that you have the RPCSS service running.                                #The Diagnostic Policy Service enables problem detection, troubleshooting and resolution for Windows components.  If this service is stopped, diagnostics will no longer function.
#   "WdiServiceHost"                            #The Diagnostic Service Host is used by the Diagnostic Policy Service to host diagnostics that need to run in a Local Service context.  If this service is stopped, any diagnostics that depend on it will no longer function.
#   "WdiSystemHost"                             #The Diagnostic System Host is used by the Diagnostic Policy Service to host diagnostics that need to run in a Local System context.  If this service is stopped, any diagnostics that depend on it will no longer function.
#   "BFE"                                       #Disables Base Filtering Engine (BFE) (is a service that manages firewall and Internet Protocol security)
#   "BrokerInfrastructure"                      #Disables Windows infrastructure service that controls which background tasks can run on the system.
#   "SENS"                                      # Monitors system events and notifies subscribers to COM+ Event System of these events.
#   "AppIDSvc"                                  # Determines and verifies the identity of an application. Disabling this service will prevent AppLocker from being enforced.
#   "camsvc"                                    # Provides facilities for managing UWP apps access to app capabilities as well as checking an app's access to specific app capabilities.
#   "WdNisSvc"                                  # Helps guard against intrusion attempts targeting known and newly discovered vulnerabilities in network protocols.
#   "StorSvc"                                   #Disables StorSvc (usb external hard drive will not be reconised by windows)
    #"StateRepository"                              #Provides required infrastructure support for the application model. Apps on the Microsoft store will not work https://answers.microsoft.com/en-us/windows/forum/all/whats-the-point-that-when-you-disable-the-state/50dea8b0-50a0-4404-83e2-b70277520973
    #"CertPropSvc"   # needed service              # Copies user certificates and root certificates from smart cards into the current user's certificate store, detects when a smart card is inserted into a smart card reader, and, if needed, installs the smart card Plug and Play minidriver.



# TextInputManagementService seems to be needed to login
# CloudBackupRestoreSvc_34048 is not needed to be disabled

    Out-File -FilePath  ".\log.txt" -Append
)
# These services break core functionality
#$deepservices =@ (
#    "LanmanServer"                            #The LanmanServer service allows your computer to share files and printers with other devices on your network.
#    "Dhcp"                                    #Registers and updates IP addresses and DNS records for this computer. If this service is stopped, this computer will not receive dynamic IP addresses and DNS updates. If this service is disabled, any services that explicitly depend on it will fail to start.
#    "Dnscache"  not reccomended to disable    #The DNS Client service (dnscache) caches Domain Name System (DNS) names and registers the full computer name for this computer. If the service is stopped, DNS names will continue to be resolved. However, the results of DNS name queries will not be cached and the computer's name will not be registered. If the service is disabled, any services that explicitly depend on it will fail to start.
#    "Power"                                   #Manages power policy and power policy notification delivery.
#     "VaultSvc"                               #Provides secure storage and retrieval of credentials to users, applications and security service packages
#    "TroubleshootingSvc"                      #The Recommended Troubleshooting Service 
#    "diagsvc"                                 #Executes diagnostic actions for troubleshooting support   

#)

# uncomment the above services and the script below in order for it to run
# This disables core services which may break core functionality
#foreach ($service in $services) {
#    Get-Service -Name $service | Stop-Service -Force
#    Get-Service -Name $service | Set-Service -StartupType Disabled
#    Write-Output "Trying to disable $service"
#    Write-Output "Trying to Stop $service"
#    Out-File -FilePath  ".\log.txt"
#}

foreach ($service in $services) {
    Get-Service -Name $service | Stop-Service -Force | Out-File -FilePath  ".\log.txt" -Append
    Get-Service -Name $service | Set-Service -StartupType Disabled | Out-File -FilePath  ".\log.txt" -Append
    Write-Output "Trying to disable $service" | Out-File -FilePath  ".\log.txt" -Append
    Write-Output "Trying to Stop $service" | Out-File -FilePath  ".\log.txt" -Append
}

# Disables all acer services (I don't have an acer laptop, either remove this script or manually disable the services.If you dont trust it)
$acer = Get-Service | Where-Object {$_.DisplayName -like '*Acer*'}
foreach ($acer in $acer) {
    Get-Service -Name $acer | Stop-Service -Force 
    Get-Service -Name $acer | Set-Service -StartupType Disabled 
    The follow acer service is being stopped Stop-Service $acer 
    The follow acer service is being disabled Disable-Service $acer 
}

#Disables all Samsung services( I don't have an Samsung laptop, either remove this script or manually disable the services, If you dont trust it)
$sam = Get-Service | Where-Object {$_.DisplayName -like '*Samsung*'}
foreach ($sam in $sam) {
    Get-Service -Name $sam | Stop-Service -Force 
    Get-Service -Name $sam | Set-Service -StartupType Disabled 
    The follow acer service is being stopped Stop-Service $sam
    The follow acer service is being disabled Disable-Service $sam
    Out-File -FilePath  ".\log.txt"
}

#Disables all MSI services( I don't have an MSI, either remove this script or manually disable the services. If you dont trust it)
$msi = Get-Service | Where-Object {$_.DisplayName -like '*msi*'}
foreach ($msi in $msi) {
    Get-Service -Name $msi | Stop-Service -Force 
    Get-Service -Name $msi | Set-Service -StartupType Disabled 
    The follow acer service is being stopped Stop-Service $msi
    The follow acer service is being disabled Disable-Service $msi
    Out-File -FilePath  ".\log.txt"
}

#Disables all Huawei services( I don't have an Huawei laptop, either remove this script or manually disable the services. If you dont trust it)
$Huawei = Get-Service | Where-Object {$_.DisplayName -like '*Huawei*'}
foreach ($Huawei in $Huawei) {
    Get-Service -Name $Huawei | Stop-Service -Force 
    Get-Service -Name $Huawei | Set-Service -StartupType Disabled 
    The follow acer service is being stopped Stop-Service $Huawei
    The follow acer service is being disabled Disable-Service $Huawei 
}