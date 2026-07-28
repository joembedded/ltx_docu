# LTX Typ 1720 – SDI-12-Datenlogger mit LoRaWAN

[← Zur LTX-Dokumentationsübersicht](../ltx_docu_dateiliste.md)

> [!NOTE]
> Dieses Dokument beschreibt hauptsächlich die Hardware und die gerätespezifischen Einstellungen des LTX Typ 1720. Die gemeinsame Software-Inbetriebnahme mit BLX Dashboard, The Things Network (TTN) oder ChirpStack, Payload-Decoder und LTX Microcloud steht in der [LoRaWAN-Inbetriebnahmeanleitung](../ltx_lorawan_howto/ltx_lorawan_howto.md).

Der **LTX Typ 1720** ist ein kompakter, batteriebetriebener Datenlogger für SDI-12-Sensoren. Er kombiniert LoRaWAN EU868 mit lokalem Messwertspeicher und Bluetooth Low Energy (BLE) für Service und Konfiguration vor Ort. Das schlanke 2-Zoll-Rundgehäuse eignet sich besonders für Messstellen, an denen lange Batterielaufzeit, kleine Gehäuseabmessungen und eine unabhängige lokale Datensicherung benötigt werden.

![Geöffneter LTX Typ 1720 im 2-Zoll-Rundgehäuse](../img/t1720_2zoll_rundgehaeuse.jpg)

*Beispiel des 2-Zoll-Rundgehäusekonzepts. Innenaufbau und Bestückung können je nach Geräteausführung abweichen.*

## Abgrenzung zu Typ 1820

Typ 1720 und [Typ 1820](LTX_T1820_LoRaWAN.MD) verwenden denselben LoRaWAN-Modemkern und dieselbe Software-Inbetriebnahme. Die wesentlichen Unterschiede liegen in Mechanik und Energieversorgung:

| Merkmal | Typ 1720 | Typ 1820 |
|---|---|---|
| Gehäuse | Schlankes 2-Zoll-Rundgehäuse | Größeres Polycarbonatgehäuse |
| Interne Versorgung | 1 × Lithium-D-Zelle | 6 × AA oder optional 2 × Lithium-D-Zelle |
| Externe Versorgung | Nicht als Standardversorgung vorgesehen | 5–14 V, interne Batterien können als Backup dienen |
| Typischer Einsatz | Besonders kompakte, energieoptimierte Messstelle | Flexible Versorgung, mehr Einbauraum |

## Wesentliche Merkmale

