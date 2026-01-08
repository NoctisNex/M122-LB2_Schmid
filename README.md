# 🛡️ Backup & Restore Automation (M122 LB2)

> **Ein PowerShell-basiertes Tool zur Automatisierung von Backups mit Reporting, Versionierung und Restore-Funktionalität.**

![Status](https://img.shields.io/badge/Status-In%20Development-yellow?style=flat-square)
![Language](https://img.shields.io/badge/Language-PowerShell-blue?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

## 📖 Über das Projekt

Dieses Projekt wurde im Rahmen des Moduls **M122 – Abläufe mit einer Scriptsprache automatisieren** (LB2 Praxisarbeit) entwickelt.
Ziel ist es, eine zuverlässige, automatisierte Lösung für Datei-Backups zu schaffen, die ohne teure Enterprise-Software auskommt und sich flexibel via JSON konfigurieren lässt.

### Kernfunktionen
*   **Versionierte Backups**: Erstellt pro Lauf einen neuen Ordner mit Zeitstempel.
*   **Robuste Kopie**: Nutzt `robocopy` für effiziente und sichere Dateiübertragungen.
*   **Reporting**: Generiert detaillierte Logs und Reports (CSV/HTML).
*   **Retention Policy**: Löscht automatisch alte Backups nach Zeit oder Anzahl (in Entwicklung).
*   **Restore Modus**: Einfaches Wiederherstellen früherer Versionen (in Entwicklung).

---

## 🚀 Features & Roadmap

Das Projekt wird in drei definierten Phasen entwickelt:

| Phase | Status | Beschreibung |
| :--- | :---: | :--- |
| **1. POC (Proof of Concept)** | ✅ | Grundlegendes Backup einer Quelle, Logging, Exit Codes. |
| **2. Prototyp** | 🚧 | JSON Config, Mehrere Quellen, Excludes, Retention, Dry-Run. |
| **3. MVP (Minimum Viable Product)** | 📅 | Restore-Modus, Task Scheduler Integration, Fehlerbehandlung, Doku. |

---

## 🛠️ Installation & Voraussetzungen

### Voraussetzungen
*   **Betriebssystem**: Windows 10 / 11 oder Windows Server
*   **PowerShell**: Version 5.1 oder PowerShell 7+ (Core)

### Setup
1.  Repository klonen:
    ```bash
    git clone https://github.com/DeinUser/M122-LB2_Schmid.git
    cd M122-LB2_Schmid
    ```
2.  Ausführung erlauben (falls nötig):
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

---

## 💻 Verwendung

### Aktuelle Version (POC)
Momentan werden Quelle und Ziel direkt als Parameter übergeben.

```powershell
# Syntax
.\BackupAutomation.ps1 -Source "PFAD_ZUR_QUELLE" -BackupRoot "PFAD_ZUM_BACKUP_ORDNER"

# Beispiel
.\BackupAutomation.ps1 -Source "C:\Users\Robin\Documents\Projekt" -BackupRoot "D:\Backups"
```

### Geplante Verwendung (Prototyp/MVP)
Später wird das Skript über eine `config.json` gesteuert:

```powershell
# Backup Modus
.\BackupAutomation.ps1 -ConfigPath .\config.json -Mode Backup

# Dry-Run (Simulation)
.\BackupAutomation.ps1 -ConfigPath .\config.json -Mode DryRun

# Restore
.\BackupAutomation.ps1 -ConfigPath .\config.json -Mode Restore -RestoreVersion "latest"
```

---

## 👤 Autor

**Robin Schmid**  
Modul 122 - LB2 Praxisarbeit  
Datum: Dezember 2025

---

*Dieses Projekt dient als Leistungsnachweis für die Berufsbildung und ist für Bildungszwecke gedacht.*
