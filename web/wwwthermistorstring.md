---
title: "GEOprecision Thermistor Strings – System, Sensoren und technische Daten"
description: "KI-taugliche Zusammenfassung der Thermistor-String-Webseite und ihrer technischen Unterseiten"
company: "GEOprecision GmbH"
product_family: "Digitale 2Wire-Thermistorketten und Sensorketten"
website: "https://thermistor-string.com/"
language: "de"
source_type: "lokaler Webseiten-Quellbestand und gerenderte XAMPP-Seiten"
retrieved: "2026-08-19"
---

# Digitale Thermistorketten von GEOprecision

## Kurzfassung

GEOprecision fertigt kundenspezifische digitale 2Wire-Sensorketten zur Erfassung räumlicher Temperatur- und optional Druckprofile. Die Messpunkte können in Linien- oder Sterntopologie angeordnet und mit unterschiedlichen Sensortypen bestückt werden. Typische Anwendungen sind Bohrlöcher, Permafrost, Boden und Fels, Gletscher, Seen, Meere, Feuchtgebiete, Deiche und Dämme.

Die Sensorkette kommuniziert intern über einen digitalen Zweidrahtbus. Für die Aufzeichnung stehen zwei Wege zur Verfügung:

1. direkter Anschluss an einen kompatiblen GEOprecision-Minilogger oder
2. Umsetzung des 2Wire-Busses auf SDI-12 V1.3 durch den Konverter **OSX-Knoten Typ 410** und Anschluss an einen SDI-12-fähigen Datenlogger.

Jede Kette wird nach Messaufgabe, Messpunkten, Genauigkeit, Kabellängen, Topologie, Gehäuse und gewünschter Auslesung konfiguriert. Es handelt sich deshalb nicht um eine einzige starre Standardausführung.

## Zweck und Funktionsprinzip

Eine Thermistorkette misst Temperatur an mehreren definierten Positionen entlang eines Kabelsystems. Dadurch entsteht ein Temperaturprofil über Tiefe, Höhe oder räumliche Entfernung. Entsprechend konfigurierte Ketten können zusätzlich Drucksensoren enthalten.

Wesentliche Eigenschaften des digitalen Systems:

- Jeder Messpunkt besitzt Sensor und Elektronik am selben Ort.
- Kalibrierdaten bleiben im jeweiligen digitalen Sensorknoten gespeichert.
- Ein Austausch des Datenloggers verändert die im Sensorknoten hinterlegte Kalibrierung nicht.
- Digitale Übertragung vermeidet kabelbedingte Verluste der Messgenauigkeit innerhalb der angegebenen Systemgrenzen.
- Dünne Zweidrahtleitungen reduzieren Gewicht und unerwünschten Wärmetransport entlang der Leiter.
- Kompatible Sensortypen können innerhalb einer Kette kombiniert werden.
- Linien- und Sterntopologien sind möglich.

## Systemgrenzen

| Merkmal | Angabe |
|---|---|
| Sensoranzahl | bis zu 50 standardmäßig; optional bis zu 300 |
| Standardlänge einer Sensorkette | bis zu 100 m |
| Sonderlänge einer Sensorkette | 250 m oder mehr auf Anfrage |
| Maximale Gesamtkabellänge des Netzes | bis zu 500 m |
| Topologien | Linie oder Stern |
| Minimaler üblicher Sensorabstand | 15 cm |
| Möglicher erster Sensorabstand | 10 cm |
| Temperaturbereich aller drei TNode-Typen | −40 °C bis +85 °C |
| Druckbereich | bis 5 bar beziehungsweise etwa 50 m Wassersäule; höhere Bereiche optional |
| String-Protokoll | digitaler GEOprecision-2Wire-Bus |

Die Grenzen sind Konfigurationswerte des Gesamtsystems. Eine konkrete Kombination aus Sensoranzahl, Kabellänge, Topologie, Versorgung und Logger muss von GEOprecision für das Projekt ausgelegt werden.

## Temperatursensoren

Alle aufgeführten Temperaturknoten arbeiten am gleichen digitalen 2Wire-System und dürfen innerhalb einer kompatiblen Kette kombiniert werden.

### Technischer Vergleich

