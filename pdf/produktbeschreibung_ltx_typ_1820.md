---
title: LTX Typ 1820
subtitle: Flexibler SDI-12-Datenlogger mit LoRaWAN
document-type: Produktbeschreibung
product-code: LTX 1820
lead: Autonomer SDI-12-Datenlogger mit lokalem Speicher, BLE und LoRaWAN - ausgelegt für flexible interne oder externe Energieversorgung.
cover-image: pdf/assets/LTX_Typ1820_antenna.jpg
date: Juli 2026
version: "1.0"
---

\noindent{\headingfont\fontsize{22}{25}\selectfont\color{GPInk}Produktprofil}\par
\vspace{4mm}

Der **LTX Typ 1820** ist ein batteriebetriebener Datenlogger für SDI-12-Sensoren. Er kombiniert LoRaWAN EU868, lokalen Messwertspeicher und Bluetooth Low Energy (BLE). Das größere Polycarbonatgehäuse bietet Raum für verschiedene Batterieoptionen und unterstützt zusätzlich eine externe Versorgung. Damit eignet sich der Logger für Messstellen mit flexiblem Energie- und Backup-Konzept.

# Vorteile auf einen Blick

- Bis zu **20 SDI-12-Messkanäle** nach SDI-12 Version 1.3
- LoRaWAN 1.0.4, Klasse A, im EU868-Band
- Lokaler Speicher mit 8 MB Standardkapazität
- Ring- oder Linearspeicher für unabhängige Datensicherung
- BLE-Zugriff für Konfiguration, Diagnose und lokalen Datenabruf
- Interne AA- oder optionale Lithium-D-Zellen
- Externe Versorgung von 5 bis 14 V mit möglicher Batterie-Backup-Funktion
- Geräumiges Polycarbonatgehäuse für flexible Feldinstallationen

\newpage

# Technische Daten

| Eigenschaft | Wert |
|---|---|
| Anwendung | Autonomer Datenlogger für SDI-12-Sensoren |
| Sensorschnittstelle | SDI-12 Version 1.3, auch für Low-Voltage-Sensoren |
| Anzahl Messkanäle | Bis zu 20 |
| Messintervall | 10 bis 86.400 Sekunden, konfigurierbar |
| LoRaWAN | Version 1.0.4, Klasse A |
| Frequenzbereich | EU868, 863 bis 870 MHz |
| Sendeleistung | Maximal 14 dBm |
| Nutzdaten pro Uplink | Bis zu 51 Byte, abhängig von Datenrate und Netzparametern |
| Lokale Kommunikation | Bluetooth Low Energy ab BLE 4.2 |
| Lokaler Speicher | 8 MB Standard, bis zu 16 MB bestückbar |
| Speicherkapazität | Typisch etwa 400.000 historische Messwerte bei 8 MB; abhängig von Kanalzahl und Datensatzgröße |
| Interne Versorgung | 6 × 1,5-V-AA-Zelle; optional 2 × 3,6-V-Lithium-D-Zelle |
| Externe Versorgung | 5 bis 14 V; die höhere anliegende Spannung wird verwendet |
| Sensorversorgung | Höchste Versorgungsspannung wird durchgeschaltet |
| Gehäuseformat (B × L × H) | Ca. 75 mm × 180 mm × 60 mm |
| Antennenanschluss | N-Buchse, ausführungsabhängig |
| Gehäuse | Polycarbonat mit transparentem Deckel; je nach Ausführung bis IP68 |

# Flexibles Versorgungskonzept

Der Typ 1820 kann mit sechs AA-Zellen, optional zwei Lithium-D-Zellen oder einer externen Quelle betrieben werden. Bei paralleler Versorgung verwendet die Hardware die höhere Spannung; interne Batterien können als Backup dienen. Laufzeit und externe Versorgung sind anhand von Sensorlast, Mess- und Funkintervall, Empfangspegel, Batteriechemie und Temperatur auszulegen.

# Daten, Funk und Service

Der Logger speichert Messwerte unabhängig von der Funkübertragung lokal im Ring- oder Linearspeicher. Das **BLX Dashboard** unterstützt per BLE Konfiguration, Diagnose und Datenzugriff. LoRaWAN stellt kompakte Uplinks und bidirektionale Kommunikation bereit; Housekeeping-Werte ergänzen die Ferndiagnose.

# Typische Einsatzbereiche

- Hydrologische, geotechnische und meteorologische Messstellen
- SDI-12-Sensorik mit höherem Energie- oder Platzbedarf
- Standorte mit externer Akku- oder Solarversorgung
- Langzeitmonitoring mit lokaler Datensicherung, Fernübertragung und Versorgungsreserve

# Hinweise zur Projektierung

Schutzart, Antenne, Batterie, Sensorlast, Funkabdeckung und Gehäusekonfiguration sind projektspezifisch abzustimmen. Details zu LoRaWAN-Inbetriebnahme, Payload, Firmware und Parametrierung stehen in der technischen LTX-Dokumentation dieses Repos.
