# LTX Typ 1820 – SDI-12-Datenlogger mit LoRaWAN

[← Zur LTX-Dokumentationsübersicht](../ltx_docu_dateiliste.md)

> [!NOTE]
> Dieses Dokument beschreibt hauptsächlich die Hardware und die gerätespezifischen Einstellungen des LTX Typ 1820. Die gemeinsame Software-Inbetriebnahme mit BLX Dashboard, The Things Network (TTN) oder ChirpStack, Payload-Decoder und LTX Microcloud steht in der [LoRaWAN-Inbetriebnahmeanleitung](../ltx_lorawan_howto/ltx_lorawan_howto.md).

Der **LTX Typ 1820** ist ein batteriebetriebener Datenlogger für SDI-12-Sensoren. Er kombiniert LoRaWAN EU868 mit lokalem Messwertspeicher und Bluetooth Low Energy (BLE) für Service und Konfiguration vor Ort. Das größere Polycarbonatgehäuse bietet mehrere interne Batterieoptionen und kann zusätzlich aus einer externen Versorgung gespeist werden. Dadurch eignet sich Typ 1820 besonders für Messstellen mit flexiblem Energieversorgungskonzept.

![LTX Typ 1820 im Polycarbonatgehäuse mit LoRa-Antenne](../img/LTX_Typ1820_antenna.png)

*Beispielgerät mit transparentem Deckel und LoRa-Antenne. Innenaufbau, Anschlüsse und Bestückung können je nach Geräteausführung abweichen.*

## Abgrenzung zu Typ 1720

Typ 1820 und [Typ 1720](LTX_T1720_LoRaWAN.MD) verwenden denselben LoRaWAN-Modemkern und dieselbe Software-Inbetriebnahme. Die wesentlichen Unterschiede liegen in Mechanik und Energieversorgung:

| Merkmal | Typ 1820 | Typ 1720 |
|---|---|---|
| Gehäuse | Größeres Polycarbonatgehäuse | Schlankes 2-Zoll-Rundgehäuse |
| Interne Versorgung | 6 × AA oder optional 2 × Lithium-D-Zelle | 1 × Lithium-D-Zelle |
| Externe Versorgung | 5–14 V, interne Batterien können als Backup dienen | Nicht als Standardversorgung vorgesehen |
| Typischer Einsatz | Flexible Versorgung, mehr Einbauraum | Besonders kompakte, energieoptimierte Messstelle |

## Wesentliche Merkmale