| Eigenschaft | TNode | TNode EX | TNode HD |
|---|---|---|---|
| Sensortyp | digitaler Sensorchip | Pt1000 | Pt100 |
| Auflösung | 0,01 °C | 0,001 °C | 0,0001 °C |
| Genauigkeit im besten angegebenen Bereich | ±0,1 °C bei −5 bis +50 °C | ±0,1 °C bei −20 bis +25 °C | ±0,05 °C bei −20 bis +25 °C |
| Erweiterte Genauigkeit | ±0,5 °C bei −40 bis +85 °C | ±0,2 °C bei −30 bis +40 °C; ±0,5 °C bei −40 bis +85 °C | ±0,1 °C bei −30 bis +40 °C; ±0,25 °C bei −40 bis +85 °C |
| Betriebsspannung | 3,2 bis 3,6 V | 3,0 bis 3,8 V | 3,0 bis 3,8 V |
| Ruhestrom | 0,75 µA | 0,5 µA | 0,6 µA |
| Aktivstrom und Messdauer | 2,5 mA für 500 ms | 2,5 mA für 600 ms | 4 mA für 800 ms |
| Datenausgang | digitaler 2Wire-Bus | digitaler 2Wire-Bus | digitaler 2Wire-Bus |

### Auswahlhilfe

- **TNode** ist der Standardsensor für präzise Temperaturprofile mit 0,01 °C Auflösung.
- **TNode EX** verwendet einen Pt1000 und bietet eine höhere Auflösung von 0,001 °C.
- **TNode HD** verwendet einen Pt100 und bietet die höchste angegebene Auflösung und Genauigkeit.

Auflösung und Genauigkeit sind unterschiedliche Größen. Eine Auflösung von 0,0001 °C bedeutet nicht automatisch eine Genauigkeit von 0,0001 °C; für TNode HD beträgt die beste genannte Genauigkeit ±0,05 °C.

## Mechanischer Aufbau

| Bauteil oder Merkmal | Ausführung |
|---|---|
| Sensorrohr | Edelstahl, Werkstoff DIN 1.4571 |
| String-Kabel | PUR, etwa 4,2 mm Durchmesser |
| Zulässige Zuglast | bis 30 kg |
| Anschluss | M8-Steckverbinder mit IP67 oder steckverbinderlose Ausführung |
| Schutz der Messpunkte | umspritzt und wasserbeständig |
| Aufbau | kundenspezifische Sensorpositionen, Kettenlänge, Topologie und Anschlüsse |

Die Webseite beschreibt die Elektronik in abgedichteten Gehäusen als vergossen. Produkt- und projektspezifische Einbau-, Dichtheits- und Sicherheitsvorgaben haben Vorrang vor der allgemeinen Webseitenbeschreibung.

## Anschluss- und Logger-Varianten

### Variante 1: direkter GEOprecision-Minilogger

Eine kompatible Thermistorkette kann ohne separaten Protokollkonverter direkt an einen passenden GEOprecision-Minilogger angeschlossen werden.

Merkmale:

- native 2Wire-Verbindung,
- kompaktes, aufeinander abgestimmtes System aus Kette und Logger,
- Loggergehäuse aus Edelstahl oder POM verfügbar,
- lokale Funkvarianten mit 433 MHz oder 915 MHz,
- austauschbare Batterie im AA-Format ohne Lötarbeit.

Je nach bestellter Loggerkonfiguration kommen eine 1,5-V-Alkali- oder Lithiumzelle oder eine 3,6-V-Lithium-Thionylchlorid-Zelle infrage. Es darf nur der für das konkrete Gerät vorgeschriebene Batterietyp verwendet werden. Für kalte Umgebungen ist normalerweise die spezifizierte Lithiumausführung erforderlich.

Die Funkfrequenz richtet sich nach dem Einsatzland und dessen Vorschriften. Die Webseite nennt 433 MHz typischerweise für Europa, Asien und Afrika sowie 915 MHz für Amerika und weitere Regionen, in denen dieses Band zulässig ist. Maßgeblich sind immer die örtlichen Funkbestimmungen.

### Variante 2: Typ 410 als 2Wire-zu-SDI-12-Konverter

Der **OSX-Knoten Typ 410** setzt den nativen 2Wire-Bus der Kette auf **SDI-12 V1.3** um.

Merkmale:

- POM-Gehäuse,
- 2Wire-Anschluss auf der Sensorseite,
- Versorgung, Masse und SDI-12-Datensignal auf der Loggerseite,
- verwendbar mit jedem geeigneten SDI-12-fähigen Datenlogger,
- für GEOprecision-LTX-Logger optimiert,
- Bluetooth Low Energy für lokale Konfiguration und Diagnose,
- Bedienung mit BlueShell oder dem browserbasierten BLX Dashboard auf PCs und kompatiblen Android-Geräten.

