# LTX-Logger Dokumentation – Übersicht

Stand: 2026-07-31

Einstiegsdokument für die LTX-Logger-Dokumentation. Alle inhaltlichen Dokumente liegen unter `editiert/` beziehungsweise in den dortigen thematischen Unterverzeichnissen.

---

> [!IMPORTANT]
> **An diesem Dokument und Unter-Dokumenten wird noch gearbeitet!**
> Bitte bei ungeklärten Fragen direkt melden!

## Gerätetypen und Hardware

### [logger_Zusammenfassung.md](ltx_typen/logger_Zusammenfassung.md)
Übersicht aller LTX-Logger-Varianten mit SDI-12-Unterstützung (Typen 1500–3000).
Beschreibt verfügbare Mobilfunk- und Funktechnologien (LTE Cat1, LTE-M, NB-IoT, LoRa EU868), Hardware-Baukästen („BoPla"-Trägerplatine, „2-Zoll"-Logger), Energiebetrachtungen sowie eine Jahresbetrieb-Beispielberechnung.

### [firmware_uebersicht.md](ltx_typen/firmware_uebersicht.md)
Beschreibt lokale Firmware-Ablage, Web-Mirror-Schema und die getrennten Firmware-Dateien fuer Typ 1800 und Typ 1801.

### [LTX_T1720_LoRaWAN.MD](ltx_typen/LTX_T1720_LoRaWAN.MD)
Kurz-Datenblatt für den SDI-12-Datenlogger LTX Typ 1720 mit LoRaWAN EU868.
Beschreibt vor allem das kompakte 2-Zoll-Rundgehäuse, die Versorgung mit einer Lithium-D-Zelle, Speicher, Laufzeitplanung und die gerätespezifischen Basisparameter. Für die gemeinsame Software-Inbetriebnahme verweist das Dokument auf das LoRaWAN-How-to.

### [LTX_T1820_LoRaWAN.MD](ltx_typen/LTX_T1820_LoRaWAN.MD)
Kurz-Datenblatt für den SDI-12-Datenlogger LTX Typ 1820 mit LoRaWAN EU868.
Beschreibt vor allem das größere Polycarbonatgehäuse, AA-/D-Zellen- und externe Versorgung mit Backup-Möglichkeit, Speicher, Laufzeitplanung und die gerätespezifischen Basisparameter. Enthält außerdem eine kompakte Abgrenzung zum Typ 1720 und verweist für die Software-Inbetriebnahme auf das LoRaWAN-How-to.

---

## SDI-12-Sensoren und Interfaces

### [sdi12_sensors.md](sdi12_sensors.md)
Übersicht aller aktuellen Open-SDI12-Blue-Sensortypen außerhalb des Archivs `Obsolete`.
Beschreibt Messgrößen, Bereiche, Genauigkeiten, Versorgung und Besonderheiten und verlinkt die Datenblätter sowie vorhandene Sensor-Firmware direkt im Web-Archiv.

