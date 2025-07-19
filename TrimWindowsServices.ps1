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

    # Windows Telemetry (privacy)
    "DiagTrack"                      # Connected User Experiences and Telemetry

    # Program Compatibility
    "PcaSvc"                         # Program Compatibility Assistant

    # Remote Access / VPN
    "RasMan"                         # Remote Access Connection Manager
    "SstpSvc"                        # Secure Socket Tunneling Protocol Service

    # Network discovery
    "SSDPSRV"                        # SSDP Discovery

    # Distributed Link Tracking (LAN file tracking)
    "TrkWks"                         # Distributed Link Tracking Client

    # Print Spooler (if you don't print)
    "Spooler"                        # Print Spooler

    # Example: CyberGhost VPN (if not needed)
    #"CyberGhost8Service"             # CyberGhost 8 Service

    # Example: Plex Media Server auto-update (optional)
    #"PlexUpdateService"              # Plex Update Service

    # (Add Bluetooth services here if you don’t use Bluetooth)
    # Example: "bthserv"             # Bluetooth Support Service (if you see it)

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

add all services here