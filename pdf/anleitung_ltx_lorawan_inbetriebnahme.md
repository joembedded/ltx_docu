---
title: LTX-Datenlogger über LoRaWAN in Betrieb nehmen
subtitle: Schritt-für-Schritt-Anleitung für The Things Network und ChirpStack V4
document-type: Technische Anleitung
product-code: LTX / LoRaWAN
lead: Von der Geräteparametrierung über OTAA und Payload-Codec bis zur HTTP-Integration und LTX Microcloud.
cover-image: editiert/ltx_lorawan_howto/lora_images/00_ziel_ltx_microcloud.png
date: 29. Juli 2026
version: "1.2"
toc: true
toc-depth: 1
---

Diese Anleitung führt einen LTX-Datenlogger vollständig über einen von zwei LoRaWAN-Stacks bis optional zur LTX Microcloud (oder einer anderen Datenbank).

> **Hinweis:** Der Schwerpunkt dieses Dokuments liegt auf Software, LoRaWAN-Netzwerk und Cloud-Anbindung. Produktspezifische Angaben zu Gehäuse, Energieversorgung, Speicher und Einbau stehen in den Hardwareanleitungen für [LTX Typ 1720](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/LTX_T1720_LoRaWAN.MD) und [LTX Typ 1820](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/LTX_T1820_LoRaWAN.MD).

```text
LTX-Datenlogger → LoRaWAN-Gateway → TTN oder ChirpStack → HTTP/JSON → LTX Microcloud
```

Die Geräteparametrierung und das Datenformat sind in beiden Fällen gleich. Nur die Einrichtung des LoRaWAN-Stacks unterscheidet sich. Folgen Sie deshalb zuerst dem gemeinsamen Teil und wählen Sie danach genau einen der beiden Wege:

