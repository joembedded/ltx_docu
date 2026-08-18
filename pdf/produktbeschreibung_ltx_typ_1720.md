---
title: LTX Typ 1720
subtitle: Kompakter SDI-12-Datenlogger mit LoRaWAN
document-type: Produktbeschreibung
product-code: LTX 1720
lead: Autonom messen, lokal sichern und energieeffizient per LoRaWAN übertragen - in einem schlanken 2-Zoll-Rundgehäuse für kompakte Messstellen.
cover-image: editiert/img/t1720_2zoll_rundgehaeuse.jpg
date: Juli 2026
version: "1.1"
---

\noindent{\headingfont\fontsize{22}{25}\selectfont\color{GPInk}Produktprofil}\par
\vspace{4mm}

Der **LTX Typ 1720** ist ein kompakter, batteriebetriebener Datenlogger für SDI-12-Sensoren. Er verbindet LoRaWAN EU868 mit lokalem Messwertspeicher und Bluetooth Low Energy (BLE) für Service, Diagnose und Konfiguration vor Ort. Sein schlankes 2-Zoll-Rundgehäuse eignet sich besonders für Messstellen, an denen wenig Einbauraum und eine lange autonome Betriebsdauer entscheidend sind.

![Geöffneter LTX Typ 1720 im 2-Zoll-Rundgehäuse](../editiert/img/t1720_2zoll_rundgehaeuse.jpg){width=125mm}

# Vorteile auf einen Blick

- Bis zu **20 SDI-12-Messkanäle** nach SDI-12 Version 1.3
- LoRaWAN 1.0.4, Klasse A, im europäischen EU868-Band
- Bidirektionale Funkkommunikation mit kompakten LTX-Payloads
- Lokaler Messwertspeicher mit 8 MB Standardkapazität
- Ring- oder Linearspeicherbetrieb für unabhängige Datensicherung
- BLE-Zugriff mit dem BLX Dashboard für Konfiguration und Datenabruf
- Energieoptimierter Betrieb mit einer Lithium-D-Zelle
- Housekeeping-Werte für Batterie, Energiebudget und interne Umgebungswerte

\newpage

# Technische Daten

| Eigenschaft | Wert |
|---|---|
| Anwendung | Autonomer Datenlogger für SDI-12-Sensoren |
| Sensorschnittstelle | SDI-12 Version 1.3, auch für Low-Voltage-Sensoren |
| Anzahl Messkanäle | Bis zu 20 |
| Messintervall | 120 bis 86.400 Sekunden, konfigurierbar |
| LoRaWAN | Version 1.0.4, Klasse A |
| Frequenzbereich | EU868, 863 bis 870 MHz |
| Sendeleistung | Maximal 14 dBm |
| Nutzdaten pro Uplink | Bis zu 51 Byte, abhängig von Datenrate und Netzparametern |
| Lokale Kommunikation | Bluetooth Low Energy ab BLE 4.2 |
| Lokaler Speicher | 8 MB Standard, bis zu 16 MB bestückbar |
| Speicherkapazität | Typisch etwa 400.000 historische Messwerte bei 8 MB; abhängig von Kanalzahl und Datensatzgröße |
| Versorgung | 3,4 bis 3,6 V |
| Batterie | 1 × Lithium-D-Zelle, typisch 12 Ah |
| Sensorversorgung | Intern geschaltet, etwa 9 V; optional 12 V, bis ca. 250 mA |
| Leiterplattenformat | Ca. 35 mm × 115 mm |
| Gehäuse | Schlankes 2-Zoll-Rundgehäuse |

# Energieverbrauch und Laufzeit

Der Typ 1720 ist auf einen energieoptimierten Langzeitbetrieb mit einer 3,6-V-Lithium-D-Zelle ausgelegt. Sein Ultra-Low-Power-Design benötigt im Schlafmodus bei aktivem Bluetooth Low Energy weniger als **20 µA**. Eine BLE-Verbindung verursacht nur einen geringen zusätzlichen Energiebedarf. SDI-12-Sensoren werden ausschließlich für die Messung versorgt; die Bereitstellung der etwa 9 V benötigt dabei rund 15 mA zuzüglich des Sensorstroms. Der geschaltete Versorgungsausgang kann Sensoren mit bis zu etwa 250 mA versorgen. Das LoRaWAN-Modem verursacht beim Senden kurzzeitig Stromspitzen bis etwa 50 mA.

Eine übliche 3,6-V-Lithium-D-Zelle stellt etwa 10.000 bis 15.000 mAh bereit. Bei angemessener Sensorlast sowie Mess- und Übertragungsintervall ist damit ein mehrjähriger Betrieb möglich. Die tatsächliche Laufzeit hängt vor allem von Sensorverbrauch, Funkintervall, LoRaWAN-Datenrate, Empfangsqualität, Batteriechemie und Temperatur ab. Insbesondere die Netzqualität und die daraus resultierende Datenrate beeinflussen den Funkenergiebedarf erheblich.

Alle LTX-Logger verfügen über ein internes Energiemanagement. Es summiert den tatsächlich verbrauchten Energieanteil dynamisch in mAh und führt den daraus abgeleiteten prozentualen Kapazitätsverbrauch als Housekeeping-Wert mit. Zusammen mit der Batteriespannung in mV ermöglicht dies eine belastbare Wechselprognose auch bei wechselnden Betriebsbedingungen, sodass Batterien nicht rein vorsorglich zu früh getauscht werden müssen. Die Spannung eignet sich besonders für Systeme mit gut auswertbarem Spannungsverlauf, etwa Blei-Gel-, Alkali- oder LiPo-Akkus. Bei Lithium-Primärbatterien ist dagegen überwiegend die verbrauchte Kapazität aussagekräftig, weil deren Spannung über lange Zeit nur wenig abfällt.

Eine überschlägige Betrachtung für Messung und Sensorversorgung enthält das [TensioMark-Beispiel in der Logger-Hardwareübersicht](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/logger_Zusammenfassung.md#4-energiebetrachtung--beispiel-tensiomark-3-sensoren). Detaillierte Messwerte zum LoRaWAN-Energiebedarf bei verschiedenen Datenraten und Nutzlasten enthält der [Energie-Vergleich der LoRa-Module](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/energie_vergleich.md).

Messwerte werden unabhängig von der Funkverbindung lokal gespeichert; wahlweise als Ring- oder Linearspeicher.

# Kommunikation und Bedienung

Die lokale Einrichtung erfolgt per BLE mit dem **BLX Dashboard**. LoRaWAN ermöglicht zyklische Uplinks und bidirektionale Kommunikation. Abhängig von der Geräteausführung können Batteriespannung, Energiebudget, interne Temperatur, Feuchte, Luftdruck sowie Diagnosewerte übertragen werden.

# Typische Einsatzbereiche

- Kompakte hydrologische und meteorologische Messstellen
- Boden-, Pegel- und Umweltsensorik mit SDI-12
- Abgelegene Standorte mit energieeffizienter LoRaWAN-Anbindung
- Anwendungen mit zusätzlicher lokaler Datensicherung und begrenztem Einbauraum

# Hinweise zur Projektierung

Batterieparameter, Sensorlast, Funkabdeckung, Antennenposition und Messintervall müssen projektspezifisch geprüft werden. Details zu Inbetriebnahme, Payload, Firmware und Geräteparametern stehen in der technischen LTX-Dokumentation unter [joembedded/ltx_docu](https://github.com/joembedded/ltx_docu).
