# JesFS – Kompakte Zusammenfassung

## Inhaltsverzeichnis

- [Was ist JesFS?](#was-ist-jesfs)
- [Kerneigenschaften im Überblick](#kerneigenschaften-im-überblick)
- [Wie NOR-Flash funktioniert – und warum das wichtig ist](#wie-nor-flash-funktioniert--und-warum-das-wichtig-ist)
  - [3-Ebenen-Architektur](#3-ebenen-architektur)
- [Das „Unclosed Files"-Prinzip](#das-unclosed-files-prinzip)
- [Flaches Dateisystem – kein Verzeichnisbaum](#flaches-dateisystem--kein-verzeichnisbaum)
- [API-Überblick](#api-überblick)
- [Warum JesFS für Datenlogger ideal ist](#warum-jesfs-für-datenlogger-ideal-ist)
- [Praxisempfehlungen für Logger-Projekte](#praxisempfehlungen-für-logger-projekte)
- [Plattformen & Hardware](#plattformen--hardware)
- [Grenzen und Hinweise](#grenzen-und-hinweise)
- [Quellen / Originaldokumentation](#quellen--originaldokumentation)

---

## Was ist JesFS?

**JesFS** (Jo's Embedded Serial File System) ist ein leichtgewichtiges, praxiserprobtes Dateisystem für kleine Embedded-Systeme mit seriellem NOR-Flash-Speicher. Es wurde speziell für IoT-Geräte mit extrem begrenzten Ressourcen entwickelt und läuft weltweit auf tausenden Geräten – von Industriesensoren bis zu Bergstationen auf 3000 m Höhe.

> [!NOTE]
> JesFS ist **kein POSIX-kompatibles Dateisystem** und kein Desktop-Ersatz. Es ist konsequent auf die Anforderungen von Ultra-Low-Power-IoT-Geräten ausgelegt.

---

## Kerneigenschaften im Überblick

| Merkmal | Wert |
|---|---|
| **Min. RAM** | ~200 Bytes |
| **Min. Code-Größe** | ~8 kB (inkl. Bootloader) |
| **Flash-Unterstützung** | 8 kB – 16 MB (optional bis 2 GB) |
| **Max. Dateien** | ~1.000 (bei 4-kB-Sektoren) |
| **Dateiname** | bis 21 Zeichen, fast alle Zeichen erlaubt |
| **Lesegeschwindigkeit** | 0,5 – 3,75 MB/s (je nach SPI-Takt & CRC) |
| **Schreibgeschwindigkeit** | 30 – 70 kB/s |
| **Deep-Sleep-Strom** | < 0,5 µA (MX25Rxxxx-Chips) |
| **Aufwachzeit** | Wenige Mikrosekunden |
| **Integrität** | CRC32 (ISO 3309) |
| **Lizenz** | MIT |

---

## Wie NOR-Flash funktioniert – und warum das wichtig ist

NOR-Flash hat eine physikalische Besonderheit: Bits können **nur von 1 → 0 geschrieben**, aber **nie direkt von 0 → 1 gesetzt** werden. Das Zurücksetzen auf `0xFF` erfordert ein **blockweises Löschen** ganzer Sektoren (typisch 4 kB). Einzelne Bytes können jedoch bitweise beschrieben werden.

JesFS nutzt diese Eigenschaft gezielt aus:

- **Schreiben** erfolgt append-orientiert – bereits genutzte Bytes werden nie überschrieben.
- **Löschen** von Sektoren geschieht nur, wenn Speicher freigegeben werden muss.
- **Wear-Leveling** verteilt Schreibzyklen über alle verfügbaren Sektoren, um die Flash-Lebensdauer zu maximieren (typisch 1.000 – 1.000.000 Löschzyklen pro Sektor, je nach Flash-Typ).

### 3-Ebenen-Architektur

JesFS unterteilt den Flash-Speicher in drei logische Bereiche:

1. **Index** – Mastertabelle aller Dateien (wird nie gelöscht)
2. **Head** – Startbereich jeder einzelnen Datei
3. **Sector Pool** – Der restliche Speicher für Dateiinhalte

---

## Das „Unclosed Files"-Prinzip

> [!IMPORTANT]
> Dies ist eines der markantesten Alleinstellungsmerkmale von JesFS gegenüber klassischen Dateisystemen wie FAT.

**Das Problem bei klassischen Dateisystemen:** Eine Datei muss explizit geschlossen werden, damit Metadaten (Dateigröße, Zeitstempel, Verzeichniseintrag) konsistent geschrieben werden. Fällt die Versorgungsspannung *während des Close-Vorgangs* aus, entstehen inkonsistente oder verlorene Daten.

**Die JesFS-Lösung:** Da ungeschriebener NOR-Flash immer den Wert `0xFF` enthält, kann JesFS das **Ende jeder Datei jederzeit ohne explizites Close finden** – einfach durch Scannen bis zum ersten `0xFF`-Block. Ein formales Schließen ist für die Datenkonsistenz nicht erforderlich.

> [!WARNING]
> Damit das funktioniert, **dürfen Dateiinhalte keine `0xFF`-Bytes enthalten**. Rohdaten müssen entsprechend kodiert werden:
> - Escape-Sequenz: `0xFE 0x01` als Ersatz für `0xFF`
> - Oder: ASCII- bzw. Base64-Kodierung der Nutzdaten

**Ergebnis:** Stromausfall, Reset, Brownout – die Daten bis zum letzten vollständig geschriebenen Block bleiben konsistent und sind sofort nach dem Neustart wieder verfügbar.

---

## Flaches Dateisystem – kein Verzeichnisbaum

JesFS ist bewusst **flat** gehalten: Es gibt keine Verzeichnisse, nur Dateien mit langen Namen.

- Bis zu **~1.000 Dateien** auf einem Standard-4-kB-Sektor-Flash
- Dateinamen bis **21 Zeichen**, nahezu beliebige Zeichen erlaubt  
  (z. B. `sensor_data_2025.log`, `fw_v2.3.1.bin`, `*$abc/hello\world.bin$*`)

---

## API-Überblick

Die API ist bewusst an `fopen()`/`fread()`/`fwrite()` angelehnt – **jedoch nicht POSIX-konform**.

```c
// Dateisystem
int16_t fs_start(uint8_t mode);          // Initialisierung
int16_t fs_format(uint32_t f_id);        // Formatierung
void    fs_deepsleep(void);              // Ultra-Low-Power-Modus

// Dateioperationen
int16_t fs_open(FS_DESC *pdesc, char* pname, uint8_t flags);
int32_t fs_read(FS_DESC *pdesc, uint8_t *pdest, uint32_t anz);
int16_t fs_write(FS_DESC *pdesc, uint8_t *pdata, uint32_t len);
int16_t fs_close(FS_DESC *pdesc);
int16_t fs_delete(FS_DESC *pdesc);
int16_t fs_rewind(FS_DESC *pdesc);
int16_t fs_rename(FS_DESC *pd_odesc, FS_DESC *pd_ndesc);

// Dateisystem-Info & Integrität
int16_t  fs_info(FS_STAT *pstat, uint16_t fno);
uint32_t fs_get_crc32(FS_DESC *pdesc);
int16_t  fs_check_disk(void cb_printf(char *fmt, ...), uint8_t *pline, uint32_t line_size);
```

> [!NOTE]
> Alle `fs_*`-Funktionen prüfen beim Eintritt die Versorgungsspannung über den Callback `_supply_voltage_check()`. Ist die Spannung unzureichend, wird die Operation abgebrochen – ein wichtiges Sicherheitsnetz für Batteriegeräte.

---

## Warum JesFS für Datenlogger ideal ist

- **Ausfallsicherheit**: Kein Datenverlust bei Spannungsunterbrechung (Batteriewechsel, Brownout) dank des Unclosed-Files-Prinzips.
- **Viele kleine Dateien**: Fortlaufendes Speichern von Messdatensätzen in separaten Log-Dateien problemlos möglich.
- **Lange Laufzeiten**: Wear-Leveling und Deep-Sleep (<0,5 µA) schonen Flash und Akku gleichermaßen.
- **Firmware-Updates im Feld**: Verschlüsselte Firmware-Dateien (AES-128) lassen sich per BLE, LTE, LoRa o. ä. übertragen und durch den sicheren Bootloader **JesFsBoot** (nur 8 kB!) einspielen – ohne physischen Zugriff.
- **Trennung von Firmware und Nutzdaten**: Messdaten bleiben als Dateien erhalten, wenn Firmware aktualisiert wird.
- **Externe Synchronisation**: Das Flag `SF_OPEN_EXT_SYNC` markiert Dateien für automatischen Abgleich mit externen Servern (PHP-Framework vorhanden).

---

## Praxisempfehlungen für Logger-Projekte

- Messwerte in **rotierenden Log-Dateien** ablegen (z. B. nach Zeitfenster oder Dateigröße begrenzen).
- **Keine `0xFF`-Bytes** in Dateiinhalten – ASCII- oder Base64-Kodierung verwenden oder Escape-Sequenzen (`0xFE 0x01`).
- Flash-Bereiche logisch trennen: Konfiguration, Firmware-Assets, Messdaten.
- Wartungsfunktionen einplanen: Speicherstand (`fs_info`), Dateianzahl, älteste/neueste Datei, Exportstatus, Integritätsprüfung (`fs_check_disk`).
- Vor Serienbetrieb **Lasttests** mit realistischen Schreibprofilen durchführen (Intervall, Temperatur, Brownout-Szenarien).

---

## Plattformen & Hardware

**Unterstützte MCU-Plattformen:** Nordic nRF52840/52832, TI CC13xx/CC26xx, Atmel SAMD20, Windows (Entwicklung/Simulation)

**Getestete Flash-Chips (Weitspannungsbereich 1,6 V – 3,6 V):**
- Macronix MX25R-Serie
- GigaDevices GD25WD/GD25WQ-Serie
- Prinzipiell jeder Standard-Serial-NOR-Flash

---

## Grenzen und Hinweise

> [!CAUTION]
> JesFS ist ausschließlich für **NOR-Flash** konzipiert. NAND-Flash oder eMMC werden nicht unterstützt.

- Dateinamen sind auf **21 Zeichen** begrenzt.
- **Kein Verzeichnisbaum** – für Anwendungen, die Verzeichnishierarchien benötigen, ist JesFS ungeeignet.
- Konkrete Integrations- und Portierungsschritte hängen vom Ziel-MCU und der Flash-Anbindung (SPI/QSPI) ab – die Low-Level-Treiberschicht (`JesFs_ll_xxxxx.c`) muss ggf. angepasst werden.
- Mehrere gleichzeitig offene Dateien sind möglich (solange RAM vorhanden), jedoch **nur eine Schreibinstanz pro Datei**.

---

## Quellen / Originaldokumentation

- 📦 **JesFS GitHub (Originaldokumentation, API, Demos):** https://github.com/joembedded/JesFS
- 🌐 **Projektseite:** https://joembedded.de/
- 📄 **Detailliertes Integrationsbeispiel (LTX Logger):** [Use_JesFs_en.md](https://github.com/joembedded/JesFs/blob/master/Documentation/Use_JesFs_en.md)
- 📊 **Performance-Messungen:** [PerformanceTests.pdf](https://github.com/joembedded/JesFs/blob/master/Documentation/PerformanceTests.pdf)
