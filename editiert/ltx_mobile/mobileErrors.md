# Exkurs: Haeufige Mobil-Funk-Fehler (LTX)

Quelle: `ltx-server -> .../sw/docu/mobileErrors.txt`  
Stand: 22.02.2026

Diese Seite fasst haeufige Fehlercodes im Mobilfunk-Kontext zusammen.

## Modem Basic

| Code | Bedeutung |
|---|---|
| -20xx | CREG-bezogene Fehler |
| -2005 | Roaming denied |
| -2006 | Net denied |
| -2007, -2017 | APN |
| -2011 | PowerDown-Fehler: Modem antwortet nicht |
| -2012 | PowerDown-Fehler: Modem bestaetigt PowerDown-Cmd nicht |
| -2013 | PowerDown-Fehler: Modem-Abmeldung schlug fehl |
| -2018 | APN-Timeout |
| -2029 | NoNetFound (creg=2) |
| -2030 | Denied Net (creg=3) |
| -2031 | Unknown Net (creg=4) |
| -2032 | Roaming Error Net (creg=5, falls nicht erlaubt) |
| -2033 bis -2036 | No Net (creg=6..8, sollte nicht vorkommen) |
| -2000, -1001 | Keine Antwort vom Modem |
| -240x | DNS Failure |
| -2303 | Server nicht erreichbar (gprs_transfer.c) |

## UDP

| Code | Bedeutung |
|---|---|
| -2190 | Open/DNS |
| -2191 | SendUDP |
| -2192 | NoReply |
| -2199 | Close |

## HTTP

| Code | Bedeutung |
|---|---|
| -2208 | Initialer Timeout beim Content (ca. 20 Sekunden sollten reichen) |
| -2209 | Timeout im Content, z. B. Not Found |
| -2303 | Server nicht erreichbar oder viel zu langsam |
| -2304 | Modem antwortet nicht (evtl. Sleep oder Batterie low) |
| -2300 bis -2310 | u-Blox Socket Setup Failure |
| -231x | SSL-Setup |
| -3000 + HTTP-Code | z. B. -3301 bei permanently moved |
| -2100 | Connection to Server failed (Open failure) |
| -2101 | Quectel Close failed |
| -2102 | GPS init failure |
| -2103 | GPS exit failure |
| -2104 | GPS init2 failure |
| -2105 | GPS: No Reply from Modem |
| -2201, -2202, -2203 | Send Header |
| -2205 | Send Trailer |

## Content

| Code | Bedeutung |
|---|---|
| -1002 | Kann auch auftreten, wenn Server zu spaet antwortet und z. B. "400 Bad Gateway" als Content erkannt wird |
| -4000 | Notepad voll |
| -4001 | Unbekanntes Kommando im Notepad |
| -4002 | fnamelen < 1 oder > FNAMELEN bei GET |
| -4003 | fnamelen < 1 oder > FNAMELEN bei SET |
| -4004 | Unbekannter Block (CMD an Device), ggf. ueberspringen |
| -4005 | Notepad voll |
| -4006 | Disk available zu wenig (kann trotzdem passen) |
| -4007 | Falsche Filename-Laenge |
| -4008 | Illegale Zeichen im Filename |
| -4009 | CRC2 bei File-Block falsch (Pendant: -1004 bei normalen Bloecken) |
| -4010 | Interface |
| -4011 | User does not want to receive this file |
| -4998 | Interface not set |
| -4999 | Internet disabled (reserviert fuer periodically called user_content_exit) |
| -5000 + x | Content-Fehler im unterliegenden Layer SEND (x = 0..255) |
| -5300 + x | Content-Fehler im unterliegenden Layer GET (x = 0..255) |
| -5546 | Timeout (Beispiel) |
| -5600 + x | Read Contentlen (radio_task) |

## GPRS_TRANSFER

| Code | Bedeutung |
|---|---|
| -2208 | Initialer Timeout beim Content |
| -2209 | Timeout im Content |
| -2303 | Server nicht erreichbar oder viel zu langsam |
| -2300, -2301, -2302 bis -2310 | u-Blox Socket Setup (* bei einzelnen Codes: keine Wiederholung) |
| -231x | SSL-Setup |
| -3000 + HTTP-Code | z. B. -3301 bei permanently moved |
| -3000 bis -3999 | HTTP-basierte Fehlerklasse |
| -2100 | Connection to Server failed (DNS failure) |
| -2101 | Quectel Close failed |
| -2201, -2202, -2203 | Send Header |
| -2205 | Send Trailer |

## LFTP

| Code | Bedeutung |
|---|---|
| -2500 | No Reply from Modem (might be sleeping/off) |
| -2501 | Protokoll nicht LFTP (Legacy FTP direkt, ohne Verschluesselung) |
| -2502 | Format unknown |
| -2503 | NTP-Server not found |
| -2504 | FTP Hostname missing |
| -2505 | FTP Port missing |
| -2506 | FTP User missing |
| -2507 | FTP Password missing |
| -2508 | Unknown/incorrect CMD |
| -2550 | Connect Server - Context |
| -2551 | Connect Server - Filetype |
| -2552 | Connect Server - User/PW refused |
| -2553 | Connect Server - Connection refused (A) |
| -2554 | Connect Server - Connection refused (B) |
| -2555 | Open File on FTP Server |
| -2556 | Close File on FTP Server Error |
| -2557 | Send Filecontent to FTP Server failed |
