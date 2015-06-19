@echo off

ml /c /coff src\main\MasmTry.asm || goto ErrLable
link /subsystem:windows MasmTry.obj || goto ErrLable

goto end
:ErrLable
echo Error
:end
pause