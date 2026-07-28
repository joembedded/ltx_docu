# GeoPrecision PDF-Stil

Diese Vorlage überträgt die visuelle Sprache der GeoPrecision-Website auf technische Dokumente. Sie ist für Produktbeschreibungen, Datenblätter und kompakte Anleitungen im A4-Format gedacht.

## Gestaltungsprinzipien

- **Farben:** Dunkelblau `#132536`, Sekundärblau `#294256`, Eisblau `#DFECEF`, Akzentrot `#DF2F32`, Papiergrau `#F6F8F7`.
- **Typografie:** Segoe UI in kräftigen Schnitten für Überschriften und als gut lesbare Fließtextschrift, Consolas für Kommandos. Das entspricht der klaren Sans-Serif-Anmutung der Website und funktioniert mit den Windows-Systemschriften.
- **Aufbau:** Titelblatt soll primär den Inhalt kurz beschreiben, Hintergrund eher neutral, deutliche rote Akzentlinien, großzügige Abstände, zurückhaltende Tabellen und eine sparsame Kopf-/Fußzeile. Bilder auf Titelblatt mittelgross bis gross, je nach verfügbarem Platz. Bild darf auffallen.
- **Ton:** technisch präzise, kurze Abschnitte, klar gekennzeichnete Planungswerte und keine ungesicherten Werbeversprechen.
- **Bildsprache:** Produktfreisteller oder sachliche Anwendungsbilder auf weißer beziehungsweise eisblauer Fläche. Die Bilder gerne etwas grösser, wenn Platz auf der Seite ist.
- **Titelbild wiederholen:** Das kleine Produktbild des Titelblatts wird auf der ersten Inhaltsseite direkt nach dem Produktprofil noch einmal groß und mit korrekter Bildbeschreibung gezeigt. Für Querformatbilder sind etwa 120 bis 130 mm Bildbreite ein guter Ausgangswert; bei hohen Hochformatbildern ist stattdessen eine Höhe um 100 bis 110 mm zu verwenden. Das Bild wird eingebettet und darf deshalb einen lokalen Repository-Pfad verwenden.
- **Nachweise verlinken:** Aussagen wie „Details stehen in der Dokumentation dieses Repos“ erhalten immer einen anklickbaren Weblink. Für die LTX-Dokumentation ist das Ziel `[joembedded/ltx_docu](https://github.com/joembedded/ltx_docu)`; relative `.md`-Links oder `file:///`-Ziele sind in weitergegebenen PDFs unzulässig.
- **Verlinkungen:** Bei Verweisen auf lokale Dateien oder Repos nicht die lokalen Pfade verwenden, sondern komplette Links für URLs. Das Repo `ltx_docu` befindet sich im Internet auf https://github.com/joembedded/ltx_docu , das Repo `payload-decoder`auf  https://github.com/joembedded/payload-decoder . Suche bei anderen lokane Dateien selbst den Internet-Speicherort.

Die Ausgangsbasis ist die lokale Kopie der Website unter `C:\html\wrk\wwwgeoprec\www` (Stand Juli 2026). Das verwendete Logo liegt für reproduzierbare Builds unter `assets/geoprecision-logo.png`.

## Neue Dokumente anlegen

Eine neue Markdown-Datei wird in `pdf/` abgelegt. Der Kopf sollte mindestens diese Felder enthalten:

```yaml
---
title: Produktname
subtitle: Kurze technische Einordnung
document-type: Produktbeschreibung
product-code: PRODUKTCODE
lead: Ein kurzer Nutzen- und Anwendungsabsatz für das Titelblatt.
cover-image: editiert/img/produktbild.png
date: Juli 2026
version: "1.0"
---
```

Danach folgt normales Pandoc-Markdown. Für belastbare Ergebnisse sollten Tabellen nicht mehr als drei Spalten haben und Bilder ausreichend hoch aufgelöst sein.

## PDFs erzeugen

Alle Quellen bauen:

```powershell
.\documentation\pdf-style\build-pdfs.ps1
```

Nur ausgewählte Quellen bauen:

```powershell
.\documentation\pdf-style\build-pdfs.ps1 -Source pdf\produkt_a.md,pdf\produkt_b.md
```

Voraussetzungen sind Pandoc und XeLaTeX. Die fertigen Dateien werden standardmäßig nach `output/pdf/` geschrieben. Farben, Typografie, Titelblatt, Kopf-/Fußzeilen und Tabellenformat werden zentral in `geoprecision.tex` gepflegt.

## Pflege

- Website-Farben oder Branding nur zentral in `geoprecision.tex` ändern.
- Das Logo nur ersetzen, wenn die offizielle Website ebenfalls aktualisiert wurde.
- Nach Änderungen alle PDFs neu bauen und jede Seite gerendert auf abgeschnittene Inhalte, Tabellenumbrüche und Bildqualität prüfen.
- Produktwerte immer aus den fachlichen Quelldokumenten übernehmen; die Vorlage steuert ausschließlich Darstellung und wiederkehrende Metadaten.

Unter Windows können alle PDF-Seiten ohne Zusatzinstallation als PNG gerendert werden:

```powershell
.\documentation\pdf-style\render-pdfs.ps1
```

Die Prüfbilder landen standardmäßig unter `tmp/pdfs/rendered/` und gehören nicht zu den auszuliefernden Dokumenten.
