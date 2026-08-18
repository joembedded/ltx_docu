---
title: LTX Typ 18xx_eco
subtitle: Kundenspezifische SDI-12-Loggerplattform mit flexibler Funk- und Energieoption
document-type: Produktbeschreibung
product-code: LTX 18xx_eco
lead: Kundenspezifische Loggerplattform auf Basis des LTX Typ 1820 mit mehreren SDI-12-Anschlüssen, externer 4-14-V-Zusatzversorgung und wählbarer Datenübertragung.
cover-image: editiert/img/pcb-lora-eco.png
date: Juli 2026
version: "1.2"
---

\noindent{\headingfont\fontsize{22}{25}\selectfont\color{GPInk}Produktprofil}\par
\vspace{4mm}

Der **LTX Typ 18xx_eco** ist eine kundenspezifische, modulare Datenloggerplattform für SDI-12-Messstellen. Die Elektronik basiert weitgehend auf dem LTX Typ 1820 und ergänzt dessen Funktionsumfang um mehrere SDI-12-Anschlüsse, eine externe Status-LED sowie eine ausdrücklich für externe Quellen ausgelegte Zusatzversorgung von **4 bis 14 V**. Damit eignet sich die Plattform besonders für autarke Messstellen mit Solarversorgung, mehreren Sensorsträngen oder projektspezifischer Anschluss- und Gehäusetechnik.

Die abgebildete Leiterplatte ist mit einem LoRaWAN-EU868-Modem bestückt. Abhängig von Funknetz, Datenmenge, Energieversorgung und Installationsort ist der LTX Typ 18xx_eco auch mit LTE Cat 1, LTE-M/NB-IoT oder ohne Modem erhältlich. Gehäuse, Anschlüsse, Bestückung und Kommunikationsvariante werden für das jeweilige Projekt abgestimmt.

![LTX Typ 18xx_eco als kundenspezifische Leiterplatte mit LoRaWAN-Modem](editiert/img/pcb-lora-eco.png){width=125mm}

*Kundenspezifische LTX-18xx_eco-Leiterplatte mit LoRaWAN-EU868-Modem, externer Antenne, Batteriehalter und zusätzlichen Anschlussmöglichkeiten. Gehäuse und Anschlussbelegung sind projektspezifisch.*

# Plattform mit projektspezifischen Anschlüssen

Der LTX Typ 18xx_eco verbindet eine bewährte Loggerbasis mit einer für die jeweilige Messstelle anpassbaren Anschlussseite. Mehrere SDI-12-Ausgänge erleichtern die strukturierte Verdrahtung von Sensorgruppen, Verteilerpunkten oder getrennten Kabelwegen. Die konkrete Anzahl der Anschlüsse, die Pinbelegung und die mechanische Ausführung werden vor der Lieferung festgelegt.

Die zusätzliche externe Versorgung ist für Anwendungen mit Energie aus Solarsystemen, Akkus oder anderen Gleichspannungsquellen ausgelegt. Sie ergänzt die interne Batterieoption und erlaubt ein auf die Anwendung abgestimmtes Energie- und Backup-Konzept. Eine externe LED kann den Betriebszustand auch dann sichtbar machen, wenn die Leiterplatte in einem kundenspezifischen Gehäuse eingebaut ist.

| Bereich | Ausführung beim LTX Typ 18xx_eco |
|---|---|
| Loggerbasis | weitgehend identisch mit LTX Typ 1820 |
| SDI-12 | SDI-12 Version 1.3, auch für Low-Voltage-Sensoren |
| Sensoranschlüsse | mehrere projektspezifisch ausgeführte SDI-12-Ausgänge |
| Externe Versorgung | separate Zusatzversorgung von 4 bis 14 V, geeignet für externe Akku- und Solarsysteme |
| Betriebsanzeige | externe Status-LED |
| Gehäuse | kundenspezifisch, daher abhängig von Projekt und Einbausituation |
| Datenübertragung | LoRaWAN EU868, LTE Cat 1, LTE-M/NB-IoT oder ohne Modem, abhängig von der Bestückung |

# Vorteile auf einen Blick

