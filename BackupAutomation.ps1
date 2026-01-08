<#
.SYNOPSIS
    BackupAutomation - POC Version
    Führt ein Backup einer Quelle in ein versioniertes Zielverzeichnis aus.

.DESCRIPTION
    Dieses Skript dient als Proof of Concept (POC) für die Backup-Automatisierung.
    Es sichert eine Quellverzeichnis in ein Zielverzeichnis unter Verwendung eines Zeitstempels.
    Es erstellt ein Logfile und liefert Exit Codes zurück.

.PARAMETER Source
    Der Pfad zum Quellverzeichnis, das gesichert werden soll.

.PARAMETER BackupRoot
    Das Wurzelverzeichnis, in dem die Backups abgelegt werden.

.EXAMPLE
    .\BackupAutomation.ps1 -Source "C:\Data\MyProject" -BackupRoot "D:\Backups"
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_ -PathType Container})]
    [string]$Source,

    [Parameter(Mandatory=$true)]
    [string]$BackupRoot
)

# --- Konfiguration & Init ---
$ErrorActionPreference = "Stop"
$ExitCode = 0
$Timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$RunId = $Timestamp

# Pfade definieren
$BackupTargetDir = Join-Path -Path $BackupRoot -ChildPath $RunId
$LogDir = Join-Path -Path $BackupRoot -ChildPath "logs"
$LogFile = Join-Path -Path $LogDir -ChildPath "backup_$($RunId).log"

# --- Helper Funktionen ---

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $LogEntry = "{0} [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
    
    # Console Output
    Write-Host $LogEntry

    # File Output (Append)
    try {
        Add-Content -Path $LogFile -Value $LogEntry -ErrorAction Stop
    }
    catch {
        Write-Warning "Konnte nicht in Logfile schreiben: $($_.Exception.Message)"
    }
}

# --- Hauptablauf ---

try {
    # 1. Vorbereitung
    if (-not (Test-Path -Path $BackupRoot)) {
        New-Item -Path $BackupRoot -ItemType Directory -Force | Out-Null
        Write-Host "BackupRoot erstellt: $BackupRoot"
    }

    if (-not (Test-Path -Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
    }

    # Log Start
    Write-Log "Backup gestartet. RunID: $RunId"
    Write-Log "Quelle: $Source"
    Write-Log "Ziel: $BackupTargetDir"

    # 2. Pre-Checks (Source Existenz ist schon durch Parameter-Validierung geprüft, aber sicherheitshalber)
    if (-not (Test-Path -Path $Source)) {
        throw "Quellverzeichnis existiert nicht: $Source"
    }

    # 3. Backup durchführen (Robocopy Wrapper)
    Write-Log "Starte Kopiervorgang..."
    
    # Robocopy Argumente: /MIR (Spiegeln), /R:3 (Retries), /W:5 (Wait), /NFL /NDL (Weniger Output), /NP (Kein Progress)
    $RoboArgs = @($Source, $BackupTargetDir, "/MIR", "/R:3", "/W:5", "/NFL", "/NDL", "/NP")
    
    # Robocopy ausführen
    $Process = Start-Process -FilePath "robocopy.exe" -ArgumentList $RoboArgs -NoNewWindow -PassThru -Wait
    $RoboExitCode = $Process.ExitCode

    # Robocopy Exit Codes interpretieren
    # 0 = No errors, no copying
    # 1 = One or more files copied successfully
    # 2 = Extra files or directories detected (in destination)
    # 3 = (2+1) Some files copied, extra files present
    # ...
    # 8 = FAILED copy
    
    if ($RoboExitCode -lt 8) {
        Write-Log "Kopiervorgang erfolgreich beendet. Robocopy ExitCode: $RoboExitCode"
    }
    else {
        throw "Robocopy Fehler. ExitCode: $RoboExitCode"
    }

    Write-Log "Backup erfolgreich abgeschlossen."
    $ExitCode = 0

}
catch {
    # Fehlerbehandlung
    $ErrorMessage = $_.Exception.Message
    if (-not (Test-Path $LogDir)) {
        # Fallback falls LogDir Erstellung fehlschlug
        Write-Error "KRITISCHER FEHLER: $ErrorMessage"
    } else {
        Write-Log "FEHLER: $ErrorMessage" "ERROR"
        Write-Log "Backup fehlgeschlagen." "ERROR"
    }
    
    $ExitCode = 2
}

exit $ExitCode
