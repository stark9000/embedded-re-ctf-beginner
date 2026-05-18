@echo off
set AVRDUDE_DIR=C:\Users\<username>\AppData\Local\Arduino15\packages\arduino\tools\avrdude

for /d %%D in ("%AVRDUDE_DIR%\*") do set AVRDUDE_PATH=%%D\bin\avrdude.exe & set AVRDUDE_CONF=%%D\etc\avrdude.conf

"%AVRDUDE_PATH%" -C "%AVRDUDE_CONF%" -c arduino -p m328p -P COM5 -b 115200 -U flash:r:embedded_CTF_arduino_nano_0_ino.bin:r
    
echo Done! embedded_CTF_arduino_nano_0_ino.bin saved.

pause