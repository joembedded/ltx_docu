---
title: Aquatos Radar
subtitle: Radar-Distanzsensor Typ 470 / 0470
document-type: Ausführliches Produktdatenblatt
product-code: AQUATOS RADAR · TYP 0470
lead: Wasserstände und Abstände berührungslos messen. Energieeffizienter 60-GHz-Radarsensor mit bis zu drei Echos, SDI-12 und Bluetooth. Optional mit LTX-Datenloggern der Typen 15xx und 17xx kombinierbar.
cover-image: editiert/img/0470_radar_terratransfer_montage.jpg
date: September 2026
version: "1.0"
lang: de-DE
---

# Produktprofil

Der **Aquatos Radar Typ 0470** von **TerraTransfer** ist ein Distanzsensor auf Basis der Open-SDI12-Blue-Plattform (OSX). Er erfasst Entfernungen zu Wasseroberflächen und anderen geeigneten Reflexionsflächen bis **12 m**, optional bis **20 m**. Die Parametrierung und Diagnose erfolgen vor Ort mit dem **BLX Dashboard über Bluetooth**. Die **SDI-12-Schnittstelle V1.3** verbindet den Sensor mit einem Datenlogger.

![Illustratives Montagebeispiel aus dem TerraTransfer-Datenblatt: Radarsensor unter einer Brücke, senkrecht zur Wasseroberfläche ausgerichtet.](../../img/0470_radar_terratransfer_montage.jpg){width=145mm}

| Messung | Ausstattung |
|---|---|
| Typische Genauigkeit **≤ 2 mm**, Auflösung **1 mm** | **Bis zu 3 Echos**, jeweils Distanz und Signalstärke |
| Anwendungsbereich **0,10 bis 12 m**, optional bis 20 m | Standard-Radaroptik mit **ca. 10°** Öffnungswinkel |
| Berührungsloses 60-GHz-PCR-Messprinzip | **SDI-12 V1.3** und **Bluetooth Low Energy** |

**Anwendungen:** Pegelmessstellen an Bächen, Flüssen und Kanälen; Rückhaltebecken und Behälter; Messstellen unter Brücken oder in Schächten. Geeignete nichtleitende Behälterwände können durchmessen werden. Mehrere Echos unterstützen die Beurteilung zusätzlicher Reflexionen durch Einbauten oder treibendes Eis.

<!-- pagebreak -->

# Technische Daten

Die folgenden Angaben gelten für den **Radarsensor Typ 0470**. Eigenschaften eines optional angeschlossenen LTX-Datenloggers werden im Abschnitt „Systembetrieb mit Aquatos Web LTX“ beschrieben.

| Parameter | Radarsensor Typ 0470 |
|---|---|
| Messprinzip | 60-GHz-Radar, Pulsed Coherent Radar (PCR) |
| Anwendungsbereich laut Originalquelle | 0,10 bis 12 m; optional bis 20 m |
| Technische Nahgrenze | Unter 0,05 m keine Erfassung; Ausgabe „ToClose“ |
| Nahbereichseinstellung | Unter 0,15 m LeakCancellation aktivieren |
| Typische Genauigkeit / Auflösung | ≤ 2 mm / 1 mm |
| Messbereich ab Werk | 0,25 bis 3,00 m; Start und Ende parametrierbar |
| Radaroptik | Standard ca. 10° Öffnungswinkel; angepasste Optiken auf Anfrage |
| Echoauswertung | Bis zu 3 Distanzen, jeweils mit Signalstärke in dB |
| Sortierung | Nach Abstand oder Signalstärke einstellbar |
| Ausgabe | Distanz in m; Signalstärke in dB; optional Versorgungsspannung |
| Schnittstellen | SDI-12 V1.3; Bluetooth Low Energy; SDI-12-Kommandos über BLE |
| Versorgung | 3,6 bis 16 V DC; kein Verpolschutz |
| Strom während der Messung | Kurzzeitig bis zu 100 mA |
| Ruhestrom / BLE verbunden | < 30 µA bei 4 V im Deep Sleep / < 60 µA bei 4 V im Connected Mode |
| Startbereitschaft | Ca. 250 ms nach Einschalten; dies ist nicht die Dauer einer Radarmessung |
| Betriebstemperatur | -40 °C bis +85 °C |
| Elektronik / Schutzart | **IP67, nicht vergossen**; angebotene TerraTransfer-Ausführung |
| Konformität / Frequenzband | CE-konform; RoHS gemäß Originalquelle; 60-GHz-Band global sehr verbreitet |