- LoRaWAN **Version 1.0.4**, Geräteklasse A
- Funkbereich **EU868**, maximale Sendeleistung 14 dBm
- Bidirektionale Kommunikation über LoRaWAN
- SDI-12-Schnittstelle nach Version 1.3, auch für Low-Voltage-Sensoren
- bis zu **20 Messkanäle** als Fließkommawerte; abhängig vom Zahlenformat passen Mess- und Housekeeping-Werte in einen Uplink mit 51 Byte Nutzdaten
- lokaler Messwertspeicher, standardmäßig **8 MB**
- Ring- oder Linearspeicherbetrieb
- BLE für Konfiguration, Diagnose und lokalen Datenzugriff
- Bedienung mit der PWA [BLX Dashboard](https://github.com/joembedded/ltx_ble_demo) auf Android- und Windows-Geräten
- interne oder externe Versorgung mit optionaler Backup-Funktion
- Übertragung von Housekeeping-Werten wie Batteriespannung, verbrauchtem Energiebudget, interner Temperatur und interner Feuchte

## Technische Daten

| Eigenschaft | Wert |
|---|---|
| Gerätetyp | LTX Typ 1820 |
| Anwendung | Autonomer Datenlogger für SDI-12-Sensoren |
| Sensorschnittstelle | SDI-12 Version 1.3 |
| Anzahl Messkanäle | bis zu 20 |
| Messintervall | 10 bis 86.400 Sekunden, konfigurierbar |
| LoRaWAN | Version 1.0.4, Klasse A |
| Frequenzbereich | EU868, 863 bis 870 MHz |
| Sendeleistung | maximal 14 dBm |
| Nutzdaten pro Uplink | bis zu 51 Byte, abhängig von Datenrate und Netzparametern |
| Datenübertragung | zyklisch, bidirektional; ADR-Unterstützung |
| Lokale Kommunikation | Bluetooth Low Energy, ab BLE 4.2 |
| Lokaler Speicher | 8 MB Standard, bis zu 16 MB bestückbar |
| Speicherbetrieb | Ringspeicher oder linear |
| Speicherkapazität | typisch etwa 400.000 historische Messwerte bei 8 MB; abhängig von Kanalzahl und Datensatzgröße |
| Interne Versorgung | 6 × 1,5-V-AA-Zelle; optional 2 × 3,6-V-Lithium-D-Zelle |
| Externe Versorgung | 5–14 V; höhere Spannung wird priorisiert, interne Batterien können als Backup dienen, höchste Spannung wird verwendet |
| Sensorversorgung | (höchste) Versorgungsspannung durchgeschaltet  |
| Gehäuseformat (B × L × H) | ca. 75 mm × 180 mm × 60 mm |
| Antennenanschluss | N-Buchse, ausführungsabhängig |
| Gehäuse | Polycarbonat mit transparentem Deckel; je nach Ausführung bis IP68 |

## Energieversorgung und Laufzeit

Für Typ 1820 sind folgende Versorgungsvarianten vorgesehen:

- 6 × 1,5-V-AA-Alkali, nominal 9 V und typischerweise etwa 2.000 mAh;
- 6 × 1,5-V-AA-Lithium, nominal 9 V und typischerweise etwa 3.500 mAh;
- optional 2 × 3,6-V-Lithium-D-Zelle, nominal 7,2 V und typischerweise etwa 12–13 Ah;
- optional eine externe Versorgung mit 5–14 V, beispielsweise aus Akku oder Solarsystem.

Bei gleichzeitiger interner und externer Versorgung priorisiert die Hardware die höhere Spannung. Die interne Batterie kann dadurch als Backup dienen. Die tatsächlich erreichbare Laufzeit hängt vor allem vom Sensor, Mess- und Übertragungsintervall, LoRaWAN-Datenrate, Empfangspegel, Batteriechemie und Temperaturbereich ab.

Für stationäre Messstellen ist `ADR=1` meist sinnvoll. Bei mobilen Geräten oder stark wechselnden Funkbedingungen kann `ADR=0` geeigneter sein; Datenrate und Sendeleistung müssen dann an die Anwendung angepasst werden. `DR0` bietet in EU868 eine hohe Link-Budget-Reserve, benötigt aber deutlich mehr Airtime und Energie als höhere Datenraten. Details enthält der [Energie-Vergleich, Abschnitt „ADR bei stationären und mobilen Geräten“](../lora/energie_vergleich.md#adr-bei-stationären-und-mobilen-geräten).

## Lokale Datensicherung

Typ 1820 zeichnet Messwerte unabhängig von der Funkübertragung lokal auf. Im Ringspeicherbetrieb werden bei vollem Speicher die ältesten Datensätze überschrieben. Im Linearspeicherbetrieb endet die Aufzeichnung, wenn der Speicher vollständig belegt ist. Messdaten und Diagnoseinformationen lassen sich vor Ort per BLE mit dem BLX Dashboard abrufen.

## LoRaWAN-Funkmodul und Firmware

Das LoRa-EU868-Shield wird auch im Typ 1720 eingesetzt. Die kompakten LTX-Payloads reduzieren Funkzeit und Energiebedarf. Typ 1820 kann mit ChirpStack, The Things Stack/TTN und kompatiblen LoRaWAN-Netzbetreibern verwendet werden.

Passende Logger-Firmware: [Typ 1820 – `firmware_typ1820_ltx_loraeu868_0v1.sec`](https://joembedded.de/x3/ltx_firmware/LTX-Loggers/LTE_Logger_CPU40/Typ1820_LTX_BOPLA14V_mit_Shield_LoRaEU868/firmware_typ1820_ltx_loraeu868_0v1.sec). Vor einem Update müssen Gerätetyp und Dateiname geprüft werden; Typ 1720 benötigt eine andere Firmware. Eine typenübergreifende Liste steht in der [Firmware-Übersicht](firmware_uebersicht.md).

## Gerätespezifische Basisparameter

Die vollständige Logger-, Modem- und Serverkonfiguration ist in der [LoRaWAN-Inbetriebnahmeanleitung](../ltx_lorawan_howto/ltx_lorawan_howto.md) beschrieben. Für eine Ausführung mit sechs Lithium-AA-Zellen können folgende Werte als Ausgangspunkt dienen:

| Feld in `sys_param` | Beispielwert | Bedeutung |
|---|---:|---|
| `y Bat. Capacity` | `3000` | vorsichtig angesetzte Batteriekapazität in mAh |
| `l Bat. Volts 0%` | `6` | 0-%-Schwelle bei 6 × 1,0 V |
| `h Bat. Volts 100%` | `9` | 100-%-Schwelle bei 6 × 1,5 V |
| `m mAmsec/Measure` | `10000` | Ausgangswert für die Basisenergie einer Messung in mA·ms |

Die entsprechenden Einzelparameter-Kommandos lauten:

```text
xsy3000
xsl6
xsh9
xsm10000
xWrite
```

> [!IMPORTANT]
> Diese Beispielwerte gelten nicht unverändert für die optionale D-Zellen-Bestückung oder eine externe Versorgung. Batteriekapazität, Spannungsschwellen und Messenergie müssen zur tatsächlichen Bestückung und zum angeschlossenen Sensor passen.

`fPort`, Messkanäle, Float16/Float32-Format, OTAA-Schlüssel und LoRaWAN-Stack werden nicht produktspezifisch eingerichtet. Dafür gelten die gemeinsame [LoRaWAN-Inbetriebnahmeanleitung](../ltx_lorawan_howto/ltx_lorawan_howto.md) und die [LoRa-Payload-Dokumentation](../lora/lora_payload.md).

## Weiterführende Dokumentation

- [LTX Typ 1720 – kompakte Hardwarevariante](LTX_T1720_LoRaWAN.MD)
- [LoRaWAN-Inbetriebnahme mit TTN oder ChirpStack](../ltx_lorawan_howto/ltx_lorawan_howto.md)
- [LoRa-Payload, fPort, Einheiten und Downlinks](../lora/lora_payload.md)
- [LoRaWAN-AT-Kommandos](../lora/ltx_lora_at_kommandos.md)
- [Energie-Vergleich LoRa-Module EU868](../lora/energie_vergleich.md)
- [Logger-Hardwareübersicht](logger_Zusammenfassung.md)

---

*Kurz-Datenblatt · Stand: Juli 2026 · Technische Änderungen vorbehalten*

**Firmware- und Datenblatt-Archiv:** [https://joembedded.de/x3/ltx_firmware/index.php](https://joembedded.de/x3/ltx_firmware/index.php)