Bluetooth ist die lokale Serviceverbindung. Die Messdaten werden vom Typ 410 über SDI-12 an den angeschlossenen Logger übergeben.

## Welche Daten liefert das System?

Je nach Aufbau kann das System folgende Informationen liefern:

- Temperaturwerte an jedem konfigurierten Messpunkt,
- Temperaturprofile über Tiefe oder Entfernung,
- Druckwerte und Druckprofile bei entsprechend bestückten Sensorketten,
- Sensorknoten-spezifische Kalibrierinformationen,
- über den Logger zeitlich aufgezeichnete Messreihen.

Der Datenweg ist:

`Sensorknoten → digitaler 2Wire-Bus → direkter Minilogger oder Typ 410 → gegebenenfalls SDI-12-Logger`

Die Webseite definiert kein allgemeines Cloud-, API- oder Exportformat für alle Konfigurationen. Speicherung, Übertragung, Dateiformat und Fernkommunikation hängen vom verwendeten Datenlogger ab.

## Betrieb, Speicher und Wartung

- Ein kompatibler Logger kann ausgetauscht werden; die Kalibrierung verbleibt in den digitalen Sensorknoten.
- Bei unterstützten Loggern lässt sich der Parametersatz mit der passenden GEOprecision-Software aus dem alten Gerät exportieren und in ein Ersatzgerät importieren.
- Im Speicher-Modus **Overwrite** läuft die Aufzeichnung bei vollem Flash weiter und überschreibt die ältesten Datensätze.
- Im Speicher-Modus **Stop** pausiert die Aufzeichnung bei vollem Flash, bis der Speicher gelöscht wurde.
- Der gewünschte Speichermodus ist vor dem Feldeinsatz zu prüfen.
- Bei Funkproblemen im unmittelbaren Nahbereich kann ein zu starkes Signal die Ursache sein; ein größerer Abstand zwischen Logger und USB-Dongle kann helfen.
- Größere Funkreichweite kann durch erhöhte Positionierung, Abstand des Dongles vom Computer mittels USB-Verlängerung oder eine geeignete Antenne erreicht werden.

Diese Hinweise sind allgemeine FAQ-Angaben. Das Handbuch des konkreten Logger- und Hardwaretyps ist verbindlich.

## Anwendungsgebiete

### Wasser und Eis

Mehrpunktmessung von Temperaturprofilen in Gletschern, Seen und Meeren. Optional lassen sich bei geeigneter Konfiguration Druckmesspunkte ergänzen.

### Permafrost, Boden und Fels

Thermistorketten erfassen an mehreren Tiefen dieselbe jährliche thermische Entwicklung. Oberflächennahe Temperaturänderungen sind groß und schnell; mit zunehmender Tiefe werden sie gedämpft und zeitlich verzögert. Messreihen über definierte Tiefen unterstützen unter anderem die Untersuchung von:

- aktiver Auftauschicht,
- Gefrier- und Auftauzeitpunkten,
- langfristigen Temperaturänderungen unterhalb der starken saisonalen Schwankungen,
- thermischen Vorgängen in Felsklüften und permafrostbeeinflussten Hängen.

Die Sensorabstände können nahe der Oberfläche oder aktiven Schicht enger und in größeren Tiefen weiter gewählt werden.

Die Forschungsabbildungen auf der Webseite dienen als Anwendungsbeispiele. Die Seite stellt ausdrücklich klar, dass die dort übernommenen wissenschaftlichen Diagramme nicht als GEOprecision-Messergebnisse ausgegeben werden.

### Feuchtgebiete, Deiche und Dämme

Temperaturprofile können zur thermischen Beobachtung von Feuchtgebieten und wasserbaulichen Strukturen eingesetzt werden.

## Projektierung und Bestellung

Für die Konfiguration einer Kette benötigt GEOprecision insbesondere:

1. Einsatzumgebung und Messaufgabe,
2. Gesamt- und Teilkabellängen,
3. Positionen und Abstände der Messpunkte,
4. Temperatur- und gegebenenfalls Drucksensoren,
5. gewünschte Genauigkeit beziehungsweise Sensortypen,
6. Linien- oder Sterntopologie,
7. mechanische Ausführung, Gehäuse und Anschluss,
8. direkte Loggeranbindung oder SDI-12 über Typ 410,
9. gewünschte lokale oder drahtlose Auslesung.