![Produktabbildung aus dem TerraTransfer-Datenblatt: Gehäuse mit Radaroptik und Befestigungslaschen.](../../img/0470_radar_terratransfer_produkt.jpg){height=48mm}

Die **0,05-m-Nahgrenze** bezeichnet die technische Erfassungsgrenze. Sie ersetzt nicht den in der Originalquelle genannten Anwendungsbereich ab **0,10 m**. Für die Einrichtung empfiehlt sich zunächst das Standardfenster ab **0,25 m**. Die konkrete Messzeit hängt unter anderem von Messbereich und Parametrierung ab.

<!-- pagebreak -->

# Mehrere Echos verstehen und nutzen

Ein Radarsignal wird an unterschiedlichen Materialgrenzen teilweise reflektiert. Ein weiterer Anteil kann geeignete Materialien durchdringen und an einer dahinterliegenden Fläche reflektiert werden. Dadurch entstehen Echos mit verschiedenen Laufzeiten und Signalstärken. Der Typ 0470 kann **bis zu drei Distanzen gleichzeitig** ausgeben.

![Schematische Erklärgrafik: drei Reflexionsflächen im Kunststofftank und unter einer Brücke mit vorbeitreibendem Eisblock. Farben und Nummern verbinden die Flächen mit den jeweiligen Signalspitzen.](../../img/0470_radar_drei_echos_de.png){width=170mm}

## Im Kunststofftank

Die **Behälterwand**, ein zusätzlicher **Kunststoffeinbau** und die **Wasseroberfläche** erzeugen im gezeichneten Beispiel je ein Echo. Ein Teil des Signals durchdringt den Kunststoff und erreicht das Wasser. Der zusätzliche Einbau dient der Erklärung eines dritten Echos; die Tankmessung in der Originaldokumentation zeigt zwei Echos: eine schwache Reflexion an der PE-Behälterwand und die Hauptreflexion am Wasser.

## Unter der Brücke bei Eisgang

Ein **Bauteil im Messfeld**, die **Eisoberseite** und die **freie Wasserfläche neben dem Eisblock** liefern im Beispiel drei Reflexionen. Das Wasserecho wird hier neben dem Eis erfasst. Eine Messung durch Eis ist in dieser Darstellung keine Voraussetzung. Die Reflexionen werden anhand ihrer Distanz und Signalstärke beurteilt; die Messung allein ordnet ihnen keine Materialnamen zu.

## Nutzen für die Auswertung

Messbereich, Empfindlichkeit und Sortierung helfen, das gewünschte Echo auszuwählen. Ein starkes oder nahes Echo muss nicht von der Wasseroberfläche stammen. Die Echo-Nummern in der Grafik sind **keine festen Kanalzuordnungen**. Erkennbarkeit und Trennung hängen von Material, Abstand der Flächen, Geometrie und Einstellung ab. Die Kurven sind schematisch und keine Messdaten.

<!-- pagebreak -->

# Radaroptik, Einbau und Anschluss

## Messprinzip und Materialdurchdringung