Web-Einstieg: [Open-SDI12-Blue-Sensors](https://joembedded.de/x3/ltx_firmware/index.php?dir=./Open-SDI12-Blue-Sensors)

---

## BLX Dashboard

<img src="img/blxDashboard_preview640x480.png" alt="BLX Dashboard Bluetooth-App fuer LTX-Logger" width="360">

*Bluetooth-App zur Bedienung und Konfiguration von LTX-Loggern.*

### [blx_commands.md](blx_dashboard/blx_commands.md)
Vollständige Kommando-Referenz für das BLX Dashboard (Web-App zur BLE-Kommunikation mit LTX-Loggern).
Beschreibt alle SysCommands (beginnen mit `.`), den internen Browser-Store (IndexedDB), Audio-Funktionen,
Verbindungsverwaltung, Dateioperationen (`.get`, `.put`, `.fput`, `.del`, `.firmware`), Skript-Ausführung (`.crun`/`.expect`) sowie konfigurierbare Store-Variablen (`#blxDash_#badgeURL`, `#blxDash_#AutoPINURL`).

- Quellen: 
  - [github.com/joembedded/blxdashboard 🔒](https://github.com/joembedded/blxdashboard) *Quelle, für Collaborators* 
  - [github.com/joembedded/ltx_ble_demo](https://github.com/joembedded/ltx_ble_demo) *(öffentlich, lauffähige APP)*

---

## Kommandos

### [LTX_Kommandos.md](ltx_kommandos/LTX_Kommandos.md)
Vollständige Kommando-Referenz für alle LTX-Logger der Typen 1500–3000.
Behandelt alle Kommunikationswege (BLE, UART, Mobilfunk-Downlink, LoRa-Downlink), allgemeine BLE-Kommandos, Datei- und Speicherkommandos, das Parameterkommando `x...`/`xWrite`, SDI-12-Kommandos sowie die modemspezifischen Kommandos für Mobilfunk- und LoRa-Geräte.

---

## Diagnose und Fehlerbehebung

### [diagnose_fehlerbehebung_howto.md](diagnose_fehlerbehebung/diagnose_fehlerbehebung_howto.md)
Praxisanleitung für Hardware-Entwicklung, Inbetriebnahme und technischen Service.
Beschreibt den sicheren Anschluss und die Bedienung der lokalen 3,3-V-Debug-UART,
wichtige Diagnosekommandos sowie die direkte Untersuchung des SDI-12-Busses mit
einem RS-232-Adapter und SDI12Term. Enthält Anschlussbilder, minimale
SDI-12-Messabläufe, Hinweise zum parallelen Mitschneiden und eine Diagnosematrix.

---

## Parameter

### [ltx_parameter_referenz.md](ltx_parameter/ltx_parameter_referenz.md)
Detailreferenz der LTX-Parameterdateien `iparam.lxp` und `sys_param.lxp`.
Erklärt das Dateiformat (zeilenweise ASCII), alle Kanalparameter, Systemparameter (Netzwerk, Batterie, Speicher), das Konzept von Housekeeping (HK), Linearisierung und Energieberechnung sowie den Einzelzugriff auf Parameter über `x...`-Kommandos.

---

## Datenfiles

### [ltx_fileformat_edt.md](ltx_datenfiles/ltx_fileformat_edt.md)
Referenz des LTX Easy-Data-Textformats (`*.edt`) für Messwertdateien wie `data.edt`, `data.edt.bak` und `data.edt.old`.
Beschreibt Dateirotation und BLE-Synchronisation, Info-Tags (`<...>`), Tabellenköpfe (`!U`), Messzeilen (`!`), UTC- und Relativzeiten, Kanal-/HK-Zuordnung, Fehlerwerte, alarmierte Werte sowie Base64-codierte Binärpayloads (`$...`) inklusive Token-Referenz und Empfehlungen zur Speicheroptimierung.

> Hinweis: neben regulären Datenfiles sind auf den Geräten auch andere Filestypen, z.B. Logdateien, Firmware oder Kalibrierdaten möglich. Genauere Beschreibungen folgen. *todo*


---


## LoRa

### [ltx_lorawan_howto.md](ltx_lorawan_howto/ltx_lorawan_howto.md)
Praxisanleitung zur vollständigen LoRaWAN-Inbetriebnahme eines LTX-Datenloggers mit The Things Network/The Things Stack oder ChirpStack V4.
Behandelt Logger- und Modemkonfiguration, OTAA, Payload-Codecs, Webhook beziehungsweise HTTP-Integration, die Anbindung an die LTX Microcloud, Funktionstests, Fehlersuche und den energieoptimierten Dauerbetrieb.

### [ltx_lora_at_kommandos.md](lora/ltx_lora_at_kommandos.md)
Referenz aller LoRaWAN-AT-Kommandos für LTX-Geräte der Typen 1720/1730 und 1820/1830.
Basis ist der STM32CubeWL-Stack (AN5481 v1.0.4) mit LTX-projektspezifischen Erweiterungen. Dokumentiert Schlüssel/EUIs (`AT+DEUI`, `AT+NWKKEY`, …), Join- und Sendebefehle (`AT+JOIN`, `AT+SEND`), Netzwerkverwaltung (ADR, DR, Frequenzband, TX-Power) sowie LTX-Erweiterungen wie `AT+XSTATE`, `AT+RECV` und `AT+SAVECFG`.

### [lora_payload.md](lora/lora_payload.md)
Kompakte, optisch strukturierte Zusammenfassung des LTX-LoRa-Payload-Formats und des lokalen Payload-Decoders.
Beschreibt Uplink-Decoding für ChirpStack/TTN, `fPort`-Zuordnung, Float16/Float32-Messwerte, Housekeeping-Kanäle, Fehlercodes sowie Downlink-Kommandos auf `fPort 10`.

### [energie_vergleich.md](lora/energie_vergleich.md)
Messtechnischer Vergleich von drei LoRa-EU868-Modulen (STM32WL5MOC, RAK3172LP-SIP, RAK3172-SIP) hinsichtlich Standby-Strom und Sendestrom bei typischen Nutzlastlängen (10 und 40 Bytes).
Gibt Orientierung bei der Modulauswahl in Bezug auf Energieverbrauch und Batterielebensdauer.

---


## Dateisystem

### [Jesfs_zusammenfassung.md](ltx_filesystem/jesfs_zusammenfassung.md)
Kompakter Überblick (rein informativ) zu JesFS (Jo's Embedded Serial File System) für serielle NOR-Flash-Speicher.
Beschreibt Funktionsprinzip, Logging-Eignung auf LTX-Datenloggern sowie praktische Einsatzempfehlungen für robuste, flash-schonende Messdatenspeicherung.

---

## Mobilfunk

### [mobileErrors.md](ltx_mobile/mobileErrors.md)
Strukturierte Fehlercode-Referenz für häufige Mobilfunkprobleme in LTX-Projekten.
Enthält die Bereiche Modem Basic, UDP, HTTP, Content, GPRS_TRANSFER und LFTP mit typischen Fehlercodes und Kurzbeschreibung.

### [mobilfunk_metadaten.md](ltx_mobile/mobilfunk_metadaten.md)
Liste der vom Logger uebertragenen Mobilfunk-Metadaten (`mcc`, `net`, `lac`, `cid`, `ta`, `dbm`, `act`) sowie der serverseitigen Speicherorte und abgeleiteten Zellposition.

---

## Schnellübersicht

| Dokument | Thema | Zielgruppe |
|---|---|---|
| [logger_Zusammenfassung.md](ltx_typen/logger_Zusammenfassung.md) | Gerätetypen, Hardware, Funkoptionen | Projektplanung, Inbetriebnahme |
| [firmware_uebersicht.md](ltx_typen/firmware_uebersicht.md) | Firmware-Ablage, Web-Mirror, Typ 1800/1801 | Service, Firmware-Update |
| [LTX_T1720_LoRaWAN.MD](ltx_typen/LTX_T1720_LoRaWAN.MD) | Typ-1720-Datenblatt, LoRaWAN, Energieversorgung | Geräteauswahl, LoRa-Projekte |
| [LTX_T1820_LoRaWAN.MD](ltx_typen/LTX_T1820_LoRaWAN.MD) | Typ-1820-Datenblatt, flexible Energieversorgung, Gehäuse | Geräteauswahl, LoRa-Projekte |
| [sdi12_sensors.md](sdi12_sensors.md) | Open-SDI12-Blue-Sensoren, Interfaces und Datenblätter | Sensorwahl, Planung, Inbetriebnahme |
| [blx_commands.md](blx_dashboard/blx_commands.md) | BLX Dashboard SysCommands, Store, Dateioperationen | BLE-App-Nutzung, Inbetriebnahme |
| [LTX_Kommandos.md](ltx_kommandos/LTX_Kommandos.md) | Alle Kommandos (BLE, UART, LoRa, Mobilfunk) | Integration, Service |
| [diagnose_fehlerbehebung_howto.md](diagnose_fehlerbehebung/diagnose_fehlerbehebung_howto.md) | Debug-UART, SDI-12-Terminal und systematische Fehlersuche | Hardware-Entwicklung, Inbetriebnahme, Service |
| [ltx_parameter_referenz.md](ltx_parameter/ltx_parameter_referenz.md) | Parameterdateien, `x...`-Kommandos | Parametrierung, Konfiguration |
| [ltx_fileformat_edt.md](ltx_datenfiles/ltx_fileformat_edt.md) | EDT-Messdatenformat, CSV-Expansion, Payload-Decoding | Datenanalyse, Import, Service |
| [ltx_lorawan_howto.md](ltx_lorawan_howto/ltx_lorawan_howto.md) | LoRaWAN-Inbetriebnahme mit TTN oder ChirpStack und LTX Microcloud | Inbetriebnahme, Integration, Service |
| [ltx_lora_at_kommandos.md](lora/ltx_lora_at_kommandos.md) | LoRaWAN-AT-Kommandos (vollständig) | LoRa-Inbetriebnahme |
| [lora_payload.md](lora/lora_payload.md) | LoRa-Payload, Uplink-Decoder, Downlink-Kommandos | Plattform-Integration |
| [energie_vergleich.md](lora/energie_vergleich.md) | LoRa-Modulvergleich Stromverbrauch | Hardware-Auswahl |
| [jesfs_zusammenfassung.md](ltx_filesystem/jesfs_zusammenfassung.md) | JesFS-Dateisystem für Logger | Speicher-/Firmware-Konzept |
| [mobileErrors.md](ltx_mobile/mobileErrors.md) | Häufige Mobilfunk-Fehlercodes | Service, Diagnose |
| [mobilfunk_metadaten.md](ltx_mobile/mobilfunk_metadaten.md) | Mobilfunk-Metadaten | Handbuch, Service, Diagnose |

---

**Firmware- und Datenblatt-Archiv:** [https://joembedded.de/x3/ltx_firmware/index.php](https://joembedded.de/x3/ltx_firmware/index.php)
