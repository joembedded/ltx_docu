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

## Links in eigenständigen PDFs

PDF-Dateien aus `output/pdf/` werden unabhängig vom lokalen Repository weitergegeben. Deshalb dürfen anklickbare Markdown-Links in den PDF-Quellen nicht auf lokale oder relative Dateien zeigen. Pandoc würde einen Link wie `[Dokument](editiert/datei.md)` andernfalls als `file:///C:/...` in die PDF schreiben.

Für dieses Repository gelten folgende Webziele:

- Repository-Übersicht: `https://github.com/joembedded/ltx_docu`
- Standard-Branch: `master`
- Basis für einzelne Dateien: `https://github.com/joembedded/ltx_docu/blob/master/`

Beispiele:

```markdown
[joembedded/ltx_docu](https://github.com/joembedded/ltx_docu)

[LTX LoRa-Payload](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/lora_payload.md)

[Typ/FPort am Logger einstellen](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/lora_payload.md#typfport-am-logger-einstellen)
```

Dabei ist zu unterscheiden:

- Links auf andere Dokumente im Repository müssen vollständige GitHub-URLs verwenden.
- Links auf externe Dokumentationen bleiben vollständige `https://`-URLs.
- Jeder Satz, der auf „dieses Repo“, „die technische Dokumentation“ oder weiterführende Unterlagen verweist, muss das tatsächlich gemeinte Webziel direkt verlinken. Für die allgemeine LTX-Dokumentation lautet das Ziel `[joembedded/ltx_docu](https://github.com/joembedded/ltx_docu)`.
- Sprünge innerhalb derselben PDF dürfen als `#anker` erhalten bleiben.
- `cover-image` und Markdown-Bilder dürfen lokale Repository-Pfade verwenden, weil Pandoc die Bilddaten in die PDF einbettet. Sie sind keine Verweise, die der Leser später lokal öffnen muss.
- `file:///`, Windows-Laufwerkspfade und relative `.md`-Links dürfen nicht als anklickbare Ziele in einer auszuliefernden PDF verbleiben.

Das Build-Skript bricht ab, wenn es in einer PDF-Quelle einen lokalen anklickbaren Markdown-Link findet. Zusätzlich kann vor dem Build gesucht werden mit:

```powershell
rg --pcre2 -n -g '*.md' '(?<!!)\[[^]]+\]\((?!https?://|mailto:|tel:|#)[^)]+\)' pdf
```

## Titelbild auf der ersten Inhaltsseite

Das im Metadatenfeld `cover-image` verwendete Produktbild wird nicht nur klein auf dem Titelblatt gezeigt. Es muss auf der unmittelbar folgenden Inhaltsseite nach dem einleitenden Produktprofil noch einmal groß erscheinen. Dadurch ist das Produkt auch in einer verkleinerten Bildschirmansicht klar erkennbar.

Empfohlenes Markdown:

```markdown
![Aussagekräftige Beschreibung des Produkts](../editiert/img/produktbild.jpg){width=125mm}
```

Für ein hohes Hochformatbild wird die Höhe begrenzt:

```markdown
![Aussagekräftige Beschreibung des Produkts](../editiert/img/produktbild-hochformat.png){height=105mm}
```

Dabei gelten folgende Regeln:

- möglichst dasselbe Bild wie bei `cover-image` verwenden;
- Querformat: Bildbreite als Ausgangswert etwa `120mm` bis `130mm`;
- hohes Hochformat: Bildhöhe als Ausgangswert etwa `100mm` bis `110mm`, damit Produktprofil, Bild und Vorteile auf derselben Seite bleiben;
- Seitenverhältnis nie verzerren;
- korrekten Produkttyp im Alternativtext nennen;
- Bild direkt nach dem Produktprofil und vor den Vorteilen platzieren;
- nach dem PDF-Build prüfen, dass Bild, Beschriftung und Folgetext vollständig auf die Seite passen.

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

> Erstelle aus den von mir genannten Daten unter `/editiert/` für jedes Produkt eine professionelle deutschsprachige Produktbeschreibung als PDF. Verwende konsequent den vorhandenen GeoPrecision-Stil unter `/documentation/pdf-style/`. Lege die bearbeitbaren Markdown-Fassungen unter `/pdf/` und die fertigen PDFs unter `/output/pdf/` ab. Gliedere die Dokumente in Kurzbeschreibung, Vorteile, Einsatzbereiche, Funktionen und technische Daten, soweit diese Informationen in den Quellen vorhanden sind. Verwende vorhandene Produktbilder, ohne deren Seitenverhältnis zu verzerren. Zeige das kleine Titelbild auf der ersten Inhaltsseite nach dem Produktprofil noch einmal groß: bei Querformat üblicherweise etwa 125 mm breit, bei hohem Hochformat etwa 105 mm hoch. Erfinde keine technischen Werte. Da die PDFs eigenständig weitergegeben werden, müssen alle anklickbaren Verweise auf Repository-Dateien vollständige GitHub-URLs unter `https://github.com/joembedded/ltx_docu/blob/master/` verwenden; relative lokale Links und `file:///`-Ziele sind unzulässig. Allgemeine Hinweise auf die technische Dokumentation oder „dieses Repo“ müssen direkt auf `[joembedded/ltx_docu](https://github.com/joembedded/ltx_docu)` verlinken. Lokale Bildpfade sind erlaubt, wenn die Bilder in die PDF eingebettet werden. Baue die PDFs, rendere alle Seiten zur Kontrolle und korrigiere Überläufe, abgeschnittene Inhalte, schlecht umbrechende Tabellen und unleserliche Abbildungen. Nenne mir anschließend die erzeugten Dateien und alle getroffenen Annahmen.
