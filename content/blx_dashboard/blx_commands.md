# BLX Dashboard – Kommando-Referenz

Stand: 2026-05-04  
Quellen:
- **BLX.js** (Bluetooth-Worker): [github.com/joembedded/blxdashboard 🔒](https://github.com/joembedded/blxdashboard) *(privates Repo – nur für Collaboratora)*
- **Öffentliche Demo-App**: [github.com/joembedded/ltx_ble_demo](https://github.com/joembedded/ltx_ble_demo)

Geprüfte Versionen: `blx.js V1.40 / 19.1.2026`, `blxdash.js V0.56 / 24.04.2026`

---

## Übersicht

Das BLX Dashboard kommuniziert über Web Bluetooth (BLE) mit LTX-Loggern.
Es gibt zwei Klassen von Kommandos:

| Typ | Präfix | Verarbeitung |
|---|---|---|
| **SysCommands** | beginnen mit `.` | werden von `blx.js` intern verarbeitet (`blxSysCmd()`) |
| **Gerätebefehle** | ohne `.` | direkt über BLE an das Gerät gesendet (siehe `ltx_ble.c`) |

> **Hinweis:** Einige Aktionen sind auf beiden Wegen auslösbar, z.B. Reset mit `R` (BLE-Kommando) und `.reset` (SysCommand).  
> Im Terminal wiederholt `*` den letzten Befehl.

Das Terminal wird mit `blx.setTerminal("blxTerminal", bleCallback)` aktiviert, wobei `"blxTerminal"` ein leeres `<div>` im HTML ist.

---

## SysCommands (Befehle beginnend mit `.`)

### `.?`
Zeigt die aktuelle BLX-Terminal-Version an.

---

### `.q` / `.quit`
Blendet das BLX-Terminal aus.

---

### `.cls`
Löscht den Inhalt des Terminals.

---

### `.s [Unterbefehl]` / `.store [Unterbefehl]`
Zugriff auf den internen Browser-Speicher (IndexedDB als Key/Value-Paare).  
Ohne Parameter: Listet alle gespeicherten Einträge (Schlüssel, Datum, Größe).

#### Unterbefehle:

| Unterbefehl | Kurzform | Beschreibung |
|---|---|---|
| `v KEY` / `v KEY VALUE` | `var` | Systemvariable anzeigen bzw. setzen. Löschen mit `c/clear` |
| `c` | `clear` | Gesamten IndexedDB-Inhalt löschen |
| `r [KEY]` | `remove` | Einen Eintrag löschen |
| `l [KEY]` | `list` | Inhalt als Textzeilen ausgeben (nur für Textdateien von Geräten) |
| `m IDX NEUTEXT [KEY]` | `modify` | Textzeile Idx durch neuen Text ersetzen (kein Leerzeichen erlaubt) |

**Beispiele:**
```
.s                                              → Alle Einträge auflisten
.s v #blxDash_#badgeURL                        → Badge-URL anzeigen
.s v #blxDash_#badgeURL http://localhost/...   → Badge-URL auf lokalen Pfad setzen
.s v #blxDash_#AutoPINURL https://...          → AutoPIN-URL setzen
.s r F65F6C3B7F1527C1_sys_param.lxp            → Eintrag löschen
.s l F65F6C3B7F1527C1_sys_param.lxp            → Dateiinhalt anzeigen
.s m 18 999 F65F6C3B7F1527C1_sys_param.lxp     → Zeile 18 auf "999" setzen
```

> **Store-Variablen mit Sonderfunktion:**
> - `#blxDash_#badgeURL` – URL zum lokalen Label-Drucker (Badge-Druck)
> - `#blxDash_#AutoPINURL` – URL zur automatischen PIN-Generierung (wird in `blxdash.js` ausgewertet)

---

### `.e [KEY]` / `.export [KEY]`
Exportiert einen Eintrag aus dem Store als Datei (Browser-Download).  
Ohne KEY: verwendet den zuletzt mit `.get` abgerufenen Dateinamen.

---

### `.a [[RSSI] TERM]` / `.audio [[RSSI] TERM]`
Listet oder setzt Audio-Flags:
- `RSSI` (0/1): Bei 1 ertönt bei jedem RSSI-Paket ein Ton (Tonhöhe zeigt Entfernung)
- `TERM` (0/1): Bei 0 ist das Terminal stumm

```
.a 1 1    → RSSI-Ton AN, Terminal-Ton AN
.a 0 0    → Alles stumm
```

---

### `.f [FRQ [DUR [VOL]]]`
Spielt einen Testton ab.
- `FRQ` – Frequenz in Hz (Standard: 440)
- `DUR` – Dauer in Sekunden
- `VOL` – Lautstärke (0–10)

```
.f 440 2 5    → 440 Hz, 2 Sekunden, Lautstärke 5
```

---

### `.k [CONT]` / `.keep [CONT]`
Zeigt oder setzt das „Verbindung halten"-Flag.  
Normalerweise werden BLE-Verbindungen nach einigen Minuten automatisch getrennt.  
Mit `CONT=1` bleibt die Verbindung dauerhaft bestehen.

---

### `.rs [SHOW_RSSI]` / `.rssi [SHOW_RSSI]`
Zeigt oder setzt die RSSI-Anzeige im Terminal (in dBm).  
`0` = aus, `1` = ein.

---

### `.cf [[VAL_FS] VAL_MEM]` / `.connectionfast [[VAL_FS] VAL_MEM]`
Setzt oder zeigt die schnelle Verbindungsgeschwindigkeit:
- `VAL_FS` – Geschwindigkeit für Dateiübertragungen (Zahl 3–30 oder `F` für Auto)
- `VAL_MEM` – Geschwindigkeit für internes CPU-Flash (langsamer)

---

### `.bfast` / `.bslow`
Schaltet die BLE-Verbindungsgeschwindigkeit manuell um.  
`.bfast` erhöht die Geschwindigkeit vorübergehend (ca. 15 Sekunden, dann AUTO-Slow).  
Nur bei bestehender Verbindung wirksam.

---

### `.l [ANZ]` / `.lines [ANZ]`
Setzt oder zeigt die Anzahl der Zeilen im Terminal-Ausgabebereich.

---

### `.sl MSEC` / `.sleep MSEC`
Testfunktion: Wartet die angegebene Anzahl Millisekunden.

```
.sl 1000    → 1 Sekunde warten
```

---

### `.c [PIN [CTRIES]]` / `.connect [PIN [CTRIES]]`
Öffnet das BLE-Verbindungsfenster zur Geräteauswahl.  
Optional: PIN (mindestens 6 Zeichen) und Anzahl Verbindungsversuche.

> **Hinweis:** Erfordert einen Chromium-basierten Browser (Chrome, Edge) mit Web Bluetooth API.

---

### `.d` / `.disconnect`
Trennt die aktuelle BLE-Verbindung.

---

### `.r [PIN]` / `.reconnect [PIN]`
Stellt eine zuvor getrennte BLE-Verbindung wieder her.  
Optional mit Access-PIN.

---

### `.i [PIN]` / `.identify [PIN]`
Verbindet optional erneut und identifiziert das Gerät (liest Gerätetyp, MAC, Firmware-Version).  
Bei erfolgreicher PIN-Authentifizierung ertönt ein Bestätigungston.

---

### `.m` / `.memory`
Berechnet den verfügbaren Datenspeicher auf Geräten mit Dateisystem.  
Gibt Gesamtgröße, belegten Anteil (%), Aufzeichnungsmodus (LINEAR/RING/OFF) und neu geschriebene Bytes aus.

---

### `.u` / `.upload`
Lädt `data.edt` und `data.edt.old` vom Gerät in den Store hoch.  
Schnellgeschwindigkeit ist standardmäßig aktiv.  
Nur für Geräte mit Dateisystem.

---

### `.x [MAC]` / `.xtract [MAC]`
Extrahiert die Messdaten (`data.edt`/`data.old`) für ein Gerät und speichert sie als synthetisierte Key/Value-Datei im Store (für die Anzeige im Graph-Tool).  
Ohne MAC: verwendet das aktuelle/zuletzt verbundene Gerät.  
Nur für Geräte mit Dateisystem.

---

### `.g FNAME [pos0 [anz]]` / `.get FNAME [pos0 [anz]]`
Lädt eine Datei aus dem Gerätedateisystem in den Store.  
Nur für Geräte mit Dateisystem.

| Aufruf | Beschreibung |
|---|---|
| `.g FNAME` | Gesamte Datei herunterladen |
| `.g FNAME pos0` | Ab Position `pos0` bis Ende |
| `.g FNAME pos0 anz` | `anz` Bytes ab Position `pos0` |

---

### `.p [SYNCFLAG]` / `.put [SYNCFLAG]`
Öffnet einen Dateiauswahldialog und sendet die gewählte Datei in das Gerätedateisystem.  
Bei `SYNCFLAG=1` wird das Sync-Flag im Dateisystem gesetzt.  
Nur für Geräte mit Dateisystem.

---

### `.memput`
Öffnet einen Dateiauswahldialog und sendet eine kleine Datei in den Gerätespeicher (RAM/Flash).  
Nur für kleine Dateien, siehe LTX-Dokumentation.

---

### `.fput KEY`
Sendet eine Datei aus dem Store (KEY) direkt in das Gerätedateisystem.  
Format des KEY: `<16-stellige-MAC>_<Dateiname>`  
Nur für Geräte mit Dateisystem.

```
.fput F65F6C3B7F1527C1_sys_param.lxp
```

---

### `.del FNAME`
Löscht eine Datei auf dem Gerätedateisystem.  
Nur für Geräte mit Dateisystem.

```
.del data.edt
```

---

### `.firmware`
Lädt ein gesichertes Firmware-Image (`.sec`-Datei) auf das Gerät und installiert es.  
Die BLE-Verbindung wird danach automatisch getrennt.  
Nur für Geräte mit Dateisystem (Logger-Typen ≥ 1000 oder mit Disk).

---

### `.reset`
Setzt das Gerät zurück (Reset).  
Die BLE-Verbindung wird dabei getrennt.

---

### `.t [set]` / `.time [set]`
Fragt die Echtzeituhr (RTC) des Geräts ab (`.t`) oder setzt sie auf die aktuelle Browserzeit (`.t set`).  
Nur für BLX (Web-App). In der Windows-Version ist dies in `.info` enthalten.

---

### `.devicelist`
Zeigt die Geräteliste/den Cache an.  
**Hinweis:** Im BLX-Web-Terminal nicht verfügbar (Geräteliste wird im IndexedDB gespeichert).  
Nur in der Windows-Version (BlueWorker.cs) implementiert.

---

### `.crun [URL]`
Führt eine Kommandoskript-Datei (`.crun`) aus.  
Zeilen mit `//` sind Kommentare, Leerzeilen werden ignoriert.

| Aufruf | Beschreibung |
|---|---|
| `.crun` | Öffnet Dateiauswahl-Dialog |
| `.crun URL` | Lädt Skript von der angegebenen URL |

**Beispiele:**
```
.crun crun/scan433sdi.crun
.crun http://127.0.0.1:5000/crun/orbcomm_init.crun
```

Beispiel-Skript (`scan433sdi.crun`):
```
// --- Scannt Wireless SDI12 Dongle ---
z?I!
z*15000 ?XL!
// ---
```

Fertige `.crun`-Skripte für verschiedene Gerätetypen befinden sich im Verzeichnis `crun/` des Repos:
- `0210_modbus_draginoo2.crun` – Modbus Dragino O2-Sensor
- `0210_modbus_seedo2.crun` – Modbus Seed O2-Sensor
- `0470_radar_*.crun` – Radar-Sensor (verschiedene Messbereiche)
- `0920_orbcomm_init_*.crun` – ORBCOMM-Initialisierung (1h/6h)
- `scan433sdi.crun` – Wireless SDI-12 Scan

---

### `.expect [Bedingung]`
Prüft eine Bedingung (hauptsächlich in `.crun`-Skripten verwendet).  
Bei Fehler wird die Ausführung abgebrochen.

| Aufruf | Beschreibung |
|---|---|
| `.expect type 920` | Prüft ob Gerätetyp = 920 |
| `.expect connected` | Prüft ob BLE-Verbindung besteht |

---

### `.shell BEFEHL`
Ruft eine anwendungsseitig registrierte Shell-Callback-Funktion auf (`blxShellCB`).  
Wird in `blxdash.js` über `blx.setShellCallback(blx2DashCallback)` registriert.  
Dient zur Erweiterung der Kommandos durch die Dashboard-Anwendung.

---

## Systemvariablen im Store

Über `.s v KEY [VALUE]` können Systemvariablen gesetzt werden, die das Dashboard-Verhalten steuern:

| Schlüssel | Beschreibung |
|---|---|
| `#blxDash_#badgeURL` | URL zum Label-/Badge-Drucker |
| `#blxDash_#AutoPINURL` | URL zur automatischen PIN-Generierung (z.B. `https://joembedded.de/x3/sec/gen_pin.php?k=...`) |
| `#blxDash_#SETUP` | Allgemeine Dashboard-Setup-Optionen (intern) |
| `<MAC>_#PIN` | Gespeicherter PIN für ein bestimmtes Gerät (16 Zeichen MAC + `_#PIN`) |

---

## Hinweise zur Browserkompatibilität

Die Web Bluetooth API wird nur von Chromium-basierten Browsern unterstützt (Chrome, Edge, Opera, Vivaldi).  
Firefox und Safari unterstützen Web Bluetooth nicht.

---

## Quellen und weiterführende Informationen

- **Privates Repo** (Quellcode, nur für Collaboratora):  
  [github.com/joembedded/blxdashboard 🔒](https://github.com/joembedded/blxdashboard)
  - **BLX.js** – Bluetooth-Worker, implementiert alle SysCommands in `blxSysCmd()` (ab Zeile 1309)
  - **BLXDASH.js** – Dashboard-Logik, wertet Store-Variablen aus und registriert Shell-Callback
  - **BLSTORE.js** – IndexedDB-Wrapper für den lokalen Browser-Speicher


- **Öffentliche Demo-App** (lauffähige Version für alle Anwender):  
  [github.com/joembedded/ltx_ble_demo](https://github.com/joembedded/ltx_ble_demo)

- **Gerätebefehle (ohne `.`)**: Dokumentiert in [LTX_Kommandos.md](../ltx_kommandos/LTX_Kommandos.md)
