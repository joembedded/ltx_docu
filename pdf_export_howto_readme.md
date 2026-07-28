# PDF-Export aus `/editiert/`

Diese Notiz enthält einen wiederverwendbaren Auftragstext für Codex, um aus den aufbereiteten Daten im Verzeichnis `/editiert/` ansprechend gestaltete PDF-Dokumente zu erzeugen.

## Kurzer Auftrag

Den folgenden Text kann ich später direkt an Codex senden:

> Erstelle aus den passenden Markdown-Dateien unter `/editiert/` professionelle Produktbeschreibungen als PDF. Verwende den vorhandenen GeoPrecision-Dokumentationsstil unter `/documentation/pdf-style/`, lege bei Bedarf bearbeitbare PDF-Quelldateien unter `/pdf/` an und speichere die fertigen PDFs unter `/output/pdf/`. Übernimm technische Daten sorgfältig aus den Quelldateien, erfinde keine fehlenden Angaben und kennzeichne Unklarheiten. Baue anschließend alle PDFs und prüfe jede Seite durch Rendern auf ein sauberes Layout, vollständige Tabellen, lesbare Bilder und nicht abgeschnittene Inhalte.

## Auftrag für bestimmte Produkte

Wenn nur ausgewählte Dokumente verarbeitet werden sollen, sollte ich die Dateien oder Produkte ausdrücklich nennen:

> Erstelle aus diesen Dateien jeweils eine separate Produktbeschreibung als PDF:
>
> - `/editiert/PFAD/ZUR/DATEI_1.md`
> - `/editiert/PFAD/ZUR/DATEI_2.md`
> - `/editiert/PFAD/ZUR/DATEI_3.md`
>
> Verwende den vorhandenen GeoPrecision-Stil, ergänze passende Titelbilder aus dem Repository und prüfe die fertigen PDFs visuell. Bestehende Produktdaten dürfen redaktionell gegliedert und sprachlich verbessert, aber nicht inhaltlich erfunden werden.

## Falls Codex die Dateien selbst auswählen soll

> Untersuche `/editiert/` und ermittle alle eigenständigen Produkte, zu denen ausreichend Informationen für eine Produktbeschreibung vorhanden sind. Zeige mir zuerst kurz die gefundene Zuordnung von Produkt zu Quelldatei. Erstelle danach für jedes ausgewählte Produkt eine eigene PDF-Datei im vorhandenen GeoPrecision-Dokumentationsstil.

Wenn die Auswahl nicht vorher bestätigt werden muss, kann stattdessen ergänzt werden:

> Triff bei mehrdeutigen Dateinamen eine sinnvolle Auswahl und dokumentiere deine Annahmen am Ende.

## Vorhandene Struktur

- Quelldaten: `/editiert/`
- Bearbeitbare PDF-Inhalte: `/pdf/`
- Fertige PDF-Dateien: `/output/pdf/`
- Allgemeiner Dokumentationsstil: `/documentation/pdf-style/`
- Gestaltungsvorlage: `/documentation/pdf-style/geoprecision.tex`
- Gemeinsame Einstellungen: `/documentation/pdf-style/geoprecision.yaml`
- Anleitung zum Stil: `/documentation/pdf-style/README.md`

## PDFs erneut erzeugen

Alle Produktbeschreibungen können im Hauptverzeichnis des Repositories mit folgendem Befehl neu gebaut werden:

```powershell
.\documentation\pdf-style\build-pdfs.ps1
```

Nur eine bestimmte Markdown-Datei bauen:

```powershell
.\documentation\pdf-style\build-pdfs.ps1 `
  -Source pdf\produktbeschreibung_ltx_typ_1820.md
```

Die PDFs zur visuellen Kontrolle in PNG-Seiten rendern:

```powershell
.\documentation\pdf-style\render-pdfs.ps1
```

## Sinnvolle zusätzliche Angaben

Je genauer der Auftrag ist, desto passender werden die Dokumente. Bei Bedarf kann ich zusätzlich angeben:

- Zielgruppe, beispielsweise Vertrieb, technischer Einkauf oder Installation
- gewünschte Sprache
- gewünschter Umfang
- Datenblatt, Produktbroschüre oder ausführliche Dokumentation
- gewünschte Produkte und Quelldateien
- Bilder, Logos oder Diagramme, die verwendet werden sollen
- ob Rückfragen gestellt oder sinnvolle Annahmen getroffen werden dürfen
- ob bestehende PDFs überschrieben werden dürfen

## Empfohlener vollständiger Auftrag

> Erstelle aus den von mir genannten Daten unter `/editiert/` für jedes Produkt eine professionelle deutschsprachige Produktbeschreibung als PDF. Verwende konsequent den vorhandenen GeoPrecision-Stil unter `/documentation/pdf-style/`. Lege die bearbeitbaren Markdown-Fassungen unter `/pdf/` und die fertigen PDFs unter `/output/pdf/` ab. Gliedere die Dokumente in Kurzbeschreibung, Vorteile, Einsatzbereiche, Funktionen und technische Daten, soweit diese Informationen in den Quellen vorhanden sind. Verwende vorhandene Produktbilder, ohne deren Seitenverhältnis zu verzerren. Erfinde keine technischen Werte. Baue die PDFs, rendere alle Seiten zur Kontrolle und korrigiere Überläufe, abgeschnittene Inhalte, schlecht umbrechende Tabellen und unleserliche Abbildungen. Nenne mir anschließend die erzeugten Dateien und alle getroffenen Annahmen.