Die PCR-Technologie ermöglicht eine sehr energieeffiziente Abstandsmessung. Metalle reflektieren nahezu vollständig, Wasser sehr stark; auch feuchte Erde oder Vegetation können klare Signale liefern. Geeigneter **Kunststoff, Keramik, Glas oder dünnes, trockenes Holz** dämpfen das Signal vergleichsweise wenig und können durchmessen werden. Zusammensetzung, Dicke und Feuchte beeinflussen die tatsächliche Durchlässigkeit.

Auch Wassereis ohne flüssigen Wasserfilm kann teilweise durchlässig sein. Bei Messungen durch Eis sind die veränderte Laufzeit und zusätzliche Grenzflächen zu berücksichtigen. Eine generelle Zusage für korrekte Pegelmessung durch beliebiges Eis lässt sich daraus nicht ableiten.

Die Wellenlänge beträgt etwa **5 mm**. Der interne Radarstrahler erzeugt ohne fokussierende Optik eine breite Keule von etwa **60° bis 90°**. Die Standardoptik bündelt diese auf **ca. 10°**. Ihre Austrittsfläche kann je nach Ausführung plan oder als Kalotte gestaltet sein. Kunststofflinsen können zusätzlich in Nebenrichtungen abstrahlen; in engen Einbausituationen ist dies bei der Ausrichtung zu beachten. Angepasste Optiken sind auf Anfrage möglich.

## Montage

Den Sensor senkrecht über der gewünschten Reflexionsfläche an einer Brücke, Wandhalterung oder einem Ausleger befestigen. Befestigung und Kabelführung so auslegen, dass sich die Ausrichtung nicht verändert. Wände, Einbauten und weitere Objekte im Messfeld beim Raw Scan prüfen. Die Bündelung reduziert deren Einfluss, schließt Störreflexionen aber nicht grundsätzlich aus.

Bei einer Messung durch eine geeignete Behälterwand kann die Radaroptik häufig direkt an der Wand montiert werden. Laut Originalquelle ist dies für die Signalqualität meist vorteilhaft. Der Abstand zur Behälterwand in den Beispielen dient vor allem dazu, deren zusätzliches Echo zu zeigen.

Die hier angebotene Elektronik hat **Schutzart IP67 und ist nicht vergossen**. Einbau, Kabeldurchführung und Gehäuse müssen diese Ausführung berücksichtigen. Eine dauerhafte Unterwassermontage ist für die berührungslose Pegelmessung nicht vorgesehen.

## Elektrischer Anschluss

| Aderfarbe laut Originalquelle | Funktion |
|---|---|
| Schwarz | GND / Masse |
| Braun | Versorgung 3,6 bis 16 V DC |
| Weiß oder Blau | SDI-12-Datensignal |

**Nicht verpolungssicher:** Vor dem Anschluss Polarität und gerätespezifische Kabelbelegung prüfen. Die Quelle nennt für Typ 0470 mindestens **3,6 V**, auch wenn andere OSX-Plattformvarianten niedrigere Spannungen erlauben. Die Versorgung muss die kurzzeitigen **100 mA** während einer Messung liefern können.

<!-- pagebreak -->

# Inbetriebnahme mit BLX Dashboard

Der Sensor kann über **SDI-12**, **Bluetooth BLE** oder **SDI-12-Kommandos über Bluetooth** bedient werden. Das browserbasierte BLX Dashboard bietet die grafischen Werkzeuge **Raw Scan** und **Live-Plot**. In der Originalquelle werden Chrome, Edge und Opera am PC sowie Android genannt. Alternativ steht BlueShell für Windows zur Verfügung.

## Verbindung und erster Messwert

