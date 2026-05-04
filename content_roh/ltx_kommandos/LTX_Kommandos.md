# LTX-Logger Kommando-Referenz

Stand: 2026-05-04  


## Inhaltsverzeichnis

- [LTX-Logger Kommando-Referenz](#ltx-logger-kommando-referenz)
  - [Inhaltsverzeichnis](#inhaltsverzeichnis)
  - [Vorbemerkung](#vorbemerkung)
    - [relevante Gerätetypen](#relevante-gerätetypen)
  - [Kommunikationswege](#kommunikationswege)
  - [Gemeinsame Logger-Kommandos](#gemeinsame-logger-kommandos)
  - [SDI-12-Kommandos](#sdi-12-kommandos)
  - [Parameter-Kommando `x...`](#parameter-kommando-x)
    - [Syntax in dieser Firmware](#syntax-in-dieser-firmware)
    - [Beispiele](#beispiele)
    - [Wichtige Parameter für Funkbetrieb](#wichtige-parameter-für-funkbetrieb)
  - [Gruppe: Kein Modem](#gruppe-kein-modem)
  - [Gruppe: Mobilfunk-Modem](#gruppe-mobilfunk-modem)
    - [Mobilfunk-Kommandos](#mobilfunk-kommandos)
    - [Mobilfunk-Downlink-Kommandos](#mobilfunk-downlink-kommandos)
    - [Direktes Mobilfunk-Terminal](#direktes-mobilfunk-terminal)
  - [Gruppe: LoRa-Modem](#gruppe-lora-modem)
    - [LTX-LoRa-Kommandos auf Logger-Ebene](#ltx-lora-kommandos-auf-logger-ebene)
    - [LTX-LoRa-Systemkommandos (`@$...`)](#ltx-lora-systemkommandos-)
    - [LoRa-AT-Kommandos](#lora-at-kommandos)
    - [LoRa-Downlink-Kommandos](#lora-downlink-kommandos)
  - [Kurztabelle nach Gruppe](#kurztabelle-nach-gruppe)
  - [Datei- und Speicherkommandos über BLE](#datei--und-speicherkommandos-über-ble)
  - [Allgemeine BLE-Kommandos (überwiegend für internen Gebrauch)](#allgemeine-ble-kommandos-überwiegend-für-internen-gebrauch)
  - [Quellen im Projekt](#quellen-im-projekt)

---

## Vorbemerkung

Die LTX-Logger haben zwar dem Benuzer gegenüber in den jeweiligen UIs Buttons z.B. für Messung ausführen, Internet-Übertragung, Zeit setzen, etc... Aber auf unterer Ebene werden diese zumeist in ASCII-Kommandos übersetzt, 
die dann auf verschiedenen Wegen (hauptsächlich aber direkt lokal über Bluetooth (BLE 5)) an den Logger gesendet werden.
(Alternativ können die LTX-Logger Dateien übertragen, das wird hier aber nicht behandelt, da Dateien üblicherweise zwischen LTX-Logger und einem Internet-Server via TCP/IP oder HTTP(s) oder FTP ausgetauscht werden. Dazu bitte die separate Dokumentation der Server-Software LTX-Server oder LTX-Legacy konsultieren).

Hier werden ausschliesslich die zeilenweise basierten ASCII-Kommandos betrachtet.

Viele der Kommandos können aber auch von remote geschickt werden, z.B. über LoRa

> [!NOTE]
> Dies ist ein **Referenzdokument** und daher recht umfangreich! Für spezielle Aufgabenbereiche
> wie etwa Parametrierung der SDI-12-Messungen oder Internet-Kommunikation für reguläre Benutzer sind eigene,
> auf das Thema mehr spezialisierte Dokus vorgesehen.
> Wichtig: Referenzen auf Funktionsnamen im Programmcode dienen lediglich zur internen Orientierung, und haben für Anwender keine Relevanz.

### relevante Gerätetypen

Diese **Referenz** beschreibt die Kommandos für LTX-Logger der Typen 1500 bis
3000, getrennt nach:

| Gruppe | DEVICE_TYP | Modem |
|---|---:|---|
| Kein Modem | 2000, 3000 | kein Internet-/LoRa-Modem |
| Mobilfunk-Modem | 1500, 1700, 1750, 1800, 1850 | Quectel/BG/EG, `DEVICE_HAS_INTERNET` |
| LoRa-Modem | 1720, 1820, 2100 | LoRaWAN, `DEVICE_HAS_LORA` |

Hinweis: `DEVICE_TYP` 1720 und 1820 erhalten `DEVICE_HAS_LORA` über
`logger_types/osx_pins.h` bei gesetztem `LTX_SHIELD`; `DEVICE_TYP` 2100
setzt `DEVICE_HAS_LORA` direkt in `device.h`.

## Kommunikationswege

| Weg | Firmware-Einstieg | Besonderheiten |
|---|---|---|
| BLE / BLX-Dashboard | `parse_and_reply_bleterm()` in `jw_libs/ltx_ble.c` | eigener BLE-Layer für Login, Zeit, Datei-Up/Download und Messung; unbekannte Kommandos gehen weiter an `device_cmdline()` |
| lokale UART-Kommandozeile | `uart_cmdline()` in `jw_libs/main.c` | Entwickler-/Service-Konsole; viele Kommandos entsprechen BLE, teils mit anderer Ausgabe |
| Mobilfunk-Downlink | `user_content_cmd()` / `user_content_exit()` in `logger_types/user_func.c` | Server-Payload wird nach einer Übertragung verarbeitet |
| LoRa-Downlink | `menu_parse_payload()` in `logger_types/osx_main.c` | ASCII-Kommandos werden zerlegt und wie Kommandozeilen-Kommandos verarbeitet |

Downlink-Payloads dürfen mehrere Kommandos enthalten. `menu_parse_payload()`
trennt bei `|` und bei Steuerzeichen kleiner Space. Beispiel (für Gerät mit LoRa-Modem):

```text
xip600|xih31|x@AT+DR=3
```

Bei Loggern (`DEVICE_TYP > 1000`) werden Parameteränderungen nach der
Downlink-Verarbeitung automatisch mit `slfix_changes()` gespeichert. Bei
manueller Terminal-/BLE-Eingabe ist nach `x...`-Änderungen normalerweise
`xWrite` erforderlich.

## Gemeinsame Logger-Kommandos

Diese Kommandos sind für alle drei Gruppen relevant, soweit die jeweilige
Hardware die benötigte Funktion besitzt.

| Kommando | Funktion |
|---|---|
| `e` | Messung sofort auslösen. BLE liefert Kanalwerte als `~#<kanal>:` und HK-Werte als `~H<kanal>:` zurück |
| `e<flags>` | Messung mit Flags: Bit 0 HK erzwingen, Bit 1 Messung loggen, Bit 2 Hello-Flags behalten |
| `n` | neue Messreihe starten: Log-/Daten-Dateien löschen, nächste Messung planen |
| `n1` | Disk soft formatieren, Parameter zurückschreiben, neue Messreihe starten |
| `l[anzahl]` | `logfile.txt` ausgeben; Standardwert 250 Zeilen |
| `W FactoryWrite` | aktuelle System-, I- und Kanalparameter als Factory-Setup in internes NVM schreiben |
| `W FactoryRestore` | Factory-Setup aus internem NVM laden |
| `W FactoryDelete` | Factory-Setup im internen NVM löschen |
| `W FactoryReset` | Flash soft formatieren, danach Reset |
| `=` | interne CPU-Spannung ausgeben |
| `E` | Roh-Energiezähler in mAh ausgeben |

## SDI-12-Kommandos

Verfügbar bei `DEVICE_HAS_SDI12_0`, also bei den betrachteten SDI-12-Loggern.

| Kommando | Funktion |
|---|---|
| `Z<kommando>` | komplettes SDI-12-Messkommando ausführen, z. B. `Z*3000 1M`; das abschließende `!` wird nicht mit eingegeben |
| `z<kommando>` | direktes SDI-12-Kommando senden und Antwortzeilen ausgeben |
| `z+` | SDI-12-Versorgung dauerhaft (max. 600 sec) einschalten |
| `z-` | SDI-12-Versorgung ausschalten |
| `zdbg` / `zdbg0` / `zdbg1` | BLE-SDI-Debugstatus anzeigen bzw. setzen |

Bei `z` kann vor dem SDI-Befehl optional `*<msec>` stehen. Beispiel:

```text
z*3000 0M
```

Dies ist die 'Aufwärmzeit' in msec nach dem Anschalten des SDI-12 Busses, bevor das erste SDI-12-Kommando ausgeführt wird. Der Default sind 500 msec (`*500`).

## Parameter-Kommando `x...`

`x...` ist das wichtigste Kommando zum Setzen einzelner Parameter. Die
Detailbedeutung der Parameter steht in:

```text
C:\html\ltx_docu\content\ltx_parameter\ltx_parameter_referenz.md
```

Dort besonders Abschnitt `5. Einzelzugriff auf Parameter (Single-Line-Zugriff)`,
Abschnitt `3. iparam.lxp` und Abschnitt `4. sys_param.lxp`.

### Syntax in dieser Firmware

```text
x<Datei><Parameter><Wert>
xWrite
```

| Teil | Bedeutung |
|---|---|
| `x` | Präfix für Single-Line-Parameterkommando |
| `<Datei>` | `i` = `iparam.lxp`, `s` = `sys_param.lxp` |
| `<Parameter>` | Mnemonic des Parameters, bei Kanalparametern zuerst Kanalnummer |
| `<Wert>` | neuer Wert; bei numerischen Werten ohne Leerzeichen direkt nach dem Mnemonic |
| `xWrite` | geänderte `iparam.lxp`/`sys_param.lxp` dauerhaft schreiben |

Wichtig: Der Code in `slparam_set_full()` / `slparam_set_iparam()` /
`slparam_set_sys_param()` verarbeitet in dieser Version Set- und
Validierungskommandos. Numerische Werte dürfen kein Leerzeichen vor dem Wert haben.
Die externe Parameterreferenz beschreibt zusätzlich den Einzelzugriff als
allgemeines Konzept.

Achtung bei negativen Zahlen: `sl_get_num_i32()` prüft aktuell, ob das erste
Zeichen eine Ziffer ist. Negative Werte wie `xid-10` oder `xiu-3600` sind
damit in diesem Parserstand nicht setzbar, obwohl die Parameterbereiche solche
Werte fachlich vorsehen.

### Beispiele

| Kommando | Wirkung |
|---|---|
| `xip600` | Messperiode (`iparam.p`) auf 600 s setzen |
| `xit3600` | Internet-/Funk-Übertragungsperiode (`iparam.t`) auf 3600 s setzen |
| `xiu3600` | UTC-Offset auf +3600 s setzen |
| `xih31` | HK-Aktivierung auf Bitmaske 31 setzen |
| `xim1` | Netzwerkmodus auf Normalbetrieb setzen |
| `xis0` | Internet-/Funk-Übertragungs-Offset auf 0 s setzen |
| `xi0a1` | Kanal 0 Action auf 1 setzen |
| `xi0p768` | Kanal 0 physikalischen Kanal auf 768 setzen, typisch SDI-12 Bus 0 |
| `xi3um` | Kanal 3 Einheit auf `m` setzen; Strings beginnen direkt nach dem Mnemonic |
| `xi0x*1800 0MC` | Kanal 0 Xbytes/SDI-12-Messkommando setzen |
| `xsaiot.1nce.net` | APN setzen |
| `xssjoembedded.de` | Server setzen |
| `xsp80` | Port setzen |
| `xso0` | Mobilfunk-/LoRa-Protokollfeld setzen |
| `xWrite` | Änderungen dauerhaft speichern (wichtig bei lokalen Änderungen, remote wird automatisch gespeichert) |

### Wichtige Parameter für Funkbetrieb

| Parameter | Beispiel | Bedeutung |
|---|---|---|
| `xit...` | `xit3600` | Funk-/Internet-Übertragungsperiode in Sekunden |
| `xim...` | `xim1` | Netzwerkmodus: 0 aus, 1 normal, 2/3 Testmodi |
| `xid...` | `xid0` | Mindesttemperatur für Mobilfunkübertragung; negative Werte siehe Hinweis oben |
| `xsp...` | `xsp80` oder LoRa-FPort | Server-Port bzw. LoRaWAN-FPort |
| `xso...` | `xso0` | Protokoll-/LoRa-Modus-Bitfeld, siehe Parameterreferenz |

## Gruppe: Kein Modem

Betroffene Typen in diesem Dokument: `DEVICE_TYP` 2000 und 3000.

Verfügbar sind die allgemeinen BLE-, Datei-, Mess-, SDI-12- und
Parameterkommandos. Nicht verfügbar sind alle Modemkommandos:

| Kommando | Status ohne Modem |
|---|---|
| `i` | nicht verfügbar, keine Internet-/LoRa-Übertragung |
| `@...` | nicht als Modem-/LoRa-Direktkommando verfügbar |
| `#...` | kein Modem-Terminal |
| `m`, `M`, `?`, `%`, `$`, `q`, `g`, `k` | mobilfunk-spezifisch, nicht verfügbar |

Typische lokale Bedienung:

```text
e
xip900
xi0x*1800 0MC
xWrite
n
```

## Gruppe: Mobilfunk-Modem

Betroffene Typen: `DEVICE_TYP` 1500, 1700, 1750, 1800, 1850. Die konkrete
Modemfamilie wird über `osx_pins.h` gesetzt, z. B. `QUECTEL_BG600L`,
`QUECTEL_EG912U` oder `QUECTEL_EG912N`.

### Mobilfunk-Kommandos

| Kommando | Funktion |
|---|---|
| `i` | manuelle Internet-Übertragung starten (`internet_transfer(REASON_MANUAL)`) |
| `i<flags>` | wie `i`, mit Verbose-/Debugflags; im Code kommentiert: 1 Verbose, 2 ExtraLong, 128 Debug |
| `m` | Modem ins Netz einbuchen / registrieren |
| `m<verbose>` | Registrierung mit Verbose-Level |
| `M` | Modem ausbuchen / abmelden (aktiv abschalten)|
| `?` | Signal- und Modeminfo abfragen |
| `??` | kompakten Modemstatus ausgeben |
| `@AT...` | direktes AT-Kommando an das Mobilfunkmodem senden |
| `@$...` | Modem-Factory-Kommando (`modem_factory_command()`), Timeout bis 1 h |
| `%` | Netzscan, wenn `USE_COPS` aktiv ist |
| `$<netz>` | manuelle Netzauswahl, wenn `USE_COPS` aktiv ist |
| `q...` | Quectel-Location/QLBS, nur wenn `HAS_QUECLOCATOR` aktiv ist |
| `g...` | GPS/A-GPS starten, nur wenn `HAS_AGPS` aktiv ist |
| `k` | GPS/A-GPS stoppen, nur wenn `HAS_AGPS` aktiv ist |
| `#<wert>` | interaktives 1:1-Modemterminal über BLE/UART starten |

Beispiele:

```text
i
i129
?
??
@AT
@AT+CSQ
@AT+COPS=?
m1
M
```

`AT+COPS=?` bekommt im BLE-Pfad einen langen Timeout, weil der Netzscan beim
Quectel-Modem mehrere Minuten dauern kann.

### Mobilfunk-Downlink-Kommandos

Der Server kann ASCII-Kommandos zurückgeben. Diese werden in `usercmd`
gespeichert und nach der Übertragung von `user_content_exit()` verarbeitet.
Mehrere Kommandos können mit `|` getrennt werden:

```text
xip600|xit3600|xWrite
```

Bei `HAS_AGPS` sind serverseitig zusätzlich `g...`-Kommandos vorgesehen, um
eine A-GPS-Aktion für die nächste automatische Übertragung zu triggern. Bei
`HAS_QUECLOCATOR` kann `q...` eine Quectel-Positionsabfrage auslösen.

### Direktes Mobilfunk-Terminal

Über BLE startet `#<wert>` ein 1:1-Terminal zum Modem. Der Wert wird an
`modem_ble_terminal()` übergeben; mit Wert kann das Modem je nach
Implementierung länger aktiv bleiben. Für einzelne AT-Kommandos ist meist
`@AT...` praktischer.

## Gruppe: LoRa-Modem

Betroffene Typen: `DEVICE_TYP` 1720, 1820, 2100.

### LTX-LoRa-Kommandos auf Logger-Ebene

| Kommando | Funktion |
|---|---|
| `i` | manuelle LoRaWAN-Übertragung starten (`lora_transfer(REASON_MANUAL, server.port)`) |
| `@AT...` | direktes AT-Kommando an das LoRa-Modem senden |
| `@$...` | LTX-LoRa-Systemkommando ausführen |
| `#lo` oder `#lora` | interaktives LoRa-Modemterminal über BLE starten |

Beispiele:

```text
i
@AT
@AT+XSTATE=?
@$info
@$initeu868
```

### LTX-LoRa-Systemkommandos (`@$...`)

Die Systemkommandos sind in `modem_libs/lora_modem.md` bereits genauer
dokumentiert. Auf Logger-Ebene wird ihnen ein `@` vorangestellt, weil `@`
das LoRa-Modemkommando in `device_cmdline()` einleitet.

| Logger-Kommando | internes Kommando | Funktion |
|---|---|---|
| `@$res` | `$res` | LoRa-Modem per Hardware-/Typ-Init resetten |
| `@$dbg` | `$dbg` | Debugstatus anzeigen |
| `@$dbg0` | `$dbg 0` | Debug ausschalten |
| `@$dbg1` | `$dbg 1` | Debug einschalten |
| `@$initeu868` | `$initeu868` | EU868-Keys initialisieren, SoC-MAC als Device EUI setzen |
| `@$beefcode` | `$beefcode` | feste Factory-Test-Keys setzen |
| `@$info` | `$info` | Status, DEUI, APPEUI, NWKKEY, ADR, DR, Join- und Fehlerstatus ausgeben |
| `@$f...` | `$f...` | Fake-Payload-Länge, nur wenn `TST_FAKEPAYLOAD` gebaut wurde |

Besonders wichtig für die Inbetriebnahme:

```text
@$initeu868
@$info
```

`@$initeu868` ruft `lora_keys_eu868(mac_addr_h, mac_addr_l)` auf. Damit wird
die MAC des LTX-Loggers als LoRaWAN Device EUI gesetzt. Das ist wichtig,
damit Messdaten und Rückparameter eindeutig dem Logger zugeordnet werden
können.

Wenn LoRa-Parameter oder Keys nicht mehr setzbar sind, weil ein gespeicherter
Join-Kontext existiert, zuerst das Modem löschen:

```text
@AT+RFS
@$initeu868
```

### LoRa-AT-Kommandos

Die vollständige LoRaWAN-AT-Referenz steht in:

```text
C:\html\ltx_docu\content\lora\ltx_lora_at_kommandos.md
```

Wichtige Stellen:

| Abschnitt | Inhalt |
|---|---|
| `Befehlskonventionen` | Syntax `AT+CMD`, `AT+CMD?`, `AT+CMD=value`, `AT+CMD=?` |
| `Schlüssel, IDs und EUIs` | `AT+DEUI`, `AT+APPEUI`, `AT+NWKKEY`, Session-Keys |
| `Join- und Sendebefehle` | `AT+JOIN`, `AT+SEND`, `AT+LINKC` |
| `Netzwerkverwaltungsbefehle` | `AT+ADR`, `AT+DR`, `AT+BAND`, `AT+CLASS`, RX-Fenster, TX-Power |
| `LTX-Erweiterungen` | `AT+TIMEREQ`, `AT+NVMJS=?`, `AT+XSTATE=?`, `AT+RECV`, `AT+SAVECFG` |
| `Kurzreferenz aller möglichen Befehle` | schnelle AT-Befehlstabelle |

Typische LoRa-Direktkommandos über den Logger:

```text
@AT
@AT?
@AT+DEUI=00:11:22:33:44:55:66:77
@AT+APPEUI=11:11:11:11:22:22:22:22
@AT+NWKKEY=01:23:45:67:01:23:45:67:01:23:45:67:01:23:45:67
@AT+ADR=0
@AT+DR=3
@AT+SAVECFG
@AT+JOIN=1
@AT+XSTATE=?
@AT+RECV=?
```

### LoRa-Downlink-Kommandos

LoRa-Downlinks werden in `lora_modem.c` empfangen und an
`menu_parse_payload()` weitergereicht. Sie können dieselben ASCII-Kommandos
enthalten wie die Kommandozeile, z. B.:

```text
xip900|xit7200
```

Nach der Verarbeitung werden Parameteränderungen für Logger automatisch
gespeichert. Wegen der kleinen LoRaWAN-Payloads sind `x...`-Einzelparameter
der bevorzugte Weg; komplette Dateien sind für LoRa normalerweise zu groß.

## Kurztabelle nach Gruppe

| Kommando | Kein Modem | Mobilfunk | LoRa |
|---|---:|---:|---:|
| `e` | ja | ja | ja |
| `i` | nein | Internet-Übertragung | LoRaWAN-Übertragung |
| `x...` | ja | ja | ja |
| `xWrite` | ja | ja | ja |
| `Z...`, `z...` | ja, bei SDI-12 | ja, bei SDI-12 | ja, bei SDI-12 |
| `@AT...` | nein | Mobilfunk-AT | LoRa-AT |
| `@$...` | nein | Mobilfunk-Factory-Kommando | LoRa-Systemkommando |
| `#...` | nein | 1:1-Mobilfunkterminal | `#lo` LoRa-Terminal |
| `m`, `M`, `?`, `%`, `$` | nein | ja | nein |
| `q`, `g`, `k` | nein | optional GPS/QLBS | nein |
| Datei-BLE `P/N/G/L/D/v/V/X/Y` | ja | ja | ja |

## Datei- und Speicherkommandos über BLE

Diese Kommandos werden vom BLX-Dashboard für Parameterdateien, Messdaten und
Firmware-/Speicheroperationen verwendet. Sie setzen ein vorhandenes
Filesystem voraus, außer `I/K/L` für internen Speicher.

| Kommando | Funktion |
|---|---|
| `v` | Verzeichnis / virtuelle Disk listen |
| `V` | gründlichen Disk-Check ausführen |
| `X` | `iparam.lxp` neu einlesen/prüfen; bei Fehler alte Kopie zurückschreiben |
| `Y` | `sys_param.lxp` neu einlesen/prüfen; bei Fehler alte Kopie zurückschreiben |
| `T` | aktuelle Zeit, Runtime und nächste Messzeit abfragen |
| `R` | System-Reset |

## Allgemeine BLE-Kommandos (überwiegend für internen Gebrauch)

Diese Kommandos liegen im BLE-Layer und sind daher für alle BLE-fähigen
Logger relevant. Für geschützte Kommandos muss die PIN-Freigabe erfolgt sein.

> [!NOTE]
> Für den regulären Betrieb sind diese Kommandos absolut unwichtig!

| Kommando | Verfügbarkeit | Funktion |
|---|---|---|
| leeres Kommando | nach PIN | Antwort `OK` |
| `~` | BLE | Hello/Handshake. Antwort enthält MTU und 16-Byte-MAC in zwei 32-Bit-Hälften: `~B:<mtu> <mac_h><mac_l>` |
| `/ <challenge-response>` | BLE | PIN/Challenge freischalten. Antwort `~V:<device_type> <fw> <boot_cookie> <cpu> <inet>` |
| `T<unix>` | BLE/UART | Unix-Zeit setzen; bei RTC-Hardware wird die RTC mit gesetzt |
| `C` | BLE | BLE-Connection-Intervall abfragen |
| `CS` | BLE | Standard-Connection-Intervall setzen |
| `CF` | BLE | schnelles Connection-Intervall setzen |
| `C<wert>` | BLE | Connection-Intervall numerisch setzen |
| `R<wert>` | BLE | bei gesetztem Wert Full-Reset-Marker setzen, dann Reset |
| `D:<datei>` | Datei löschen |
| `P:<datei>` | Datei zum Upload öffnen; danach Binärblöcke senden |
| `P!:<datei>` | Upload mit External-Sync-Flag öffnen |
| `L` | laufenden Upload/Speichertransfer schließen; Antwort `~L:<bytes>` |
| `N:<datei>` | Datei zum Download öffnen; Antwort `~N:<len> <ctime>` |
| `G[<len> [<pos>]]` | nach `N:` Datei ganz oder teilweise senden |
| `K:<addr> <len>` | interne Flash-Sektoren ab Adresse löschen |
| `I:<addr>` | internen Flash zum Schreiben öffnen |
| `&[wert]` | (internes) Factory-Test-Lock anzeigen/setzen |

## Quellen im Projekt

| Datei | Relevanz |
|---|---|
| `C:\html\ltx_docu\content\ltx_parameter\ltx_parameter_referenz.md` | Detailreferenz für `x...` und Parameterdateien |
| `C:\html\ltx_docu\content\lora\ltx_lora_at_kommandos.md` | Detailreferenz der LoRaWAN-AT-Kommandos |
| `C:\html\ltx_docu\content\ltx_typen\logger_Zusammenfassung.md` | Gerätetypen und Funkvarianten |
