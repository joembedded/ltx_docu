# Energie-Vergleich LoRa-Module EU868
- Stand 14.03.2026/JW

> Es wurden 3 Module (LTX-Shields) verglichen. Ein LTX-Shield enthält im wesentlichen nur das LoRa-Funkmodul und einen 50Ohm UFL. Als Firmware auf dem LoRa-Modul wurde die AT-Firmware von STM (Basis 'AN5481') in einer angepassten Version implementiert (zusätzliche Events, Watchdog, etc...).

Für die Übersichtstabelle wurden 2 typische Nutzlängen verwendet:
- 10 Bytes: z.B. typisch für einfachen Temperatur-/Feuchte-Sensor
- 40 Bytes: z.B. typisch für kleine Wetterstation mit 8-10 Kanälen

## Testbedingungen
- Messdaten: März 2026 / JoEm
- Versorgungsspannung: 3.3V, Funkband: EU868
- Sendeleistung: ~12 dBm (Spektrumanalyzer @ 868.5 MHz)
- ADR und DCS deaktiviert (AT+ADR=0, AT+DCS=0)
- LoRaWAN-Version 1.0.4, Firmware: V1.4
- Messung: Sende-Peak bis "+EVT:FINISH" (inkl. RX-Slots), Nordic PPK2

## Module im Vergleich

| Modul | Standby | TX-PA-Typ | I\_TX\_max | Bemerkung |
|-------|---------|-----------|-----------|-----------|
| **STM32MOC (LP-Mode)** | 2.4 µA | LP-PA | 29 mA | **Referenz** |
| **RAK3172LP-SIP** | 3.3 µA | LP-PA | 38 mA | auch als ST50H; min. 3.0V (TCXO) |
| **RAK3172-SIP** | 3.3 µA | HP-PA | 91 mA | auch als ST50HE; min. 3.0V (TCXO) |

> **RAK3172-SIP:** Der HP-TX-Amplifier wird auch bei 14 dBm im 20-dBm-Bias betrieben (EU868 erlaubt max. 14 dBm) — dadurch 3× höherer TX-Strom als beim STM32MOC.

| STM32WL5MOC Shield | RAK3172(LP)-SIP Shield |
|:------------------:|:------------------:|
| ![STM32WL5MOC Shield](img/stm32wl5moc_shield.png) | ![RAK3172LP-SIP Shield](img/rak3172LP_shield.png) |

## Energieverbrauch @ 3.3V — unconfirmed TX (mC)

### 1 Byte Nutzdaten (aus Messung in mC)

| DR | STM32MOC | RAK3172LP-SIP | RAK3172-SIP |
|:--:|:--------:|:---------:|:-----------:|
| 0  | 39.8     | 50.2      | 121.6       |
| 1  | 21.0     | 27.3      | 61.6        |
| 2  | 11.7     | 15.9      | 31.8        |
| 3  | 7.1      | 10.3      | 17.0        |
| 4  | 5.1      | 7.7       | 10.5        |
| 5  | 3.6      | 6.3       | 6.8         |

Der RAK3172LP benötigt je nach Datenrate 26 % bis 75 % mehr Energie als der STM32MOC. Der RAK3172-SIP (HP-PA) verbraucht trotz gleicher Sendeleistung das 1,9- bis 3,1-fache des STM32MOC.

### 51 Bytes Nutzdaten (aus Messung in mC)

| DR | STM32MOC | RAK3172LP | RAK3172-SIP |
|:--:|:--------:|:---------:|:-----------:|
| 0  | 80.5     | 100.2     | 253.4       |
| 1  | 46.0     | 57.8      | 142.5       |
| 2  | 21.9     | 28.4      | 64.9        |
| 3  | 13.4     | 17.9      | 37.2        |
| 4  | 8.5      | 11.9      | 21.6        |
| 5  | 5.8      | 8.6       | 12.5        |

Der RAK3172LP benötigt je nach Datenrate 24 % bis 48 % mehr Energie als der STM32MOC. Der RAK3172-SIP (HP-PA) verbraucht das 2,2- bis 3,1-fache des STM32MOC.

> **Fazit TX-Energie:**
> - **LP-PA vs. HP-PA:** Der RAK3172-SIP verbraucht trotz gleicher Ausgangsleistung (14 dBm) zwei- bis dreimal mehr als der STM32MOC — Ursache ist der hohe Bias-Strom des HP-Amplifiers, der zwar 20 dBm kann, in EU868 aber nur 14 dBm senden darf.
> - **STM32MOC vs. RAK3172LP-SIP (beide LP-PA):** Der STM32MOC liegt 20 % bis 75 % unter dem RAK3172LP-SIP. Ursache sind vermutlich der 3-V-TCXO des RAK3172LP-SIP (vs. 1,8-V-TCXO im STM32MOC) sowie interne Multiplexer.

---

## Auswirkung auf die Batterielebensdauer (2200 mAh @ 3.3V, nur TX-Energie) in Jahren (J)


### 10 Bytes unconfirmed — Intervall 10 min (52.560 Pakete/Jahr)

> 10 Bytes: z.B. typisch für einfachen Temperatur-/Feuchte-Sensor

| DR | STM32MOC | RAK3172LP-SIP | RAK3172-SIP |
|:--:|:--------:|:---------:|:-----------:|
| 0  | **3.2 J** | 2.5 J | 1.0 J |
| 2  | **11.1 J** | 8.3 J | 4.0 J |
| 5  | **37.6 J** | 22.5 J | 19.3 J |

### 10 Bytes unconfirmed — Intervall 60 min (8.760 Pakete/Jahr)

| DR | STM32MOC | RAK3172LP-SIP | RAK3172-SIP |
|:--:|:--------:|:---------:|:-----------:|
| 0  | **19.0 J** | 14.9 J | 6.2 J |
| 2  | **66.9 J** | 49.9 J | 23.9 J |
| 5  | **225.7 J** | 134.8 J | 115.9 J |


### 40 Bytes — Intervall 10 min (52.560 Pakete/Jahr)

> 40 Bytes: z.B. typisch für kleine Wetterstation mit 8–10 Kanälen. Bei dieser Paketgröße unterscheiden sich confirmed und unconfirmed um weniger als 5 %, daher wird hier nur eine Tabelle (unconfirmed) angegeben.

| DR | STM32MOC | RAK3172LP-SIP | RAK3172-SIP |
|:--:|:--------:|:---------:|:-----------:|
| 0  | **2.1 J** | 1.7 J | 0.7 J |
| 2  | **7.7 J** | 5.8 J | 2.6 J |
| 5  | **27.4 J** | 18.6 J | 13.5 J |


---

> **Hinweis:** Nur TX-Energie berücksichtigt. Sensorauslesen, MCU-Betrieb und Standby-Verluste reduzieren die tatsächliche Batterielebensdauer.


***