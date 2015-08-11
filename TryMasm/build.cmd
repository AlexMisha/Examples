@echo off

ml /c /coff /Zp4 /D LOG_LEVEL=0 src\main\MasmTry.asm || goto ErrLable
link /subsystem:windows /debug MasmTry.obj || goto ErrLable

goto end
:ErrLable
echo Error
:end
pause