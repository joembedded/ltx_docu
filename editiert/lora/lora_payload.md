# LTX LoRa-Payload

Kurze Zusammenfassung des lokalen Payload-Decoders aus `C:\html\wrk\payloaddecoder\` und der vorhandenen LTX-LoRa-Dokumentation.

**Repository:** <https://github.com/joembedded/payload-decoder>

> [!NOTE]
> Der Payload-Decoder ist für schmalbandige Funkwege optimiert: LoRaWAN, Satellit und vergleichbare Verbindungen. Ziel ist, Messwerte, Systemdaten und Fehlerzustände mit möglichst wenigen Bytes eindeutig zu übertragen.

---

## Inhaltsverzeichnis

- [Überblick](#überblick)
- [Uplink und Downlink](#uplink-und-downlink)
- [Warum ein eigener Payload?](#warum-ein-eigener-payload)
- [Uplink-Struktur](#uplink-struktur)
  - [1. Byte: Flags und Übertragungsgrund](#1-byte-flags-und-übertragungsgrund)
  - [Danach: Kanalblöcke](#danach-kanalblöcke)
- [Kanal- und Einheitenschema](#kanal--und-einheitenschema)
- [Fehlerdarstellung](#fehlerdarstellung)
- [Downlink: Kommandos als Payload](#downlink-kommandos-als-payload)
- [Bezug zu den LoRa-AT-Kommandos](#bezug-zu-den-lora-at-kommandos)

---

## Überblick

| Bereich | Kurzbeschreibung |
|---|---|
| Uplink | Logger an Server; binär komprimierte Messdaten, dekodiert mit `payload_ltx.js`, `payload_ltx_clean.js` oder `payload_ltx.exs` |
| Downlink | Server an Logger; Klartext-Kommandos als ASCII, optional erzeugt mit `paydown_ltx.js` |
| Plattformen | ChirpStack, TTN und andere LoRaWAN-Stacks |
| Uplink-fPort | `1` bis `199`, der Port beschreibt den Gerätetyp bzw. die Einheitengruppe |
| Downlink-fPort | `10`, allgemeiner LTX-Kommandoport |
| Werteformat | Float16 oder Float32, Big Endian |
| Kanäle | `0` bis `89` Messkanäle, `90` bis `99` Housekeeping-Kanäle |

Der Decoder macht aus kompakten Bytes eine strukturierte Datenliste. Jeder Eintrag enthält mindestens einen Kanal und entweder einen Messwert (`value`) oder eine Klartextmeldung (`msg`).

```javascript
{
  "flags": "(Alarm)(Measure)",
  "reason": "(Auto)",
  "chans": [
    { "channel": 0, "value": 20.5625, "prec": "F16", "unit": "°C" },
    { "channel": 93, "value": 0.334717, "prec": "F16", "unit": "mAh(HK_usedEnergy)" }
  ]
}
```

---

## Uplink und Downlink

Bei LTX-LoRa sind Uplink und Downlink bewusst unterschiedlich aufgebaut.

| Richtung | Zweck | Format | Verarbeitung |
|---|---|---|---|
| Uplink | Messdaten vom Logger zum Server | kompaktes Binärformat mit Flags, Kanälen, Float16/Float32 und HK-Daten | Payload-Decoder wandelt Bytes in strukturierte Messwerte um |
| Downlink | Kommandos vom Server zum Logger | Klartext als ASCII, z. B. `xip900|xit7200` | Logger zerlegt den Text und führt ihn wie Kommandozeilen-Kommandos aus |

Der **Payload-Decoder wird also für Uplinks** verwendet. Er interpretiert die komprimierten Messdaten, ordnet Einheiten über den `fPort` zu und übersetzt Fehlercodes in lesbare Meldungen.

Für **Downlinks wird kein binäres Messwertformat** verwendet. Der Server sendet kurze Klartext-Kommandos. `paydown_ltx.js` ist dabei kein Messwert-Decoder, sondern nur ein Helfer, der ein `cmd`-Feld in ASCII-Bytes für `fPort 10` umsetzt.

---

## Warum ein eigener Payload?

LoRaWAN-Pakete sind klein. In EU868 stehen je nach Datenrate nur begrenzte Nutzdaten zur Verfügung; in den vorhandenen LoRa-AT-Unterlagen sind z. B. bei DR0 bis DR2 maximal 51 Byte genannt. Gleichzeitig sollen mehrere Sensorwerte, Housekeeping-Daten und Fehlerzustände übertragen werden.

Der LTX-Payload löst das durch drei Entscheidungen:

1. Messwerte werden standardisiert als Float16 oder Float32 übertragen.
2. Einheiten werden nicht in jedem Messwert wiederholt, sondern über den `fPort` abgeleitet.
3. Fehler werden im reservierten NaN-Bereich der Float-Darstellung kodiert und als Klartext ausgegeben.

Damit passen sehr viele Kanäle in ein kleines Paket. Das Decoder-Repo nennt als Beispiel eine 20-kanalige Temperaturmesskette inklusive mehrerer HK-Kanäle innerhalb von 51 Byte.

---

## Uplink-Struktur

### 1. Byte: Flags und Übertragungsgrund

| Bits | Bedeutung |
|---|---|
| Bit 7 / `128` | Gerät hatte Reset |
| Bit 6 / `64` | aktueller Alarm |
| Bit 5 / `32` | früherer Alarm |
| Bit 4 / `16` | Messwerte enthalten |
| Bit 0 bis 3 | Übertragungsgrund |

| Reason | Bedeutung |
|---|---|
| `2` | automatische Übertragung |
| `3` | manuelle Übertragung |
| andere | reserviert bzw. unbekannt |

### Danach: Kanalblöcke

| Steuercode | Bedeutung |
|---|---|
| `0Fxxxxxx` | Messwertblock; `F=0` für Float32, `F=1` für Float16, `xxxxxx` = Anzahl folgender Werte |
| Anzahl `0` | Sonderfall: nächstes Byte setzt den aktuellen Kanal-Cursor |
| `1xxxxxxx` | Housekeeping-Block; 7-Bit-Maske für HK-Kanäle ab `90` |

Messkanäle laufen normalerweise fortlaufend hoch. Wenn Kanäle übersprungen werden sollen, setzt ein Cursor-Token den nächsten Kanal explizit. Housekeeping beginnt bei Kanal `90` und wird immer als Float16 übertragen.

---

## Kanal- und Einheitenschema

Der Uplink-`fPort` beschreibt den LTX-Typ bzw. die Einheitengruppe. Bekannte Einheiten aus `payload_ltx.js`:

| fPort | Einheitengruppe |
|---|---|
| `1` bis `9` | frei bzw. kundenspezifisch |
| `10` | Temperaturkanäle in `°C` |
| `11` | Feuchte/Temperatur: `%rH`, `°C` |
| `12` | Druck/Pegel: `Bar`, `°C` |
| `13` | Pegel: `m`, `°C` |
| `14` | Distanz/Radar: `m`, `dBm` |
| `15` | Leitfähigkeit/Wasser: `°C`, `uS/cm` |

Housekeeping-Kanäle sind fest zugeordnet:

| Kanal | Bedeutung |
|---|---|
| `90` | Batteriespannung `V(HK_Bat)` |
| `91` | interne Temperatur `°C(HK_intTemp)` |
| `92` | interne Feuchte `%rH(HK_intHum.)` |
| `93` | verbrauchte Energie `mAh(HK_usedEnergy)` |
| `94` | Luftdruck `mBar(HK_Baro)` |

---

## Fehlerdarstellung

Statt separate Fehlerfelder zu übertragen, nutzt der Decoder spezielle Float-Bitmuster. Im dekodierten Ergebnis steht dann `msg` statt `value`.

| Code | Meldung |
|---|---|
| `0` | `NumberOverflow` |
| `1` | `NoValue` |
| `2` | `NoReply` |
| `3` | `OldValue` |
| `6` | `ErrorCRC` |
| `7` | `DataError` |
| `8` | `NoCachedValue` |

Das ist besonders wichtig für SDI-12-Sensoren: Ein fehlender Sensorwert kann dadurch im selben Kanalmodell bleiben und muss nicht über ein separates Statusformat interpretiert werden.

---

## Downlink: Kommandos als Payload

Downlinks werden als ASCII-Kommandos übertragen. Der Downlink-Encoder `paydown_ltx.js` erwartet ein Objekt mit `cmd` und setzt den LoRaWAN-`fPort` auf `10`.

```json
{
  "cmd": "xip900|xit7200"
}
```

Der Encoder wandelt den String byteweise in ASCII um. Die maximale Kommando-Länge ist im Encoder auf 51 Byte begrenzt; längere Kommandos werden gekürzt.

Auf Logger-Seite werden LoRa-Downlinks in der bestehenden Kommandodokumentation beschrieben:

- Empfang in `lora_modem.c`
- Weitergabe an `menu_parse_payload()`
- Trennung mehrerer Kommandos bei `|` oder Steuerzeichen kleiner Space
- Ausführung wie normale Kommandozeilen-Kommandos
- Parameteränderungen bei Loggern werden nach der Verarbeitung automatisch gespeichert

Typische Downlinks sind daher kurze `x...`-Einzelparameter:

```text
xip600|xih31|x@AT+DR=3
```

Komplette Dateien sind für LoRa normalerweise zu groß. Für Konfiguration über LoRa sind Einzelparameter der bevorzugte Weg.

---

## Bezug zu den LoRa-AT-Kommandos

Die LoRa-AT-Dokumentation beschreibt den Transport:

```text
AT+SEND=<port>:<confirmed>:<hex_payload>
```

Der Payload-Decoder beschreibt den Inhalt von `<hex_payload>`. Downlink-Payloads erscheinen am Modem u. a. als Event:

```text
+EVT:<port>:<len>:<hex>
```

oder können mit dem LTX-erweiterten Befehl abgefragt werden:

```text
AT+RECV=?
REC: P:<port>:<len>:<hex>
```

Für die Anwendungsebene gilt damit:

| Schicht | Zuständig |
|---|---|
| LoRaWAN / AT | Join, Datenrate, Sendeleistung, `AT+SEND`, Empfangsevents |
| LTX Payload | Messwertkompression, Einheiten, Fehlercodes, HK-Kanäle |
| LTX Kommandoebene | Downlink-Kommandos wie `xip...`, `xih...`, `x@AT...` |

---

## Dateien im Payload-Decoder-Repo

| Datei | Zweck |
|---|---|
| `readme_de.md` | deutschsprachige Beschreibung und Beispiele |
| `payload_ltx.js` | Uplink-Decoder mit Testbereich |
| `payload_ltx_clean.js` | bereinigte Variante für ChirpStack |
| `payload_ltx.exs` | Elixir-Version, u. a. für ELEMENT IoT |
| `paydown_ltx.js` | Downlink-Encoder/Decoder für ASCII-Kommandos |
| `index.html` | einfacher Browser-Test |
| `qjs.exe` | lokaler QuickJS-Test unter Windows |
| `write_clean_chirpstack_decoder.php` | erzeugt die bereinigte JavaScript-Datei |

Test lokal:

```powershell
cd C:\html\wrk\payloaddecoder
.\qjs.exe payload_ltx.js
```

---

## Praxisempfehlung

Für neue Integrationen wird typischerweise `payload_ltx_clean.js` als Uplink-Decoder in ChirpStack verwendet. Für TTN kann `payload_ltx.js` genutzt werden, nachdem der Testbereich entfernt wurde. Downlinks sollten kurz bleiben und vorzugsweise `x...`-Parameterkommandos verwenden, weil sie auf Logger-Seite direkt verarbeitet und automatisch gespeichert werden.
