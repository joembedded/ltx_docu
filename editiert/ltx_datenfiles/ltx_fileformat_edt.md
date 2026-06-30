# LTX-Logger EDT-Dateiformat

**Stand:** 2026-05-08

Dieses Dokument beschreibt das Easy-Data-Textformat (`*.edt`) der LTX-Logger. Ziel ist, EDT-Dateien korrekt zu lesen, nach CSV zu expandieren und die enthaltenen Messwerte, Housekeeping-Werte und komprimierten Payloads einordnen zu können.

---

## Inhaltsverzeichnis

- [LTX-Logger EDT-Dateiformat](#ltx-logger-edt-dateiformat)
  - [Inhaltsverzeichnis](#inhaltsverzeichnis)
  - [1. Überblick](#1-überblick)
  - [2. Dateien und Historie](#2-dateien-und-historie)
  - [3. Grundstruktur einer EDT-Datei](#3-grundstruktur-einer-edt-datei)
  - [4. Zeilentypen](#4-zeilentypen)
    - [4.1 Info-Tags `<...>`](#41-info-tags-)
    - [4.2 Tabellenkopf `!U`](#42-tabellenkopf-u)
    - [4.3 Messzeilen `!`](#43-messzeilen-)
  - [5. Zeitstempel und CSV-Expansion](#5-zeitstempel-und-csv-expansion)
  - [6. Kanäle, Einheiten und Housekeeping](#6-kanäle-einheiten-und-housekeeping)
    - [6.1 Messkanäle 0 bis 89](#61-messkanäle-0-bis-89)
    - [6.2 Housekeeping-Kanäle 90 bis 99](#62-housekeeping-kanäle-90-bis-99)
  - [7. Fehlerwerte und Alarme](#7-fehlerwerte-und-alarme)
  - [8. Binäre Payload-Zeilen (`$...`)](#8-binäre-payload-zeilen-)
  - [9. Token-Referenz für komprimierte Payloads](#9-token-referenz-für-komprimierte-payloads)
    - [9.1 Tokens 0 bis 89: Messkanäle](#91-tokens-0-bis-89-messkanäle)
    - [9.2 Tokens 90 bis 99: Housekeeping](#92-tokens-90-bis-99-housekeeping)
    - [9.3 Tokens 100 bis 109: synthetische HK-Werte](#93-tokens-100-bis-109-synthetische-hk-werte)
    - [9.4 Tokens 110 bis 127: Steuerkommandos](#94-tokens-110-bis-127-steuerkommandos)
    - [9.5 Tokens 128 bis 255: Erweiterungen](#95-tokens-128-bis-255-erweiterungen)
  - [10. Speicheroptimierung](#10-speicheroptimierung)
  - [11. Beispiel und Interpretation](#11-beispiel-und-interpretation)
    - [11.1 Beispiel mit drei Temperaturkanälen und HK-Werten](#111-beispiel-mit-drei-temperaturkanälen-und-hk-werten)
    - [11.2 Beispiel mit eingebetteter komprimierter Payload](#112-beispiel-mit-eingebetteter-komprimierter-payload)
  - [12. Parser-Checkliste](#12-parser-checkliste)

---

## 1. Überblick

EDT steht für **Easy Data Text**. Das Format ist ein kompaktes, zeilenorientiertes ASCII-Format für Messdaten. Normale Messzeilen sind bewusst menschenlesbar und lassen sich mit wenig Logik in CSV-Tabellen umwandeln.

Wichtige Eigenschaften:

- Zeilenorientierter ASCII-Text.
- Messwerte stehen als Paare `Kanal:Wert`.
- Zeitstempel sind Unix-UTC-Sekunden.
- Relative Zeitstempel beginnen mit `+` und sparen Speicherplatz.
- Kanäle `0` bis `89` sind Messkanäle aus der Parametrierung. Die tatsaechlich verfuegbare Anzahl ist firmwareabhaengig (`MAX_CHANNELS`), z. B. Typ 1800: 48 Messkanaele, Typ 1801: 90 Messkanaele.
- Kanäle `90` bis `99` sind interne Housekeeping-Kanäle.
- Zeilen mit `$` enthalten Base64-codierte binäre Payloads für komprimierte oder zusätzliche Daten.

Die Bedeutung von Messkanälen, Einheiten, Speicher-Flags und HK-Konfiguration ergibt sich aus den Parameterdateien `iparam.lxp` und `sys_param.lxp`; siehe [ltx_parameter_referenz.md](../ltx_parameter/ltx_parameter_referenz.md).

---

## 2. Dateien und Historie

Typische Datenfiles auf dem Logger:

| Datei | Bedeutung |
|---|---|
| `data.edt` | Aktuelle Messdaten-Datei |
| `data.edt.bak` | Vorherige Daten-Datei nach Rotation |
| `data.edt.old` | Alternative Bezeichnung für ältere Daten-Datei, je nach System/Server-Kontext |

Sobald `data.edt` eine definierte Größe erreicht, wird sie auf dem Logger in `data.edt.bak` rotiert. Das Limit liegt typischerweise knapp unter 50 % des verfügbaren Flash-Bereichs. Dadurch bleibt eine Mindesthistorie erhalten.

Für BLE-Synchronisation ist wichtig:

- App und Logger müssen nicht exakt identische `data.edt`-Dateien besitzen.
- Es genügt, wenn sich die Dateien zeitlich überlappen.
- Fehlende Abschnitte können gezielt nachgeladen werden.
- `data.edt.bak` bekommt denselben Dateizeitstempel wie die neue `data.edt`.

Der gemeinsame Zeitstempel hilft der BLE-App, eine Messreihe wiederzuerkennen und nur fehlende Datenbereiche zu übertragen.

---

## 3. Grundstruktur einer EDT-Datei

Eine EDT-Datei besteht aus vier Hauptbestandteilen:

| Typ | Erkennung | Bedeutung |
|---|---|---|
| Info-Tag | `<...>` | Metadaten, Ereignisse, Statusinformationen |
| Tabellenkopf | `!U ...` | Kanalnummern und Einheiten |
| Messzeile | `!...` | Zeitstempel plus `Kanal:Wert`-Paare |
| Payload-Zeile | `$...` | Base64-codierter Binärblock |

Minimaler Ausschnitt:

```text
<NEW>
<COOKIE 1569494503>
!U 0:oC 1:oC 2:oC 90:V_HK 91:oC_HK 92:rH_HK
!1591782000 0:15.74 1:15.77 2:15.72 90:5.89 91:17.3 92:82.6
!+600 0:15.74 1:15.77 2:15.73
```

Die erste Messzeile enthält eine absolute UTC-Zeit (`1591782000`). Die nächste Messzeile enthält `+600`, also 600 Sekunden nach der vorherigen Messzeit.

---

## 4. Zeilentypen

### 4.1 Info-Tags `<...>`

Info-Tags enthalten Metadaten oder Ereignisse. Parser sollten unbekannte Tags speichern oder ignorieren, aber nicht als Fehler behandeln.

| Tag | Bedeutung |
|---|---|
| `<NEW>` | Beginn einer neuen Messreihe oder Datei |
| `<MAC: ...>` | Geräte-MAC oder eindeutige Gerätekennung |
| `<NAME: ...>` | Loggername |
| `<NOWUTC: ...>` | Zeitpunkt der Datei-/Transfererzeugung als lesbare UTC-Zeit |
| `<COOKIE ...>` | Referenz auf den Parametersatz |
| `<NT AUTO OK(6)>` | Automatische Internetübertragung erfolgreich, hier mit 6 Sekunden Dauer |
| `<...>` | Weitere firmware- oder serverabhängige Informationen |

> [!IMPORTANT]
> Der `COOKIE`-Wert ist ein Unix-Timestamp aus `iparam.lxp` und identifiziert den Parametersatz, mit dem die Messdaten entstanden sind. Bei einer Analyse sollte der Cookie möglichst mit der passenden Parameterdatei abgeglichen werden, weil Einheiten, Kanalnamen, HK-Aktivierung und Speicheroptionen aus der Parametrierung kommen.

### 4.2 Tabellenkopf `!U`

Der Tabellenkopf ordnet Kanalnummern Einheiten zu:

```text
!U 0:oC 1:oC 2:oC 90:V_HK 91:oC_HK 92:rH_HK
```

Regeln:

- `!U` leitet die Einheitenzeile ein.
- Danach folgen Paare `Kanal:Einheit`.
- Die Reihenfolge definiert eine sinnvolle CSV-Spaltenreihenfolge.
- Kanäle können später fehlen; fehlende Werte werden beim CSV-Export als leere Zellen ausgegeben.

### 4.3 Messzeilen `!`

Messzeilen beginnen mit `!` und enthalten zuerst eine Zeitangabe, danach beliebig viele `Kanal:Wert`-Paare:

```text
!1591782000 0:15.74 1:15.77 2:15.72 90:5.89 91:17.3 92:82.6
!+600 0:15.74 1:15.77 2:15.73
```

Syntax:

```text
!<Zeit> <Kanal>:<Wert> [<Kanal>:<Wert> ...]
```

| Element | Beschreibung |
|---|---|
| `<Zeit>` | Absolute Unix-UTC-Sekunden oder relative Sekunden mit `+` |
| `<Kanal>` | Dezimalzahl, typischerweise `0` bis `99` |
| `<Wert>` | Zahl, Textfehler oder alarmmarkierter Wert |

Messwerte können Floating-Point-Zahlen oder Textwerte wie `SensorError` oder `NoReply` sein.

---

## 5. Zeitstempel und CSV-Expansion

EDT speichert Zeiten intern in UTC. Der lokale UTC-Offset steht in `iparam.lxp` (`UTC-Offset`, Index 11). Für eine CSV-Ausgabe ist deshalb zu unterscheiden:

- **Rohzeit:** Unix-UTC-Sekunden aus EDT.
- **Lokale Anzeigezeit:** Rohzeit plus UTC-Offset aus der Parameterdatei.

Parser-Regel für Zeitstempel:

1. Beginnt die Zeitangabe nicht mit `+`, ist sie eine absolute Unix-UTC-Zeit.
2. Beginnt die Zeitangabe mit `+`, wird der Zahlenwert auf die zuletzt gültige absolute Zeit addiert.
3. Nach jeder Messzeile wird die berechnete absolute Zeit als neuer Bezugspunkt gespeichert.

Beispiel:

```text
!1591782000 0:15.74
!+600 0:15.75
!+599 0:15.76
```

Ergebnis:

| Zeile | EDT-Zeit | Absolute UTC-Zeit |
|---|---:|---:|
| 1 | `1591782000` | `1591782000` |
| 2 | `+600` | `1591782600` |
| 3 | `+599` | `1591783199` |

Beim Export nach CSV empfiehlt sich:

- Eine feste Spalte `UTC`.
- Optional eine Spalte `LocalTime`, berechnet über den Parameter-UTC-Offset.
- Danach je Kanal eine Spalte aus der `!U`-Zeile.
- Fehlende Kanalwerte bleiben leer.

---

## 6. Kanäle, Einheiten und Housekeeping

### 6.1 Messkanäle 0 bis 89

Kanäle `0` bis `89` sind die maximal moeglichen frei parametrierten Messkanäle. Ihre Bedeutung ergibt sich aus den Kanalblöcken `@0` bis `@89` in `iparam.lxp`; welche Kanalbloecke gueltig sind, legt `MAX_CHANNELS` der Firmware fest.

Wichtige Parameter für die EDT-Interpretation:

| Parameter in `iparam.lxp` | Bedeutung für EDT |
|---|---|
| `Action` | Ob ein Kanal gemessen/aufgezeichnet wird |
| `Einheit` | Einheit in `!U` |
| `Speicher-Format` | Anzahl Nachkommastellen im ASCII-EDT |
| `Offset` / `Faktor` | Messwert wurde bereits skaliert abgelegt |
| `Alarm_hi` / `Alarm_lo` | Kontext für alarmmarkierte Werte |

Die in EDT gespeicherten Werte sind normalerweise bereits die berechneten Messwerte:

```text
Messwert = Rohwert * Faktor - Offset
```

### 6.2 Housekeeping-Kanäle 90 bis 99

Kanäle `90` bis `99` sind interne Loggerwerte. Sie sind nicht als normale Messkanäle in `iparam.lxp` konfiguriert, sondern werden über HK-Flags und `HK-Reload` gesteuert.

| Kanal | Bedeutung im EDT | Komprimierte interne Skalierung |
|---:|---|---|
| 90 | 🔋 Batteriespannung, z. B. `V(Bat)` | mV als UInt16 |
| 91 | Interne Temperatur, z. B. `°C(int)` | 0,1 °C als Int/UInt16 |
| 92 | Interne Feuchte, z. B. `%rH` | 0,1 %rH als UInt16 |
| 93 | Verbrauchte Batteriekapazität, z. B. `mAh(Bat)` | 0,001 Ah = 1 mAh als UInt16 |
| 94 | Barometrischer Druck | 0,1 mbar als UInt16 |
| 95-99 | Reserviert | noch nicht verwendet |

Im ASCII-EDT werden HK-Werte bereits lesbar ausgegeben, z. B. `90:3.525` für Batteriespannung in Volt.

`HK-Reload` bestimmt, wie häufig HK-Werte in Messzeilen erscheinen. Beispiel: Bei Messperiode 5 Minuten und `HK-Reload = 72` erscheinen HK-Werte etwa alle 6 Stunden.

---

## 7. Fehlerwerte und Alarme

Messwerte können statt Zahlen auch Text enthalten:

```text
!+600 0:15.75 1:15.77 2:SensorError
!1678574880 0:NoReply 1:NoReply 90:3.519 91:17.2 93:4.38
```

> [!WARNING]
> Parser sollten Werte **nicht blind als Float parsen**, sondern pro Wert zwischen Zahl und Textfehler unterscheiden.

Alarmierte Werte können im EDT mit `*` markiert sein. In komprimierten Payloads entspricht dies Token `110`: Der folgende Kanal ist als Alarm markiert. Beim CSV-Export kann ein Parser entweder den Wert mit Marker erhalten oder eine zusätzliche Alarmspalte führen.

Komprimierte Daten können nicht alle Textfehler vollständig speichern. Häufige Fehler werden als Fehlercode codiert und beim Expandieren z. B. als `ErrXXX` oder als bekannter Text wie `NoReply` ausgegeben.

---

## 8. Binäre Payload-Zeilen (`$...`)

Zeilen mit `$` enthalten Base64-codierte Binärdaten:

```text
$bwAVAEQNgAABQYszMw
$AP0AAAIB/QAAAg
```

Regeln:

- Das führende `$` gehört nicht zur Base64-Payload.
- Base64 wird ohne Padding am Ende gespeichert.
- Für Standard-Decoder kann fehlendes Padding bei Bedarf ergänzt werden.
- Base64 benötigt etwa das 1,33-fache der binären Originaldaten.

Base64-Alphabet:

```c
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
```

Beispiele:

| Base64-Payload | Hex-Daten |
|---|---|
| `bwAVAEQNgAABQYszMw` | `6f001500440d800001418b3333` |
| `AEGAAAABRAyAAA` | `004180000001440c8000` |
| `AP0AAAIB/QAAAg` | `00fd00000201fd000002` |

Die Payload-Zeilen dienen vor allem der Speicherkomprimierung, können aber auch zusätzliche Binärdaten, Satelliten-/LoRa-Payloads oder andere Erweiterungsdaten enthalten.

> [!NOTE]
> **Base64-Padding**
>
> Standard-Base64 kodiert je 3 Bytes zu 4 ASCII-Zeichen. Ist die Binärdatenmenge nicht durch 3 teilbar, hängen viele Implementierungen am Ende ein oder zwei `=`-Zeichen an, um die Ausgabe auf ein Vielfaches von 4 Zeichen aufzufüllen. Diese `=`-Zeichen transportieren keine Nutzdaten, sondern zeigen nur an, wie viele Füll-Bytes verwendet wurden.
>
> LTX-Logger schreiben Base64 **ohne** abschließendes `=`-Padding. Da jede `$`-Zeile mit einem Nicht-Base64-Zeichen endet (Zeilenende `\n` oder ein anderes Trennzeichen), kann ein Parser die Länge der Payload direkt aus der Zeichenanzahl ableiten:
>
> | Anzahl Base64-Zeichen mod 4 | Restbytes | Auffüllen für Decoder |
> |:---:|:---:|---|
> | 0 | 0 | kein Padding nötig |
> | 2 | 1 | zwei `=` ergänzen |
> | 3 | 2 | ein `=` ergänzen |
>
> Das Padding ist damit **implizit** bekannt. Standard-Decoder, die `=` zwingend erwarten, können es rechnerisch ergänzen; es muss nicht gespeichert werden. Jedes weggelassene `=` spart ein Byte Flash-Speicher, was bei vielen kurzen Zeilen messbar ins Gewicht fällt.

---

## 9. Token-Referenz für komprimierte Payloads

Nach dem Base64-Decoding wird der Binärstrom tokenweise gelesen. Ein Token ist das erste Byte eines Datenelements.

### 9.1 Tokens 0 bis 89: Messkanäle

Tokens `0` bis `89` stehen für Messkanäle. Danach folgen immer exakt 4 Bytes IEEE-754-Float32 im Big-Endian-Format.

Beispiel:

```text
00 41 80 00 00
```

Interpretation:

- `00` = Kanal 0
- `41 80 00 00` = Float32 Big Endian = `16.0`

> [!CAUTION]
> In komprimierter Form sind Kanäle `0` bis `89` immer Float32. Sehr große Integer-Zählerwerte über etwa 10 Millionen können dadurch Präzision verlieren.

Fehler-Erweiterung:

- `0xFD` innerhalb eines Float-Feldes wird als eigene Fehlercodierung genutzt.
- Beispiel `00 FD 00 00 02` bedeutet Kanal `0`, Fehlercode `2`.
- Fehlercode `2` steht im vorhandenen Beispiel für `NoReply`.

### 9.2 Tokens 90 bis 99: Housekeeping

Tokens `90` bis `99` beschreiben HK-Werte. Danach folgen je nach Wert immer 2 Bytes Big Endian.

| Token | Bedeutung | Binärformat |
|---:|---|---|
| 90 | Geräte-Batteriespannung | mV, 16 Bit Big Endian |
| 91 | Geräte-Temperatur | 0,1 °C, 16 Bit Big Endian |
| 92 | Geräte-Feuchtigkeit | 0,1 %rH, 16 Bit Big Endian |
| 93 | Verbrauchte Batteriekapazität | 1 mAh, 16 Bit Big Endian |
| 94 | Geräte-Barometer | 0,1 mbar, 16 Bit Big Endian |
| 95-99 | Reserviert | noch nicht verwendet |

Fehlerwert: `0x80FD`.

### 9.3 Tokens 100 bis 109: synthetische HK-Werte

Diese Werte werden serverseitig erzeugt, z. B. für Satellit oder LoRa. Logger-Firmware und neue Encoder sollten sie nicht für normale Messkanäle verwenden.

| Token | Bedeutung |
|---:|---|
| 100 | Paket-Index, Satellit max. 0-64999; LoRa z. B. Paket pro Tag |
| 101 | Paket-Travel-Time in Sekunden |
| 102 | RSSI |
| 103 | SNR, hauptsächlich LoRa |
| 104 | Laufzeit zum vorherigen Paket in Sekunden |
| 105-109 | Reserviert |

### 9.4 Tokens 110 bis 127: Steuerkommandos

| Token | Bedeutung |
|---:|---|
| 110 | Alarmmarker: Der nachfolgende Kanal ist als Alarm markiert |
| 111 | Delta-Time als 16-Bit-Zahl, maximal 43199 Sekunden |
| 112-127 | Reserviert |

Token `111` wird nur eingebaut, wenn eine Delta-Zeit im Binärstrom nötig ist.

### 9.5 Tokens 128 bis 255: Erweiterungen

Tokens `128` bis `255` sind für zusätzliche Satelliten-/LoRa-Payloads, eingebettete Beschleunigungsdaten oder zukünftige Erweiterungen reserviert.

> [!TIP]
> Parser sollten unbekannte Tokens in diesem Bereich robust behandeln und den Rohblock für spätere Analyse erhalten.

---

## 10. Speicheroptimierung

Die Speicherart wird in `iparam.lxp` über die Aufzeichnungs-Flags gesteuert:

| Bit | Bedeutung |
|---:|---|
| Bit 0 (`1`) | Aufzeichnung aktiv |
| Bit 1 (`2`) | Ringspeicher aktiv |
| Bit 2 (`4`) | Komprimierte Ablage aktiv |

Typische Einstellungen:

| Wert | Bedeutung | Einsatz |
|---:|---|---|
| `3` | Aufzeichnung + Ringspeicher | Standardbetrieb |
| `1` | Aufzeichnung linear, kein Ring | Maximale Historie bis Speicher voll |
| `7` | Aufzeichnung + Ring + Kompression | Mehr Historie, aber schlechter direkt lesbar |
| `5` | Aufzeichnung linear + Kompression | Maximale Speicherausnutzung bis Speicher voll |

Für maximale lokale Historie:

1. Ringspeicher deaktivieren, wenn das Gerät bis zum vollen Speicher aufzeichnen soll.
2. Data Compression aktivieren.
3. `HK-Reload` erhöhen, weil nur Nicht-HK-Zeilen komprimiert gespeichert werden.

💡 Praxisempfehlung:

- Standard `HK-Reload = 6`.
- Bei 5-minütiger Messung für Langzeitaufzeichnung z. B. `HK-Reload = 72`.
- Dann erscheinen HK-Werte etwa alle 6 Stunden statt alle 30 Minuten.

Überschlägige Kompressionsleistung:

| Nutzdaten pro Zeile | Speicherbedarf | Beispiel mit 2 MB |
|---|---:|---:|
| 1 Messwert | ca. 9 Byte pro Zeile | ca. 230000 Messungen |
| 2 Messwerte | ca. 16 Byte pro Zeile | ca. 130000 Zeilen = ca. 260000 Messwerte |

Der Unterschied entsteht, weil pro Zeile eine Kennung bzw. Zeit-/Strukturinformation gespeichert werden muss.

---

## 11. Beispiel und Interpretation

### 11.1 Beispiel mit drei Temperaturkanälen und HK-Werten

```text
<NEW>
<NT AUTO OK(6)>
<COOKIE 1569494503>
!U 0:oC 1:oC 2:oC 90:V_HK 91:oC_HK 92:rH_HK
!1591782000 0:15.74 1:15.77 2:15.72 90:5.89 91:17.3 92:82.6
!+600 0:15.74 1:15.77 2:15.73
!+600 0:15.74 1:15.77 2:15.73
!+600 0:15.73 1:15.75 2:15.72
!+600 0:15.73 1:15.75 2:15.72
!+600 0:15.74 1:15.75 2:15.73
!1591785600 0:15.74 1:15.76 2:15.73 90:5.89 91:17.4 92:83.3
!+600 0:15.73 1:15.75 2:15.72
!+600 0:15.75 1:15.77 2:15.72
!+600 0:15.75 1:15.77 2:SensorError
!+600 0:15.76 1:15.78 2:15.73
!+600 0:15.77 1:15.80 2:15.73
<NT AUTO OK(6)>
!1591789200 0:15.77 1:15.78 2:15.73 90:5.89 91:17.6 92:83.1
!+600 0:15.76 1:15.77 2:15.73
!+600 0:15.76 1:15.78 2:15.75
!+600 0:15.77 1:15.78 2:15.76
!+600 0:15.86 1:15.87 2:15.82
!+600 0:15.86 1:15.86 2:15.83
```

Interpretation:

- `<COOKIE 1569494503>` verweist auf den Parametersatz.
- `!U` definiert drei Messkanäle und drei HK-Kanäle.
- Absolute Zeitstempel erscheinen regelmäßig, relative Zeitstempel sparen Speicher.
- HK-Werte erscheinen nur in jeder sechsten Messzeile.
- `2:SensorError` ist ein Textfehler auf Kanal 2 und darf nicht als Zahl interpretiert werden.
- `<NT AUTO OK(6)>` dokumentiert eine erfolgreiche automatische Übertragung.

### 11.2 Beispiel mit eingebetteter komprimierter Payload

```text
<MAC: 83EA5ACE6C30B9CC>
<NAME: LTX6C30B9CC>
<NOWUTC: 15.03.2023 16:55:09>
<COOKIE 1678833613>
!U 0:uS/cm 90:V(Bat) 91:°C(int) 93:mAh(Bat)
!1678889595 0:573.00 90:3.525 91:19.2 93:0.65
$bwAtAEQOQAA
$bwA8AEQOwAA
$AEQOgAA
$AEQPQAA
```

Mögliche expandierte Ausgabe:

```csv
LocalTime(UTC+01),uS/cm(0),V(Bat)(90),°C(int)(91),mAh(Bat)(93)
15.03.2023 15:13:15,573.00,3.525,19.2,0.65
15.03.2023 15:14:00,569.00,,,
15.03.2023 15:15:00,571.00,,,
```

Die Payload-Zeilen enthalten weitere komprimierte Messpunkte. HK-Spalten bleiben leer, wenn für diese Zeitpunkte keine HK-Werte gespeichert wurden.

---

## 12. Parser-Checkliste

Ein robuster EDT-Parser sollte:

1. Datei zeilenweise lesen und leere Zeilen ignorieren.
2. Info-Tags `<...>` erfassen, insbesondere `COOKIE`, `MAC`, `NAME`, `NOWUTC` und Transferereignisse.
3. `!U` als aktuelle Kanal-/Einheiten-Definition speichern.
4. Messzeilen `!` in Zeitstempel und `Kanal:Wert`-Paare zerlegen.
5. Relative Zeiten `+...` auf den letzten absoluten Zeitwert addieren.
6. Werte typisiert behandeln: Float, Textfehler, Alarmmarker.
7. Kanäle `0` bis `89` als Messkanäle und `90` bis `99` als HK-Werte unterscheiden.
8. `$`-Zeilen Base64-decodieren, fehlendes Padding bei Bedarf ergänzen.
9. Binärpayloads tokenweise interpretieren und unbekannte Erweiterungstokens erhalten.
10. Für CSV fehlende Kanalwerte als leere Felder ausgeben.
11. Den `COOKIE` mit der passenden `iparam.lxp` abgleichen, wenn Einheiten, Kanalbedeutung oder UTC-Offset sicher benötigt werden.
12. Unbekannte Info-Tags oder Erweiterungstokens nicht verwerfen, sondern für Diagnosezwecke protokollieren.

---
