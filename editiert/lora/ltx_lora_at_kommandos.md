# Projekt LTX Typ 1720/1730 1820/1830 – LoRaWAN AT-Kommandos

**Stand:** 23.04.2026 / JW  
**Basis:** STMicroelectronics Application Note AN5481 „LoRaWAN AT commands for STM32CubeWL"  
**Erweiterungen:** LTX-projektspezifische Befehle (implementiert von JW)

Dieses Dokument beschreibt alle AT-Befehle der LoRaWAN-AT-Schnittstelle für die LTX-Gerätereihe. Es umfasst die in [AN5481 v1.4.0 Rev 6 – April 2026](an5481-lorawan-at-commands-for-stm32cubewl-stmicroelectronics.pdf) dokumentierten Standardbefehle des STM32CubeWL-Stacks sowie die projektspezifischen Erweiterungen, die für den Betrieb mit einem externen Host-Mikrocontroller sinnvoll sind.

> [!TIP]
> Entfernt wurde nicht relevante AT-Kommandos (z.B. für Class B und Class C Betrieb). Bei Unklarheiten: AN5481.
> Im Text gekennzeichnet ist die Herkunft der Kommandos (AN5481 oder *LTX-erweitert, für Collaborators* [LoRaWAN Extended AT Slave 🔒](https://github.com/joembedded/ltx_lora_at_slave) ). 


> [!IMPORTANT]
> Die Namensgebung NWKKEY/APPKEY unterscheidet sich zwischen LoRaWAN V1.0.3/V1.0.4 und V1.1.0. Diese Firmware implementiert **LoRaWAN 1.0.4**. Der verwendete „NWKKEY" entspricht dem kombinierten App+Network-Root-Key in V1.0.x.

---

## Inhaltsverzeichnis

- [Projekt LTX Typ 1720/1730 1820/1830 – LoRaWAN AT-Kommandos](#projekt-ltx-typ-17201730-18201830--lorawan-at-kommandos)
  - [Inhaltsverzeichnis](#inhaltsverzeichnis)
  - [Befehlskonventionen](#befehlskonventionen)
  - [Event-Tabelle](#event-tabelle)
  - [Allgemeine Befehle (AN5481 Kap. 3.4)](#allgemeine-befehle-an5481-kap-34)
    - [`AT` – Test](#at--test)
    - [`AT?` – Befehlsliste](#at--befehlsliste)
    - [`ATZ` – MCU-Reset](#atz--mcu-reset)
    - [`AT+VL` – Verbose-Level (Ausgabe-Detailgrad)](#atvl--verbose-level-ausgabe-detailgrad)
    - [`AT+LTIME` – Lokale Zeit (UTC) *(LTX-erweitert)*](#atltime--lokale-zeit-utc-ltx-erweitert)
  - [Kontextverwaltung (AN5481 Kap. 3.5)](#kontextverwaltung-an5481-kap-35)
    - [`AT+RFS` – Factory-Reset](#atrfs--factory-reset)
    - [`AT+CS` – Kontext speichern](#atcs--kontext-speichern)
  - [Schlüssel, IDs und EUIs (AN5481 Kap. 3.6)](#schlüssel-ids-und-euis-an5481-kap-36)
    - [`AT+APPEUI` – Application EUI (JoinEUI)](#atappeui--application-eui-joineui)
    - [`AT+NWKKEY` – Network Root Key](#atnwkkey--network-root-key)
    - [`AT+APPKEY` – Application Root Key](#atappkey--application-root-key)
    - [`AT+APPSKEY` – Application Session Key](#atappskey--application-session-key)
    - [`AT+NWKSKEY` – Network Session Key](#atnwkskey--network-session-key)
    - [`AT+DADDR` – Device Address](#atdaddr--device-address)
    - [`AT+DEUI` – Device EUI](#atdeui--device-eui)
    - [`AT+NWKID` – Network ID](#atnwkid--network-id)
  - [Join- und Sendebefehle (AN5481 Kap. 3.7)](#join--und-sendebefehle-an5481-kap-37)
    - [`AT+JOIN` – LoRaWAN-Netzwerk beitreten](#atjoin--lorawan-netzwerk-beitreten)
    - [`AT+LINKC` – Link-Check-Anfrage](#atlinkc--link-check-anfrage)
    - [`AT+SEND` – Daten senden](#atsend--daten-senden)
  - [Netzwerkverwaltungsbefehle (AN5481 Kap. 3.8)](#netzwerkverwaltungsbefehle-an5481-kap-38)
    - [`AT+VER` – Firmware-Version](#atver--firmware-version)
    - [`AT+ADR` – Adaptive Data Rate](#atadr--adaptive-data-rate)
    - [`AT+DR` – Datenrate](#atdr--datenrate)
    - [`AT+BAND` – Aktive Region (Frequenzband)](#atband--aktive-region-frequenzband)
    - [`AT+CLASS` – LoRaWAN-Geräteklasse](#atclass--lorawan-geräteklasse)
    - [`AT+DCS` – Duty-Cycle-Einstellung](#atdcs--duty-cycle-einstellung)
    - [`AT+JN1DL` – Join-Verzögerung RX-Fenster 1](#atjn1dl--join-verzögerung-rx-fenster-1)
    - [`AT+JN2DL` – Join-Verzögerung RX-Fenster 2](#atjn2dl--join-verzögerung-rx-fenster-2)
    - [`AT+RX1DL` – Verzögerung RX-Fenster 1](#atrx1dl--verzögerung-rx-fenster-1)
    - [`AT+RX2DL` – Verzögerung RX-Fenster 2](#atrx2dl--verzögerung-rx-fenster-2)
    - [`AT+RX2DR` – Datenrate RX-Fenster 2](#atrx2dr--datenrate-rx-fenster-2)
    - [`AT+RX2FQ` – Frequenz RX-Fenster 2](#atrx2fq--frequenz-rx-fenster-2)
    - [`AT+TXP` – Sendeleistung](#attxp--sendeleistung)
  - [Radio-Test-Befehle (AN5481 Kap. 3.9)](#radio-test-befehle-an5481-kap-39)
    - [`AT+TTONE` – RF-Ton-Test](#atttone--rf-ton-test)
    - [`AT+TRSSI` – RF-RSSI-Ton-Test](#attrssi--rf-rssi-ton-test)
    - [`AT+TCONF` – RF-Testkonfiguration](#attconf--rf-testkonfiguration)
    - [`AT+TTX` – PER-TX-Test](#atttx--per-tx-test)
    - [`AT+TRX` – PER-RX-Test](#attrx--per-rx-test)
    - [`AT+TTH` – RF-TX-Hopping-Test](#attth--rf-tx-hopping-test)
    - [`AT+TOFF` – RF-Test beenden](#attoff--rf-test-beenden)
  - [Zertifizierung (AN5481 Kap. 3.10)](#zertifizierung-an5481-kap-310)
    - [`AT+CERTIF` – Zertifizierungsmodus](#atcertif--zertifizierungsmodus)
  - [Information (AN5481 Kap. 3.11)](#information-an5481-kap-311)
    - [`AT+BAT` – Batteriestand](#atbat--batteriestand)
  - [LTX-Erweiterungen](#ltx-erweiterungen)
    - [`AT+TIMEREQ` – Netzzeit-Anforderung](#attimereq--netzzeit-anforderung)
    - [`AT+NVMJS=?` – NVM Join-Status abfragen](#atnvmjs--nvm-join-status-abfragen)
    - [`AT+XSTATE=?` – Laufzeitzustand abfragen](#atxstate--laufzeitzustand-abfragen)
    - [`AT+RECV` – Empfangspuffer lesen](#atrecv--empfangspuffer-lesen)
    - [`AT+SAVECFG` – Konfiguration speichern](#atsavecfg--konfiguration-speichern)
  - [Beispiele](#beispiele)
    - [Inbetriebnahme: Keys setzen und Join (OTAA)](#inbetriebnahme-keys-setzen-und-join-otaa)
    - [Senden mit Zeitabgleich (bestätigt)](#senden-mit-zeitabgleich-bestätigt)
    - [Downlink-Empfang mit Puffer-Abfrage](#downlink-empfang-mit-puffer-abfrage)
    - [Neustart mit gespeichertem Kontext](#neustart-mit-gespeichertem-kontext)
  - [Kurzreferenz aller möglichen Befehle](#kurzreferenz-aller-möglichen-befehle)

---

## Befehlskonventionen

| Syntaxform | Bedeutung |
|---|---|
| `AT+CMD` | Kommando ohne Parameter (Aktion ausführen) |
| `AT+CMD?` | Aktuellen Wert lesen |
| `AT+CMD=value` | Wert setzen |
| `AT+CMD=?` | Unterstützten Wertebereich abfragen |

**Fehlerkodes:**

| Code | Bedeutung |
|---|---|
| `AT_ERROR` | Allgemeiner Fehler |
| `AT_PARAM_ERROR` | Ungültiger Parameter |
| `AT_BUSY_ERROR` | Modem beschäftigt (Kommando läuft bereits) |
| `AT_TEST_PARAM_OVERFLOW` | Test-Parameter-Überlauf |
| `AT_NO_NETWORK_JOINED` | Kein Netzwerk beigetreten |
| `AT_RX_ERROR` | Empfangsfehler (Integritätsprüfung fehlgeschlagen) |

---

## Event-Tabelle

Asynchrone Ereignisse werden mit dem Präfix `+EVT:` gemeldet und können unabhängig von laufenden AT-Befehlen jederzeit ausgegeben werden.

| Event | Quelle | Bedeutung |
|---|---|---|
| `+EVT:JOIN_DONE` | AN5481 | Join-Vorgang erfolgreich |
| `+EVT:JOINED` | AN5481 | Verbunden mit LoRaWAN-Netzwerk |
| `+EVT:JOIN_FAILED` | AN5481 | Join-Vorgang fehlgeschlagen |
| `+EVT:SEND_DONE` | AN5481 | Unbestätigtes Senden abgeschlossen |
| `+EVT:TX_UNCONFIRMED` | AN5481 | Unbestätigtes Frame übertragen |
| `+EVT:TX_CONFIRMED` | AN5481 | Bestätigung (ACK) empfangen |
| `+EVT:SEND_CONFIRMED` | LTX | Bestätigtes Senden abgeschlossen (ACK erhalten) |
| `+EVT:RX_1, PORT <p>, DR <dr>, RSSI <r>, SNR <s>` | LTX | Daten auf RX-Fenster 1 empfangen |
| `+EVT:RX_2, PORT <p>, DR <dr>, RSSI <r>, SNR <s>` | LTX | Daten auf RX-Fenster 2 empfangen |
| `+EVT:<port>:<len>:<hex>` | LTX | Downlink-Nutzdaten (Port, Länge, Hex-Payload) |
| `+EVT:FINISH` | LTX | Class-A-Übertragungszyklus (Join oder Send) vollständig abgeschlossen |
| `+EVT:TIME RECEIVED` | LTX | Netzzeit empfangen (`DeviceTimeAns`) |
| `+EVT:LINK_CHECK` | AN5481 | Antwort auf Link-Check-Anfrage |

> **Hinweis zum `+EVT:FINISH`:** Dieses Event wird ausgegeben, sobald ein kompletter Class-A-Zyklus (Join oder Send inkl. aller RX-Fenster) abgeschlossen ist oder der zugehörige Timeout ausläuft. Es signalisiert dem Host, dass Folgekommandos ausgeführt werden können.

---

## Allgemeine Befehle (AN5481 Kap. 3.4)

### `AT` – Test

Prüft, ob das Modem antwortet.

```
AT
OK
```

---

### `AT?` – Befehlsliste

Gibt alle unterstützten AT-Befehle aus.

```
AT?
...Liste aller Befehle...
OK
```

---

### `ATZ` – MCU-Reset

Setzt das Modem zurück (Soft-Reset). Nach dem Reset gibt das Modem einen Begrüßungstext aus:

```
ATZ

--- EVK-Nucleo-WL55JC1 V1.4 Type:8000 ---
(C)JoEmbedded.de (Dec 13 2025 14:15:43)
CONFIG RESTORED
DEVEUI: 00:11:22:33:44:55:66:77
LoRa.ADR: 0
LoRa.DR: 3
RESTORED CONTEXT
```

---

### `AT+VL` – Verbose-Level (Ausgabe-Detailgrad)

Steuert, wie ausführlich das Modem antwortet.

| Syntax | Funktion |
|---|---|
| `AT+VL?` | Aktuellen Wert lesen |
| `AT+VL=<X>` | Wert setzen |
| `AT+VL=?` | Wertebereich abfragen |

| Wert | Bedeutung |
|---|---|
| `0` | Minimale Ausgabe (nur `OK`/Fehler) |
| `1` | Standard (Fehler mit Text) |
| `2` | Debug-Ausgabe |
| `3` | Erweiterte Debug-Ausgabe |

```
AT+VL=1
OK
```

---

### `AT+LTIME` – Lokale Zeit (UTC) *(LTX-erweitert)*

Gibt die vom LoRaWAN-Netzwerk synchronisierte Zeit aus. Erfordert einen vorherigen `AT+TIMEREQ` und den Empfang von `+EVT:TIME RECEIVED`.

Die LTX-Erweiterung fügt das Feld `T:<unix_sekunden>` hinzu, um eine maschinelle Weiterverarbeitung zu ermöglichen.

| Syntax | Funktion |
|---|---|
| `AT+LTIME?` oder `AT+LTIME=?` | Aktuelle Zeit lesen |

```
AT+LTIME=?
LTIME: 13:32:48 13.12.2025 T:1765632768
OK
```

Vor einer Zeitsynchronisation:

```
AT+LTIME=?
LTIME: 00:37:36 01.01.1970 T:2256
OK
```

---

## Kontextverwaltung (AN5481 Kap. 3.5)

### `AT+RFS` – Factory-Reset

Setzt alle LoRaWAN-Parameter auf Werkseinstellungen zurück. Löscht sowohl den NVM-Kontext (gespeichert durch `AT+CS`) als auch die Flash-Konfiguration (gespeichert durch `AT+SAVECFG`).

```
AT+RFS
OK
```

> [!IMPORTANT]
> Wenn ein gespeicherter Kontext vorhanden ist, können Keys und manche LoRa-Parameter ggf. nicht geändert werden. Daher vor dem Setzen neuer Keys ggfs. zuerst `AT+RFS` ausführen.

---

### `AT+CS` – Kontext speichern

Speichert den aktuellen LoRaWAN-Stack-Kontext (Session-Keys, Frame-Counter, DevNonce, JoinNonce usw.) im NVM (vorletztes 2k-Segment der CPU).

```
AT+CS
OK
```

> Sollte nach einem erfolgreichen JOIN aufgerufen werden, um bei einem Neustart den Join-Vorgang zu überspringen (sofern serverseitig Frame-Counter-Validation deaktiviert ist).

---

## Schlüssel, IDs und EUIs (AN5481 Kap. 3.6)

### `AT+APPEUI` – Application EUI (JoinEUI)

8-Byte-Bezeichner der Applikation / des Join-Servers (OTAA).

| Syntax | Funktion |
|---|---|
| `AT+APPEUI?` | Aktuellen Wert lesen |
| `AT+APPEUI=<XX:XX:XX:XX:XX:XX:XX:XX>` | Wert setzen (8 Bytes Hex, Doppelpunkt-getrennt) |

```
AT+APPEUI=11:11:11:11:22:22:22:22
OK
AT+APPEUI=?
01:01:01:01:01:01:01:01
OK
```

---

### `AT+NWKKEY` – Network Root Key

16-Byte-Schlüssel (LoRaWAN 1.0.4: kombinierter App+Network-Root-Key, OTAA).

| Syntax | Funktion |
|---|---|
| `AT+NWKKEY?` | Aktuellen Wert lesen |
| `AT+NWKKEY=<16 Bytes Hex>` | Wert setzen |

```
AT+NWKKEY=01:23:45:67:01:23:45:67:01:23:45:67:01:23:45:67
OK
AT+NWKKEY=?
C0:DE:42:CA:FE:BA:BE:AE:51:FA:CA:DE:FA:CA:DE:51
OK
```

---

### `AT+APPKEY` – Application Root Key

16-Byte-Applikationsschlüssel (OTAA, LoRaWAN 1.1).

| Syntax | Funktion |
|---|---|
| `AT+APPKEY=<16 Bytes Hex>` | Wert setzen (nur Schreiben) |

```
AT+APPKEY=2B:7E:15:16:28:AE:D2:A6:AB:F7:15:88:09:CF:4F:3C
OK
```

---

### `AT+APPSKEY` – Application Session Key

16-Byte-Applikationssitzungsschlüssel (ABP und nach OTAA-Join aktiv).

| Syntax | Funktion |
|---|---|
| `AT+APPSKEY=<16 Bytes Hex>` | Wert setzen (nur Schreiben) |

```
AT+APPSKEY=2B:7E:15:16:28:AE:D2:A6:AB:F7:15:88:09:CF:4F:3C
OK
```

---

### `AT+NWKSKEY` – Network Session Key

16-Byte-Netzwerksitzungsschlüssel (ABP).

| Syntax | Funktion |
|---|---|
| `AT+NWKSKEY=<16 Bytes Hex>` | Wert setzen (nur Schreiben) |

```
AT+NWKSKEY=2B:7E:15:16:28:AE:D2:A6:AB:F7:15:88:09:CF:4F:3C
OK
```

---

### `AT+DADDR` – Device Address

4-Byte-Geräteadresse (ABP oder nach OTAA-Join vom Netzwerk zugewiesen).

| Syntax | Funktion |
|---|---|
| `AT+DADDR?` | Aktuellen Wert lesen |
| `AT+DADDR=<XXXXXXXX>` | Wert setzen (4 Bytes Hex, ohne Trennzeichen) |

```
AT+DADDR=26011234
OK
```

---

### `AT+DEUI` – Device EUI

8-Byte-Geräte-Bezeichner (weltweit eindeutig, OTAA). Der Default-Wert ist die werkseitige MAC-Adresse der CPU.

| Syntax | Funktion |
|---|---|
| `AT+DEUI?` | Aktuellen Wert lesen |
| `AT+DEUI=<XX:XX:XX:XX:XX:XX:XX:XX>` | Wert setzen |

```
AT+DEUI=00:11:22:33:44:55:66:77
OK
```

---

### `AT+NWKID` – Network ID

Netzwerk-ID (NwkId, die oberen 7 Bit der DevAddr bei ABP).

| Syntax | Funktion |
|---|---|
| `AT+NWKID?` | Aktuellen Wert lesen |
| `AT+NWKID=<X>` | Wert setzen |

```
AT+NWKID=0
OK
```

---

## Join- und Sendebefehle (AN5481 Kap. 3.7)

### `AT+JOIN` – LoRaWAN-Netzwerk beitreten

Startet den Join-Vorgang (OTAA oder aktiviert ABP).

| Syntax | Funktion |
|---|---|
| `AT+JOIN=<mode>` | Join starten (Kurzform) |
| `AT+JOIN=<mode>,<auto>,<interval>,<tries>` | Join starten (vollständig) |

**Parameter:**

| Parameter | Wertebereich | Bedeutung |
|---|---|---|
| `mode` | `0` / `1` | `0` = ABP, `1` = OTAA |
| `auto` | `0` / `1` | `0` = manuell, `1` = automatischer Re-Join |
| `interval` | Sekunden | Wartezeit zwischen Re-Join-Versuchen |
| `tries` | Anzahl | Maximale Anzahl an Join-Versuchen |

```
AT+JOIN=1
OK
+EVT:JOINED
+EVT:FINISH
```

> **Hinweis:** Das Ergebnis wird asynchron über Events gemeldet. `+EVT:FINISH` zeigt den Abschluss des Join-Zyklus an.

---

### `AT+LINKC` – Link-Check-Anfrage

Fordert beim nächsten Uplink einen LoRaWAN-LinkCheckReq an.

```
AT+LINKC
OK
+EVT:LINK_CHECK
```

---

### `AT+SEND` – Daten senden

Sendet Nutzdaten (Payload) über das LoRaWAN-Netzwerk.

| Syntax | Funktion |
|---|---|
| `AT+SEND=<port>:<confirmed>:<hex_payload>` | Daten senden |

**Parameter:**

| Parameter | Wertebereich | Bedeutung |
|---|---|---|
| `port` | `1` … `223` | LoRaWAN-Applikationsport |
| `confirmed` | `0` / `1` | `0` = unbestätigt, `1` = bestätigt (ACK anfordern) |
| `hex_payload` | Hex-String | Nutzdaten als Hex-Zeichenkette (z. B. `112233`) |

```
# Unbestätigt senden
AT+SEND=3:0:11
OK
+EVT:FINISH

# Bestätigt senden (mit ACK)
AT+SEND=3:1:112233
OK
+EVT:SEND_CONFIRMED
+EVT:FINISH
```

> **Hinweis:** Das Modem antwortet sofort mit `OK`. Das Ergebnis wird asynchron über `+EVT:FINISH` (und ggf. `+EVT:SEND_CONFIRMED`) gemeldet. Danach kann `AT+XSTATE` oder `AT+RECV` abgefragt werden.

---

## Netzwerkverwaltungsbefehle (AN5481 Kap. 3.8)

### `AT+VER` – Firmware-Version

```
AT+VER?
+VER:1.2.3
OK
```

---

### `AT+ADR` – Adaptive Data Rate

| Syntax | Funktion |
|---|---|
| `AT+ADR?` | Aktuellen Wert lesen |
| `AT+ADR=<X>` | Wert setzen (`0`=aus, `1`=ein) |

```
AT+ADR=0
OK
```

> [!TIP]
> Bei mobilen Geräten empfiehlt sich die ADR auf 0 zu setzen und ggfs. die DR auch auf 0. Dann ist zwar der Energieverbrauch nicht optimal, aber die Reichweite am größten. Das Setzen muss aber vor dem ersten JOIN erfolgen, evtl. dazu den NVM-Speicher löschen. Zum Energieverbrauch siehe separate Dokumentation.


---

### `AT+DR` – Datenrate

Setzt die LoRa-Datenrate manuell (nur wirksam, wenn ADR deaktiviert).


| Syntax | Funktion |
|---|---|
| `AT+DR?` | Aktuellen Wert lesen |
| `AT+DR=<X>` | Datenrate setzen |
| `AT+DR=?` | Unterstützte Datenraten der aktiven Region auflisten |

| Wert | SF / BW (EU868) | Max. Payload |
|---|---|---|
| `0` | SF12 / 125 kHz | 51 Bytes |
| `1` | SF11 / 125 kHz | 51 Bytes |
| `2` | SF10 / 125 kHz | 51 Bytes |
| `3` | SF9 / 125 kHz | 115 Bytes |
| `4` | SF8 / 125 kHz | 242 Bytes |
| `5` | SF7 / 125 kHz | 242 Bytes |

```
AT+DR=3
OK
AT+DR?
3
OK
```

---

### `AT+BAND` – Aktive Region (Frequenzband)

| Syntax | Funktion |
|---|---|
| `AT+BAND?` | Aktuellen Wert lesen |
| `AT+BAND=<X>` | Region setzen |

| Wert | Region |
|---|---|
| `5` | EU868 |

```
AT+BAND=5
OK
```

> [!NOTE]
> Für die Geräte der Gruppe EU868 ist nur Band 5 erlaubt

---

### `AT+CLASS` – LoRaWAN-Geräteklasse

| Syntax | Funktion |
|---|---|
| `AT+CLASS?` | Aktuellen Wert lesen |
| `AT+CLASS=<X>` | Klasse setzen |

| Wert | Klasse | Beschreibung |
|---|---|---|
| `A` | Class A | Standard: bidirektional, RX-Fenster nur nach TX |

```
AT+CLASS=A
OK
```

> [!NOTE]
> Für LTX ist nur die Geräteklasse Class A vorgesehen


---

### `AT+DCS` – Duty-Cycle-Einstellung

Aktiviert oder deaktiviert die gesetzliche Sendezeitbegrenzung (Duty Cycle, relevant für EU868).

| Wert | Bedeutung |
|---|---|
| `0` | Duty Cycle deaktiviert |
| `1` | Duty Cycle aktiviert |

```
AT+DCS=1
OK
```

> [!CAUTION]
> Deaktivieren des Duty Cycles wird nicht im NVM gespeichert und ist nur für Test-Zwecke vorgesehen.


---

### `AT+JN1DL` – Join-Verzögerung RX-Fenster 1

Wartezeit nach einem Join-Request bis zum ersten RX-Fenster (ms). 

```
AT+JN1DL=5000
OK
```

> [!NOTE]
> Das ist der empfohlene Wert.

---

### `AT+JN2DL` – Join-Verzögerung RX-Fenster 2

Wartezeit nach einem Join-Request bis zum zweiten RX-Fenster (ms, typisch JN1DL + 1000).

```
AT+JN2DL=6000
OK
```

> [!NOTE]
> Das ist der empfohlene Wert.

---

### `AT+RX1DL` – Verzögerung RX-Fenster 1

Wartezeit nach dem Senden bis zum ersten Empfangsfenster (ms, Standard: 1000).

```
AT+RX1DL=1000
OK
```

> [!NOTE]
> Das ist der empfohlene Wert.

---

### `AT+RX2DL` – Verzögerung RX-Fenster 2

Wartezeit nach dem Senden bis zum zweiten Empfangsfenster (ms, Standard: 2000).

```
AT+RX2DL=2000
OK
```

> [!NOTE]
> Das ist der empfohlene Wert.

---

### `AT+RX2DR` – Datenrate RX-Fenster 2

Datenraten-Index des zweiten Empfangsfensters (wie `AT+DR`).

```
AT+RX2DR=0
OK
```

> [!NOTE]
> Das ist der empfohlene Wert.

---

### `AT+RX2FQ` – Frequenz RX-Fenster 2

Frequenz des zweiten Empfangsfensters (Hz).

```
AT+RX2FQ=869525000
OK
```

> [!NOTE]
> Das ist der empfohlene Wert.

---

### `AT+TXP` – Sendeleistung

TX Power Index.

| Index | Leistung (EU868) |
|---|---|
| `0` | Maximal (z. B. 14 dBm EIRP) |
| `1` | −2 dB |
| `2` | −4 dB |
| `3` | −6 dB |
| `4` | −8 dB |
| `5` | −10 dB |

```
AT+TXP=0
OK
```

> [!NOTE]
> Im Funkbereich EU868 sind maximal 16 dBm EIRP erlaubt (maximal 14 dBm TX-Leistung + 2 dB Antennengewinn).


---


## Radio-Test-Befehle (AN5481 Kap. 3.9)

> [!CAUTION] 
> Nur in abgeschirmter Umgebung oder mit ausreichendem Abstand zu anderen Geräten verwenden.
> Danach benötigt das Gerät i.d.R. einen Reset (z.B. `ATZ`)

### `AT+TTONE` – RF-Ton-Test

Sendet ein HF-Dauersignal (CW). Stoppen mit `AT+TOFF`.

### `AT+TRSSI` – RF-RSSI-Ton-Test

Misst kontinuierlich den RSSI auf der konfigurierten Frequenz.

### `AT+TCONF` – RF-Testkonfiguration

```
AT+TCONF=<freq>,<power>,<bw>,<sf>,<cr>,<lna>,<pa>,<mod>,<plen>,<fdev>,<lowdr>,<BT>
```

| Parameter | Beschreibung | Wertebereich |
|---|---|---|
| `freq` | Frequenz | Hz |
| `power` | Sendeleistung | dBm |
| `bw` | Bandbreite | `0`=125 kHz, `1`=250 kHz, `2`=500 kHz |
| `sf` | Spreading Factor | `5`…`12` (LoRa), `0` (FSK) |
| `cr` | Coding Rate | `1`=4/5, `2`=4/6, `3`=4/7, `4`=4/8 |
| `lna` | Low Noise Amp | `0`=aus, `1`=ein |
| `pa` | Power Amplifier | `0`=RFO, `1`=PA_BOOST |
| `mod` | Modulation | `0`=FSK, `1`=LoRa |
| `plen` | Payload-Länge | Bytes |
| `fdev` | FSK-Frequenzabweichung | 600 … 300000 bit/s |
| `lowdr` | Low Data Rate Opt. | `0`=aus, `1`=ein, `2`=Auto (SF11/12) |
| `BT` | FSK BT-Produkt | `0`=aus, `1`=ein |

### `AT+TTX` – PER-TX-Test

`AT+TTX=<n>` – `n` Testpakete senden.

### `AT+TRX` – PER-RX-Test

`AT+TRX=<n>` – auf `n` Testpakete warten.

### `AT+TTH` – RF-TX-Hopping-Test

`AT+TTH=<fstart>,<fstop>,<fdelta>,<pkt>`

### `AT+TOFF` – RF-Test beenden

Stoppt alle laufenden RF-Tests.

---

## Zertifizierung (AN5481 Kap. 3.10)

### `AT+CERTIF` – Zertifizierungsmodus

`AT+CERTIF=1` – LoRaWAN-Zertifizierungsmodus aktivieren (mit automatischem Join).

---

## Information (AN5481 Kap. 3.11)

### `AT+BAT` – Batteriestand

| Wert | Bedeutung |
|---|---|
| `0` | Extern versorgt |
| `1` … `253` | Akkustand (1 = fast leer, 253 = fast voll) |
| `254` | Voll geladen |
| `255` | Nicht ermittelbar |

```
AT+BAT?
+BAT:254
OK
```

---

## LTX-Erweiterungen

Die folgenden Befehle sind **nicht** in AN5481 enthalten. Sie wurden für den LTX-Produkteinsatz entwickelt und ermöglichen ein energieeffizientes Betriebsmodell, bei dem der Host-Mikrocontroller zwischen Übertragungen schlafen kann.

### `AT+TIMEREQ` – Netzzeit-Anforderung

Fordert bei der nächsten Uplink-Übertragung einen LoRaWAN-`DeviceTimeReq` an, um die interne Uhr zu synchronisieren.

- Erfolgreiche Annahme: `OK`
- Bei erfolgreichem Zeitabgleich folgt: `+EVT:TIME RECEIVED`
- Zeit auslesen mit: `AT+LTIME=?`

```
AT+TIMEREQ
OK
```

---

### `AT+NVMJS=?` – NVM Join-Status abfragen

Liefert den Join-Zustand, der zuletzt mit `AT+CS` im NVM gespeichert wurde.

**Ausgabeformat:** `NVM: MJ:<mac_joined> DN:<devnonce> JN:<joinnonce>`

| Feld | Bedeutung |
|---|---|
| `MJ` | `0` = nicht gejoint, `1` = gejoint (LoRaMAC-Handler-Sicht) |
| `DN` | Zuletzt gespeicherte DevNonce (`-1` = nicht initialisiert) |
| `JN` | Zuletzt gespeicherte JoinNonce (`-1` = nicht initialisiert) |

```
AT+NVMJS=?
NVM: MJ:0 DN:-1 JN:-1
OK
```

> [!NOTE]
> Wenn `MJ:1`, kann nach Reset sofort gesendet werden, sofern die Frame-Counter-Validierung serverseitig deaktiviert ist.
> Normalerweise aber ist die übliche JOIN-Prozedur per OTAA vorzuziehen. 

---

### `AT+XSTATE=?` – Laufzeitzustand abfragen

Gibt den aktuellen detaillierten Betriebszustand des Modems aus. Ermöglicht dem Host, ohne Event-Auswertung den Zustand zu pollen.
Das ist einer der wichtigsten Befehle der Erweiterung!

**Ausgabeformat:** `XS: J:<join_age> C:<cmd_age> LS:<last_srv_age> LT:<last_time_age> R:<rx_bytes> E:<result> D:<datarate>`

| Feld | Bedeutung |
|---|---|
| `J` | Zeit seit erfolgreichem Join in Sekunden (`0` = nicht gejoint) |
| `C` | Zeit seit dem letzten gestarteten Join/SEND-Kommando (s) |
| `LS` | Zeit seit der letzten Serverantwort (s) |
| `LT` | Zeit seit der letzten Zeitantwort (`-1` = noch keine erhalten) |
| `R` | Größe der ungelesenen Empfangsdaten in Bytes (`0` = keine) |
| `E` | Letztes Ergebnis (siehe Tabelle unten) |
| `D` | Aktuelle Sende-Datenrate |

**Werte für `E`:**

| `E` | Bedeutung |
|---|---|
| `>0` | Kommando läuft noch (nicht fertig) |
| `0` | JOIN erfolgreich |
| `-1` | SEND ohne Acknowledge fertig |
| `-2` | SEND mit erhaltenem Acknowledge (ACK) fertig |
| `-3` | JOIN fehlgeschlagen |
| `-4` | VCC der CPU zu niedrig |

```
AT+XSTATE=?
XS: J:378 C:250 LS:249 LT:249 R:0 E:-2 D:3
OK
```

> [!TIP]
> **Energiesparen:** Sofort nach `OK` bei `AT+SEND` kann die Host-CPU schlafen. Empfehlung: alle 6 Sekunden, maximal 24 Sekunden lang `E:` pollen, bis dieser ≤ 0 wird. Bei hohen Datenraten (gutes Netz) kann dies erheblich Energie sparen.

---

### `AT+RECV` – Empfangspuffer lesen

Liest den zuletzt empfangenen Downlink-Payload oder markiert ihn als gelesen.

| Syntax | Funktion |
|---|---|
| `AT+RECV?` | Empfangene Daten lesen |
| `AT+RECV=0` | Puffer als gelesen markieren (Länge auf 0 setzen) |

**Ausgabe bei vorhandenen Daten:** `REC: P:<port>:<len>:<hex>`

```
AT+RECV=?
REC: P:8:0C:703D3336303020686B723D30
OK

AT+RECV=0
OK
```

Ohne Daten: `AT_ERROR`

---

### `AT+SAVECFG` – Konfiguration speichern

Speichert die aktuelle Gerätekonfiguration (DevEUI, AppEUI, DevAddr, NWK/APP-Key, ADR-Status, aktuelle Datenrate) persistent im Flash (letztes 2k-Segment der CPU).

```
AT+SAVECFG
SAVE CONFIG OK
OK
```

Bei Fehler: `SAVE CONFIG ERROR`

> [!NOTE]
> `AT+SAVECFG` speichert die Struktur `AppConfig_t` aus `stb_tools.h`. Im vorletzten 2k-Segment liegen die durch `AT+CS` gespeicherten Stack-Kontext-Daten. `AT+RFS` löscht beide Segmente.

---

## Beispiele

### Inbetriebnahme: Keys setzen und Join (OTAA)

Meldung nach Reset (Werkseinstellungen, noch kein gespeicherter Kontext):

```
--- LTX-AT-MODEM V1.4 Type:8000 ---
(C)JoEmbedded.de 
*** WARNING: No CONFIG Presets! ***
DEVEUI: 00:80:E1:15:05:31:06:08
LoRa.ADR: 1
LoRa.DR: 0
```

Zustand und Default-Keys prüfen:

```
AT+NVMJS=?
NVM: MJ:0 DN:-1 JN:-1
OK
AT+XSTATE=?
XS: J:0
OK
AT+APPEUI=?
01:01:01:01:01:01:01:01
OK
AT+NWKKEY=?
C0:DE:42:CA:FE:BA:BE:AE:51:FA:CA:DE:FA:CA:DE:51
OK
```

Eigene Keys und LoRa-Parameter setzen (ADR aus, DR3 für mehr Payload), dann speichern:

```
AT+DEUI=00:11:22:33:44:55:66:77
OK
AT+APPEUI=11:11:11:11:22:22:22:22
OK
AT+NWKKEY=01:23:45:67:01:23:45:67:01:23:45:67:01:23:45:67
OK
AT+ADR=0
OK
AT+DR=3
OK
AT+SAVECFG
SAVE CONFIG OK
OK
```

JOIN und Kontext sichern:

```
AT+JOIN=1
OK
+EVT:JOINED
+EVT:FINISH
AT+CS
OK
```

---

### Senden mit Zeitabgleich (bestätigt)

```
AT+LTIME=?
LTIME: 00:37:36 01.01.1970 T:2256
OK
AT+TIMEREQ
OK
AT+SEND=3:1:112233
OK
+EVT:SEND_CONFIRMED
+EVT:SEND_CONFIRMED
+EVT:RX_1, PORT 0, DR 3, RSSI -54, SNR 10
+EVT:TIME RECEIVED
+EVT:FINISH
AT+LTIME=?
LTIME: 13:32:48 13.12.2025 T:1765632768
OK
AT+XSTATE=?
XS: J:378 C:250 LS:249 LT:249 R:0 E:-2 D:3
OK
```

---

### Downlink-Empfang mit Puffer-Abfrage

Server sendet Downlink zurück:

```
AT+SEND=3:0:11
OK
+EVT:8:0C:703D3336303020686B723D30
+EVT:RX_1, PORT 8, DR 3, RSSI -58, SNR 11
+EVT:FINISH
```

Zustand pollen und Puffer auslesen:

```
AT+XSTATE=?
XS: J:1340 C:21 LS:20 LT:1211 R:12 E:-1 D:3
OK
AT+RECV=?
REC: P:8:0C:703D3336303020686B723D30
OK
AT+RECV=0
OK
```

---

### Neustart mit gespeichertem Kontext

```
ATZ

--- EVK-Nucleo-WL55JC1 V1.4 Type:8000 ---
(C)JoEmbedded.de (Dec 13 2025 15:03:28)
CONFIG RESTORED
DEVEUI: 00:11:22:33:44:55:66:77
LoRa.ADR: 0
LoRa.DR: 3
RESTORED CONTEXT

AT+JOIN=1
OK
+EVT:JOINED
+EVT:FINISH
```

> `AT+JOIN=1` ist nach einem Neustart nur nötig, wenn die Frame-Counter-Validation auf dem Server aktiviert ist.

---

## Kurzreferenz aller möglichen Befehle

| Befehl | Typ | Quelle | Beschreibung |
|---|---|---|---|
| `AT` | – | AN5481 | Test |
| `AT?` | R | AN5481 | Alle Befehle auflisten |
| `ATZ` | – | AN5481 | MCU-Reset |
| `AT+VL` | R/W | AN5481 | Verbose-Level `[0:3]` |
| `AT+LTIME` | R | AN5481+LTX | Lokale UTC-Zeit (+ Unix-Sekunden `T:`) |
| `AT+RFS` | – | AN5481 | Factory-Reset (löscht NVM + Flash) |
| `AT+CS` | – | AN5481 | Stack-Kontext speichern |
| `AT+APPEUI` | R/W | AN5481 | Application EUI (8 Byte) |
| `AT+NWKKEY` | R/W | AN5481 | Network Root Key (16 Byte) |
| `AT+APPKEY` | W | AN5481 | Application Root Key (16 Byte) |
| `AT+APPSKEY` | W | AN5481 | App Session Key (16 Byte) |
| `AT+NWKSKEY` | W | AN5481 | Network Session Key (16 Byte) |
| `AT+DADDR` | R/W | AN5481 | Device Address (4 Byte) |
| `AT+DEUI` | R/W | AN5481 | Device EUI (8 Byte) |
| `AT+NWKID` | R/W | AN5481 | Network ID |
| `AT+JOIN` | W | AN5481 | Join-Netzwerk |
| `AT+LINKC` | – | AN5481 | Link-Check-Anfrage |
| `AT+SEND` | W | AN5481 | Daten senden |
| `AT+VER` | R | AN5481 | Firmware-Version |
| `AT+ADR` | R/W | AN5481 | Adaptive Data Rate `[0:1]` |
| `AT+DR` | R/W | AN5481 | Datenrate `[0:7]` |
| `AT+BAND` | R/W | AN5481 | Frequenzregion `[0:9]` |
| `AT+CLASS` | R/W | AN5481 | Geräteklasse `[A:B:C]` - *nur Class A* |
| `AT+DCS` | R/W | AN5481 | Duty Cycle `[0:1]` |
| `AT+JN1DL` | R/W | AN5481 | Join RX1 Verzögerung (ms) |
| `AT+JN2DL` | R/W | AN5481 | Join RX2 Verzögerung (ms) |
| `AT+RX1DL` | R/W | AN5481 | RX1 Verzögerung (ms) |
| `AT+RX2DL` | R/W | AN5481 | RX2 Verzögerung (ms) |
| `AT+RX2DR` | R/W | AN5481 | RX2 Datenrate |
| `AT+RX2FQ` | R/W | AN5481 | RX2 Frequenz (Hz) |
| `AT+TXP` | R/W | AN5481 | TX-Leistungsindex `[0:5]` |
| `AT+PGSLOT` | R/W | AN5481 | Ping-Slot-Periodizität `[0:7]` |
| `AT+TTONE` | – | AN5481 | RF-Ton starten |
| `AT+TRSSI` | – | AN5481 | RF-RSSI messen |
| `AT+TCONF` | R/W | AN5481 | RF-Testkonfiguration |
| `AT+TTX` | W | AN5481 | PER TX-Test |
| `AT+TRX` | W | AN5481 | PER RX-Test |
| `AT+TTH` | W | AN5481 | RF-Hopping-Test |
| `AT+TOFF` | – | AN5481 | RF-Test stoppen |
| `AT+CERTIF` | W | AN5481 | Zertifizierungsmodus |
| `AT+BAT` | R | AN5481 | Batteriestand |
| `AT+TIMEREQ` | – | **LTX** | Netzzeit-Anforderung (nächster Uplink) |
| `AT+NVMJS=?` | R | **LTX** | NVM Join-Status lesen |
| `AT+XSTATE=?` | R | **LTX** | Laufzeitzustand abfragen |
| `AT+RECV` | R/W | **LTX** | Downlink-Puffer lesen / quittieren |
| `AT+SAVECFG` | – | **LTX** | Konfiguration im Flash speichern |

*Typ: R = nur lesen, W = nur schreiben, R/W = lesen und schreiben, – = Aktion*


***