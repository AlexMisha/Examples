@echo off

ml /c /coff /Zp4 /D LOG_LEVEL=4 src\main\MasmTry-2.asm || goto ErrLable
link /subsystem:windows /debug MasmTry-2.obj || goto ErrLable

goto end
:ErrLable
echo Error
:end
pause