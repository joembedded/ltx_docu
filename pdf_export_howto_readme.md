# PDF-Export aus `/editiert/`

**Howto:** Kopiere die Vorlage, ersetze die Platzhalter:

## Kopiervorlage für PROMPT:

> Erstelle ein [kompaktes/ausführliches] deutschsprachiges Produktdatenblatt als PDF für **[Produkttyp und Produktbezeichnung]**: [kurze Produktbeschreibung]. Schwerpunkte: [Zielgruppe, Umfang und wichtige Themen].
>
> Nutze [primäre Quelle] als maßgebliche Quelle und ergänze sie mit [weitere Quellen]. Prüfe passende Bilder im Repository. Bei Widersprüchen gilt die primäre Quelle; erfinde keine Werte oder Zusagen und dokumentiere Annahmen.
>
> Erstelle `/pdf/[dateiname].md` im GeoPrecision-Stil aus `/documentation/pdf-style/` und exportiere nach `/output/pdf/[dateiname].pdf`. Gliedere nach den Quellen in Produktprofil, Vorteile, technische Daten, Funktionen und Einsatzbereiche; ergänze bei Bedarf [z. B. Schnittstellen, Projektierung, Montage oder Konformität]. Nutze Tabellen für technische Daten.
>
> Verwende ein passendes `cover-image` und zeige es nach dem Produktprofil noch einmal groß. Bilder dürfen lokal eingebettet sein, müssen aber unverzerrt und lesbar bleiben. Für PDF-Links auf Repository-Dateien verwende nur vollständige URLs unter `https://github.com/joembedded/ltx_docu/blob/master/`; allgemeine LTX-Verweise führen zu [joembedded/ltx_docu](https://github.com/joembedded/ltx_docu). Keine lokalen oder relativen anklickbaren Links.
>
> Baue und rendere das PDF. Korrigiere Überläufe, Seitenumbrüche, Tabellen und Abbildungen. Nenne abschließend erzeugte Dateien, Quellen und Annahmen.

## Regeln

- Quellen: `/editiert/`; PDF-Quellen: `/pdf/`; fertige PDFs: `/output/pdf/`.
- Das Titelbild erscheint auch auf der ersten Inhaltsseite nach dem Produktprofil: Querformat etwa `125mm` breit, hohes Hochformat etwa `105mm` hoch.
- Für Links sind `https://`-URLs und interne `#anker` erlaubt. Keine Windows-Pfade, `file:///`-Ziele oder relativen `.md`-Links.
- Bei automatischer Produktauswahl: „Untersuche `/editiert/`, nenne die Zuordnung von Produkt zu Quelle und triff bei Mehrdeutigkeiten dokumentierte Annahmen.“

## Bauen und prüfen

```powershell
.\documentation\pdf-style\build-pdfs.ps1
```

```powershell
.\documentation\pdf-style\build-pdfs.ps1 -Source pdf\[dateiname].md
```

```powershell
.\documentation\pdf-style\render-pdfs.ps1
```