- [Weg A: The Things Network / The Things Stack](#weg-a-the-things-network--the-things-stack)
- [Weg B: ChirpStack V4](#weg-b-chirpstack-v4)

Das Ziel ist ein erfolgreicher OTAA-Join, eine dekodierte Uplink-Payload und die Weiterleitung per Webhook beziehungsweise HTTP-Integration an die LTX Microcloud. Der LoRaWAN-Stack transportiert und dekodiert die Daten; für die dauerhafte Speicherung und Darstellung ist hier die Microcloud zuständig.

![In der LTX Microcloud dargestellte Loggerdaten](editiert/ltx_lorawan_howto/lora_images/00_ziel_ltx_microcloud.png)

*Zielbild: Mess- und Housekeeping-Werte eines LoRaWAN-Loggers in der LTX Microcloud.*

> **Hinweis:** Die Screenshots entstanden mit The Things Stack Sandbox V3 und ChirpStack V4.18.0. Bezeichnungen oder Positionen können sich in neueren Oberflächen leicht ändern. Entscheidend sind die in dieser Anleitung genannten Felder und Werte.

> **Achtung:** Alle EUIs, Schlüssel, E-Mail-Adressen, URLs und Gerätenamen in Text und Bildern sind Beispiele. Verwenden Sie ausschließlich die Werte Ihres eigenen Loggers und Ihres eigenen Servers. Root Keys und API-Schlüssel sind Geheimnisse.

# 1. Welcher Stack passt zur Anwendung?

> **Tipp:** **Kurzentscheidung:** TTN eignet sich besonders für einen schnellen Einstieg und wenige Geräte, wenn am Einsatzort bereits Community-Abdeckung vorhanden ist. ChirpStack ist meist die bessere Wahl, wenn eigene Gateways, volle Kontrolle, kommerzieller Betrieb, viele Geräte oder kürzere Übertragungsintervalle gefordert sind.

| Kriterium | The Things Network / The Things Stack (TTN) | ChirpStack V4 |
|---|---|---|
| Infrastruktur | Global organisiertes Community-Netz; vorhandene Gateways können mitgenutzt werden. Die lokale Abdeckung vorher im [TTN Mapper](https://ttnmapper.org/heatmap/) prüfen. | Eigener ChirpStack-Server und mindestens ein erreichbares eigenes Gateway sind erforderlich. |
| Kosten | Die Sandbox ist für kleine, nichtkommerzielle Tests kostenlos. Der kostenlose kommerzielle Discovery-Tarif umfasst derzeit bis zu 10 Geräte und 10 Gateways; darüber hinaus gelten kostenpflichtige Tarife. | Die Open-Source-Software ist auch kommerziell kostenlos. Kosten entstehen für Server, Gateways, Wartung und Betrieb; für kleine Installationen genügt meist ein günstiger VServer. |
| Funkverkehr | Die Community-Fair-Use-Policy begrenzt pro Gerät und 24 Stunden die Uplink-Airtime auf 30 Sekunden sowie die Zahl der Downlinks auf 10. | Keine zusätzliche ChirpStack-Kontingentgrenze; maßgeblich bleiben die gesetzlichen Funkvorgaben, insbesondere Duty Cycle und Sendeleistung. |
| Kontrolle und Skalierung | Plattformbetrieb, Community-Abdeckung und Nutzungsregeln werden übernommen; gut für Versuche und kleine Installationen. | Volle Kontrolle über Server, Gateways, Mandanten und Daten. Je nach Serverauslegung lassen sich auch Flotten mit vielen Tausend Geräten verwalten. |
| Einrichtungsaufwand | Schnell eingerichtet; bei ausreichender lokaler Abdeckung ist häufig kein eigenes Gateway nötig. | Server, Gateway-Anbindung, Updates, Datensicherung und Betrieb liegen in eigener Verantwortung. Die Installation ist mit den bereitgestellten Paketen beziehungsweise Containern gut automatisierbar. |

**Praktische Folgen für die Geräteparametrierung:**

- Bei TTN können lange Pakete und ungünstige Datenraten die zulässige Airtime schnell ausschöpfen. Für schlechte Funkbedingungen sollte deshalb eher mit Übertragungsintervallen von 30 Minuten oder länger kalkuliert werden. Ein Messintervall von 10 Minuten ist nur ein Konfigurationsbeispiel und nicht automatisch TTN-tauglich.
- Bei ChirpStack sind - sofern Airtime, Duty Cycle und Netzkapazität es zulassen - deutlich kürzere Intervalle möglich. Bei einer guten Verbindung und beispielsweise `DR:5` kann auch eine Übertragung pro Minute praktikabel sein.
- `ADR=1` ist für stationäre Geräte mit hinreichend stabiler Funkstrecke in der Regel sinnvoll, weil jeder LoRaWAN-Network-Server Datenrate, Sendeleistung und `NbTrans` optimieren kann. Wertebereich und Regelstrategie für `NbTrans` hängen vom Stack ab; beim aktuellen ChirpStack-Standardalgorithmus liegt der mögliche Bereich bei `1...3`. Diese ADR-/`NbTrans`-Strategie ist eine Design-Entscheidung beim Server-Setup und muss zum Energie- und Zuverlässigkeitsziel der Anwendung passen.

> **Hinweis:** Die Registrierung erfolgt über [thethingsnetwork.org](https://www.thethingsnetwork.org/). Ob eine Zahlungsmethode verlangt wird, kann vom gewählten Tarif und vom Kontotyp abhängen. Bei privaten E-Mail-Adressen ist für die Sandbox üblicherweise keine Zahlungsmethode erforderlich; der Registrierungsablauf kann sich jedoch ändern.

Tarife und Gerätegrenzen können sich ändern. Maßgeblich sind die [aktuelle Sandbox-Beschreibung](https://www.thethingsindustries.com/docs/concepts/ttn/), die [Tarifübersicht](https://www.thethingsindustries.com/stack/plans/) und die [Fair-Use-Policy](https://www.thethingsnetwork.org/forum/t/the-things-network-fair-use-policy/47689).

# 2. Voraussetzungen

Vor Beginn benötigen Sie:

- einen LoRaWAN-fähigen LTX-Datenlogger, beispielsweise [Typ 1720](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/LTX_T1720_LoRaWAN.MD) oder den in den Screenshots verwendeten [Typ 1820](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/LTX_T1820_LoRaWAN.MD);
- die passende und aktuelle Logger- sowie LoRa-Modem-Firmware;
- die PWA [BLX Dashboard](https://github.com/joembedded/ltx_ble_demo) oder einen gleichwertigen BLE-Terminalzugang;
- ein EU868-LoRaWAN-Gateway in Funkreichweite (ein eigenes für ChirpStack beziehungsweise lokale TTN-Abdeckung für The Things Network);
- einen TTN-/The-Things-Stack-Zugang **oder** eine betriebsbereite ChirpStack-V4-Installation;
- den [LTX Payload Decoder](https://github.com/joembedded/payload-decoder);
- optional eine erreichbare LTX-Microcloud-Installation und deren Geräte-API-Key;


Für ChirpStack muss das Gateway bereits mit der richtigen Region am Server arbeiten. Die offizielle Anleitung [Connecting a device](https://www.chirpstack.io/docs/guides/connect-device.html) setzt dies ebenfalls voraus.

# 3. Gemeinsame Vorbereitung des LTX-Loggers

Dieser Abschnitt gilt unverändert für beide Stacks.

## 3.1 Beispielmessung konfigurieren

Das Beispiel liest über einen '433-MHz-zu-SDI-12-Sammler' eine Temperatur und die Signalstärke ein. Kanal 0 (der Temperaturwert) wird hochauflösend als Float32, Kanal 1 (die weniger wichtige Signalstärke) platzsparend als Float16 übertragen.

### Messkanäle

| Parameter | Kanal `#0`: Temperatur | Kanal `#1`: Signalstärke |
|---|---:|---:|
| `Action` | `1` - messen und Cache füllen | `3` - messen, Wert aus Cache verwenden |
| `Physkan` | `768` - SDI-12 | vom Sammelkanal vorgegeben |
| `Src_index` | `0` | `1` |
| `Unit` | `°C` | `Sig` |
| `Mem_format` | `2` - Float32, lokale Anzeige mit 2 Stellen | `128` - Float16, keine lokale Nachkommastelle |
| `Messbits` | `160`, siehe Datenblatt des 433-MHz-zu-SDI-12-Konverters | wie vom Sammelkanal vorgegeben |
| `Xbytes` | `0M` | leer beziehungsweise gerätespezifisch |

Für LoRaWAN entscheidet bei `Mem_format` das Bit mit dem Wert `128` über Float16. Ohne dieses Bit wird Float32 übertragen. Details stehen in der [LTX LoRa-Payload-Dokumentation](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/lora_payload.md) und in der [LTX-Parameter-Referenz](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_parameter/ltx_parameter_referenz.md).

### Allgemeine Parameter

| Parameter | Beispielwert | Bedeutung |
|---|---:|---|
| `Period` | `600` | alle 600 Sekunden messen |
| `Period_Internet_sec` | `0` | jeden neuen Messwert übertragen |
| `HK_reload` | `6` | bei jeder sechsten Messung Housekeeping-Werte ergänzen |
| `MinTemp_oC` | `-40` | minimale Betriebstemperatur für die Konfiguration |
| `Config0_U31` | vorübergehend `0` | ausführlichere LoRaWAN-Ausgabe während der Inbetriebnahme |
| `Service Parameter → Sysparam → p Port` | `1` | LoRaWAN-Uplink-`fPort` des Beispiels |

Der Uplink-`fPort` steuert zugleich das Einheitenschema des Payload-Decoders. `1` bis `9` sind frei beziehungsweise kundenspezifisch; bekannte Standards sind beispielsweise:

| fPort | Einheitengruppe |
|---:|---|
| `10` | Temperatur, `°C` |
| `11` | Feuchte/Temperatur, `%rH`, `°C` |
| `12` | Druck/Temperatur, `Bar`, `°C` |
| `13` | Pegel/Temperatur, `m`, `°C` |
| `14` | Radar, `m`, `dBm` |
| `15` | Leitfähigkeit, `°C`, `uS/cm` |

Setzen Sie also nicht blind `1` (da ohne Einheiten), sondern einen zur Messaufgabe passenden Typ. Per Terminal (oder später remote) lautet das Kommando beispielsweise:

```text
xsp14
xWrite
```

Bei lokaler Eingabe speichert `xWrite` die Änderung dauerhaft. Ausführliche Beispiele enthält der Abschnitt [Typ/FPort am Logger einstellen](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/lora_payload.md#typfport-am-logger-einstellen).


> **Hinweis:** Im JavaScript-Code des Payload-Codecs können auch eigene Einheitensysteme hinterlegt werden.

## 3.2 LoRa-Modem prüfen und für EU868 initialisieren

Öffnen Sie das Terminal im BLX Dashboard und setzen Sie das Modem zurück:

```text
@$res
```

Die Ausgabe zeigt Modemtyp, Firmware, Device EUI und die gespeicherten Werte für ADR und Datenrate. Fehlen Presets oder stimmt die Device EUI nicht mit der MAC des Loggers überein, initialisieren Sie das Modem für EU868:

```text
@$initeu868
```

Danach lesen Sie die OTAA-Daten aus:

```text
@$info
```

Notieren Sie diese drei Werte exakt:

| LTX-Ausgabe | Bedeutung | Eingabe im Stack |
|---|---|---|
| `DEUI` | Device EUI, normalerweise identisch mit der Logger-MAC | `DevEUI` beziehungsweise `Device EUI` |
| `APPEUI` | Application EUI / Join EUI | `JoinEUI` beziehungsweise `Join EUI` |
| `NWKKEY` | OTAA Root Key bei LoRaWAN 1.0.x | `AppKey` beziehungsweise `Application key` |

Die hier beschriebenen LTX-Logger werden per **OTAA** aktiviert und arbeiten als LoRaWAN-**Klasse-A-Geräte**.

Beispiel einer Statusausgabe, Werte hier absichtlich verkürzt:

```text
DEUI:   C4:C9:…:39:72
APPEUI: 4A:0D:…:68:C7
NWKKEY: EE:1B:…:C2:BA
DataRate DR:0
Autom. DR Reduction ADR:1
No active Join
No Network!
```

`No active Join` und `No Network!` sind vor der Registrierung normal.

> **Warnung:** `@AT+RFS` löscht Modemkonfiguration, gespeicherten Join-Kontext und Nonces. Verwenden Sie es nur bewusst. Danach müssen die OTAA-Daten erneut gesetzt und die verwendeten DevNonces auch auf dem Server zurückgesetzt werden; andernfalls kann der nächste Join als Replay abgewiesen werden.

Wenn Keys wegen eines gespeicherten Join-Kontexts nicht geändert werden können:

```text
@AT+RFS
@$initeu868
@$info
```

Alternativ kann es genügen, das Gerät für einige Minuten vollständig stromlos zu machen. Manuell geänderte Modemparameter werden mit folgendem Befehl gespeichert:

```text
@AT+SAVECFG
```

Die vollständigen Befehle und Nebenwirkungen sind in der [LTX-LoRaWAN-AT-Referenz](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/ltx_lora_at_kommandos.md) sowie in der [LTX-Logger-Kommando-Referenz](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_kommandos/LTX_Kommandos.md) beschrieben.

## 3.3 ADR, `NbTrans` und Datenrate festlegen

Die ADR-/`NbTrans`-Strategie ist nicht nur eine Geräteeinstellung, sondern eine Design-Entscheidung beim Setup und Betrieb des Network Servers. Legen Sie sie je Anwendung beziehungsweise Geräteprofil fest und dokumentieren Sie das gewünschte Verhältnis zwischen automatischer Funkoptimierung, Zustellwahrscheinlichkeit und vorhersehbarem Energiebedarf.

| Betriebsziel | Geräteeinstellung | Folge für Server und Betrieb |
|---|---|---|
| automatische Optimierung bei stationärer, stabiler Funkstrecke | `ADR=1` | Jeder LoRaWAN-Network-Server darf Datenrate, Sendeleistung und `NbTrans` über `LinkADRReq` ändern. Wertebereich und Regelstrategie sind stackabhängig; beim aktuellen ChirpStack-Standardalgorithmus gilt `1...3`. |
| vorhersehbares Energiebudget | `ADR=0`, erprobte feste Datenrate | Die Firmware verwendet für `NbTrans` immer den Default `1`; der Server optimiert die Funkparameter nicht mehr automatisch. Die fehlende Wiederholung spart Energie, kann aber die Zustellwahrscheinlichkeit verringern. |
| mobile oder schnell wechselnde Funkbedingungen | häufig `ADR=0`, anwendungsgerecht gewählte Datenrate und Sendeleistung | Eine am vorherigen Standort optimierte Einstellung wird vermieden. Die Anwendung trägt die Verantwortung für robuste Funkparameter. |

`NbTrans` bezeichnet die Gesamtzahl der Übertragungen je Uplink-Frame. Werden alle Übertragungen ausgeführt, können `NbTrans=3` gegenüber `NbTrans=1` die Funk-Airtime und die Energie des Sende-/Empfangszyklus bei gleicher Datenrate näherungsweise verdreifachen. Bei `ADR=1` kann jeder LoRaWAN-Stack den Wert zugunsten der Zustellwahrscheinlichkeit verändern. Der konkrete Wertebereich ist eine Implementierungsentscheidung des Stacks; der aktuelle ChirpStack-Standard-ADR-Algorithmus regelt `NbTrans` anhand erkannter Paketverluste im Bereich `1...3`.

Bei `ADR=0` verwendet die Firmware für `NbTrans` immer den Default `1`. Das Kommando `AT+NBTRANS=X` mit `X=1...15` ist nur für Tests implementiert. Der damit gesetzte Wert wird nicht gespeichert und steht nach einem Reset wieder auf `1`; auch `AT+SAVECFG` macht diese Testeinstellung nicht persistent.

`DR0` bietet in EU868 eine große Link-Budget-Reserve, benötigt aber deutlich mehr Airtime und Energie als höhere Datenraten. Wählen Sie bei einer festen Konfiguration die höchste Datenrate, die am Einsatzort noch ausreichend zuverlässig funktioniert.

Beispiel für eine bewusst feste Konfiguration; `NbTrans=1` ergibt sich bei `ADR=0` automatisch:

```text
@AT+ADR=0
@AT+DR=3
@AT+SAVECFG
```

Kontrollieren Sie den aktuell wirksamen Wert mit `AT+NBTRANS=?` oder im Feld `N:` von `AT+XSTATE=?`. Für TTN sollte bei stationären Geräten bevorzugt ADR aktiv sein; bei einem eigenen ChirpStack-Server ist die Auswahl des ADR-Algorithmus Teil des Geräteprofil-Designs. Hintergründe, Messwerte und Befehlsdetails finden Sie im [Energie-Vergleich LoRa-Module EU868](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/energie_vergleich.md) und in der [LTX-LoRaWAN-AT-Referenz](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/ltx_lora_at_kommandos.md#atnbtrans--anzahl-der-uplink-übertragungen).

\clearpage

# Weg A: The Things Network / The Things Stack {#weg-a-the-things-network--the-things-stack}

Die folgenden Schritte bilden eine vollständige TTN-Einrichtung ab: Konto und Cluster, Anwendung, Endgerät, Payload-Formatter, Webhook und Test.

## A1. Anmelden und Cluster wählen

1. Öffnen Sie [thethingsnetwork.org](https://www.thethingsnetwork.org/) und melden Sie sich mit Ihrer The Things ID an oder registrieren Sie ein Konto.
2. Öffnen Sie die Console.
3. Wählen Sie den Cluster für den Standort des Geräts. Für Deutschland ist im gezeigten Sandbox-Setup `Europe 1 (eu1)` vorgesehen.

![Anmeldung mit The Things ID](editiert/ltx_lorawan_howto/lora_images/01_ttn_anmeldung.png)

*Anmeldung an der The-Things-ID-Seite. Verwenden Sie Ihr eigenes Konto und ein starkes Passwort.*

![Auswahl des europäischen TTN-Clusters](editiert/ltx_lorawan_howto/lora_images/02_ttn_cluster_europa.png)

*Für Geräte in Deutschland den empfohlenen europäischen Cluster wählen. Anwendung, Gerät und spätere API-Endpunkte müssen zum selben Cluster gehören.*

## A2. Anwendung anlegen

1. Klicken Sie in der Console auf **Add application**.
2. Vergeben Sie eine eindeutige `Application ID`, zum Beispiel `ltx-test`.
3. Name und Beschreibung sind optional, aber für den späteren Betrieb empfehlenswert.
4. Klicken Sie auf **Create application**.

![TTN: neue Anwendung hinzufügen](editiert/ltx_lorawan_howto/lora_images/03_ttn_anwendung_hinzufuegen.png)

*Eine Anwendung gruppiert die LTX-Endgeräte und deren Integrationen.*

![TTN: Anwendungs-ID und Beschreibung eingeben](editiert/ltx_lorawan_howto/lora_images/04_ttn_anwendung_anlegen.png)

*Die Application ID wird Bestandteil interner Bezeichner und sollte kurz, eindeutig und dauerhaft sein.*

## A3. Endgerät manuell registrieren

1. Öffnen Sie die Anwendung und wählen Sie **Add end device**.
2. Wählen Sie **Enter end device specifics manually**.
3. Stellen Sie ein:
   - Frequency plan: `Europe 863-870 MHz (SF9 for RX2 - recommended)`;
   - LoRaWAN version: `LoRaWAN Specification 1.0.4`;
   - Regional Parameters: `RP002 Regional Parameters 1.0.4`;
   - Activation mode: `OTAA` und Geräteklasse `A`.
4. Übernehmen Sie anschließend die Werte aus `@$info`:

| LTX | TTN-Feld |
|---|---|
| `APPEUI` | `JoinEUI` |
| `DEUI` | `DevEUI` |
| `NWKKEY` | `AppKey` |

5. Vergeben Sie eine eindeutige `End device ID`, zum Beispiel `testlogger`.
6. Klicken Sie auf **Register end device**.

![TTN: Gerät manuell mit EU868 und LoRaWAN 1.0.4 anlegen](editiert/ltx_lorawan_howto/lora_images/05_ttn_geraetetyp.png)

*Manuelle Registrierung mit dem zum LTX-Modem passenden Frequenzplan und der LoRaWAN-Version 1.0.4.*

![TTN: JoinEUI, DevEUI und AppKey aus dem Logger übernehmen](editiert/ltx_lorawan_howto/lora_images/06_ttn_geraeteschluessel.png)

*Die Feldnamen unterscheiden sich von der LTX-Ausgabe. Doppelpunkte und Leerzeichen sind in der TTN-Oberfläche unkritisch, sofern der Wert vollständig übernommen wird.*

## A4. Uplink-Decoder einrichten und testen

1. Öffnen Sie beim Endgerät **Payload formatters → Uplink**.
2. Wählen Sie `Custom Javascript formatter`.
3. Kopieren Sie den vollständigen Inhalt von [`payload_ltx_clean.js`](https://github.com/joembedded/payload-decoder/blob/master/payload_ltx_clean.js) in das Codefeld.
4. Speichern Sie den Formatter.

![TTN: LTX-Uplink-Decoder als Custom JavaScript Formatter](editiert/ltx_lorawan_howto/lora_images/07_ttn_uplink_codec.png)

*Der bereinigte Decoder enthält keinen lokalen Test-Console-Block und ist deshalb für die Console geeignet.*

Testen Sie den Decoder direkt in der Oberfläche:

```text
Byte payload:
12 42 4D 24 4C E4 01 41 94 8F 5C 88 35 5B

FPort:
1
```

Als erste beiden Kanäle sollten ungefähr `20.5625` und `19.5625` erscheinen. Bei `fPort 1` werden keine Standard-Einheiten ergänzt.

![TTN: Uplink-Decoder mit Beispiel-Payload testen](editiert/ltx_lorawan_howto/lora_images/08_ttn_uplink_test.png)

*Ein gültiger Test bestätigt Syntax und grundlegende Dekodierung, ersetzt aber noch keinen Funk-Uplink.*

## A5. Downlink-Encoder einrichten und testen

Downlinks sind für die reine Messdatenübertragung nicht erforderlich, ermöglichen aber spätere Parameterkommandos an den Logger.

1. Öffnen Sie **Payload formatters → Downlink**.
2. Wählen Sie `Custom Javascript formatter`.
3. Kopieren Sie den vollständigen Inhalt von [`paydown_ltx.js`](https://github.com/joembedded/payload-decoder/blob/master/paydown_ltx.js) in das Codefeld.
4. Speichern Sie den Formatter.

![TTN: LTX-Downlink-Encoder einrichten](editiert/ltx_lorawan_howto/lora_images/09_ttn_downlink_codec.png)

*TTN verwaltet Uplink- und Downlink-Code in zwei getrennten Feldern.*

Testobjekt:

```json
{ "cmd": "p 300" }
```

Verwenden Sie für LTX-Kommandos `fPort 10`. Der Teststring ist nur ein Encoder-Beispiel; produktive Downlinks sind normalerweise kurze `x...`-Parameterkommandos aus der LTX-Kommando-Referenz.

![TTN: Downlink-Encoder mit einem Beispielkommando testen](editiert/ltx_lorawan_howto/lora_images/10_ttn_downlink_test.png)

*Der Encoder wandelt den Kommando-String in ASCII-Bytes um. Downlinks sparsam verwenden.*

## A6. Webhook zur LTX Microcloud anlegen

Die LTX Microcloud unterstützt die JSON-Formate von TTN V3 und ChirpStack V4 über denselben Endpunkt:

```text
https://SERVER/ltx/sw/lxu_ltxlora_v1.php?KEY=GERAETE_API_KEY
```

Für die von JoEmbedded bereitgestellte LTX Microcloud lautet das Schema:

```text
https://joembedded.de/ltx/sw/lxu_ltxlora_v1.php?KEY=IHR_GERAETE_API_KEY
```

Den gültigen Schlüssel erhalten Sie vom Betreiber. Für eine eigene Installation ersetzen Sie Host, Installationspfad und Key entsprechend.

Der `GERAETE_API_KEY` entspricht bei einer Standardinstallation dem `D_API_KEY` aus `sw/conf/api_key.inc.php` beziehungsweise einem individuell für das Gerät freigeschalteten Schlüssel.

1. Öffnen Sie in der Anwendung **Integrations → Webhooks**.
2. Fügen Sie einen **Custom webhook** hinzu.
3. Vergeben Sie eine `Webhook ID`, zum Beispiel `ltx-microcloud`.
4. Wählen Sie `JSON`.
5. Tragen Sie die vollständige HTTPS-URL als `Base URL` ein.
6. Lassen Sie die Event-Pfade leer, damit die Base URL unverändert aufgerufen wird.
7. Aktivieren Sie mindestens **Uplink message**. **Join accept** kann zusätzlich aktiviert werden und erleichtert die Diagnose.
8. Lassen Sie `Downlink API key` leer, solange Ihr eigener Endpunkt keine TTN-Downlinks plant. Dieses TTN-Feld ist **nicht** der LTX-`D_API_KEY`; der LTX-Key steht als `KEY=` in der Base URL.
9. Speichern Sie den Webhook.

![TTN: JSON-Webhook zur LTX Microcloud](editiert/ltx_lorawan_howto/lora_images/11_ttn_webhook.png)

*Die Microcloud-URL erhält den Geräte-API-Key als Query-Parameter. Im Produktivbetrieb ausschließlich HTTPS verwenden und Screenshots mit echten Schlüsseln vermeiden.*

Filtern Sie beim ersten Test keine JSON-Felder heraus. Der Endpunkt benötigt unter anderem Gerätekennung, Zeit, `uplink_message`, dekodierte Payload und Empfangsmetadaten. Die offizielle Beschreibung der Felder finden Sie unter [Creating Webhooks](https://www.thethingsindustries.com/docs/integrations/webhooks/creating-webhooks/).

## A7. Übertragung auslösen und in TTN prüfen

Starten Sie im BLX-Terminal eine manuelle Übertragung:

```text
i
```

Die erste Übertragung führt bei einem neuen Gerät zunächst den OTAA-Join aus. Eine erfolgreiche Ausgabe endet beispielsweise mit:

```text
LoRa-Transfer (verified) OK (DR:0)
```

![Manuelle LoRaWAN-Übertragung mit dem Kommando i](editiert/ltx_lorawan_howto/lora_images/12_ttn_logger_testuebertragung.png)

*Das Kommando `i` sendet manuell Mess- und Housekeeping-Daten. Im Diagnosebetrieb sind mehr Details sichtbar als im CE-konformen Dauerbetrieb.*

Öffnen Sie anschließend beim Gerät **Live data** und wählen Sie den Uplink. Kontrollieren Sie:

- ein Join- und danach ein Uplink-Ereignis;
- `decoded_payload.chans` mit den erwarteten Kanälen;
- `f_port` passend zur Logger-Konfiguration;
- keine `as.webhook.fail`-Ereignisse.

![TTN Live Data mit dekodierten LTX-Kanälen](editiert/ltx_lorawan_howto/lora_images/13_ttn_live_data.png)

*Die sichtbaren Kanäle 0, 1 sowie 90 bis 93 zeigen, dass Uplink-Decoder und Housekeeping-Daten funktionieren.*

Prüfen Sie danach die LTX Microcloud. Ein neuer Logger wird vom LTX-Endpunkt anhand seiner DevEUI/MAC zugeordnet beziehungsweise bei zulässigem API-Key angelegt.

## A8. DevNonces nur nach einem Modem-Reset zurücksetzen

Wenn am Logger `@AT+RFS` ausgeführt wurde, müssen auch die auf TTN gespeicherten DevNonces zurückgesetzt werden. Öffnen Sie die erweiterten Join-/Geräteeinstellungen und verwenden Sie **Reset used DevNonces**. Die Option, Nonce-Resets dauerhaft zu erlauben, sollte nur während einer kontrollierten Wiederinbetriebnahme aktiv sein.

![TTN: verwendete DevNonces zurücksetzen](editiert/ltx_lorawan_howto/lora_images/14_ttn_nonces_zuruecksetzen.png)

*Geräte- und Serverzustand müssen zusammenpassen. Nonces ohne Anlass zurückzusetzen schwächt den Replay-Schutz.*

Damit ist Weg A abgeschlossen. Fahren Sie mit [Gemeinsamer Abschluss und Dauerbetrieb](#4-gemeinsamer-abschluss-und-dauerbetrieb) fort.

\clearpage

# Weg B: ChirpStack V4

Die folgenden Schritte bilden dieselbe Kette für ChirpStack ab: Anwendung, Geräteprofil, Endgerät, Payload-Codec, HTTP-Integration und Test.

## B1. Anwendung anlegen

1. Melden Sie sich an Ihrer ChirpStack-V4-Instanz an.
2. Wählen Sie den richtigen Tenant.
3. Öffnen Sie **Applications → Add application**.
4. Vergeben Sie einen Namen, zum Beispiel `ltx-test`, und klicken Sie auf **Submit**.

![ChirpStack: Anwendung für LTX-Logger anlegen](editiert/ltx_lorawan_howto/lora_images/20_chirpstack_anwendung.png)

*Eine ChirpStack-Anwendung gruppiert die Endgeräte und die gemeinsame HTTP-Integration.*

## B2. Geräteprofil anlegen

Öffnen Sie beim Tenant **Device Profiles → Add device profile**. Verwenden Sie für die gezeigte LTX-Firmware:

| Feld | Einstellung |
|---|---|
| Name | zum Beispiel `LTX Profile` |
| Region | `EU868` |
| MAC version | `LoRaWAN 1.0.4` |
| Regional parameters revision | `RP002-1.0.5` wie im getesteten ChirpStack-Setup |
| ADR algorithm | `Default ADR algorithm (LoRa only)` |
| Join | OTAA, Klasse A; Class B und Class C nicht aktivieren |
| Expected uplink interval | tatsächliches Sendeintervall des Loggers, im Beispiel `600` Sekunden |

Der Screenshot zeigt bei `Expected uplink interval` noch `3600`. Übernehmen Sie dort die reale Konfiguration und nicht blind den Bildwert.

> **Wichtig:** Die Auswahl des ADR-Algorithmus ist eine bewusste Server-Designentscheidung. Grundsätzlich kann jeder LoRaWAN-Stack bei `ADR=1` neben Datenrate und Sendeleistung auch `NbTrans` anpassen. Der aktuelle ChirpStack-Standardalgorithmus `Default ADR algorithm (LoRa only)` regelt `NbTrans` bei Paketverlusten im Bereich `1...3`. Überwachen Sie daher bei `ADR=1` den wirksamen Wert. Wird für das Energiebudget zwingend `NbTrans=1` benötigt, ist nach Funkmessungen eine feste Gerätekonfiguration mit `ADR=0` und einer ausreichend zuverlässigen Datenrate die passende Alternative; `NbTrans` steht dann immer auf dem Default `1`, die fehlende Wiederholung kann aber die Zustellwahrscheinlichkeit reduzieren. `AT+NBTRANS=X` ist lediglich ein flüchtiger Testbefehl und nach einem Reset wieder auf `1` gesetzt.

![ChirpStack: EU868-Geräteprofil mit LoRaWAN 1.0.4](editiert/ltx_lorawan_howto/lora_images/21_chirpstack_profil.png)

*Region, MAC-Version und Regional Parameters müssen zur Gerätefirmware und zur Server-Region passen.*

## B3. Gemeinsamen Up-/Downlink-Codec einrichten

ChirpStack hat im Geräteprofil ein gemeinsames JavaScript-Codefeld für beide Richtungen. Stellen Sie unter **Payload codec** `JavaScript functions` ein und setzen Sie den Inhalt in dieser Reihenfolge zusammen:

1. vollständiger Inhalt von [`payload_ltx_clean.js`](https://github.com/joembedded/payload-decoder/blob/master/payload_ltx_clean.js);
2. direkt dahinter der vollständige Inhalt von [`paydown_ltx.js`](https://github.com/joembedded/payload-decoder/blob/master/paydown_ltx.js).

Danach speichern Sie das Geräteprofil mit **Submit**.

![ChirpStack: gemeinsamer JavaScript-Codec für Up- und Downlink](editiert/ltx_lorawan_howto/lora_images/22_chirpstack_codec.png)

*Anders als TTN verwendet ChirpStack nur ein Codec-Feld. Deshalb werden Uplink-Decoder und Downlink-Encoder zusammengefügt.*

Die genaue Plattformzuordnung und Testbeispiele stehen in der [deutschen README des Payload-Decoders](https://github.com/joembedded/payload-decoder/blob/master/readme_de.md).

## B4. Endgerät registrieren

1. Öffnen Sie **Applications → ltx-test → Add device**.
2. Vergeben Sie einen Namen, zum Beispiel `ltx-test-logger`.
3. Übernehmen Sie die Werte aus `@$info` ohne Doppelpunkte und Leerzeichen:

| LTX | ChirpStack-Feld | Länge |
|---|---|---:|
| `DEUI` | `Device EUI (EUI64)` | 16 Hex-Zeichen |
| `APPEUI` | `Join EUI (EUI64)` | 16 Hex-Zeichen |
| zuvor angelegtes Profil | `Device profile` | - |

4. Lassen Sie **Device is disabled** ausgeschaltet.
5. Lassen Sie **Disable frame-counter validation** ausgeschaltet. Diese Schutzfunktion ist bei einem korrekt arbeitenden OTAA-Gerät nicht zu deaktivieren.
6. Klicken Sie auf **Submit**.

![ChirpStack: Device EUI, Join EUI und Profil zuordnen](editiert/ltx_lorawan_howto/lora_images/23_chirpstack_geraet.png)

*Die EUIs werden in ChirpStack als zusammenhängende Hex-Zeichen eingegeben. Eine rote Validierungsmeldung muss vor dem Speichern verschwunden sein.*

Öffnen Sie danach beim Gerät **OTAA keys** und tragen Sie den LTX-`NWKKEY` als **Application key** ein. Bei LoRaWAN 1.0.x wird kein separater Network Key benötigt. Speichern Sie mit **Submit**.

![ChirpStack: NWKKEY als OTAA Application key eintragen](editiert/ltx_lorawan_howto/lora_images/24_chirpstack_appkey.png)

*Der Application Key besteht aus genau 32 Hex-Zeichen. Keine Doppelpunkte, Leerzeichen oder abgeschnittenen Zeichen übernehmen.*

Die offizielle ChirpStack-Dokumentation erläutert die Rollen von [Device Profiles](https://www.chirpstack.io/docs/chirpstack/features/device-profile.html) und [OTAA Devices](https://www.chirpstack.io/docs/chirpstack/use/devices.html).

## B5. HTTP-Integration zur LTX Microcloud anlegen

1. Öffnen Sie **Applications → ltx-test → Integrations**.
2. Fügen Sie eine **HTTP integration** hinzu.
3. Wählen Sie `JSON` als Payload encoding.
4. Tragen Sie als Event endpoint URL ein:

```text
https://SERVER/ltx/sw/lxu_ltxlora_v1.php?KEY=GERAETE_API_KEY
```

5. Zusätzliche Header sind für die Standard-LTX-Microcloud nicht erforderlich.
6. Speichern Sie mit **Submit**.

![ChirpStack: HTTP-Integration zur LTX Microcloud](editiert/ltx_lorawan_howto/lora_images/25_chirpstack_http_integration.png)

*ChirpStack sendet Ereignisse als HTTP POST. Die LTX Microcloud erkennt das ChirpStack-V4-JSON und verarbeitet die dekodierte Payload.*

Die offizielle [ChirpStack-HTTP-Dokumentation](https://www.chirpstack.io/docs/chirpstack/integrations/http.html) beschreibt die Events und den automatisch ergänzten Query-Parameter `event`.

## B6. Übertragung auslösen und Join prüfen

Starten Sie wie bei TTN im BLX-Terminal:

```text
i
```

![Manuelle LoRaWAN-Übertragung mit dem Kommando i](editiert/ltx_lorawan_howto/lora_images/26_chirpstack_logger_testuebertragung.png)

*Derselbe Loggerbefehl wird unabhängig vom gewählten LoRaWAN-Stack verwendet.*

Für eine ausführliche, vorübergehende Diagnose:

```text
@$dbg 1
i
```

Im dokumentierten Test meldete der Logger beim ersten Versuch `JOIN_FAILED`, obwohl ChirpStack bereits `JoinRequest` und `JoinAccept` zeigte:

![Erster ChirpStack-Joinversuch mit JOIN_FAILED am Logger](editiert/ltx_lorawan_howto/lora_images/27_chirpstack_erster_join_fehler.png)

*Der Server hat die Anfrage möglicherweise verarbeitet, der Logger aber den Downlink nicht sicher empfangen. Das ist ein Hinweis auf den Downlink-Pfad und kein Beleg für falsche Uplink-Funktion.*

Kontrollieren Sie unter **LoRaWAN frames**, ob `JoinRequest` und `JoinAccept` sichtbar sind:

![ChirpStack zeigt JoinRequest und JoinAccept](editiert/ltx_lorawan_howto/lora_images/28_chirpstack_join_frames.png)

*Sind beide Frames vorhanden, hat der Server den Join akzeptiert und an ein Gateway zum Downlink übergeben.*

Warten Sie kurz und lösen Sie einmalig einen zweiten Transfer aus. Im gezeigten Test war dieser erfolgreich. Schalten Sie den Debugmodus danach sofort wieder aus:

```text
@$dbg 0
i
```

![Zweiter ChirpStack-Transfer erfolgreich und Debugmodus aus](editiert/ltx_lorawan_howto/lora_images/29_chirpstack_zweiter_transfer.png)

*`LoRa-Transfer (verified) OK` bestätigt den verifizierten Transfer. Wiederholte Join-Fehler erfordern Fehlersuche und nicht beliebig viele schnelle Join-Versuche.*

## B7. Uplinks und dekodierte Daten prüfen

Öffnen Sie beim Gerät **Events**. Kontrollieren Sie:

- fortlaufende `FCnt`-Werte;
- den erwarteten `FPort`;
- Frames mit Messdaten und in den vorgesehenen Abständen zusätzliche HK-Werte;
- eine zur Funkplanung passende Datenrate.

![ChirpStack-Eventliste mit FCnt, FPort und Rohdaten](editiert/ltx_lorawan_howto/lora_images/30_chirpstack_eventliste.png)

*Die Payload mit Housekeeping ist länger als ein reiner Messwert-Uplink. Der Frame Counter muss bei neuen Uplinks steigen.*

Öffnen Sie einen `up`-Event. Unter `object` müssen die vom Codec erzeugten Messkanäle erscheinen:

![ChirpStack zeigt dekodierte LTX-Mess- und HK-Kanäle](editiert/ltx_lorawan_howto/lora_images/31_chirpstack_decodierte_daten.png)

*Im Beispiel sind Kanal 0 und 1 sowie die Housekeeping-Kanäle 90 bis 93 dekodiert.*

Prüfen Sie danach die LTX Microcloud. Sind die Daten in ChirpStack dekodiert, aber nicht in der Microcloud sichtbar, liegt der Fehler typischerweise in URL, API-Key, HTTPS-Erreichbarkeit oder HTTP-Antwort.

## B8. DevNonces nur nach einem Modem-Reset zurücksetzen

Wenn am Logger `@AT+RFS` ausgeführt wurde und ChirpStack `DevNonce has already been used` meldet, öffnen Sie beim Gerät **OTAA keys** und verwenden Sie **Flush OTAA device nonces**. Führen Sie diesen Schritt nur passend zum Reset des physischen Geräts aus. Löschen oder deaktivieren Sie nicht pauschal die Frame-Counter-Prüfung.

> **Hinweis zu den Nonces auf ChirpStack:** ChirpStack zeigt im Tab `Activation` die aktuellen Werte der Up-/Downlink-Counter.
> Diese gelten pro aufgebauter LoRaWAN-Verbindung. Im Tab `OTAA Keys` gibt es rechts oben den Button `Flush OTAA device nonces`, um die Nonces auf dem Server zurückzusetzen.

Damit ist Weg B abgeschlossen.

\clearpage

# 4. Gemeinsamer Abschluss und Dauerbetrieb {#4-gemeinsamer-abschluss-und-dauerbetrieb}

Nach einem erfolgreichen Weg A oder B sind dieselben Abschlussarbeiten erforderlich.

## 4.1 Erfolgskriterien

Die Inbetriebnahme ist erst vollständig, wenn alle sechs Ebenen funktionieren:

| Ebene | Prüfung | Erwartetes Ergebnis |
|---|---|---|
| Logger | Terminal nach `i` | `LoRa-Transfer OK` oder `LoRa-Transfer (verified) OK` |
| LoRaWAN | Live Data / LoRaWAN frames | Join und Uplink mit steigendem `FCnt` |
| Funkparameter | `AT+NBTRANS=?` oder Feld `N:` von `AT+XSTATE=?` | wirksames `NbTrans` entspricht der dokumentierten ADR-/Energiestrategie |
| Codec | `decoded_payload` / `object` | Kanäle, Werte, Einheiten und gegebenenfalls HK-Daten |
| HTTP | Webhook-/Integration-Event | HTTP-Erfolg, keine wiederholten Fehlerereignisse |
| Datenbank | LTX Microcloud | neues Gerät und aktuelle Messwerte sichtbar |

Die Serverzeit wird beim Join beziehungsweise über die LTX-Zeitanforderung synchronisiert. Nach erfolgreicher Anmeldung sollte deshalb auch die Loggerzeit plausibel sein.

## 4.2 Diagnoseeinstellungen wieder zurücknehmen

Während der Einrichtung darf `Config0_U31` testweise `0` sein. Für den CE-konformen Dauerbetrieb muss die Bitmaske `16` wieder gesetzt werden, damit Bluetooth und LoRaWAN nicht gleichzeitig aktiv sind. Die BLE-Verbindung wird während eines Transfers dann kurz getrennt und anschließend wieder aufgebaut.

Schalten Sie außerdem den Modem-Debugmodus aus:

```text
@$dbg 0
```

Der Debugmodus erzeugt zusätzliche Modemkommunikation, erhöht den Energieverbrauch und ignoriert die normale `Config0_U31`-Unterdrückung. Er darf nicht versehentlich im Batteriebetrieb aktiv bleiben.

> **Wichtig:** Auch technisch ist es sinnvoll, Bluetooth während einer LoRaWAN-Übertragung auszuschalten: Das maximiert die Reichweite und minimiert den Energieverbrauch, insbesondere bei schwachen Funksignalen. Setzen Sie daher im produktiven Betrieb `Config0_U31` auf `16` und verwenden Sie `@$dbg 0`.


## 4.3 LED- und Bestätigungsverhalten

- *Ohne LoRaWAN-Link* blitzt die Modem-LED ungefähr *jede Sekunde*.
- Bei *bestehendem Link* blitzt sie nur ungefähr alle *acht Sekunden und deutlich schwächer*.
- Manuell ausgelöste Übertragungen werden zur Diagnose bestätigt gesendet.
- Im Normalbetrieb fordert der Logger nur in größeren Abständen eine Bestätigung an, damit er die Serververbindung überwachen kann.
- Bleiben Serverantworten über längere Zeit aus, versucht der Logger einen neuen Join. Weitere Join-Versuche erfolgen energieschonend in größeren Abständen.

Bestätigte Nachrichten und Downlinks verbrauchen zusätzliche Gateway-Airtime. Verwenden Sie sie nur, wenn ihre Funktion benötigt wird.

\clearpage

# 5. Fehlersuche

| Symptom | Wahrscheinliche Ursache | Prüfung und Maßnahme |
|---|---|---|
| Kein `JoinRequest` im Stack | falsche Region, Gateway nicht verbunden, keine Funkabdeckung, Antennenproblem | EU868 auf Gerät, Profil und Gateway prüfen; Gateway-Live-Daten kontrollieren; Abstand und Antenne prüfen |
| `JoinRequest`, aber kein `JoinAccept` | EUIs/Key falsch, OTAA-Profil falsch, Server lehnt Join ab | `DEUI`, `APPEUI`, `NWKKEY` Zeichen für Zeichen vergleichen; LoRaWAN 1.0.4 und OTAA prüfen |
| `JoinAccept` am Server, aber `JOIN_FAILED` am Logger | Downlink erreicht das Gerät nicht | Gateway-Downlink, Frequenzplan, RX2-Einstellung, Duty Cycle und Funkqualität prüfen; nach kurzer Wartezeit einmal erneut testen |
| `DevNonce has already been used` | Logger wurde mit `AT+RFS` zurückgesetzt, Server kennt alte Nonces | DevNonces passend zum physischen Reset in TTN beziehungsweise ChirpStack zurücksetzen |
| MIC-Fehler | `NWKKEY`/AppKey oder Join-Kontext stimmt nicht | Root Key neu vergleichen; keine Session-Keys mit Root Keys verwechseln; kontrolliert neu provisionieren |
| Roh-Payload vorhanden, aber keine dekodierten Daten | Codec fehlt, falsche Datei, JavaScript-Fehler | TTN: `payload_ltx_clean.js` für Uplink; ChirpStack: `payload_ltx_clean.js` plus `paydown_ltx.js`; integrierten Test ausführen |
| Werte ohne oder mit falscher Einheit | falscher Uplink-`fPort` | Logger-`p Port` beziehungsweise `xsp...` an die Einheitengruppe anpassen |
| Stack dekodiert, Microcloud bleibt leer | Webhook-URL, `KEY`, JSON-Format oder HTTPS fehlerhaft | vollständige URL prüfen; `Uplink message` aktivieren; bei TTN `as.webhook.fail`, bei ChirpStack Server-/Integrationslog prüfen |
| HTTP 400 `Invalid Payload` | notwendige JSON-Felder fehlen oder falscher Eventtyp | Filter entfernen; echten Uplink senden; vollständigen Request am Server protokollieren |
| HTTP 400 `API Key` | falscher `KEY`-Queryparameter | `D_API_KEY` beziehungsweise individuelle Gerätefreigabe in der Microcloud prüfen |
| `FCnt` bleibt gleich oder wird abgelehnt | wiederholter Frame oder nicht passender Session-Zustand | Aktivierung und Gerätezustand prüfen; Frame-Counter-Validierung nicht als schnelle Lösung deaktivieren |
| `NbTrans` weicht bei `ADR=1` von einer manuellen Testvorgabe ab | der Network Server hat den Wert über `LinkADRReq` geändert | stackabhängige ADR-Strategie und Paketverluste prüfen; `NbTrans` überwachen; für ChirpStack gilt mit dem aktuellen Standardalgorithmus `1...3` |
| `NbTrans` steht nach einem Reset wieder auf `1` | `AT+NBTRANS=X` ist nur für Tests implementiert und wird nicht gespeichert | erwartetes Verhalten; bei `ADR=0` den Default `1` verwenden, bei `ADR=1` die serverseitige Regelstrategie prüfen |
| Batterie wird während des Tests stark belastet | Debugmodus, DR0, häufige Joins, `NbTrans>1` oder viele Confirmed Uplinks | `@$dbg 0`, ADR, `NbTrans`, Datenrate und Intervalle optimieren, Join-Ursache beheben |

Für ChirpStack empfiehlt die offizielle [Troubleshooting-Anleitung](https://www.chirpstack.io/docs/guides/connect-device.html#troubleshooting), Gateway-Frames, Geräte-Frames und Events in dieser Reihenfolge zu prüfen. Bei TTN liefern [Live data](https://www.thethingsindustries.com/docs/hardware/devices/troubleshooting/) und die [Webhook-Fehlersuche](https://www.thethingsindustries.com/docs/integrations/webhooks/troubleshooting/) die entsprechenden Informationen.

# 6. Sicherheit und Betrieb

- Nutzen Sie für die Microcloud-Integration HTTPS.
- Behandeln Sie `NWKKEY`/AppKey und den Microcloud-`D_API_KEY` wie Passwörter.
- Legen Sie für größere Installationen individuelle Geräte-API-Keys an, statt einen gemeinsamen Key für alle Logger zu verwenden.
- Veröffentlichen Sie keine Console-Screenshots mit vollständigen Keys oder persönlichen Anmeldedaten.
- Speichern Sie Konfigurationsänderungen bewusst und dokumentieren Sie `DEUI`, `APPEUI`, Stack, Anwendung, Profil, fPort und Installationsort.
- Prüfen Sie bei TTN regelmäßig Fair Use und Tarifbedingungen.
- Überwachen Sie bei `ADR=1` im jeweiligen Network Server die tatsächlich gesetzten Funkparameter einschließlich `NbTrans`; für ChirpStack gilt mit dem aktuellen Standardalgorithmus der Bereich `1...3`.
- Dimensionieren Sie Mess- und Sendeintervalle nach Batterielaufzeit, Funkqualität, Payload-Länge, Datenrate, `NbTrans` und gesetzlichen Vorgaben.

\clearpage

# 7. Kompakte Checkliste

## Für beide Wege

- [ ] Messkanäle und Housekeeping konfiguriert
- [ ] sinnvoller Uplink-`fPort` gewählt
- [ ] `@$initeu868` bei uninitialisiertem Modem ausgeführt
- [ ] `DEUI`, `APPEUI` und `NWKKEY` sicher notiert
- [ ] ADR-, `NbTrans`- und Datenratenstrategie passend zu Funkstrecke, Zustellziel und Energiebudget festgelegt
- [ ] erreichbares EU868-Gateway vorhanden

## TTN

- [ ] europäischen Cluster gewählt
- [ ] Anwendung angelegt
- [ ] Endgerät manuell als LoRaWAN 1.0.4 registriert
- [ ] `payload_ltx_clean.js` als Uplink-Formatter gespeichert und getestet
- [ ] `paydown_ltx.js` als Downlink-Formatter gespeichert und getestet
- [ ] JSON-Webhook mit `Uplink message` und Microcloud-URL gespeichert
- [ ] Uplink in Live Data dekodiert

## ChirpStack

- [ ] Anwendung angelegt
- [ ] EU868-/LoRaWAN-1.0.4-Geräteprofil mit OTAA angelegt
- [ ] ADR-Algorithmus als Server-Designentscheidung gewählt, ChirpStack-Bereich `NbTrans=1...3` berücksichtigt und Überwachung vorgesehen
- [ ] gemeinsamer Codec aus `payload_ltx_clean.js` und `paydown_ltx.js` gespeichert
- [ ] Device EUI, Join EUI und Application key eingetragen
- [ ] JSON-HTTP-Integration zur Microcloud gespeichert
- [ ] Join, Uplink und dekodiertes `object` in Events geprüft

## Nach dem Test

- [ ] Messwerte in der LTX Microcloud sichtbar
- [ ] `@$dbg 0` ausgeführt
- [ ] `Config0_U31` für den Dauerbetrieb wieder auf Bitmaske `16` gesetzt
- [ ] Sendeintervall, Airtime und Batterieverbrauch geprüft
- [ ] Schlüssel und Installationsdaten sicher dokumentiert

\clearpage

# 8. Weiterführende Dokumentation

## LTX

- [joembedded/ltx_docu - Gesamtprojekt](https://github.com/joembedded/ltx_docu)
- [LTX Typ 1720 - kompakter SDI-12-Datenlogger mit LoRaWAN](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/LTX_T1720_LoRaWAN.MD)
- [LTX Typ 1820 - SDI-12-Datenlogger mit flexibler Energieversorgung](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/LTX_T1820_LoRaWAN.MD)
- [LTX LoRa-Payload, fPort, Einheiten und Downlinks](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/lora_payload.md)
- [LTX-LoRaWAN-AT-Kommandos](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/ltx_lora_at_kommandos.md)
- [LTX-Logger-Kommando-Referenz](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_kommandos/LTX_Kommandos.md)
- [LTX-Parameter-Referenz](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_parameter/ltx_parameter_referenz.md)
- [Energie-Vergleich LoRa-Module EU868](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/energie_vergleich.md)
- [LTX Payload Decoder](https://github.com/joembedded/payload-decoder)
- [LTX Microcloud / LTX Server](https://github.com/joembedded/LTX_server)

## LoRaWAN-Stacks

- [The Things Stack Sandbox](https://www.thethingsindustries.com/docs/concepts/ttn/)
- [TTN Webhooks](https://www.thethingsindustries.com/docs/integrations/webhooks/)
- [TTN Device Troubleshooting](https://www.thethingsindustries.com/docs/hardware/devices/troubleshooting/)
- [ChirpStack: Connecting a device](https://www.chirpstack.io/docs/guides/connect-device.html)
- [ChirpStack Device Profiles](https://www.chirpstack.io/docs/chirpstack/features/device-profile.html)
- [ChirpStack HTTP Integration](https://www.chirpstack.io/docs/chirpstack/integrations/http.html)

---

*Stand: 28. Juli 2026. Beispielkonfiguration: LTX-Datenlogger mit EU868 und LoRaWAN 1.0.4. Vor einem produktiven Rollout Firmwarestand, regionale Funkvorgaben, Stack-Version und Tarifbedingungen erneut prüfen.*
