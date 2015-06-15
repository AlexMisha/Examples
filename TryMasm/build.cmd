@echo off

ml /c /coff src\main\MasmTry.asm || goto ErrLable || goto ErrLable
link /subsystem:windows MasmTry.obj || goto ErrLable
del MasmTry.obj
del MasmTry.exe
goto end
:ErrLable
echo Error
:end
pause