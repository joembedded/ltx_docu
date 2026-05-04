# JesFS – kompakte Zusammenfassung

## Was ist JesFS?
JesFS (Jo's Embedded Serial File System) ist ein leichtgewichtiges Dateisystem für kleine Embedded-Systeme mit seriellen NOR-Flash-Speichern. Es wurde für sehr kleine MCUs ausgelegt und benötigt entsprechend wenig RAM und Flash.

## Funktionsüberblick
- **Dateibasiertes Speichern auf NOR-Flash** statt fester Datenstrukturen im Firmware-Code.
- **Kleiner Footprint** für ressourcenarme Controller.
- **Persistenz bei Power-Loss**: Daten bleiben konsistent, auch wenn während eines Schreibvorgangs die Versorgung ausfällt.
- **Wear-Leveling-Ansätze** zur besseren Ausnutzung der Flash-Lebensdauer.
- **Hohe Lesegeschwindigkeit** für typische Embedded-Auslesevorgänge.
- **Journaling-/Logging-geeigneter Modus** für sehr viele Schreibzyklen.

**Besonderheit („unclosed files“):** Bei einem plötzlichen Reset/Power-Loss kann es vorkommen, dass eine zuletzt beschriebene Datei nicht „sauber geschlossen“ wurde. JesFS ist darauf ausgelegt, dass das Dateisystem dabei dennoch konsistent bleibt: Die betroffene Datei ist als unvollständig erkennbar und kann beim nächsten Start gezielt verworfen, gekürzt (bis zum letzten gültigen Datensatz) oder finalisiert werden. Für Logger ist das hilfreich, weil typischerweise höchstens der letzte angefangene Schreibabschnitt betroffen ist – nicht der gesamte Datenbestand.

## Wie JesFS intern arbeitet (vereinfacht)
1. Daten werden als Dateien in Flash-Blöcken abgelegt.
2. Schreiben erfolgt so, dass NOR-Flash-Eigenschaften (löschen blockweise, schreiben bitweise) berücksichtigt werden.
3. Verwaltungseinträge (Metadaten) erlauben das Wiederfinden von Dateien nach Neustart.
4. Beim Erreichen von Grenzen einzelner Bereiche wird auf andere Flash-Bereiche verteilt (Wear-Leveling).

## Einsatz auf Loggern: warum gut geeignet
Für Datenlogger ist JesFS besonders passend, weil:
- **Viele kleine Messdatensätze** fortlaufend gespeichert werden können.
- **Ausfallsicherheit** bei Batteriewechseln oder Spannungseinbrüchen wichtig ist.
- **Lange Laufzeiten** durch flash-schonende Strategien unterstützt werden.
- **Trennung von Firmware und Nutzdaten** Updates vereinfacht (Messdaten bleiben als Dateien erhalten).

## Praxisempfehlungen für Logger-Projekte
- Messwerte in **rotierenden Log-Dateien** speichern (z. B. nach Zeitfenster oder Dateigröße).
- Regelmäßig **Flush-/Commit-Punkte** setzen, um Datenverlustfenster zu minimieren.
- Für hohe Schreibraten eher **append-orientierte Dateistrukturen** verwenden.
- Flash-Bereich für Konfiguration, Firmware-Assets und Messdaten logisch trennen.
- Wartungsfunktionen vorsehen: Speicherstand, Dateianzahl, älteste/neuste Datei, Exportstatus.

## Grenzen und Hinweise
- JesFS ist für **NOR-Flash und Embedded** optimiert, nicht als allgemeiner Desktop-Dateisystemersatz gedacht.
- Konkrete API-Details und Integrationsschritte hängen vom Ziel-MCU/Board und der Flash-Anbindung (SPI/QSPI) ab.
- Vor Serienbetrieb sollten Lasttests mit realistischen Schreibprofilen (Intervall, Temperatur, Brownout-Szenarien) durchgeführt werden.

## Quellen / Originaldokumentation
- JesFS – Originaldokumentation / Projektseite (GitHub): https://github.com/joembedded/jesfs