- Kundenspezifische Plattform auf Basis des bewährten LTX-1820-Loggerkonzepts
- Mehrere SDI-12-Ausgänge für übersichtliche Sensorverdrahtung und projektspezifische Anschlusskonzepte
- SDI-12 Version 1.3, auch für Low-Voltage-Sensoren geeignet
- Zusätzliche externe Versorgung von 4 bis 14 V, besonders geeignet für Solar- und Akkusysteme
- Interne Batterieversorgung kann je nach Ausführung als Energiequelle oder Backup dienen
- Externe LED für sichtbare Betriebs- und Diagnoseanzeige am kundenspezifischen Gehäuse
- LoRaWAN EU868, LTE Cat 1, LTE-M/NB-IoT oder lokale Datenerfassung ohne Modem auswählbar
- Bis zu 20 Messkanäle bei LoRaWAN und bis zu 90 Messkanäle bei LTE-Varianten
- Lokaler Messwertspeicher, BLE-Servicezugang und konfigurierbare Messzyklen
- Serversynchronisation des Logger-Speichers bei LTE-Varianten mit der kostenfreien Open-Source-Software LTX Server
- Projektbezogene Auswahl von Gehäuse, Antenne, Anschlüssen, Modem und Energieversorgung

# Technische Basisdaten

Die folgenden Angaben beschreiben die gemeinsame technische Basis. Die kundenspezifischen Eigenschaften des LTX Typ 18xx_eco, insbesondere Anschlüsse, Gehäuse, Antenne und Modem, werden in der Projektspezifikation festgelegt.

| Eigenschaft | Wert |
|---|---|
| Anwendung | Autonomer Datenlogger für SDI-12-Sensoren und kundenspezifische Messstellen |
| Sensorschnittstelle | SDI-12 Version 1.3, Low-Voltage-fähig |
| Messkanäle bei LoRaWAN | bis zu 20 Fließkomma-Messkanäle |
| Messkanäle bei LTE-Varianten | bis zu 90 Fließkomma-Messkanäle |
| Messintervall | 10 bis 86.400 Sekunden, konfigurierbar |
| Lokale Kommunikation | Bluetooth Low Energy ab BLE 4.2 |
| Lokaler Speicher | 8 MB Standard, bis zu 16 MB bestückbar |
| Speicherbetrieb | Ringspeicher oder linear |
| Speicherkapazität | typisch etwa 400.000 historische Messwerte bei 8 MB; abhängig von Kanalzahl und Datensatzgröße |
| Interne Versorgung | abhängig von der projektspezifischen Bestückung, beispielsweise 6 AA-Zellen oder 2 Lithium-D-Zellen |
| Externe Zusatzversorgung | 4 bis 14 V Gleichspannung |
| Sensorversorgung | abhängig von Anschluss- und Versorgungskonzept; geschaltete SDI-12-Versorgung bis ca. 1 A vorgesehen |
| Externe Anzeige | Status-LED, projektspezifisch am Gehäuse positionierbar |
| Gehäuse | kundenspezifisch; Abmessungen, Schutzart und Steckverbinder werden projektbezogen definiert |

# SDI-12 und Messaufgabe

Der LTX Typ 18xx_eco ist für SDI-12-Messstellen ausgelegt. Bei LoRaWAN stehen bis zu 20 Fließkomma-Messkanäle zur Verfügung; LTE-Varianten können bis zu 90 Fließkomma-Messkanäle verarbeiten. Messabläufe, Einheiten, Nachkommastellen und Speicherverhalten werden im Logger parametriert. Mehrere physische SDI-12-Anschlüsse ändern nicht das gemeinsame Messkanalmodell: Die konkreten Sensoradressen, Buszuordnungen und Kabelwege werden gemeinsam mit der Anschlussbelegung festgelegt.

Die SDI-12-Versorgung kann für den energieeffizienten Betrieb zwischen den Messungen abgeschaltet werden. Sensoren mit einer erforderlichen Einschalt- oder Vorlaufzeit werden in der Parametrierung berücksichtigt. Das ist besonders für batteriebetriebene oder solarversorgte Messstellen wichtig, weil Sensorlast und Vorlaufzeit den Energiebedarf oft stärker beeinflussen als der Logger selbst.

| Planungsaspekt | Bedeutung für das Projekt |
|---|---|
| Sensorzahl und Sensoradressen | bestimmen Anschlussbelegung, Buskonzept und Parametrierung |
| Leitungslängen und Verteilung | beeinflussen die Auswahl von Steckverbindern, Kabeln und Gehäuseeinführungen |
| Versorgung des Sensors | bestimmt Spannungsniveau, Einschaltzeit und Energiebedarf |
| Messintervall | beeinflusst Speicherbedarf, Energiebedarf und Datenaufkommen |
| Externe Energiequelle | bestimmt die Auslegung von Solarregler, Akku, Batterie-Backup und Ladebilanz |

