# Firmware-Ablage und Download

Die Firmware-Dateien fuer Logger und Sensoren liegen lokal unter:

```text
https://joembedded.de/x3/ltx_firmware/index.php
```

## Typ 1800 / Typ 1801

Typ 1800 und Typ 1801 verwenden die gleiche BoPla-Hardware mit LTE Cat1 / 2G ueber Quectel EG912U. Der Unterschied liegt in der Firmware-Konfiguration:

| Typ | Messkanaele | Firmware |
|---:|---:|---|
| 1800 | 48 | `firmware_typ1800_ltx_eg912u_0v2.sec` |
| 1801 | 90 | `firmware_typ1801_ltx_eg912u_0v2.sec` |

Wichtig: Jeder Typ muss mit seiner passenden Firmware betrieben werden. Eine Typ-1800-Firmware ist nicht fuer Typ 1801 geeignet und umgekehrt, obwohl die Hardware identisch ist.

