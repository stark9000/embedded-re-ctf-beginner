@echo off
set AVRDUDE_DIR=C:\Users\<username>\AppData\Local\Arduino15\packages\arduino\tools\avrdude

for /d %%D in ("%AVRDUDE_DIR%\*") do set AVRDUDE_PATH=%%D\bin\avrdude.exe & set AVRDUDE_CONF=%%D\etc\avrdude.conf

"%AVRDUDE_PATH%" -C "%AVRDUDE_CONF%" -c arduino -p m328p -P COM5 -b 57600 -U flash:w:patched.bin:r

echo Done!

pause