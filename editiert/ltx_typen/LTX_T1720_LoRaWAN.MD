# LTX Typ 1720 – SDI-12-Datenlogger mit LoRaWAN

Der **LTX Typ 1720** ist ein kompakter, batteriebetriebener Datenlogger für
SDI-12-Sensoren. Er kombiniert die energieeffiziente Datenübertragung über
**LoRaWAN EU868** mit einem lokalen Messwertspeicher und einem
**Bluetooth-Low-Energy-Zugang** für Service und Konfiguration vor Ort.

Das schlanke 2"-Rundgehäuse eignet sich besonders für Messstellen, an denen
lange Batterielaufzeiten, kleine Gehäuseabmessungen und eine unabhängige lokale
Datensicherung gefordert sind.

![Beispiel eines geöffneten 2-Zoll-Rundgehäuses](../img/t1720_2zoll_rundgehaeuse.jpg)

*Das 2"-Rundgehäusekonzep; Innenaufbau und Bestückung können je nach
Geräteausführung abweichen.*

## Wesentliche Merkmale

- LoRaWAN **Version 1.0.4**, Geräteklasse A
- Funkbereich **EU868**, maximale Sendeleistung 14 dBm
- Bidirektionale Kommunikation über LoRaWAN
- SDI-12-Schnittstelle nach Version 1.3, auch für Low-Voltage-Sensoren
- Bis zu **20 Messkanäle** als Fließkommawerte (passen inkl. HK-Werte in die 51 Bytes Uplink)
- Lokaler Messwertspeicher, standardmäßig **8 MB**
- Ringspeicher- oder Linearspeicherbetrieb
- Bluetooth Low Energy (BLE) für Konfiguration, Diagnose und Datenzugriff vor Ort
- Bedienung mit der PWA **BLX Dashboard** auf Android- und Windows-Geräten
- Energieoptimierter Batteriebetrieb mit einer Lithium-D-Zelle
- Übertragung von HK-Werten (Housekeeping-Werten), also internen
    Geräte-Zustandswerten für Diagnose, Betriebssicherheit und Auswertung:
    Batteriespannung, bereits verbrauchtes Energiebudget, interne Temperatur,
    interne Feuchte (wichtig für Dichte-Überwachung) und barometrischer
    Luftdruck (zur Kompensation bei Drucksonden für Wasserpegel)

## Technische Daten

| Eigenschaft | Wert |
|---|---|
| Gerätetyp | LTX Typ 1720 |
| Anwendung | Autonomer Datenlogger für SDI-12-Sensoren |
| Sensorschnittstelle | SDI-12 Version 1.3 |
| Anzahl Messkanäle | bis zu 20 |
| Messintervall | 120 bis 86.400 Sekunden, konfigurierbar |
| LoRaWAN | Version 1.0.4, Klasse A |
| Frequenzbereich | EU868, 863 bis 870 MHz |
| Sendeleistung | maximal 14 dBm |
| Nutzdaten pro Uplink | bis zu 51 Byte, abhängig von Datenrate und Netzparametern |
| Datenübertragung | zyklisch, bidirektional; ADR-Unterstützung |
| Lokale Kommunikation | Bluetooth Low Energy, ab BLE 4.2 |
| Lokaler Speicher | 8 MB Standard, bis zu 16 MB bestückbar |
| Speicherbetrieb | Ringspeicher oder linear |
| Speicherkapazität | typisch ca. 400.000 historische Messwerte im Ringspeicherbetrieb bei 8 MB |
| Versorgung | 3,4 bis 3,6 V |
| Batterie | 1 × Lithium-D-Zelle, typisch 12 Ah |
| Sensorversorgung | intern geschaltet, ca. 9 V; optional 5V bis 12 V |
| Leiterplattenformat | ca. 35 mm × 115 mm |
| Gehäuse | schlankes 2"-Rundgehäuse |