- LoRaWAN **Version 1.0.4**, Geräteklasse A
- Funkbereich **EU868**, maximale Sendeleistung 14 dBm
- bidirektionale Kommunikation über LoRaWAN
- SDI-12-Schnittstelle nach Version 1.3, auch für Low-Voltage-Sensoren
- bis zu **20 Messkanäle** als Fließkommawerte; abhängig vom Zahlenformat passen Mess- und Housekeeping-Werte in einen Uplink mit 51 Byte Nutzdaten
- lokaler Messwertspeicher, standardmäßig **8 MB**
- Ring- oder Linearspeicherbetrieb
- BLE für Konfiguration, Diagnose und lokalen Datenzugriff
- Bedienung mit der PWA [BLX Dashboard](https://github.com/joembedded/ltx_ble_demo) auf Android- und Windows-Geräten
- energieoptimierter Betrieb mit einer Lithium-D-Zelle
- Übertragung von Housekeeping-Werten wie Batteriespannung, verbrauchtem Energiebudget, interner Temperatur, interner Feuchte und barometrischem Luftdruck

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
| Speicherkapazität | typisch etwa 400.000 historische Messwerte bei 8 MB; abhängig von Kanalzahl und Datensatzgröße |
| Versorgung | 3,4–3,6 V |
| Batterie | 1 × Lithium-D-Zelle, typisch 12 Ah |
| Sensorversorgung | intern geschaltet, etwa 9 V; optional 12 V |
| Leiterplattenformat | ca. 35 mm × 115 mm |
| Gehäuse | schlankes 2-Zoll-Rundgehäuse |

## Energieversorgung und Laufzeit

Typ 1720 ist für den energieoptimierten Betrieb mit einer 3,6-V-Lithium-D-Zelle ausgelegt. Die tatsächlich erreichbare Laufzeit hängt vor allem vom Sensor, Mess- und Übertragungsintervall, LoRaWAN-Datenrate, Empfangspegel, Batteriechemie und Temperaturbereich ab.

Für stationäre Messstellen ist `ADR=1` meist sinnvoll. Bei mobilen Geräten oder stark wechselnden Funkbedingungen kann `ADR=0` geeigneter sein; Datenrate und Sendeleistung müssen dann an die Anwendung angepasst werden. `DR0` bietet in EU868 eine hohe Link-Budget-Reserve, benötigt aber deutlich mehr Airtime und Energie als höhere Datenraten. Details enthält der [Energie-Vergleich, Abschnitt „ADR bei stationären und mobilen Geräten“](../lora/energie_vergleich.md#adr-bei-stationären-und-mobilen-geräten).

Projektbezogene Laufzeitbeispiele stehen in der [Logger-Hardwareübersicht, Abschnitt „Energiebetrachtung“](logger_Zusammenfassung.md#4-energiebetrachtung--beispiel-tensiomark-3-sensoren).

## Lokale Datensicherung

Typ 1720 zeichnet Messwerte unabhängig von der Funkübertragung lokal auf. Im Ringspeicherbetrieb werden bei vollem Speicher die ältesten Datensätze überschrieben. Im Linearspeicherbetrieb endet die Aufzeichnung, wenn der Speicher vollständig belegt ist. Messdaten und Diagnoseinformationen lassen sich vor Ort per BLE mit dem BLX Dashboard abrufen.

## LoRaWAN-Funkmodul und Firmware

Das LoRa-EU868-Shield wird auch im Typ 1820 eingesetzt. Die kompakten LTX-Payloads reduzieren Funkzeit und Energiebedarf. Typ 1720 kann mit ChirpStack, The Things Stack/TTN und kompatiblen LoRaWAN-Netzbetreibern verwendet werden.

Passende Logger-Firmware: [Typ 1720 – `firmware_typ1720_ltx_loraeu868_0v4.sec`](https://joembedded.de/x3/ltx_firmware/LTX-Loggers/LTE_Logger_CPU40/Type1720_LTX_INTENT_mit_Shield_LoRaEU868/firmware_typ1720_ltx_loraeu868_0v4.sec). Vor einem Update müssen Gerätetyp und Dateiname geprüft werden; Typ 1820 benötigt eine andere Firmware. Eine typenübergreifende Liste steht in der [Firmware-Übersicht](firmware_uebersicht.md).

## Gerätespezifische Basisparameter

Die vollständige Logger-, Modem- und Serverkonfiguration ist in der [LoRaWAN-Inbetriebnahmeanleitung](../ltx_lorawan_howto/ltx_lorawan_howto.md) beschrieben. Für eine typische Lithium-D-Zelle können folgende Werte als Ausgangspunkt dienen:

| Feld in `sys_param` | Beispielwert | Bedeutung |
|---|---:|---|
| `y Bat. Capacity` | `10000` | vorsichtig angesetzte Batteriekapazität in mAh |
| `l Bat. Volts 0%` | `3.3` | Spannung für 0 % Batteriestand |
| `h Bat. Volts 100%` | `3.6` | Spannung für 100 % Batteriestand |
| `m mAmsec/Measure` | `10000` | Ausgangswert für die Basisenergie einer Messung in mA·ms |

Die entsprechenden Einzelparameter-Kommandos lauten:

```text
xsy10000
xsl3.3
xsh3.6
xsm10000
xWrite
```

> [!IMPORTANT]
> Kapazität, Spannungsschwellen und Messenergie müssen zur tatsächlich eingesetzten Batterie und zum angeschlossenen Sensor passen. Die Tabellenwerte sind vorsichtige Ausgangswerte und keine garantierte Laufzeitberechnung.

`fPort`, Messkanäle, Float16/Float32-Format, OTAA-Schlüssel und LoRaWAN-Stack werden nicht produktspezifisch eingerichtet. Dafür gelten die gemeinsame [LoRaWAN-Inbetriebnahmeanleitung](../ltx_lorawan_howto/ltx_lorawan_howto.md) und die [LoRa-Payload-Dokumentation](../lora/lora_payload.md).

## Weiterführende Dokumentation

- [LTX Typ 1820 – Hardwarevariante mit flexibler Versorgung](LTX_T1820_LoRaWAN.MD)
- [LoRaWAN-Inbetriebnahme mit TTN oder ChirpStack](../ltx_lorawan_howto/ltx_lorawan_howto.md)
- [LoRa-Payload, fPort, Einheiten und Downlinks](../lora/lora_payload.md)
- [LoRaWAN-AT-Kommandos](../lora/ltx_lora_at_kommandos.md)
- [Energie-Vergleich LoRa-Module EU868](../lora/energie_vergleich.md)
- [Logger-Hardwareübersicht](logger_Zusammenfassung.md)

---

*Kurz-Datenblatt · Stand: Juli 2026 · Technische Änderungen vorbehalten*

**Firmware- und Datenblatt-Archiv:** [https://joembedded.de/x3/ltx_firmware/index.php](https://joembedded.de/x3/ltx_firmware/index.php)
