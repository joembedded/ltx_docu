# Mobilfunk-Metadaten

Diese Liste beschreibt die Mobilfunk-Metadaten, die ein LTX-Logger beim Serverkontakt uebertraegt oder die serverseitig daraus abgeleitet und gespeichert werden.

## Direkt vom Logger uebertragene Felder

Der Server empfaengt die Mobilfunkdaten im Upload-Record `0xA5` (`CSIGNAL_SG3G`). Daraus wird der Status-String `signal` gebildet:

```text
mcc:<mcc> net:<net> lac:<lac> cid:<cid> ta:<ta> dbm:<dbm> act:<act>
```

| Feld | Bedeutung | Speicherung / Verwendung |
|---|---|---|
| `mcc` | Mobile Country Code, Laenderkennung des Mobilfunknetzes | Bestandteil von `signal`; wird fuer Cell-Position-Abfragen verwendet |
| `net` | Netzbetreiberkennung / MNC | Bestandteil von `signal`; wird fuer Cell-Position-Abfragen verwendet |
| `lac` | Location Area Code / Tracking Area Code, Zellbereich | Bestandteil von `signal`; wird fuer Cell-Position-Abfragen verwendet |
| `cid` | Cell-ID der eingebuchten Funkzelle | Bestandteil von `signal`; wird fuer Cell-Position-Abfragen verwendet |
| `ta` | Timing Advance. `255` bedeutet unbekannt | Fuer grobe Entfernungsangabe zur Zelle; Anzeige etwa `ta * 500 + 500 m` |
| `dbm` | Empfangspegel / Signalstaerke in dBm. Im Server wird der uebertragene Bytewert als negativer dBm-Wert interpretiert | Wird im Frontend als "Letztes Signal" bewertet |
| `act` | Funkzugangstechnologie | Anzeige-Mapping: `0` unbekannt, `1` GSM/2G, `2` GPRS, `3` EDGE, `4` LTE-M, `5` LTE-NB, `6` LTE |

Nicht erfasst werden LTE-Werte wie `RSRP`, `RSRQ` oder `SINR`.

## Speicherorte auf dem Server

| Ort | Inhalt |
|---|---|
| `device_info.dat` | Aktueller Geraetestatus als Key-Value-Datei. Das Feld `signal` enthaelt den zuletzt empfangenen Mobilfunk-Statusstring. |
| `conn_log.txt` | Historie der empfangenen Mobilfunk-Statusstrings, jeweils mit UTC-Zeitstempel. Wird fuer die Verbindungs-/Zellhistorie angezeigt. |
| SQL-Tabelle `devices` | Speichert nicht den kompletten `signal`-String als eigene Spalte. Aus `signal` koennen aber `lat`, `lng`, `rad` und `last_gps` aktualisiert werden, wenn eine Zellposition ermittelt wird. |
| SQL-Tabelle `m<MAC>` | Speichert Messdaten-/Eventzeilen. Bei erfolgreicher Zellpositionsauflosung kann eine Eventzeile `<CELLOC <lat> <lng> <radius>>` eingetragen werden; bei Fehlern entsprechend `<ERROR: CELLOC ...>`. |

## Anzeige und Bewertung

Die Weboberflaeche wertet `dbm` als Signalqualitaet:

| Bereich | Anzeige |
|---:|---|
| `>= -70 dBm` | Top |
| `>= -85 dBm` | Good |
| `>= -100 dBm` | Fair |
| `< -100 dBm` | Poor |
| `>= -1 dBm` | Nicht gemessen |

Die Verbindungslog-Anzeige fasst gleiche Zellen ueber `mcc:net:lac:cid:act` zusammen und zeigt dazu den Empfangspegel, die Funktechnologie, das Land sowie bei bekanntem `ta` eine grobe Entfernungsangabe.

## Abgeleitete Zellposition

Wenn automatische Positionsaktualisierung aktiv ist, liest der Trigger den letzten `signal`-Eintrag aus `device_info.dat` und fragt mit `mcc`, `net`, `lac` und `cid` einen Cell-Location-Dienst ab. Bei Erfolg werden die abgeleiteten Werte als Geraeteposition gespeichert:

| Feld | Bedeutung |
|---|---|
| `lat` | Abgeleiteter Breitengrad der Zellposition |
| `lng` | Abgeleiteter Laengengrad der Zellposition |
| `rad` | Genauigkeit / Radius in Metern |
| `last_gps` | Zeitpunkt der letzten Positionsaktualisierung; kann aus GNSS oder Zellposition stammen |

Diese Werte sind keine direkt gemessenen Mobilfunk-Metadaten, sondern aus den Zellinformationen abgeleitete Positionsdaten.

## Fundstellen im Server-Code

| Datei | Relevanz |
|---|---|
| `C:\html\ltx_server\sw\lxu_v1.php` | Dekodiert `0xA5` und schreibt `signal`, `device_info.dat`, `conn_log.txt` |
| `C:\html\ltx_server\intern\lxu_v1_docu.md` | Kurzbeschreibung des Upload-Records `0xA5` |
| `C:\html\ltx_server\sw\js\intern_main.js` | Anzeige und Bewertung des letzten dBm-Wertes |
| `C:\html\ltx_server\sw\w_php\w_main.php` | Liefert `conn_log.txt` fuer die UI und interpretiert `act`, `ta`, `dbm` |
| `C:\html\ltx_server\sw\lxu_trigger.php` | Leitet bei Bedarf Zellpositionen aus `signal` ab |
| `C:\html\ltx_server\sw\w_php\w_gdraw_db.php` | Nutzt Zellposition als Fallback, wenn keine GPS-Position vorhanden ist |
| `C:\html\ltx_server\sw\docu\database.sql` | SQL-Felder fuer `devices`, u. a. `lat`, `lng`, `rad`, `last_gps`, `vals` |