1. Versorgung und Anschluss prüfen, Sensor einschalten und die Startbereitschaft abwarten.
2. [BLX Dashboard öffnen](https://joembedded.github.io/ltx_ble_demo/ble_api/index.html), Bluetooth-Verbindung zum Sensor herstellen und dessen Identität prüfen.
3. Die geräteeigene **6- bis 16-stellige PIN** einmalig eingeben oder den beiliegenden QR-Code scannen. Die Authentifizierung erfolgt laut Originalquelle per Challenge-Response; die PIN wird dabei nicht im Klartext übertragen.
4. Mit `k` die aktuellen Koeffizienten anzeigen. Ein geeignetes Messfenster wählen, zum Einstieg beispielsweise 0,25 bis 3 m.
5. Eine Messung starten und Distanz sowie Signalstärke prüfen. Im Live-Plot die erkannten Echos beobachten.
6. Den Raw Scan zur Ausrichtung verwenden; danach die regulären Messwerte kontrollieren und geänderte Koeffizienten mit `z?XWrite!` dauerhaft speichern.

![Raw Scan aus der Originaldokumentation: schwache Reflexion an der Behälterwand und ausgeprägte Hauptreflexion an der Wasseroberfläche.](../../img/0470_radar_rawscan_original.png){width=102mm}

## Raw Scan und Live-Plot

Der **Raw Scan** zeigt schnell ein Rohsignal und unterstützt die grobe Ausrichtung. Die reguläre präzise Messung verarbeitet mehr Daten. Die Originalquelle nennt Rohamplituden ab etwa **500** und reguläre Signalstärken typisch **über 1 dB** als Orientierung für gute Signale. Dies sind keine universellen Grenzwerte; Raw-Scan-Amplituden sind nicht mit dB-Werten gleichzusetzen.

Die Skalierung erfolgt normalerweise automatisch. `.shell raw470scale CNT` setzt einen Festwert; `.shell raw470scale` ohne Argument zeigt die aktuelle Einstellung. Der **Live-Plot** stellt die aktuellen Distanzwerte dar und eignet sich zur Beobachtung der Reflexionen bei verändertem Wasserstand oder bewegten Objekten.

<!-- pagebreak -->

# SDI-12-Befehle und Messwertausgabe

`a` steht für die Sensoradresse, `n` für die neue Adresse beziehungsweise den Datenblock. In den Einzelsensor-Beispielen der Originalquelle wird `?` als Platzhalter verwendet. Bei mehreren Geräten am Bus die konkrete Adresse verwenden.

| Befehl | Funktion |
|---|---|
| `aAn!` | SDI-12-Adresse von `a` auf `n` ändern |
| `aI!` | Identifikation; Schema: `a13JE_Radar_0470_OSXxxxxxxxx` |
| `aM!` / `aMC!` | Messung eines Echos ohne / mit CRC; 2 Ergebniswerte: Distanz und Signalstärke |
| `aM1!` / `aMC1!` | Messung von bis zu 3 Echos plus Versorgungsspannung; 7 Ergebniswerte; Schreibweise gemäß Originalquelle |
| `aD0!` ... `aD9!` | Gespeicherte Ergebnisse der vorangegangenen Messung blockweise abholen |
| `aXK0!` | Koeffizient abfragen; Ziffer entsprechend K0 bis K11 wählen |
| `aXK1=-0.123!` | Koeffizient setzen; Beispiel K1 |
| `aXDevice!` | Geräteinformationen abfragen |
| `aXWrite!` | Geänderte Koeffizienten dauerhaft speichern |
| `aXFactoryReset!` | Werkseinstellungen wiederherstellen |

## Ergebnisstruktur und Sortierung

Die erkannten Echos werden jeweils als **Distanz in m und Signalstärke in dB** ausgegeben. Bei der erweiterten Messung ergeben sich drei Paare sowie die Versorgungsspannung: **Distanz 1, Stärke 1, Distanz 2, Stärke 2, Distanz 3, Stärke 3, Versorgungsspannung**. Die Ergebnisse liegen zunächst im Cache; der Logger liest sie mit den benötigten `D`-Befehlen aus.

Die Reihenfolge hängt von **K8** ab: `0` sortiert nach Abstand, `1` nach Signalstärke. Die Position eines Echos in der Ausgabe kann sich ändern, wenn sich Distanzen oder Signalstärken ändern. Zur Beurteilung deshalb stets das Wertepaar verwenden.

| Zustand / Code | Bedeutung |
|---|---|
| Distanz `0 m`, Signalstärke `-99 dB` | Kein Echo erkannt |
| Distanz `0 m`, Signalstärke `-98 dB` | „ToClose“: Reflexion zu nahe am Sensor |
| Fehlercode `-100` bis `-999` | Fehler im Koeffizienten-Setup |
| Fehlercode `-1000` | Interner Sensorfehler / keine Antwort; Sensor oder interne Verbindung prüfen |
| Andere Fehler | Textanzeige im BLX Dashboard beziehungsweise in BlueShell beachten |

**Nullwerte mit Fehlerkennung sind keine gültigen Pegelwerte.** Die Signalstärke und die Diagnose müssen bei der Übernahme in den Logger berücksichtigt werden.

## Linearisierung und Bezugspunkt

Die Originalquelle beschreibt die Linearisierung gültiger Messwerte mit **WERT = (GEMESSEN × K0) - K1**. Werkseinstellungen sind **K0 = 1,0** und **K1 = 0,0**. Der Werksbezug ist so beschrieben, dass die obere rechteckige Gehäusekante **0,01 m** entspricht; maßgeblich ist nicht die runde Optikoberfläche. Den Bezugspunkt beim Einmessen dokumentieren. Für eine Pegelausgabe muss der Abstand auf den gewünschten Pegelnullpunkt umgerechnet werden.

<!-- pagebreak -->

# Koeffizienten und Messparameter

Mit dem BLE-Kommando **`k`** lassen sich die aktuellen Koeffizienten und, soweit verfügbar, der Speicherbedarf des Setups anzeigen. Änderungen erfolgen über die **SDI-12-`XK`-Befehle**, direkt am Bus oder mit vorangestelltem `z` über Bluetooth.

| Parameter | Bedeutung und Einstellungen |
|---|---|
| **K0** · Raw.Multi | Multiplikator der Linearisierung; Werkseinstellung **1,0** |
| **K1** · Raw.Offset | Subtrahierter Offset; Werkseinstellung **0,0** |
| **K2** · LiveSpeed | Automatische Messungen im Live-Plot; **0 = aus**. Beispiel **16400 = 1 s**, **1640 = 0,1 s** |
| **K3** · Start | Anfang des Messfensters in m; Standard **0,25** |
| **K4** · End | Ende des Messfensters in m; Standard **3,00**; optional bis **20 m** |
| **K5** · MaxStepLength | Schrittweite; **0 = automatisch**. Standard **2**, für Enddistanzen bis etwa 8 m; für 8 bis 12 m nennt die Quelle **3** |
| **K6** · ConfigProfile | Messprofil; **0 = automatisch**, Profile **1 bis 5**. Standard **3**; normalerweise beibehalten |
| **K7** · ReflectorShape | **0 = generic**, Standard für die meisten Anwendungen; **1 = planar**, etwa für ebene Wasserflächen |
| **K8** · PeakSorting | **0 = nach Abstand**, **1 = nach Signalstärke**. In der `k`-Beispielausgabe der Quelle: **1** |
| **K9** · Threshold Sensitivity | Empfindlichkeit der Erkennung, Bereich **0 bis 1**; Standard **0,5** |
| **K10** · SignalQuality | Signalqualität, Bereich **-10 bis 35 dB**; Standard **20 dB** laut `k`-Beispiel |
| **K11** · LeakCancellation | **0 = aus**, Standard; **1 = ein**, für Startdistanzen unter etwa **0,15 m** aktivieren |

## Messfenster und Messdauer

Das Messfenster ist der wichtigste Einstellbereich. Die Enddistanz nur so weit wählen, wie es der erwartete Abstand einschließlich der notwendigen Reserve erfordert. Ein größerer Bereich erhöht Messdauer und Energiebedarf und kann zusätzliche Reflexionen in die Auswertung aufnehmen. Die optionale Reichweite bis 20 m ist anwendungsspezifisch zu prüfen.

## Automatische Messungen

Für K2 nennt die Quelle Werte ab **1640**. Die automatische Folge startet einige Sekunden nach einer Messung über Bluetooth. Der Sensor passt die Zeit so an, dass die Messpause mindestens das **Vierfache der Messzeit**, bei Versorgung über **7,5 V** mindestens das **Achtfache**, beträgt. Die genannten 0,1 s beziehungsweise 1 s sind daher Einstellungen und keine garantierten Messraten für jedes Setup.

## Empfindlichkeit und Reflexionsfläche

K7 kann die Auswertung an ebene Flächen anpassen. K9 und K10 beeinflussen die Erkennung; Änderungen mit Raw Scan und regulären Messwerten kontrollieren. LeakCancellation verbessert die Nutzbarkeit des Nahbereichs, verlängert jedoch die Messung.

**Werkseinstellung prüfen:** Die Originalquelle bezeichnet bei K8 sowohl Abstands- als auch Stärkesortierung als Standard. Maßgeblich für das konkrete Gerät ist die Ausgabe von `k`. Die Einstellwerte `0` und `1` sind eindeutig beschrieben.

<!-- pagebreak -->

# Kommandobeispiele und schnelles Setup

## SDI-12 über Bluetooth

Ein vorangestelltes **`z`** leitet SDI-12-Kommandos über die BLE-Verbindung weiter. Die folgende gekürzte Beispielsitzung entspricht dem Ablauf der Originalquelle; Gerätekennung und Messwerte sind Beispiele.

```text
z?I!
013JE_Radar_0470_OSXCFCCBEB6

z?M!
00032
0

z?D0!
0+2.351+8.21
```

Der letzte Datensatz enthält für Adresse `0` die Distanz **2,351 m** und die Signalstärke **8,21 dB**. Zwischen Messstart und Datenabfrage die gemeldete Messbereitschaft beziehungsweise Wartezeit berücksichtigen.

## Koeffizienten ändern und speichern

```text
k
z?XK3!
z?XK4!
z?XK3=0.25!
z?XK4=3.00!
z?XWrite!
```

Die ersten Abfragen dokumentieren das bisherige Fenster. Das Beispiel setzt anschließend **0,25 bis 3,00 m**. Erst **`XWrite`** speichert die Änderungen dauerhaft. Ein Factory Reset stellt Werkseinstellungen wieder her und erfordert danach eine erneute Kontrolle des Messstellen-Setups.

## Vordefinierte Setups mit `.crun`

Die Originalquelle stellt folgende Kommandodateien bereit. Sie können per Terminalkommando oder über den zugehörigen Setup-QR-Code aufgerufen werden.

| Messfenster | Kommando im BLX Dashboard |
|---|---|
| 0,25 bis 3 m | `.crun crun/0470_radar_0m25_3m00.crun` |
| 0,25 bis 8 m | `.crun crun/0470_radar_0m25_8m00.crun` |
| 0,25 bis 12 m | `.crun crun/0470_radar_0m25_12m00.crun` |

Das 3-m-Setup entspricht dem Standard nach Factory Reset. Größere Enddistanzen verlängern die Messung. Nach dem Aufruf die Werte mit `k` und einer Messung prüfen; Bezugspunkt und Linearisierung gegebenenfalls an die Messstelle anpassen.

<!-- pagebreak -->

# Software, Energie und Diagnose

## Weitere BLE-Kommandos

| Kommando | Funktion |
|---|---|
| `bNEW_NAME` | Bluetooth-Advertising-Namen setzen; 3 bis 11 Zeichen |
| `.a` oder `.audio` | Audio-Einstellungen anzeigen |
| `.audio 1 1` | Audio / Finder-Funktion einschalten, wie im Quellenbeispiel |
| `.firmware` | Firmware-Datei `*.sec` lokal auswählen und über BLE übertragen |
| `.shell raw470scale CNT` | Raw-Scan-Skala auf einen festen Wert setzen |
| `.shell raw470scale` | Aktuelle Raw-Scan-Skalierung abfragen |

Für ein Firmware-Update die zum **Typ 0470** passende Datei aus dem [Open-SDI12-Blue-Archiv](https://joembedded.de/x3/ltx_firmware/index.php?dir=./Open-SDI12-Blue-Sensors/0470_RadarDistA) verwenden. Nach dem Update Identifikation, Koeffizienten und Messverhalten kontrollieren.

**BlueShell** ist ein alternatives Windows-Werkzeug für den Sensorzugriff. **SDI12Term** ermöglicht den Zugriff auf den SDI-12-Bus über einen passenden RS232-Adapter. Das BLX Dashboard selbst arbeitet im Browser; eine klassische Programminstallation ist dafür nicht erforderlich.

## Energiebedarf

Die Originalquelle nennt im Deep Sleep einen mittleren Strom **unter 30 µA bei 4 V**. Der Radarteil benötigt gegenüber dem OSX-Grundmodul etwa **10 µA zusätzlich** für den Erhalt des Radar-RAMs. Bei aktiver BLE-Verbindung werden im Mittel **unter 60 µA bei 4 V** angegeben. Während der Messung können kurzzeitig **bis zu 100 mA** auftreten.

Diese Werte beschreiben unterschiedliche Betriebszustände. Eine Laufzeitberechnung muss zusätzlich die Dauer und Häufigkeit der Messungen sowie den angeschlossenen Logger berücksichtigen. Die Startbereitschaft nach etwa **250 ms** darf nicht als feste Dauer einer vollständigen Messung angesetzt werden. Größere Messfenster und aufwendigere Einstellungen erhöhen den Messaufwand.

## Diagnose an der Messstelle

| Beobachtung | Prüfung / Maßnahme |
|---|---|
| Kein gültiges Echo | Versorgung, Ausrichtung, Start-/Enddistanz und Signalstärke prüfen; Raw Scan verwenden |
| „ToClose“ | Abstand zur nächsten Reflexionsfläche prüfen; unter 0,05 m keine Messung möglich |
| Schwaches Echo | Messfenster und Ausrichtung optimieren; K7, K9 und K10 passend einstellen |
| Echo wechselt seine Ausgabeposition | K8 und die Distanz-/Stärke-Paare vergleichen; mögliche zusätzliche Reflexionsfläche prüfen |
| Einstellungen nach Neustart verloren | Änderungen erneut setzen und mit `XWrite` speichern |
| Interner Fehler `-1000` | Versorgung sowie Sensor und interne Verbindung prüfen |

## Weitere Anwendungen mit angepasster Firmware

Die Originalquelle beschreibt Schwingungsmessungen an entfernten Objekten, etwa Personen, Bauwerken oder Maschinen, von ungefähr **0,2 Hz bis 2 kHz**. Auch Personen- und Geschwindigkeitsdetektion sind genannt. Diese Funktionen setzen **dafür angepasste Firmware** voraus und gehören nicht automatisch zum beschriebenen Distanzmessbetrieb.

<!-- pagebreak -->

# Systembetrieb mit Aquatos Web LTX

Der Sensor Typ 0470 lässt sich über SDI-12 mit **LTX-Datenloggern der Typen 15xx und 17xx** kombinieren. TerraTransfer bezeichnet diese Logger im Produktzusammenhang allgemein als **Aquatos Web LTX**. Der Radarsensor liefert die Messwerte; der Logger übernimmt deren zeitgesteuerte Erfassung, Speicherung und, je nach Ausführung, Übertragung.

| Bestandteil | Aufgabe im Messsystem |
|---|---|
| Radar Typ 0470 | Distanz und Signalstärke erfassen; lokale Parametrierung über BLE |
| LTX-Logger 15xx / 17xx | Sensor über SDI-12 abfragen; Kanäle zuordnen; Daten speichern und bei Funkausstattung übertragen |
| Sensormanager | Messdaten empfangen, darstellen und auswerten; Fernzugriff abhängig von Logger, Firmware und Anbindung |

Die Funktechnik richtet sich nach dem konkreten Logger. Die LTX-Typenübersicht nennt beispielsweise **LTE-M/NB-IoT für Typ 1500 und 1710**, **LTE Cat1 für Typ 1700** und **LoRaWAN EU868 für Typ 1720**. Deshalb sind LTE-M, NB-IoT oder eine bestimmte Batterieausstattung keine allgemeinen Merkmale des Radarsensors oder aller Aquatos-Web-LTX-Kombinationen.

## Messkanäle und Pegelbezug

Für ein Echo sind **zwei Ergebniswerte**, für die erweiterte Abfrage **sieben Ergebniswerte** zu berücksichtigen. Den Logger so konfigurieren, dass er den Messbefehl auslöst und anschließend die zugehörigen Datenblöcke ausliest. Bei mehreren Sensoren eindeutige SDI-12-Adressen vergeben. Distanz, Signalstärke und Fehlerkennungen müssen zusammen ausgewertet werden.

Für einen Wasserstand wird die gemessene Distanz auf den eingemessenen Bezugspunkt umgerechnet. Die Umrechnung im Sensor oder Logger konsistent festlegen; eine bereits erfolgte Linearisierung nicht nochmals anwenden. Mess- und Übertragungsintervall sowie die verfügbare Versorgung bestimmen den Energiebedarf des Gesamtsystems. Eine pauschale mehrjährige Laufzeit lässt sich ohne diese Angaben nicht festlegen.

## Konformität und Anbieter

Das Gerät ist **CE-konform**. Die Originalquelle nennt die Funkanlagenrichtlinie **2014/53/EU (RED)** und **RoHS 2011/65/EU einschließlich (EU) 2015/863**. Das **60-GHz-Band ist global sehr verbreitet**. Diese Beschreibung ist keine pauschale Aussage über die Zulässigkeit jeder Installation in jedem Land.

**Anbieter dieser Version: TerraTransfer GmbH** · Ottostr. 19a · 44867 Bochum · Deutschland. Telefon: +49 (0) 2327 83 44 85-1 · [info@terratransfer.de](mailto:info@terratransfer.de) · [terratransfer.de](https://terratransfer.de).

## Weiterführende Dokumentation

- [LTX-Typen und Hardware](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/logger_Zusammenfassung.md) und [LTX-Parameterreferenz](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_parameter/ltx_parameter_referenz.md).
- [BLX-Dashboard-Kommandos](https://github.com/joembedded/ltx_docu/blob/master/editiert/blx_dashboard/blx_commands.md), [BlueShell](https://joembedded.de/x3/blueshell/) und [SDI12Term](https://github.com/joembedded/SDI12Term).
- [Open-SDI12-Blue-Plattform](https://github.com/joembedded/Open-SDI12-Blue) und [Originaldatenblatt im Firmware-Archiv](https://joembedded.de/x3/ltx_firmware/Open-SDI12-Blue-Sensors/0470_RadarDistA/osx_radar_a121_de.pdf).

*Redaktionsstand September 2026. Technische Grundlage: deutsche ODT-Originaldokumentation vom 15.09.2025, ergänzt um die Angaben zur angebotenen TerraTransfer-Ausführung: Elektronik IP67, nicht vergossen. Illustratives Montage- und Produktbild aus der TerraTransfer-Produktunterlage; Echo-Grafik schematisch. Änderungen vorbehalten.*
