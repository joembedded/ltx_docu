# LTX-Logger – Parameter-Referenz

**Stand:** V0.11 / 24.04.2026 / (C) JoEmbedded.de

---

## Inhaltsverzeichnis

- [1. Übersicht](#1-übersicht)
  - [Dateiformat](#dateiformat)
- [2. Grundlegende Konzepte](#2-grundlegende-konzepte)
  - [2.1 Housekeeping-Kanäle (HK, intern Kanäle 90–99)](#21-housekeeping-kanäle-hk-intern-kanäle-9099)
  - [2.2 Messwert-Berechnung (Linearisierung)](#22-messwert-berechnung-linearisierung)
  - [2.3 Energieverbrauchsschätzung](#23-energieverbrauchsschätzung)
- [3. `iparam.lxp` – IPARAM](#3-iparamlxp--iparam)
  - [3.1 Grundeinstellungen (Block `@100`)](#31-grundeinstellungen-block-100)
  - [3.2 Kanalparameter (Blöcke `@0` … `@89`)](#32-kanalparameter-blöcke-0--89)
- [4. `sys_param.lxp` – Systemparameter (Block `@200`)](#4-sys_paramlxp--systemparameter-block-200)
- [5. Einzelzugriff auf Parameter (Single-Line-Zugriff)](#5-einzelzugriff-auf-parameter-single-line-zugriff)
  - [Syntax](#syntax)
  - [Beispiele](#beispiele)
- [6. Beispielkonfiguration – Gerät `LTXAB284B80`](#6-beispielkonfiguration--gerät-ltxab284b80)
  - [6.1 `iparam.lxp` – Grundeinstellungen](#61-iparamlxp--grundeinstellungen)
  - [6.2 `iparam.lxp` – Kanäle](#62-iparamlxp--kanäle)
  - [6.3 `sys_param.lxp` – Systemparameter](#63-sys_paramlxp--systemparameter-dieses-gerätes)
- [7. Wichtige Hinweise](#7-wichtige-hinweise)

---

## 1. Übersicht

LTX-Logger nutzen intern ein Dateisystem und verfügen über 1MB bis 16MB (max. 128MB) Flash-Speicher. Unabhängig vom Kommunikationsweg (Mobilfunk, LoRaWAN, Satellit, Bluetooth, etc.) sind sämtliche Konfigurationsdaten in genau zwei Textdateien gespeichert, während die Messwerte selbst in weiteren 1–2 Dateien gespeichert werden.

| Parameter-Datei | Block-Kennung | Inhalt (ASCII   ) |
|---|---|---|
| `iparam.lxp` | `@100` + `@0`…`@89` | Messparameter, Timing, Kanaleinstellungen |
| `sys_param.lxp` | `@200` | Systemparameter: Netzwerk, Batterie, Speicher |

| Messwert-Datei | Inhalt (ASCII) |
|---|---|
| `data.edt` |  Daten-Datei mit Messwerten |
| *`data.edt.old`* |  Optionale (vorhergehende) Daten-Datei mit (älteren) Messwerten |


Die genaue Funktion der einzelnen Parameter-Dateien und Parameter wird in diesem Dokument erklärt. Die Messwert-Dateien sind separat dokumentiert.

> [!NOTE]
> Es ist nicht wichtig alle Zeilen einzeln zu verstehen, diese Doku ist lediglich als Referenz vorgesehen.

### Dateiformat

Beide Dateien sind **zeilenweise ASCII-Textdateien**. Jede Zeile enthält genau einen Parameterwert. Kommentare oder Leerzeilen sind im Gerät nicht vorhanden – die Reihenfolge der Zeilen ist zwingend einzuhalten. Zeilen, die mit `@` beginnen, sind Block-Trennmarken und Teil des Inhalts (z. B. `@100`, `@0`, `@1`).

> **Hinweis zum Cookie:** Der `Cookie`-Parameter (iparam Index 4) ist ein 10-stelliger Unix-Timestamp (erweitert auf uint32, daher valide bis zum Jahr 2100), der bei jeder manuellen Parameteränderung durch den Zeitpunkt der Änderung ersetzt werden soll. Dadurch sind verschiedene Parametersätze eindeutig unterscheidbar.

---

## 2. Grundlegende Konzepte

Drei wichtige Punkte sollen vorab erläutert werden:
- Housekeeping (HK)
- Linearisierung
- Energieberechnung

Das **Housekeeping (HK)** sind Verwaltungsdaten, die nicht allzu häufig gemessen werden müssen. Beispielsweise die Batteriekapazität oder Innenfeuchte. Es genügt, diese Werte alle paar Messungen, z.B. einmal täglich zu messen. So benötigen sie weniger Platz oder wertvolle Übertragungsbandbreite. Rein technisch stehen maximal 10 HK-Kanäle zur Verfügung. Je nachdem, was die Hardware kann, ist die Maximalcodierung in den Parametern hinterlegt.

Die meisten LTX-Geraete haben bis zu 90 Messkanaele (0-89) und 10 HK-Kanaele (90-99). Die tatsaechliche Anzahl der Messkanaele wird durch die Firmware festgelegt (`MAX_CHANNELS`): Typ 1800 hat 48 Messkanaele, Typ 1801 ist hardwaregleich zu Typ 1800, hat aber 90 Messkanaele und benoetigt deshalb seine eigene Firmware.

Zur **Linearisierung**: Die LTX-Logger können Sensoren einfach linearisieren. Dies kann z.B. hilfreich sein bei:
- Umwandlung elektrischer Spannung oder Strom in einen Wasserstand (Stichwort 4-20 mA)
- Tarierung von Wasserstandssonden auf 'Abstich' oder 'Füllhöhe'

Das System wird im Folgenden erklärt.


Das dritte ist die **Energieberechnung**. Bei vielen Akkus oder Batterien kann man über die Spannung recht gut den Füllstand berechnen, z.B. bei Blei-Gel-Akkus oder bei Alkali-Mangan. Bei anderen Systemen, z.B. Lithium-Batterien ist die Spannung oft bis kurz vor Ende nahezu konstant. Dazu summieren die LTX Geräte die verbrauchte Energie ungefähr auf. Es ist zwar nur ein Richtwert, aber zumindest eine oft wertvolle Hilfe.

Beispielsweise bei LoRaWAN hat die sich automatisch anpassende Datenrate oft gravierenden Einfluss auf die Lebensdauer der Batterien. Dies kann durchaus ein Faktor von über 10 - 20 sein! Und ob eine Batterie schon nach 1 oder erst nach 10 Jahren gewechselt wird, ist schon ein relevanter Punkt.


### 2.1 Housekeeping-Kanäle (HK, intern Kanäle 90–99)

HK-Sensoren sind interne Sensoren des Loggers und erscheinen auf den Kanälen 90–99. Sie sind **nicht** in `iparam.lxp` konfiguriert, sondern werden durch `HK_FLAGS` (Index 3, Firmware-Kennung) und `HK-Flags` (Index 13, User-Aktivierung) gesteuert.

| Bit | Wert | Kanal | Beschreibung |
|---|---|---|---|
| Bit 0 | 1 | 90 | Batteriespannung (V) |
| Bit 1 | 2 | 91 | Interne Temperatur (°C) |
| Bit 2 | 4 | 92 | Interne Luftfeuchte (%) |
| Bit 3 | 8 | 93 | Ladestand Batterie (%) |
| Bit 4 | 16 | 94 | Barometrischer Luftdruck (hPa) |

Die Aufzeichnungshäufigkeit wird durch `HK-Reload` (Index 14) gesteuert. Wert `6` bedeutet: HK wird bei jeder 6. Messung aufgezeichnet.

---

### 2.2 Messwert-Berechnung (Linearisierung)

Für jeden Kanal kann eine lineare Skalierung konfiguriert werden:

$$\text{Messwert} = \text{Rohwert} \times \text{Faktor} - \text{Offset}$$

| Parameter | Mnemonic | Beschreibung |
|---|---|---|
| Faktor | `m` | Multiplikator (Standard: `1.0`) |
| Offset | `o` | Subtrahierter Offset nach Multiplikation (Standard: `0.0`) |

**Beispiel:** Rohwert = 1,05 bar, Faktor = 1,0, Offset = 0,05 → Messwert = 1,05 × 1,0 − 0,05 = **1,00 bar**

---

### 2.3 Energieverbrauchsschätzung

Der Logger berechnet den Energieverbrauch pro Messzyklus aus folgenden Werten:

- **`mAmsec/Measure`** (sys_param Index 18): Basisenergie einer Messung in mA·ms
- **`Messbits`** (iparam Kanal Index 12): Kanalspezifischer Zusatzverbrauch in mA·sec

$$E_{\text{Gesamt}} = E_{\text{Basis}} + \sum_{\text{Kanäle}} E_{\text{Kanal}}$$

**Beispiel Gerät `LTXAB284B80` (weiter unten beschrieben):**
- Basis: 1000 mA·ms
- Kanal @0 (Druck, SDI-12): 60 mA·sec
- Kanal @1 (Temperatur, aus Cache)
- **Gesamt pro Messung:** ≈ 32 mAsec , Messung selbst dauert ca. 0.5 sec (ohne Vorlaufzeit)

**Schritt 1 – Messenergie pro Jahr (ohne Modem):**

Bei einer Messperiode von 600 s ergeben sich pro Jahr ca. 53000 Messungen oder etwa 450 mAh pro Jahr.

Die Messenergie ist gegenüber der Batteriekapazität von 12.000 mAh **relativ vernachlässigbar**. Der dominierende Faktor ist das Modem.


**Schritt 2 – Modemenergie (Rechenbeispiel: Übertragung alle 2 Stunden, Modem 20 s bei 100 mA)**

Energie pro Übertragung beträgt etwa 200 mA für 10 Sekunden.
Das sind ≈ 4400 Übertragungen pro Jahr bei 2-Stunden-Intervall, also etwa 2.4 Ah/Jahr für das Modem.


**Schritt 3 – Gesamtenergie und Batterielaufzeit**

In der Summe ergibt sich eine Batterielaufzeit von etwa 4.2 Jahre bei 10-minütiger Messung und Übertragung alle 2 Stunden.

> **Vergleich:** Bei **4-stündlicher** Übertragung (wie in der Beispielkonfiguration) erhöht sich die Batterielaufzeit ≈ **7.5 Jahre**.  

> [!NOTE]
> Das Übertragungsintervall hat weit größeren Einfluss auf die Batterielaufzeit als die Messfrequenz. Die Messenergie selbst spielt praktisch keine Rolle.

> [!TIP]
> **Hinweis zu LoRaWAN:** Bei LoRaWAN variiert die Sendezeit je nach Spreading Factor stark. SF12 kann ein Vielfaches (Faktor 10–20) der Energie von SF7 verbrauchen. Das Übertragungsintervall und der Spreading Factor sind daher die wichtigsten Parameter für die Batterielebensdauer bei LoRaWAN-Geräten.


---

Nun aber zu den **Parameterdateien**


## 3. `iparam.lxp` – IPARAM

Die Datei `iparam.lxp` besteht aus 2 Blöcken. Zuerst die Grundeinstellungen, dann die einzelnen Kanalspezifischen Einstellungen

### 3.1 Grundeinstellungen (Block `@100`)

Der erste Block der Datei `iparam.lxp` enthält alle geräteweiten Einstellungen: Timing, Aufzeichnungsart, Internet-Übertragung und Systemverhalten. Mit `*` markierte Parameter sind fest durch die Firmware vorgegeben und sollten nicht manuell editiert werden.

| Idx | MP-Name | Mnemonic | Typ | Wertebereich | Standard | Beschreibung |
|---|---|---|---|---|---|---|
| 0 | I | `I` | String, FIX | `@100` | `@100` | **Dateikennung.** Magische Kennung, muss exakt `@100` lauten. Identifiziert den Block als Basis-Parameterblock. *(nicht editierbar)* |
| 1 | T | `T` | Uint16, FIX | gerätespez. | – | **Gerätetyp.** Numerische Kennung des Firmware-Typs (z. B. `1700` für LTX-Intent, `1500` für LTX-Intent ältere Serie). Muss zur geflashten Firmware passen; z. B. sind Typ 1800 und Typ 1801 trotz gleicher Hardware getrennte Firmware-Typen. *(nicht editierbar)* |
| 2 | M | `M` | Uint16, FIX | gerätespez. | – | **MAX_CHANNELS.** Maximal unterstützte Anzahl Messkanäle (User-Kanäle 0–89). Wird durch die Firmware festgelegt; Typ 1800 = 48, Typ 1801 = 90. *(nicht editierbar)* |
| 3 | H | `H` | Uint16, FIX | Bitmaske | – | **HK_FLAGS (Firmware).** Für jeden vorhandenen Housekeeping-Sensor ein gesetztes Bit. Maximal 10 Bits. HK-Sensoren erscheinen intern auf Kanälen 90–99. *(nicht editierbar)* |
| 4 | C | `C` | Uint32, intern | 10-stellig | – | **Cookie.** 10-stelliger Unix-Timestamp. Muss bei jeder manuellen Parameteränderung durch den aktuellen Zeitpunkt ersetzt werden, damit Parameterdateien eindeutig voneinander unterschieden werden können. |
| 5 | n | `n` | String | max. 41 Zeichen | – | **Gerätename.** Frei wählbarer Name des Loggers. Die ersten 10 Zeichen werden auch für das BLE-Advertising verwendet und sind daher besonders relevant (max. 11 Zeichen für BLE sichtbar). |
| 6 | p | `p` | Uint32 | 10 … 86400 s | 600 | **Messung-Periode** (Sekunden). Grundtakt für alle Messungen. Beispiel: `600` = alle 10 Minuten messen. Basis für alle abhängigen Perioden. |
| 7 | o | `o` | Uint32 | 0 … (Period−1) s | 0 | **Perioden-Offset** (Sekunden). Verschiebt den Startzeitpunkt innerhalb der Messperiode. Nützlich, wenn mehrere Logger zeitversetzt messen sollen, um Funkverkehr zu staffeln. |
| 8 | a | `a` | Uint32 | 0 … Period s | 0 | **Alarm-Messperiode** (Sekunden). Feineres Messraster, das im Alarmfall aktiv wird. Bei `0`: kein separater Alarm-Takt. Muss ≤ `Period_sec` sein. |
| 9 | t | `t` | Uint32 | 0 … 604799 s | 3600 | **Internet-Übertragungs-Periode** (Sekunden). Legt fest, wie oft Daten ins Internet übertragen werden. Bei `0`: bei jeder Messung übertragen. Beispiel: `3600` = stündlich übertragen, auch wenn alle 10 Minuten gemessen wird. |
| 10 | l | `l` | Uint32 | 0 … Period_Internet s | 0 | **Internet-Alarm-Periode** (Sekunden). Im Alarmfall häufigere Übertragung. Bei `0`: kein separater Alarm-Übertragungs-Takt. |
| 11 | u | `u` | Int32 | −43200 … 43200 s | 3600 | **UTC-Offset** (Sekunden). Der Logger läuft intern in UTC. Dieser Offset gibt die lokale Zeitzone an. Beispiel: `3600` = UTC+1 (Mitteleuropäische Zeit / Winterzeit), `7200` = UTC+2 (Sommerzeit). |
| 12 | f | `f` | Uint16 | Bitmaske | 3 | **Aufzeichnungs-Flags.** Steuert Art und Weise der Datenspeicherung (Bitmaske): `Bit 0` (1): Aufzeichnung ein; `Bit 1` (2): Ringspeicher (Ring-Buffer); `Bit 2` (4): Komprimierte Ablage (Base64, spart Speicher, schwerer direkt lesbar). Empfohlene Werte: `0` (Aus) oder `3` (Ein + Ring). Wert `1` (Linear) nur in Ausnahmefällen – Logger stoppt am Speicherende. |
| 13 | h | `h` | Uint16 | Bitmaske | 1 | **HK-Sensor-Aktivierung (User).** Bitmaske, welche Housekeeping-Sensoren aktiv aufgezeichnet werden sollen: `Bit 0` (1)=Batteriespannung, `Bit 1` (2)=Temperatur, `Bit 2` (4)=Luftfeuchte, `Bit 3` (8)=Prozent-Ladung, `Bit 4` (16)=Barometrischer Luftdruck. Beispiel: `31` = alle 5 Sensoren aktiv (1+2+4+8+16). |
| 14 | r | `r` | Uint16 | 0 … 255 | 6 | **HK-Reload.** Gibt an, bei jeder wievielten Messung HK-Sensoren aufgezeichnet werden. `6` = jede 6. Messung. `0` = HK nur nach Reset oder bei Internet-Übertragung, danach nie wieder. |
| 15 | m | `m` | Uint16 | 0 … 3 | 0 | **Netzwerk-Modus.** `0`=Aus (kein Internet), `1`=Normal (OnOff – Modem nach Übertragung abschalten), `2`=Modem 5 Minuten anlassen (nur für Tests), `3`=Modem dauerhaft (nur für Tests). Modi 2 und 3 sind **nicht CE-konform** und nur für Testzwecke. |
| 16 | e | `e` | Uint16 | 0 … 2 | 1 | **Fehlerbehandlung.** `0`=Keine Wiederholung, `1`=Wiederholung nur bei Alarmen, `2`=Wiederholung bei allen Übertragungsfehlern. Gilt nur bei Mobilfunk. |
| 17 | d | `d` | Int16 | −40 … 10 °C | −10 | **Mindesttemperatur für Übertragung** (°C). Unterhalb dieser Temperatur wird keine Mobilfunkübertragung gestartet, um Alkalibatterien bei Kälte zu schonen. Bei Lithiumbatterien kann −40 eingestellt werden (kein Problem). |
| 18 | c | `c` | Uint32 | Bitmaske | 0 | **Konfigurations-Bits.** Sammelbits für verschiedene Optionen: `Bit 0` (1): Internet-Periode im Offline-Betrieb An/Aus; `Bit 1+2`: BLE-Modus (On / Modem / Li / MoLi); `Bit 3` (8): DS-Sensor aktivieren; `Bit 4` (16): CE-Modus An/Aus; `Bit 5` (32): Live-Modus An/Aus. |
| 19 | i | `i` | String | max. 121 Zeichen | leer | **Konfigurations-Kommando.** Spezial-Konfigurationstext, z. B. für FTP-Einstellungen. Format und Inhalt sind separat dokumentiert. Bei Standardbetrieb leer. |
| 20 | s | `s` | Uint32 | 0 … 86399 s | 0 | **Internet-Übertragungs-Offset** (Sekunden). Verschiebt den Startzeitpunkt für Internetübertragungen innerhalb der Internet-Periode, analog zu `Period_Offset` für Messungen. |

---

### 3.2 Kanalparameter (Blöcke `@0` … `@89`)

Nach dem `@100`-Block folgen die Kanal-Blöcke. Jeder Kanal beginnt mit `@N` (z. B. `@0`, `@1`, …) und enthält exakt 13 weitere Zeilen (Indices 1–13). Kanäle müssen **aufsteigend und lückenlos** nummeriert sein. Maximal 90 User-Kanäle (0–89) sind möglich.

| Idx | MP-Name | Mnemonic | Typ | Wertebereich | Standard | Beschreibung |
|---|---|---|---|---|---|---|
| 0 | N | `N` | Uint16, FIX | `@0` … `@89` | – | **Kanalkennung.** Block-Trennmarke mit der Kanal-Nummer, z. B. `@0`. Neue Kanäle müssen aufsteigend und lückenlos ergänzt werden. *(nicht editierbar)* |
| 1 | a | `a` | Uint16 | 0 … 65535 | 0 | **Action.** Steuert, was mit dem Kanal geschehen soll (Bitmaske): `Bit 0` (1)=Kanal messen und aufzeichnen; `Bit 1` (2)=Wert aus Cache lesen (kein eigener Messvorgang); `Bit 2` (4)=Alarme für diesen Kanal auswerten. Typische Werte: `1`=aktiv messen, `3`=aufzeichnen + aus Cache (für Zweitgrößen eines Sensors). |
| 2 | p | `p` | Uint16 | 0 … 65535 | 0 | **Physikalischer Kanal (Bus).** Bitmaske zur Zuordnung des physikalischen Messkanals. Beispiel: `768` (= 0x300 = Bits 8+9) = SDI-12 auf Bus 0. Weitere Werte für I²C-Kanäle oder Spezialanpassungen sind separat dokumentiert. |
| 3 | c | `c` | String | max. 8 Zeichen | leer | **Kanal-Capabilities.** Fähigkeiten des Kanals als String. Derzeit nicht aktiv genutzt, für zukünftige Erweiterungen (z. B. Einheitensysteme) reserviert. |
| 4 | i | `i` | Uint16 | 0 … 255 | 0 | **Quellindex.** Index des Messwertes im Sensor-Cache: `0`=erster Messwert, `1`=zweiter Messwert usw. (für Sensoren, die mehrere Werte liefern). Werte ab `100` sind Spezial-Rechenwerte (z. B. barometrische Kompensation, separat dokumentiert). |
| 5 | u | `u` | String | max. 8 Zeichen | leer | **Einheit.** Einheitenstring des Kanals, z. B. `bar`, `°C`, `m`, `%`. Möglichst kurz halten (Sonderzeichen erlaubt). |
| 6 | f | `f` | Uint16 | 0 … 255 | 9 | **Speicher-Format.** Nachkommastellen für die ASCII-Ablage im Speicher: `0`=keine Nachkommastelle, `1`–`8`=Nachkommastellen. Werte `>10` sind Spezialformate. `Bit 7` (128): Kurzfloat (F16) für LoRa/UDP-Kanäle verwenden. Bei komprimierter Aufzeichnung (Base64) wird immer Float32 verwendet. |
| 7 | d | `d` | Uint32 | 0 … 2·10³¹ | 0 | **Datenbank-ID.** Optionaler Identifier, um den Kanal einer Messstelle in einem externen System zuzuordnen. Rein für Administration, hat keinen Einfluss auf das Messverhalten. |
| 8 | o | `o` | Float32 | beliebig | 0.0 | **Offset.** Linearisierungs-Offset. Messwert = Rohwert × Faktor − Offset. Wird nach der Multiplikation mit dem Faktor abgezogen. Standard: `0.0` (kein Offset). |
| 9 | m | `m` | Float32 | beliebig | 1.0 | **Faktor (Multiplikator).** Linearisierungsfaktor. Messwert = Rohwert × Faktor − Offset. Standard: `1.0` (keine Skalierung). |
| 10 | h | `h` | Float32 | beliebig | 0.0 | **Alarm-Obergrenze.** Wenn `Bit 2` in Action gesetzt: Alarm wird ausgelöst, wenn Messwert > Alarm_hi. Bei `0.0` und nicht aktivem Alarm-Bit ohne Funktion. |
| 11 | l | `l` | Float32 | beliebig | 0.0 | **Alarm-Untergrenze.** Wenn `Bit 2` in Action gesetzt: Alarm wird ausgelöst, wenn Messwert < Alarm_lo. Bei `0.0` und nicht aktivem Alarm-Bit ohne Funktion. |
| 12 | b | `b` | Uint16 | 0 … 65535 | 0 | **Messbits.** Mehrzweck-Parameter. Bei SDI-12-Kanälen: Energieverbrauch in mA × s pro Messung (z. B. `60` für einen Piezo-Drucksensor Typ 310). Wird für Energieverbrauchsberechnungen genutzt. Weitere Verwendungen sind gerätespezifisch und separat dokumentiert. |
| 13 | x | `x` | String | max. 32 Zeichen | leer | **Xbytes.** Zusatzkonfiguration für den Sensor. Bei SDI-12-Sensoren enthält dieser String das Messkommando, z. B. `*1800 1MC` für ältere STS-Pegelsonden. Inhalt und Format sind sensor- bzw. busabhängig und separat dokumentiert. |

---

## 4. `sys_param.lxp` – Systemparameter (Block `@200`)

Die Datei `sys_param.lxp` enthält Netzwerk-, Batterie- und Speicherparameter, die der normale Benutzer in der Regel nicht ändern muss. Sie werden bei der Inbetriebnahme konfiguriert und bleiben danach konstant.

| Idx | MP-Name | Mnemonic | Typ | Wertebereich | Gerät (Beispiel) | Beschreibung |
|---|---|---|---|---|---|---|
| 0 | I | `I` | String, FIX | `@200` | `@200` | **Dateikennung.** Muss exakt `@200` lauten. *(nicht editierbar)* |
| 1 | a | `a` | String | max. 65 Zeichen | `iot.1nce.net` | **APN (Access Point Name).** Mobilfunk-Zugangspunkt der SIM-Karte. Beispiele: `iot.1nce.net` für 1NCE-SIMs, `internet.telekom` für Telekom. |
| 2 | s | `s` | String | max. 65 Zeichen | `joembedded.de` | **Server / VPN.** Internet-Adresse des Zielservers für Datenübertragung. Kann auch ein VPN-Gateway sein. |
| 3 | c | `c` | String | max. 65 Zeichen | `ltx/xxSWxx/lxu_v1.php` | **Script / ID.** Pfad zum serverseitigen Empfangsskript. Bei HTTP/HTTPS: relativer URL-Pfad; bei anderen Protokollen: Protokoll-ID. |
| 4 | k | `k` | String | max. 65 Zeichen | `xxAPIxKEYxx` | **API-Key.** Zugriffsschlüssel, mit dem sich der Logger beim Server authentifiziert. Muss mit der Serverkonfiguration übereinstimmen. |
| 5 | f | `f` | Uint16 | 0 … 255 | `2` | **Verbindungs-Flags** (Bitmaske): `Bit 0` (1)=Verbose (ausführliches Logging); `Bit 1` (2)=Roaming erlaubt (Standard bei modernen SIMs empfohlen); `Bit 4` (16)=Log-Datei schreiben (max. ~100 kB, nur bei Bedarf); `Bit 5` (32)=UART-Logging; `Bit 7` (128)=Debug. Gerät: `2` = nur Roaming aktiv. |
| 6 | n | `n` | Uint16 | 0 … 65535 | `0` | **SIM-PIN.** PIN der SIM-Karte als Zahl. `0` = keine PIN (SIM nicht gesperrt). |
| 7 | u | `u` | String | max. 65 Zeichen | leer | **APN-Benutzername.** Nur bei APN-Authentifizierung erforderlich. In der Regel leer. |
| 8 | w | `w` | String | max. 65 Zeichen | leer | **APN-Passwort.** Nur bei APN-Authentifizierung erforderlich. In der Regel leer. |
| 9 | r | `r` | Uint16 | 10 … 255 s | `60` | **Netzsuche-Timeout** (Sekunden). Maximale Zeit für die Netzregistrierung. Bei Fehlern sucht das Gerät ggf. selbständig bis zu 240 Sekunden. |
| 10 | p | `p` | Uint16 | 1 … 65535 | `80` | **Port.** UDP/TCP-Port für die Serververbindung oder LoRaWAN-FPort. Standard HTTP: `80`, HTTPS: `443`. |
| 11 | t | `t` | Uint16 | 1000 … 65535 ms | `20000` | **Server-Timeout (Initial)** (Millisekunden). Timeout bis zur ersten Serverantwort beim Verbindungsaufbau. `20000` = 20 Sekunden. |
| 12 | v | `v` | Uint16 | 1000 … 65535 ms | `10000` | **Server-Timeout (laufend)** (Millisekunden). Timeout während einer laufenden Verbindung. `10000` = 10 Sekunden. |
| 13 | e | `e` | Uint16 | 60 … 3600 s | `300` | **Modem-Check-Intervall** (Sekunden). Häufigkeit der Modem-Überwachung. Standardmäßig nicht aktiv genutzt; `300` = Prüfung alle 5 Minuten. |
| 14 | y | `y` | Uint32 | 0 … 100000 mAh | `12000` | **Batteriekapazität** (mAh). Nur informativ, für die prozentuale Ladestandsanzeige. Muss mit den tatsächlich eingesetzten Batterien übereinstimmen. |
| 15 | l | `l` | Float | beliebig | `3.2` | **Batterie leer** (Volt). Spannung, unterhalb derer die Batterie als definitiv leer gilt (= 0 %). Typisch: `3.2 V` für Lithium-Primärzellen. |
| 16 | h | `h` | Float | beliebig | `3.6` | **Batterie voll** (Volt). Spannung, ab der die Batterie als definitiv voll gilt (= 100 %). Typisch: `3.6 V` für Lithium-Primärzellen; bei Alkaline oder Blei-Gel ggf. höher. |
| 17 | g | `g` | Uint32 | 1000 … 2·10³¹ Byte | `4040704` | **Ringspeicher-Größe** (Byte). Maximale Größe des Ringspeichers. Wird normalerweise automatisch vorgegeben (≈ 3,9 MB beim Beispielgerät). |
| 18 | m | `m` | Uint32 | 0 … 10⁹ mA·ms | `1000` | **Energie pro Messung** (mA × ms). Basisenergie für eine einzelne Messung (ohne Sensor-Messbits). Wird zusammen mit den Kanal-Messbits für die Gesamtenergieabschätzung verwendet. |
| 19 | o | `o` | Uint16 | 0 … 255 | `0` | **Mobilfunk-Protokoll** (Bitmaske): `Bit 0` (0/1)=HTTP/HTTPS; `Bit 1` (2)=Push-Benachrichtigung; `Bit 2+3`: TCP/UDP-Setup; `Bit 4+5`: LoRa-Modus. `0` = Standard HTTP. |

---

## 5. Einzelzugriff auf Parameter (Single-Line-Zugriff)

Für breitbandige Verbindungen (z.B. TCP/IP an Internet-Server) oder bei Direktverbindung über Bluetooth werden Dateien direkt per Stream übertragen.

Für schmalbandige Verbindungen (LoRaWAN, Satellit, tw. UDP) sind nur kleine Datenpakete möglich. Um auch hier auf Parameter gezielt zugreifen zu können, können einzelne Parameter über eine kompakte Syntax abgerufen und gesetzt werden, da keine vollständige Datei übertragen werden muss.

Über das gleiche System können so z.B. auch einzelne Kommandos an Modem, Sensoren etc. übermittelt werden.

Zum Übermitteln von einzelnen Kommandos dient das `x`-Kommando:


### Syntax

```
x<Datei><Index/Mnemonic>[<Wert>]
```

> [!NOTE]
> Weitere Kommandos sind z.B. `z..`  oder `@...` . Diese sind im Rahmen der APP oder sensorspezifisch erklärt. Dieses Dokument betrifft nur Parameter.

| Zeichen | Bedeutung |
|---|---|
| `x` | Pflichtpräfix. Unterscheidet Parameter-Kommandos von anderen Befehlen (z. B. AT-Kommandos `@AT…` oder SDI-12-Kommandos `z…`). |
| Datei-Buchstabe | `i` = `iparam.lxp`, `s` = `sys_param.lxp` |
| Index/Mnemonic | Mnemonic-Buchstabe des Parameters (z. B. `p` für Period) **oder** Kanalnummer + Mnemonic (z. B. `12a` für Action von Kanal 12) |
| Wert (optional) | Ohne Wert: aktuellen Wert lesen. Mit Wert: Parameter setzen. |

### Beispiele

| Kommando | Wirkung |
|---|---|
| `xip` | Liest die aktuelle Messperiode aus `iparam.lxp` |
| `xip 1800` | Setzt die Messperiode auf 1800 Sekunden (30 min) |
| `xsl 3.6` | Setzt `batlow` in `sys_param.lxp` auf 3.6 V |
| `xi12a` | Liest die Action von Kanal 12 |
| `xi12a 3` | Setzt die Action von Kanal 12 auf 3 |
| `xiu` | Liest den UTC-Offset |
| `xiu 7200` | Setzt den UTC-Offset auf 7200 s (UTC+2, Sommerzeit) |

> **Wichtig:** Per LoRaWAN oder UDP gesendete Parameter werden automatisch gespeichert. Bei Terminal-Eingabe ist danach das Kommando `xWrite` erforderlich, um die Änderungen dauerhaft zu speichern.

---

## 6. Beispielkonfiguration – Gerät `LTXAB284B80` vom Typ 1700 (2" mit Mobilfunk-Shield LTE cat1 / 2G)

Die folgenden Abschnitte zeigen die vollständige Konfiguration eines realen LTX-Loggers als Referenz für die Interpretation von Parameterdateien.

### 6.1 Teil 1 – `iparam.lxp` – Grundeinstellungen

| Parameter | Mnemonic | Wert | Interpretation |
|---|---|---|---|
| Dateikennung | `I` | `@100` | Gültiger Basis-Block |
| Gerätetyp | `T` | `1700` | LTX-Intent Gerätefamilie |
| Max. Kanäle | `M` | `30` | Firmware unterstützt bis zu 30 User-Kanäle |
| HK-Flags (FW) | `H` | `31` | Bits 0–4 gesetzt: Bat, Temp, Hum, Perc, Baro vorhanden |
| Cookie | `C` | `1000000000` | Parametersatz-Zeitstempel |
| Gerätename | `n` | `LTXAB284B80` | Gerätename (= letzte 10 Zeichen der Geräte-ID) |
| Messperiode | `p` | `600 s` | Messung alle **10 Minuten** |
| Perioden-Offset | `o` | `0 s` | Keine Zeitverschiebung |
| Alarm-Periode | `a` | `0 s` | Kein separater Alarmtakt |
| Internet-Periode | `t` | `3600 s` | Übertragung **stündlich** (jede 6. Messung) |
| Internet-Alarm | `l` | `0 s` | Kein separater Alarm-Übertragungs-Takt |
| UTC-Offset | `u` | `3600 s` | **UTC+1** (Mitteleuropäische Winterzeit) |
| Aufzeichnungs-Flags | `f` | `3` | Bit0+Bit1: **Aufzeichnung ein, Ringspeicher aktiv** |
| HK-Aktivierung | `h` | `31` | Alle 5 HK-Sensoren aktiv (Bat+Temp+Hum+Perc+Baro) |
| HK-Reload | `r` | `6` | HK-Aufzeichnung jede **6. Messung** (= alle 60 min) |
| Netzwerk-Modus | `m` | `1` | **Normal (OnOff)** – Modem nach Übertragung abschalten |
| Fehlerbehandlung | `e` | `0` | Keine Wiederholung bei Übertragungsfehlern |
| Mindesttemperatur | `d` | `−10 °C` | Keine Übertragung unter −10 °C (Alkalischutz) |
| Konfig-Bits | `c` | `0` | Keine Sonderfunktionen aktiv |
| Konfig-Kommando | `i` | *(leer)* | Keine Spezialkommandos |
| Internet-Offset | `s` | `0 s` | Kein Übertragungs-Offset |

### 6.2 Teil 2 – `iparam.lxp` – Kanäle

Das Gerät wurde mit einem SDI-12 Drucksensor ausgerüstet. Der hier verwendete Drucksensor benötigt etwas Vorlaufzeit nach Einschalten des SDI-12-Busses, bis Messwerte zur Verfügung stehen (hier etwa 1,5 Sekunden) und liegt auf SDI-12-Adresse 0. Der Sensor unterstützt CRC-gesicherte Übertragung. Daher lautet das Messkommando (mit 300 msec mehr Vorlauf: `*1800 0MC` )

#### 6.2.1 `iparam.lxp` – Kanal @0 (Drucksensor)


| Parameter | Mnemonic | Wert | Interpretation |
|---|---|---|---|
| Kanalkennung | `N` | `@0` | Kanal 0 |
| Action | `a` | `1` | Bit0: **aktiv messen und aufzeichnen** |
| Physikalischer Kanal | `p` | `768` | SDI-12 Bus 0 (Bits 8+9 gesetzt: 0x300 = 768) |
| Capabilities | `c` | *(leer)* | Keine Sonderfähigkeiten |
| Quellindex | `i` | `0` | **Erster Messwert** des SDI-12-Sensors |
| Einheit | `u` | `bar` | Druckmessung in bar |
| Speicher-Format | `f` | `9` | 9 Nachkommastellen |
| Datenbank-ID | `d` | `0` | Keine externe Zuordnung |
| Offset | `o` | `0.0` | Keine Korrektur |
| Faktor | `m` | `1.0` | Keine Skalierung |
| Alarm-Obergrenze | `h` | `0.0` | Kein Alarm konfiguriert |
| Alarm-Untergrenze | `l` | `0.0` | Kein Alarm konfiguriert |
| Messbits | `b` | `60` | ~60 mA·s Energieverbrauch pro SDI-12-Messung |
| Xbytes | `x` | `*1800 0MC` | SDI-12-Messkommando (z. B. für STS-Pegelsonde: `*1800 0MC`) |

#### 6.2.2 `iparam.lxp` – Kanal @1 (Temperatur aus gleichem Sensor)

| Parameter | Mnemonic | Wert | Interpretation |
|---|---|---|---|
| Kanalkennung | `N` | `@1` | Kanal 1 |
| Action | `a` | `3` | Bit0+Bit1: **aufzeichnen + Wert aus Cache lesen** |
| Physikalischer Kanal | `p` | `768` | SDI-12 Bus 0 (identisch mit Kanal @0) |
| Capabilities | `c` | *(leer)* | Keine Sonderfähigkeiten |
| Quellindex | `i` | `1` | **Zweiter Messwert** aus dem Cache (Temperatur des Drucksensors) |
| Einheit | `u` | `°C` | Temperatur in Grad Celsius |
| Speicher-Format | `f` | `2` | 2 Nachkommastellen |
| Datenbank-ID | `d` | `0` | Keine externe Zuordnung |
| Offset | `o` | `0.0` | Keine Korrektur |
| Faktor | `m` | `1.0` | Keine Skalierung |
| Alarm-Obergrenze | `h` | `0.0` | Kein Alarm konfiguriert |
| Alarm-Untergrenze | `l` | `0.0` | Kein Alarm konfiguriert |
| Messbits | `b` | `0` | Kein eigener Energieverbrauch (Wert kommt aus Cache) |
| Xbytes | `x` | *(leer)* | Kein eigenes Messkommando (Messung durch Kanal @0) |

> **Hinweis zur Kanal-Kopplung:** Kanal @0 löst die eigentliche SDI-12-Messung aus (Action=1). Der Sensor liefert dabei zwei Werte: Index 0 (Druck) und Index 1 (Temperatur). Kanal @1 liest den Temperaturwert nur aus dem Cache (Action=3, srcIndex=1) und triggert keine eigene Messung. Dadurch wird Energie gespart und der Sensor nicht zweifach angesprochen.



### 6.3 `sys_param.lxp` – Systemparameter dieses Gerätes

Die zweite Datei enthält die Einstellungen für die Kommunikation über LTE cat 1 (TCP/IP) mit einem Server:

| Parameter | Mnemonic | Wert | Interpretation |
|---|---|---|---|
| Dateikennung | `I` | `@200` | Gültiger System-Block |
| APN | `a` | `iot.1nce.net` | 1NCE IoT-SIM, kein Roaming-Problem |
| Server | `s` | `joembedded.de` | JoEmbedded Datenserver |
| Script | `c` | `ltx/xxSWxx/lxu_v1.php` | PHP-Empfangsskript auf dem Server |
| API-Key | `k` | `xxAPIxKEYxx` | Geräteklassen-Key für Serverauthentifizierung |
| Verbindungs-Flags | `f` | `2` | Bit1: **Roaming erlaubt** |
| SIM-PIN | `n` | `0` | Keine PIN (SIM nicht gesperrt) |
| APN-User | `u` | *(leer)* | Keine APN-Authentifizierung |
| APN-Passwort | `w` | *(leer)* | Keine APN-Authentifizierung |
| Netzsuche-Timeout | `r` | `60 s` | 60 Sekunden für Netzregistrierung |
| Port | `p` | `80` | Standard-HTTP-Port |
| Server-Timeout (initial) | `t` | `20000 ms` | 20 Sekunden bis zur ersten Antwort |
| Server-Timeout (laufend) | `v` | `10000 ms` | 10 Sekunden während der Verbindung |
| Modem-Check | `e` | `300 s` | Modem-Prüfung alle 5 Minuten |
| Batteriekapazität | `y` | `12000 mAh` | Eingesetzte Batterien (z. B. 8× D-Zellen Lithium) |
| Batterie leer | `l` | `3.2 V` | 0%-Schwelle für Lithium-Primärzellen |
| Batterie voll | `h` | `3.6 V` | 100%-Schwelle für Lithium-Primärzellen |
| Ringspeicher | `g` | `4040704 Byte` | Ringspeichergröße ≈ 3.86 MB |
| Energie/Messung | `m` | `1000 mA·ms` | Basisenergiebedarf einer Messung |
| Protokoll | `o` | `0` | Standard HTTP |

---

## 7. Wichtige Hinweise

1. **Parameterreihenfolge:** Die Reihenfolge der Zeilen in beiden Parameter-Dateien ist zwingend. Fehlende oder zusätzliche Zeilen führen zu Fehlinterpretationen.

2. **Cookie bei Änderungen aktualisieren:** Immer wenn Parameter manuell geändert werden, muss der Cookie (iparam Index 4) durch den aktuellen Unix-Timestamp ersetzt werden. Die APP oder der LTX-Server machen das automatisch.

3. **Kanäle lückenlos:** Kanalnummern müssen aufsteigend und ohne Lücken vergeben werden. Das Hinzufügen von Kanälen in der Mitte ist nicht möglich – nur am Ende.

4. **Unbenutzte Kanäle:** Damit die Parameterdatei `iparam.lxp` immer möglichst klein bleibt, werden nur die ersten aktiven Kanäle gespeichert. Ein Kanal gilt als aktiv, wenn er gemessen wird (seine `action` ist dann > 0). Alle unbenutzten Kanäle oberhalb des letzten aktiven werden von der APP oder dem LTX-Server automatisch entfernt.

5. **Nicht editierbare Parameter:** Parameter mit `*` im Beschreibungsarray (Typ „FIX") werden durch die Firmware gesetzt und dürfen nicht manuell geändert werden (Gerätetyp, Max-Kanäle, HK-Flags, Dateikennung). Sie werden vom Logger geprüft. Inkonsistente Dateien werden nicht weiter gelesen.

6. **Ringspeicher empfohlen:** Flag-Wert `3` (Aufzeichnung + Ringspeicher) ist der empfohlene Betriebsmodus. Linearer Modus (`1`) führt dazu, dass der Logger am Speicherende die Aufzeichnung stoppt. Dies kann für spezielle Anwendungen sinnvoll sein, i.d.R. aber ist der Ringspeicher die bevorzugte Betriebsart.

7. **LoRa/Satellit/tw. UDP:** Bei LoRaWAN oder Satellitenanbindung etc. (schmalbandige Kanäle) können nur Einzelparameter übertragen werden. Hierfür ist der Einzelzugriff (Abschnitt 5) zu verwenden.

---

