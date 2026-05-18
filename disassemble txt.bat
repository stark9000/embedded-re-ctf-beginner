@echo off

setlocal

set GCC=C:\Users\<username>\AppData\Local\Arduino15\packages\arduino\tools\avr-gcc\5.4.0-atmel3.6.1-arduino2\bin

set PATH=%GCC%;

avr-objdump -b binary -m avr5 -D --adjust-vma=0 embedded_CTF_arduino_nano_0_ino.bin > disassembly.txt

echo Done! disassembly.txt generated.

pause