<div align="center">

```
 █████╗ ██████╗ ██████╗ ██╗   ██╗██╗███╗   ██╗ ██████╗ 
██╔══██╗██╔══██╗██╔══██╗██║   ██║██║████╗  ██║██╔═══██╗
███████║██████╔╝██║  ██║██║   ██║██║██╔██╗ ██║██║   ██║
██╔══██║██╔══██╗██║  ██║██║   ██║██║██║╚██╗██║██║   ██║
██║  ██║██║  ██║██████╔╝╚██████╔╝██║██║ ╚████║╚██████╔╝
╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
    ███╗   ██╗ █████╗ ███╗   ██╗ ██████╗               
    ████╗  ██║██╔══██╗████╗  ██║██╔═══██╗              
    ██╔██╗ ██║███████║██╔██╗ ██║██║   ██║              
    ██║╚██╗██║██╔══██║██║╚██╗██║██║   ██║              
    ██║ ╚████║██║  ██║██║ ╚████║╚██████╔╝              
    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝               
```

# 🔓 Arduino Nano Embedded RE CTF

**ආරම්භකයන් සඳහා Embedded Reverse Engineering Capture The Flag**

[![Arduino](https://img.shields.io/badge/Arduino-Nano%20ATmega328P-00979D?style=for-the-badge&logo=arduino&logoColor=white)](https://www.arduino.cc/)
[![OS](https://img.shields.io/badge/OS-Windows%2010%2F11-0078D6?style=for-the-badge&logo=windows&logoColor=white)]()
[![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-4CAF50?style=for-the-badge)]()
[![Language](https://img.shields.io/badge/Tutorial-සිංහල-FF6B35?style=for-the-badge)]()
[![Tools](https://img.shields.io/badge/Tools-HxD%20%7C%20avrdude%20%7C%20avr--objdump-2E75B6?style=for-the-badge)]()

---

*Ghidra නැත. Python නැත. strings.exe නැත. Hex bytes සහ කුතුහලය පමණි.*

*Windows 10 / 11 හි test කර ඇත.*

</div>

---

## 🎯 Challenge දළ විශ්ලේෂණය

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│   Patch කිරීමට පෙර:              Patch කිරීමෙන් පසු:           │
│                                                                  │
│   CHECKING...                    CHECKING...                     │
│   SYSTEM LOCKED  ← 500ms         FLAG{patched_the_firmware} ✅  │
│   SYSTEM LOCKED                                                  │
│   SYSTEM LOCKED                  LED වේගයෙන් blink (100ms)     │
│                                                                  │
│   Mission: flash .data offset 0x7F6 → F4 01 → 64 00            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🔧 අවශ්‍යතා

### දෘඪාංග
| අවශ්‍යතාව | විස්තරය |
|----------|---------|
| Arduino Nano | ATmega328P — onboard LED Pin 13 |
| Micro USB Cable | **Data transfer** — charging only නොවේ! |
| Windows PC | Windows 10 / 11 |

### මෘදුකාංග
| Tool | අරමුණ | Source |
|------|--------|--------|
| **Arduino IDE** | avr-objdump + avrdude + Serial Monitor | [arduino.cc](https://www.arduino.cc/en/software) |
| **HxD** | Hex view + bytes patch | [mh-nexus.de](https://mh-nexus.de/en/hxd/) |
| **Notepad** | disassembly.txt කියවීම | Windows built-in |
| **BAT files** | Extract, disassemble, flash — ready-made | *Challenge package හි ඇත* |

> ✅ **Ghidra නැත. Python නැත. strings.exe නැත.**

---

## 📦 Challenge Package — BAT Files

සෑම BAT file එකක්ම package හි include කර ඇත. Manual path setup අවශ්‍ය නොවේ.

```
CTF/
├── tools/
│   ├── avrdude.exe
│   ├── avrdude.conf
│   └── avr-gcc/bin/avr-objdump.exe
│
├── extract_new.bat       ← New bootloader (115200 baud)
├── extract_old.bat       ← Old bootloader (57600 baud)
├── backup.bat            ← Original firmware backup
├── disassembly.bat       ← disassembly.txt generate
├── flash_new.bat         ← patched.bin flash (115200)
├── flash_old.bat         ← patched.bin flash (57600)
│
├── firmware.bin          ← Challenge firmware
└── README.md
```

---

## 📄 Firmware Source Code

```cpp
#define LED_PIN 13

volatile int blinkDelay = 500;  // flash .data offset 0x7F6 හි F4 01 ලෙස ගබඩා
boolean doneFlag = false;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
  Serial.println("CHECKING...");
}

void loop() {
  digitalWrite(LED_PIN, HIGH);
  delay(blinkDelay);          // delay() milliseconds — 500 = 0.5s, 100 = 0.1s

  digitalWrite(LED_PIN, LOW);
  delay(blinkDelay);

  if (blinkDelay == 100) {   // flag trigger condition
    if (!doneFlag) {
      Serial.println("FLAG{patched_the_firmware}");
    }
    doneFlag = true;
  } else {
    Serial.println("SYSTEM LOCKED");
  }
}
```

> 💡 **`volatile` ඇයි?** `volatile` නොමැතිව Arduino IDE compiler (`-Os` optimization) `if(500 == 100)` condition සෑම විටම false ලෙස evaluate කර සම්පූර්ණ block dead code ලෙස eliminate කරයි. `volatile` keyword compiler ට blinkDelay RAM variable ලෙස treat කිරීමට බල කරයි — binary patch කළ හැකි වන්නේ ඒ නිසාය.

---

## 🧠 Patch කිරීමට පෙර — Theory

### AVR Harvard Architecture

> AVR **Harvard architecture** use කරයි — program memory (flash) සහ data memory (SRAM) **සම්පූර්ණයෙන් වෙනම address spaces** දෙකක්. Flash හි code සහ initial data values ගබඩා වේ. SRAM හි runtime variables ජීවත් වේ. ඒ නිසා 0x0100 address flash location සහ SRAM location දෙකටම refer කළ හැකිය — ඒවා physical memories දෙකකි.

### Flash Memory — Raw Bytes

ATmega328P flash memory inside, සෑම දෙයක්ම raw bytes ය. Tool එකෙන් tool ට interpret කරන ආකාරය වෙනස් වේ:

```
Same bytes — different interpretation:
═══════════════════════════════════════════════════════
Interpretation          Result
─────────────────────   ──────────────────────────────
Execute as AVR opcodes  Program code (instructions)
Read as ASCII           CHECKING..., SYSTEM LOCKED
Read as integers        blinkDelay = 500
═══════════════════════════════════════════════════════

Example: bytes  F4  01
├─ avr-objdump: movw r30, r8  ← False disassembly! (data bytes misread as code)
└─ Reality:     blinkDelay = 500 (.data section initial value)
```

> **False Disassembly** — Data bytes valid AVR instruction encoding ලෙස decode වීම. avr-objdump 0x7F6 හි F4 01 confidently 'movw r30, r8' ලෙස decode කරයි — නමුත් context අනුව ඒ DATA. Embedded RE හි common challenge.

### Arduino .hex File Contents

| Section | Contents |
|---------|---------|
| `.text` | AVR machine code (program instructions) |
| `.rodata` | Read-only constants |
| `initial .data` | **RAM variable initial values ← blinkDelay මෙහිය!** |
| Interrupt vectors | Hardware interrupt jump table |

### Flash → SRAM Memory Map

```
Flash (32KB)              SRAM (2KB)
0x0000 ┌───────────┐      0x0100 ┌────────────────────┐
       │  .text    │             │ blinkDelay (2 bytes)│
       │  (code)   │             │ F4 01 → 64 00      │
       ├───────────┤             ├────────────────────┤
       │  .rodata  │             │ doneFlag   (1 byte) │
       ├───────────┤  startup    ├────────────────────┤
0x7F6  │  .data    │ ──copy──→   │ padding            │
       │  F4 01    │             ├────────────────────┤
       │  strings  │             │ strings            │
       └───────────┘             │ CHECKING...        │
                                 │ SYSTEM LOCKED      │
0x7E00 ┌───────────┐             │ FLAG{...}          │
       │ Bootloader│             └────────────────────┘
       │ (Optiboot)│  ← SRAM ට copy නොවේ
       └───────────┘
```

> `.data` initial values **flash හි ගබඩා** වේ. Boot time AVR startup code ඒ values flash සිට **SRAM ට copy** කරයි. Variables actually SRAM හි ජීවත් වී execution හිදී access වේ. Flash copy = read-only source. SRAM copy = actual runtime variable.

### HEX vs BIN

| Feature | HEX | BIN |
|---------|-----|-----|
| Format | Text + addresses + checksums | Raw bytes only |
| HxD analysis | Complex | Direct ✅ |
| Offset match | No | Yes ✅ |
| **අපේ තේරීම** | — | **✅ BIN** |

### Flash Read — ඇතුළත් වන්නේ?

| Region | Included? |
|--------|---------|
| Application firmware | ✅ YES |
| `.data` section (blinkDelay, strings) | ✅ YES |
| Bootloader | ⚠️ Read size සහ fuse config අනුව |

---

## 📍 Offset — Binary Street Analogy

Binary file = දිගු පාරක්. සෑම byte = house number (offset).

```
Offset │ 0x000 │ 0x001 │ ... │ 0x7F5 │ 0x7F6 │ 0x7F7 │ ...
───────┼───────┼───────┼─────┼───────┼───────┼───────┼────
Byte   │  0C   │  94   │ ... │  FF   │  F4   │  01   │ ...
                                       ↑       ↑
                               blinkDelay     HIGH byte
                               LOW byte       (0x01)
                               (0xF4)
                               PATCH HERE!

0x7F6 = file byte number 2038 — simple linear address, blocks නැත!
```

---

## ⚡ Step by Step

### Step 1 — Firmware Extract

| Bootloader | Baud Rate | BAT File |
|-----------|-----------|---------|
| New (CH340) | 115200 | `extract_new.bat` |
| Old (FT232) | 57600 | `extract_old.bat` |

**avrdude flags සම්පූර්ණ විස්තරය:**

```
"%AVRDUDE_PATH%" -C "%AVRDUDE_CONF%" -c arduino -p m328p -P COM5 -b 115200 -U flash:r:firmware.bin:r
│                │                   │           │          │       │          │
│                │                   │           │          │       │          └─ r = raw binary format
│                │                   │           │          │       └──────────── firmware.bin = output
│                │                   │           │          └──────────────────── r = read operation
│                │                   │           └─────────────────────────────── flash = memory region
│                │                   └─────────────────────────────────────────── baud rate
│                │                                          └────────────────────── COM port
│                └───────────────────────────────────────────────────────────────── avrdude.conf
└──────────────────────────────────────────────────────────────────────────────────── avrdude.exe
                                    -c arduino = Arduino bootloader programmer
                                    -p m328p   = ATmega328P chip
```

> ⚠️ Wrong baud rate → avrdude timeout error. Correct BAT file use කරන්න.

### Step 2 — Backup
```bat
backup.bat
```
`firmware_backup.bin` ලෙස save — safe ව තබාගන්න!

### Step 3 — HxD හි Strings බලන්න

`firmware.bin` HxD හි open → `Ctrl+End` → right ASCII panel:

```
Offset   Hex                               ASCII
07F6    [F4 01] 00 00 ...                  ........
0800     43 48 45 43 4B 49 4E 47 2E 2E 2E  CHECKING...
080B     53 59 53 54 45 4D 20 4C 4F 43 4B  SYSTEM LOCK
0816     45 44 00 46 4C 41 47 7B 70 61 74  ED.FLAG{pat
082C     72 6D 77 61 72 65 7D 00           rmware}.

[F4 01] = blinkDelay = 500 ← PATCH TARGET
```

### Step 4 — Disassemble
```bat
disassembly.bat
```

| Flag | අර්ථය |
|------|--------|
| `-b binary` | Input = raw binary |
| `-m avr5` | Architecture = AVR5 (ATmega328P) |
| `-D` | ALL sections disassemble |
| `--adjust-vma=0` | Address 0x0000 සිට — HxD offsets ට match! |

### Step 5 — Notepad හි Offset සොයන්න

`Ctrl+F` → `7f6` search:

```
7f6:   f4 01       movw  r30, r8
 ↑
 Offset 0x7F6 confirmed!
 ⚠️ 'movw r30,r8' = false disassembly — ඇත්ත DATA (blinkDelay=500)!
```

### Step 6 — HxD හි Patch කරන්න

```
Little-endian patch:
500 = 0x01F4 → F4 01  (low byte first)
100 = 0x0064 → 64 00  (low byte first)

HxD → Ctrl+G → 7F6 → Enter:
  offset 0x7F6:  F4 → 64  (low byte)
  offset 0x7F7:  01 → 00  (high byte)
```

> ⚠️ HxD status bar `OVR` (Overwrite) ලෙස confirm — Insert mode නොවේ!

File → Save As → `patched.bin`

> 💡 **ඔබ ඇත්තෙන් කළේ කුමක්ද?** Executable code patch නොකළෙමු. Flash .data section හි blinkDelay initial value patch කළෙමු. Boot time startup code ඒ value (100) SRAM ට copy කළ නිසා loop() function RAM හි 100 දුටුවේය — flag condition triggered!

### Step 7 — Flash
```bat
flash_new.bat   ← new bootloader (115200)
flash_old.bat   ← old bootloader (57600)
```

Expected output:
```
avrdude: 2009 bytes of flash written
avrdude: 2009 bytes of flash verified
avrdude done.  Thank you.
```

### Step 8 — Verify

Serial Monitor → **9600 baud** → Reset:

```
CHECKING...
FLAG{patched_the_firmware}
```

---

## 🔬 Alternative Patch Targets

Binary file හි F4 01 **එකම patchable location නොවේ**. මෙය embedded RE insight:

| Patch Location | Effect | Type |
|---------------|--------|------|
| `.data` 0x7F6 — `F4 01 → 64 00` | blinkDelay = 100 at boot → flag triggers ✅ | Data patch |
| `delay()` instructions 0x700, 0x712 | LED blinks faster — flag triggers නොවේ ❌ | Cosmetic patch |
| `cpi` instruction 0x754 | Flag trigger value change | Logic patch |

> **Cosmetic patching** = visible behavior only. **Data patching** = program state change. **Logic patching** = condition change. Correct patch type goal අනුව තෝරා ගත යුතු.

---

## 🎓 ප්‍රධාන Lessons

| # | Lesson |
|---|--------|
| 1 | Same bytes = context අනුව different meaning (code / data / string) |
| 2 | `volatile` — compiler `-Os` optimization prevent කරයි — CTF firmware සඳහා critical |
| 3 | BIN > HEX — raw bytes, direct offsets, HxD friendly |
| 4 | AVR = Harvard architecture — flash සහ SRAM වෙනම address spaces |
| 5 | Offset = linear address — 0x7F6 = byte 2038, blocks නැත |
| 6 | False disassembly — avr-objdump -D data bytes code ලෙස decode කරයි |
| 7 | Little-endian — 500 = `F4 01`, 100 = `64 00` — low byte first |
| 8 | Data patch ≠ code patch — .data value change = boot time state change |
| 9 | Visible behavior ≠ program logic — LED speed ≠ flag condition |
| 10 | New bootloader = 115200 baud, Old = 57600 — both tested ✅ |

---

## 🗂️ Repository Structure

```
arduino-nano-ctf/
│
├── firmware/
│   ├── embedded_CTF_arduino_nano_0.ino
│   ├── embedded_CTF_arduino_nano_0_ino.bin
│   └── embedded_CTF_arduino_nano_0_ino.hex
│
├── tools/
│   ├── avrdude.exe
│   ├── avrdude.conf
│   └── avr-gcc/bin/avr-objdump.exe
│
├── extract_new.bat
├── extract_old.bat
├── backup.bat
├── disassembly.bat
├── flash_new.bat
├── flash_old.bat
│
├── tutorial/
│   ├── Arduino_Nano_CTF_Tutorial_V5.docx      ← සිංහල
│   └── Arduino_Nano_CTF_Tutorial_V5_EN.docx   ← English
│
└── README.md
```

---

## ⚠️ වැදගත් සටහන්

- **COM port** — `COM5` ඔබේ port ට වෙනස් කරන්න: Device Manager → Ports (COM & LPT)
- **USB cable** — Data transfer capable — charge-only නොවේ
- **Baud rate** — New: 115200 / Old: 57600. Wrong baud → timeout error
- **HxD mode** — `OVR` (Overwrite) — Insert mode නොවේ!
- **Bootloader** — USB upload application flash only — bootloader ආරක්ෂිතයි
- **OS** — Windows 10 / 11 — සෑම command, path Windows-specific

---

## 🏁 Flag

```
FLAG{patched_the_firmware}
```

---

<div align="center">

**ඉගෙනීම සඳහා නිර්මාණය කළා. සැබෑ hardware හි test කළා. Windows 10/11.**

*Arduino Nano Embedded RE CTF — සිංහල Tutorial V5*

</div>