# Energieversorgung für autarke Messstellen

Die externe Zusatzversorgung von 4 bis 14 V ist ausdrücklich für Anwendungen mit externer Energiequelle vorgesehen. Typische Beispiele sind Solar-Akku-Systeme, externe Akkupacks oder vorhandene Gleichspannungsversorgungen am Messort. Die Auslegung von Quelle, Kabel, Absicherung und optionaler interner Backup-Versorgung erfolgt projektspezifisch.

Die Plattform setzt die Eingangsspannung energieoptimiert auf die Betriebsspannung des jeweils eingesetzten LoRaWAN- oder LTE-Modems um. Ihr Ultra-Low-Power-Design benötigt im Schlafmodus bei aktivem Bluetooth Low Energy weniger als **20 µA**; eine BLE-Verbindung verursacht nur einen geringen zusätzlichen Energiebedarf. SDI-12-Sensoren werden ausschließlich für die Messung versorgt. Die durchgeschaltete Sensorversorgung entspricht der jeweils anliegenden Versorgungsspannung, benötigt dafür etwa 1 mA zuzüglich des Sensorstroms und kann Sensoren mit bis zu etwa 1 A versorgen. Bei weniger als 9 V müssen deshalb geeignete Low-Voltage-Sensoren eingesetzt werden.

Beim Senden liegen die kurzzeitigen Stromspitzen eines LoRaWAN-Modems bei etwa 20 bis 50 mA, bei LTE-Modems bei bis zu 800 mA. Ein LTE-Transfer kann bei guter Netzqualität in wenigen Sekunden erfolgen und dadurch auch mit kleinen Batterien einen mehrjährigen Betrieb ermöglichen. Die Netzqualität hat jedoch den größten Einfluss auf Dauer und Energiebedarf einer mobilen Übertragung; sie ist daher zusammen mit Sensorlast, Messintervall und Übertragungsstrategie zu planen.

Alle LTX-Logger verfügen über ein internes Energiemanagement. Es summiert den tatsächlich verbrauchten Energieanteil dynamisch in mAh und führt den daraus abgeleiteten prozentualen Kapazitätsverbrauch als Housekeeping-Wert mit. Zusammen mit der Batteriespannung in mV ermöglicht dies eine belastbare Wechselprognose auch bei wechselnden Betriebsbedingungen, sodass Batterien nicht rein vorsorglich zu früh getauscht werden müssen. Die Spannung eignet sich besonders für Systeme mit gut auswertbarem Spannungsverlauf, etwa Blei-Gel-, Alkali- oder LiPo-Akkus. Bei Lithium-Primärbatterien ist dagegen überwiegend die verbrauchte Kapazität aussagekräftig, weil deren Spannung über lange Zeit nur wenig abfällt.

Bei einer solarversorgten Anlage ist nicht allein der Tagesenergiebedarf entscheidend. Auch die Erzeugung in den lichtarmen Monaten, die Reserven des Akkus, Temperaturbereich, Sensorlast, Übertragungsintervall und Funkqualität müssen gemeinsam betrachtet werden. Die Loggerplattform kann Messwerte lokal speichern, falls die Datenübertragung vorübergehend nicht verfügbar ist; die Funkanbindung muss deshalb nicht als alleinige Datenhaltung ausgelegt werden.

