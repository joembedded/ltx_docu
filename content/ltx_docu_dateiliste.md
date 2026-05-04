# LTX-Logger Dokumentation – Übersicht

Stand: 2026-05-04

Einstiegsdokument für die LTX-Logger-Dokumentation. Alle inhaltlichen Dokumente liegen im selben Verzeichnis `content/`.

---

## Gerätetypen und Hardware

### [logger_Zusammenfassung.md](ltx_typen/logger_Zusammenfassung.md)
Übersicht aller LTX-Logger-Varianten mit SDI-12-Unterstützung (Typen 1500–3000).
Beschreibt verfügbare Mobilfunk- und Funktechnologien (LTE Cat1, LTE-M, NB-IoT, LoRa EU868), Hardware-Baukästen („BoPla"-Trägerplatine, „2-Zoll"-Logger), Energiebetrachtungen sowie eine Jahresbetrieb-Beispielberechnung.

---

## Kommandos

### [LTX_Kommandos.md](ltx_kommandos/LTX_Kommandos.md)
Vollständige Kommando-Referenz für alle LTX-Logger der Typen 1500–3000.
Behandelt alle Kommunikationswege (BLE, UART, Mobilfunk-Downlink, LoRa-Downlink), allgemeine BLE-Kommandos, Datei- und Speicherkommandos, das Parameterkommando `x...`/`xWrite`, SDI-12-Kommandos sowie die modemspezifischen Kommandos für Mobilfunk- und LoRa-Geräte.

---

## Parameter

### [ltx_parameter_referenz.md](ltx_parameter/ltx_parameter_referenz.md)
Detailreferenz der LTX-Parameterdateien `iparam.lxp` und `sys_param.lxp`.
Erklärt das Dateiformat (zeilenweise ASCII), alle Kanalparameter, Systemparameter (Netzwerk, Batterie, Speicher), das Konzept von Housekeeping (HK), Linearisierung und Energieberechnung sowie den Einzelzugriff auf Parameter über `x...`-Kommandos.

---

## LoRa

### [ltx_lora_at_kommandos.md](lora/ltx_lora_at_kommandos.md)
Referenz aller LoRaWAN-AT-Kommandos für LTX-Geräte der Typen 1720/1730 und 1820/1830.
Basis ist der STM32CubeWL-Stack (AN5481 v1.0.4) mit LTX-projektspezifischen Erweiterungen. Dokumentiert Schlüssel/EUIs (`AT+DEUI`, `AT+NWKKEY`, …), Join- und Sendebefehle (`AT+JOIN`, `AT+SEND`), Netzwerkverwaltung (ADR, DR, Frequenzband, TX-Power) sowie LTX-Erweiterungen wie `AT+XSTATE`, `AT+RECV` und `AT+SAVECFG`.

### [energie_vergleich.md](lora/energie_vergleich.md)
Messtechnischer Vergleich von drei LoRa-EU868-Modulen (STM32WL5MOC, RAK3172LP-SIP, RAK3172-SIP) hinsichtlich Standby-Strom und Sendestrom bei typischen Nutzlastlängen (10 und 40 Bytes).
Gibt Orientierung bei der Modulauswahl in Bezug auf Energieverbrauch und Batterielebensdauer.

---

## Schnellübersicht

| Dokument | Thema | Zielgruppe |
|---|---|---|
| [logger_Zusammenfassung.md](ltx_typen/logger_Zusammenfassung.md) | Gerätetypen, Hardware, Funkoptionen | Projektplanung, Inbetriebnahme |
| [LTX_Kommandos.md](ltx_kommandos/LTX_Kommandos.md) | Alle Kommandos (BLE, UART, LoRa, Mobilfunk) | Integration, Service |
| [ltx_parameter_referenz.md](ltx_parameter/ltx_parameter_referenz.md) | Parameterdateien, `x...`-Kommandos | Parametrierung, Konfiguration |
| [ltx_lora_at_kommandos.md](lora/ltx_lora_at_kommandos.md) | LoRaWAN-AT-Kommandos (vollständig) | LoRa-Inbetriebnahme |
| [energie_vergleich.md](lora/energie_vergleich.md) | LoRa-Modulvergleich Stromverbrauch | Hardware-Auswahl |