Zur Anfrage steht das PDF **2W Thermistor String request form** bereit. Das ausgefüllte Formular wird an GEOprecision gesendet und anschließend fachlich geprüft.

## Software und Downloads

### Aktuelle Unterlagen

- 2W-Thermistorketten-Anfrageformular,
- Datenblatt des SDI-12-Konverters Typ 410,
- Übersicht der LTX-Datenlogger,
- Katalog der Open-SDI12-Sensoren und Schnittstellenknoten.

### Legacy-Bereich

Der lokale Quellbestand enthält zusätzlich ältere Handbücher, Firmwaredateien und Windows-Programme für eingestellte Logger- und Konvertergenerationen. Dazu gehören unter anderem Unterlagen zu älteren 2W-Miniloggern, Wireless-SDI-Konvertern sowie FG2-, GP5W- und BlueShell-Versionen.

Legacy-Dateien sind **nicht automatisch für aktuelle Hardware geeignet**. Handbuch, Firmware und Anwendung müssen exakt zu Modell und Hardware-Revision passen. Wenn die Generation unklar ist, sollen Modell und Seriennummer vor einem Update mit GEOprecision abgeklärt werden.

## Unternehmens- und Kontaktdaten

| Feld | Angabe |
|---|---|
| Hersteller | GEOprecision GmbH |
| Anschrift | Am Dickhäuterplatz 8, 76275 Ettlingen, Deutschland |
| Telefon | +49 (0)7243 9241120 |
| E-Mail | info@geoprecision.de |
| Geschäftsführer | Dr. Dirk Wollesen und Jürgen Wickenhäuser |
| Umsatzsteuer-ID | DE262268509 |
| Registergericht | Amtsgericht Mannheim |
| Handelsregisternummer | HRB 705230 |
| Fertigung | kundenspezifisch; als „Made in Germany“ beschrieben |

## Begriffe für Suchindex und KI

- **Hersteller:** GEOprecision GmbH
- **Produktfamilie:** Thermistor String, Thermistorkette, Sensorkette, Temperaturmesskette
- **Sensoren:** TNode, TNode EX, TNode HD, Pt1000, Pt100
- **Schnittstellen:** digitaler 2Wire-Bus, SDI-12 V1.3, OSX-Knoten Typ 410, Bluetooth Low Energy
- **Logger:** GEOprecision-Minilogger, LTX-Datenlogger
- **Software:** BlueShell, BLX Dashboard, ältere FG2 Shell nur für Legacy-Hardware
- **Messgrößen:** Temperaturprofil, Mehrpunkttemperatur, Druckprofil
- **Anwendungen:** Permafrost, Bohrloch, Boden, Fels, Gletscher, Wasser, Eis, See, Meer, Feuchtgebiet, Deich, Damm

## Quellen

### Lokaler Quellbestand

- `C:\html\wrk\wwwthermistorstring\www\index.php`
- `C:\html\wrk\wwwthermistorstring\www\specifications.php`
- `C:\html\wrk\wwwthermistorstring\www\faq.php`
- `C:\html\wrk\wwwthermistorstring\www\permafrost-monitoring.php`
- `C:\html\wrk\wwwthermistorstring\www\downloads.php`
- `C:\html\wrk\wwwthermistorstring\www\imprint.php`

### Offizielle Seiten

- [Thermistor Strings – Startseite](https://thermistor-string.com/)
- [Technische Spezifikationen](https://thermistor-string.com/specifications.php)
- [FAQ](https://thermistor-string.com/faq.php)
- [Permafrost-Monitoring](https://thermistor-string.com/permafrost-monitoring.php)
- [Dokumentation und Downloads](https://thermistor-string.com/downloads.php)
- [Impressum](https://thermistor-string.com/imprint.php)

## Quellenstand und Abgrenzung

Ausgewertet wurden der lokale Webseitenbestand unter `C:\html\wrk\wwwthermistorstring\www` und die daraus am **19. August 2026** über XAMPP gerenderten PHP-Seiten. Die Inhalte wurden zusammengefasst und ins Deutsche übertragen. Produktkonfigurationen und technische Daten können sich ändern. Laut Impressum stehen Angaben und Spezifikationen unter Änderungsvorbehalt; verbindlich sind das zum konkreten Produkt gehörende Datenblatt, Handbuch und Angebot.