Eine überschlägige Betrachtung für Messung und Sensorversorgung enthält das [TensioMark-Beispiel in der Logger-Hardwareübersicht](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/logger_Zusammenfassung.md#4-energiebetrachtung--beispiel-tensiomark-3-sensoren). Detaillierte Messwerte zum LoRaWAN-Energiebedarf bei verschiedenen Datenraten und Nutzlasten enthält der [Energie-Vergleich der LoRa-Module](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/energie_vergleich.md).

| Energiequelle | Typischer Einsatz | Zu beachten |
|---|---|---|
| Interne Batterien | kompakte, autarke Messstelle | Bestückung, Kapazität und Temperaturbereich projektspezifisch wählen |
| Externer Akku | höhere Sensorlast oder lange Reservezeit | Ladezustand, Ladeverfahren und Tiefentladeschutz berücksichtigen |
| Solar mit Akku | dauerhafte Außenmessstelle | Winterertrag, Verschattung, Akkureserve und Spitzenlast auslegen |
| Bestehende DC-Versorgung | Messstelle mit vorhandener Infrastruktur | Spannungsbereich von 4 bis 14 V und Anschlusskonzept prüfen |

# Kommunikationsvarianten

Die Leiterplatte kann passend zur Messaufgabe mit unterschiedlichen Kommunikationsmodulen bestückt werden. Die Auswahl sollte vor allem nach Netzverfügbarkeit, erwarteter Datenmenge, gewünschtem Übertragungsintervall, Energiequelle und Betriebsmodell erfolgen.

| Variante | Geeignet für | Eigenschaften |
|---|---|---|
| LoRaWAN EU868 | kleine, zyklische Sensordaten und energieoptimierte Messstellen | bis zu 20 Messkanäle; lokale LoRaWAN-Abdeckung oder eigenes Gateway erforderlich; kompakte Uplinks und bidirektionale Kommunikation |
| LTE Cat 1 | größere Datenmengen, gute Mobilfunkabdeckung und umfangreiche Online-Funktionen | bis zu 90 Messkanäle; Mobilfunkvertrag und passende Netzabdeckung erforderlich; geeignet für HTTP/HTTPS und Serversynchronisation |
| LTE-M/NB-IoT | M2M-Anwendungen mit verfügbarer Netztechnologie | bis zu 90 Messkanäle; Verfügbarkeit ist länder- und netzabhängig; Auswahl nach Datenmenge, Übertragungsweg und Synchronisationsbedarf |
| Ohne Modem | lokale Datensammlung oder spätere Erweiterung | Datenzugriff und Parametrierung lokal per BLE; Kommunikationsoption projektspezifisch nachrüstbar, sofern vorgesehen |

Die abgebildete Ausführung verwendet LoRaWAN EU868. Für LoRaWAN gelten LoRaWAN 1.0.4, Geräteklasse A, EU868 und eine maximale Sendeleistung von 14 dBm. Die vollständige Inbetriebnahme mit The Things Network, ChirpStack, Payload-Decoder und LTX Microcloud ist in der [LoRaWAN-Inbetriebnahmeanleitung](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_lorawan_howto/ltx_lorawan_howto.md) beschrieben.

Bei LTE-Varianten werden nicht nur aktuelle Messwerte übertragen. Der Logger kann seinen lokalen Speicherinhalt mit einem Server synchronisieren, sodass historische Messreihen auch nach zeitweisen Verbindungsunterbrechungen übertragen werden können. Für diesen Betrieb steht mit [LTX Server](https://github.com/joembedded/LTX_server) eine kostenfreie Open-Source-Cloudsoftware bereit. Die konkrete Serverinstallation, der Mobilfunktarif und die Übertragungsstrategie werden passend zu Datenmenge und Energieversorgung festgelegt.

# Lokale Datenhaltung, Service und Diagnose

Messwerte werden unabhängig von der gewählten Kommunikationsvariante lokal gespeichert. Im Ringspeicherbetrieb überschreibt der Logger bei vollem Speicher die ältesten Datensätze; im Linearbetrieb endet die Aufzeichnung bei vollständig belegtem Speicher. Die passende Betriebsart richtet sich danach, ob ein fortlaufender Verlauf oder eine lückenlose Kampagne bis zum manuellen Auslesen wichtiger ist.

Für Einrichtung, Diagnose und lokalen Datenzugriff steht das [BLX Dashboard](https://github.com/joembedded/ltx_ble_demo) über Bluetooth Low Energy zur Verfügung. Die als PWA ausgeführte App läuft auf PCs mit Chrome oder Edge sowie auf Android und mit Einschränkungen auch auf iOS. Sie unterstützt die Parametrierung, Diagnose und den Zugriff auf Loggerdaten direkt am Gerät.

Die Oberflächen des BLX Dashboards sind in JavaScript und HTML umgesetzt. Für wiederkehrende Messaufgaben können Kunden daher eigene, auf ihre Sensorik und Arbeitsabläufe zugeschnittene Bedienoberflächen erstellen. Die externe LED ergänzt die Diagnose am Einbauort; ihre konkrete Anzeige- und Blinklogik kann mit der kundenspezifischen Ausführung abgestimmt werden.

![BLX Dashboard bei der Bluetooth-Verbindung mit einem LTX-Datenlogger](editiert/img/blxDashboard_preview640x480.png){height=82mm}

*BLX Dashboard als PWA für Parametrierung, Diagnose und lokalen Datenzugriff per Bluetooth Low Energy. Die Bedienoberflächen können in JavaScript und HTML an die jeweilige Messaufgabe angepasst werden.*

| Funktion | Nutzen |
|---|---|
| Lokaler Speicher | Messdaten bleiben bei temporär fehlender Funk- oder Mobilfunkverbindung verfügbar |
| BLE-Servicezugang | BLX Dashboard als PWA auf PC und Android sowie eingeschränkt auf iOS; Parametrierung, Diagnose und Datenzugriff direkt am Gerät |
| Housekeeping-Werte | Ferndiagnose von Batteriezustand, Energieverbrauch und internen Betriebswerten |
| Externe LED | sichtbare Betriebsanzeige am kundenspezifischen Gehäuse |
| Bidirektionale Kommunikation | bei geeigneter Modembestückung Konfiguration und Diagnose auch über die Datenverbindung |
| LTE-Serversynchronisation | Übertragung des Logger-Speicherinhalts an LTX Server, auch nach zeitweisen Verbindungsunterbrechungen |

# Projektierung und Lieferumfang

Der LTX Typ 18xx_eco ist kein starres Standardgehäuseprodukt, sondern eine projektspezifische Variante. Vor Angebot und Fertigung werden die erforderlichen Sensoranschlüsse, das Gehäuse, die Energieversorgung und die Datenübertragung gemeinsam festgelegt. So kann die Plattform auf die tatsächliche Messaufgabe zugeschnitten werden, ohne eine generische Anschluss- oder Schutzart zu versprechen.

Bitte geben Sie bei einer Anfrage möglichst folgende Punkte an:

- eingesetzte SDI-12-Sensoren, Anzahl, Sensoradressen und ungefähre Kabellängen;
- gewünschte Mess- und Übertragungsintervalle sowie benötigte Datenmenge;
- vorhandene Energiequelle, insbesondere Solar, Akku oder externe Gleichspannung;
- Standort, Land und verfügbare LoRaWAN- oder Mobilfunkabdeckung;
- gewünschte Gehäuseform, Umgebungsbedingungen und Anforderungen an Steckverbinder;
- Bedarf an externer LED, Antenne, lokaler Bedienung und Datenfernübertragung.

Auf dieser Grundlage wird die passende 18xx_eco-Variante mit LoRaWAN, LTE Cat 1, LTE-M/NB-IoT oder ohne Modem angeboten.

# Abgrenzung zum LTX Typ 1820

Der LTX Typ 18xx_eco nutzt dieselbe grundlegende Loggerarchitektur wie der LTX Typ 1820. Er ist jedoch für kundenspezifische Einbausituationen und Anschlusskonzepte vorgesehen.

| Merkmal | LTX Typ 1820 | LTX Typ 18xx_eco |
|---|---|---|
| Grundplattform | BoPla-Logger mit LoRaWAN EU868 | abgeleitete, kundenspezifische Loggerplattform |
| Gehäuse | Polycarbonatgehäuse, ausführungsabhängig | kundenspezifisch |
| Datenübertragung | LoRaWAN EU868 | LoRaWAN EU868, LTE Cat 1, LTE-M/NB-IoT oder ohne Modem |
| SDI-12-Anschlüsse | Standardausführung | mehrere projektspezifische SDI-12-Ausgänge |
| Externe Versorgung | 5 bis 14 V | explizite Zusatzversorgung von 4 bis 14 V |
| Statusanzeige | ausführungsabhängig | externe LED vorgesehen |

# Weiterführende Dokumentation

- [LTX Typ 1820 - Basisplattform mit LoRaWAN](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/LTX_T1820_LoRaWAN.MD)
- [LTX-Logger - Hardwarevarianten und Kommunikationsoptionen](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_typen/logger_Zusammenfassung.md)
- [LoRaWAN-Inbetriebnahme mit TTN oder ChirpStack](https://github.com/joembedded/ltx_docu/blob/master/editiert/ltx_lorawan_howto/ltx_lorawan_howto.md)
- [LTX-LoRa-Payload, fPort, Einheiten und Downlinks](https://github.com/joembedded/ltx_docu/blob/master/editiert/lora/lora_payload.md)
- [LTX Server - kostenfreie Open-Source-Cloudsoftware](https://github.com/joembedded/LTX_server)
- [BLX Dashboard - PWA für lokale Loggerbedienung](https://github.com/joembedded/ltx_ble_demo)
- [LTX-Dokumentation](https://github.com/joembedded/ltx_docu)

---

*Produktdatenblatt LTX Typ 18xx_eco · Stand: Juli 2026 · Kundenspezifische Ausführung. Technische Details, Anschlüsse, Gehäuse, Schutzart und Bestückung werden projektbezogen festgelegt.*