Die tatsächlich erreichbare Batterielaufzeit hängt insbesondere vom
Messintervall, dem angeschlossenen Sensor, der LoRaWAN-Datenrate, der
Empfangssituation und der Anzahl der Übertragungen ab. Bei stationären
Messstellen kann **Adaptive Data Rate (ADR)** den Energieverbrauch deutlich
reduzieren.
Als kleine Orientierung zum Energieverbrauch siehe die Projekt-Messwerte in
[logger_Zusammenfassung.md, Abschnitt "4. Energiebetrachtung"](logger_Zusammenfassung.md#4-energiebetrachtung--beispiel-tensiomark-3-sensoren)
und [Abschnitt "5. Jahresbetrieb"](logger_Zusammenfassung.md#5-jahresbetrieb--beispielberechnung).

## Lokale Datensicherung

Im Gegensatz zu einem reinen Funkinterface zeichnet Typ 1720 die Messdaten
zusätzlich lokal auf. Im standardmäßigen Ringspeicherbetrieb werden bei vollem
Speicher automatisch die ältesten Datensätze überschrieben. Alternativ stoppt
der Linearspeicherbetrieb die Aufzeichnung, sobald der Speicher vollständig
belegt ist. Gespeicherte Daten und Diagnoseinformationen können vor Ort über
Bluetooth mit dem BLX Dashboard abgerufen werden.

## LoRaWAN-Funkmodul

LoRa-EU868-Shield für die Logger Typ 1720 und Typ 1820.

Der **LTX Typ 1720** verwendet denselben LoRaWAN-Modemkern wie der
**LTX Typ 1820**. Unterschiede liegen vor allem in der Energieversorgung und
im Gehäusekonzept:

- **Typ 1820:** 6 x 1,5 V Batterieversorgung, größeres Gehäuse
- **Typ 1720:** 1 x 3,6 V Lithium-D-Zelle, schlankes 2"-Rundgehäuse

Passende Logger-Firmware: [Typ 1720 - `firmware_typ1720_ltx_loraeu868_0v4.sec`](https://joembedded.de/x3/ltx_firmware/LTX-Loggers/LTE_Logger_CPU40/Type1720_LTX_INTENT_mit_Shield_LoRaEU868/firmware_typ1720_ltx_loraeu868_0v4.sec). Vor einem Update bitte Gerätetyp und Dateinamen prüfen; Typ 1820 benötigt eine andere Firmware.

Die wichtigsten Modem-Kenndaten (Stromaufnahme, Modulvergleich,
Sendeverhalten EU868) sind hier zusammengefasst:
[Energie-Vergleich LoRa-Module EU868](../lora/energie_vergleich.md)

| Typ 1720 (PCB-Vorschau) | Typ 1820 (Gehäusevorschau) |
|:--:|:--:|
| <img src="../img/t15xx_17xx_pcb_preview.png" alt="LTX 1720 PCB-Vorschau" width="240"> | <img src="../img/T18xx_enc_preview.jpg" alt="LTX 1820 Gehaeusevorschau" width="240"> |

Der Typ 1720 kann mit LoRaWAN-Netzen wie **ChirpStack**, **The Things Stack**
und kompatiblen Netzbetreiber-Plattformen eingesetzt werden. Die kompakten
Payloads minimieren die Funkzeit und damit den Energiebedarf.

## Konfiguration und Software

Die Inbetriebnahme und Wartung erfolgen lokal per Bluetooth mit dem
**BLX Dashboard**. Darüber lassen sich unter anderem Sensorabfragen,
Messintervalle, Geräteparameter und Diagnoseinformationen bearbeiten.

<img src="../img/blxDashboard_preview640x480.png" alt="BLX Dashboard zur Bluetooth-Bedienung von LTX-Loggern" width="420">

*BLX Dashboard: Bluetooth-App zur Bedienung und Konfiguration von LTX-Loggern vor Ort.*

### Beispiel: LoRaWAN-Parametrierung für Radar

Beim Typ 1720 wählt der LoRaWAN-`fPort` zugleich das Einheitenschema des
LTX-Payload-Decoders. Für ein Radar mit Distanz und Signalstärke wird
`fPort 14` verwendet. Der Decoder ordnet die Messwerte dann zyklisch den
Einheiten `m` und `dBm` zu. Werden mehrere Sensoren übertragen, wiederholt sich
dieses Einheitenschema entsprechend: `m`, `dBm`, `m`, `dBm` usw.

Im BLX Dashboard wird der Wert in `sys_param`, Block `@200`, Feld `p Port`
eingetragen. Im gleichen Dialog können auch Batteriedaten und die Basisenergie
pro Messung gesetzt werden:

<img src="../img/lora_sys_param_t1720.png" alt="BLX Dashboard: sys_param fuer LoRaWAN Typ 1720 mit fPort 14, Batterie und Messenergie" width="620">

| Feld | Beispielwert | Bedeutung |
|---|---:|---|
| `p Port` | `14` | LoRaWAN-Uplink-`fPort`; Typ 14 = Radar-Einheiten `m`, `dBm` |
| `y Bat. Capacity` | `10000` | Batteriekapazität in mAh, z. B. Lithium-D-Zelle (vorsichtig gewählt) |
| `l Bat. Volts 0%` | `3.3` | Spannung für 0 % Batteriestand |
| `h Bat. Volts 100%` | `3.6` | Spannung für 100 % Batteriestand |
| `m mAmsec/Measure` | `10000` | Basisenergie pro Messung in mA·ms |

Der Wert `10000 mA·ms` berücksichtigt beim T1720 den Ruhestrom des
SDI-12-Step-Ups: Für die 9,6-V-Erzeugung im Gerät fallen ungefähr 10 mA
während einer Messung an.

Die entsprechenden Einzelparameter-Kommandos sind:

```text
xsp14
xsy10000
xsl3.3
xsh3.6
xsm10000
xWrite
```

Bei lokaler Eingabe über BLE/UART speichert `xWrite` die Änderung dauerhaft.
Bei LoRaWAN-Downlinks werden Parameteränderungen nach der Verarbeitung
normalerweise automatisch gespeichert.

### Beispiel: Messwertformat für Radar-Kanäle

Die Genauigkeit pro Messkanal wird im Kanalparameter `f Mem_format`
festgelegt. Für LoRaWAN ist nicht die Anzahl der Nachkommastellen entscheidend,
sondern nur das Kurzfloat-Flag `Bit 7` mit dem Wert `128` (das achte Bit):

- `f = 3`: Messwert wird als Float32 übertragen. Das ist für die Distanz
  sinnvoll, wenn die maximale Genauigkeit erhalten bleiben soll.
- `f = 130`: `2 + 128`, also Kurzfloat/Float16 aktiv. Das ist für die
  Signalstärke ausreichend und spart Payload-Bytes.

<img src="../img/lora_iparam_radar_t1720.png" alt="BLX Dashboard: iparam fuer Radar-Kanaele mit Float32 fuer Distanz und Float16 fuer Signalstaerke" width="620">

Im Beispiel ist Kanal `@0` die Distanz in `m` mit `f = 3`; Kanal `@1` ist die
Signalstärke mit lokalem Einheitenstring `db` und `f = 130`. Über `fPort 14`
gibt der Payload-Decoder diese zweite Größe als `dBm` aus. Die unteren Bits des
Zahlenformats werden für LoRaWAN nicht als Nachkommastellen ausgewertet.
Relevant ist nur, ob das Kurzfloat-Flag gesetzt ist. Ohne gesetztes Flag wird
Float32 gesendet, mit gesetztem Flag Float16.

Typische Einzelparameter-Kommandos für dieses Beispiel:

```text
xi0um
xi0f3
xi1udb
xi1f130
xWrite
```

Weitere Details zum Einheitenschema stehen in der
[LoRa-Payload-Dokumentation](../lora/lora_payload.md#typfport-am-logger-einstellen).

Für die Cloud-Anbindung stehen offene Softwarekomponenten zur Verfügung:

- [BLX Dashboard](https://github.com/joembedded/ltx_ble_demo)
- [LTX Payload Decoder](https://github.com/joembedded/payload-decoder)
- [LTX Microcloud](https://github.com/joembedded/LTX_Server)

---

*Kurz-Datenblatt · Stand: März 2026 · Technische Änderungen vorbehalten*

**Firmware- und Datenblatt-Archiv:** [https://joembedded.de/x3/ltx_firmware/index.php](https://joembedded.de/x3/ltx_firmware/index.php)
