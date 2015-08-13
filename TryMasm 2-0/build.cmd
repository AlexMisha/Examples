@echo off

RC src\resource\rsrc.rc || goto ErrLable

ml /c /coff /Zp4 /D LOG_LEVEL=4 src\main\MasmTry-2.asm || goto ErrLable
link /subsystem:windows /debug MasmTry-2.obj src\resource\rsrc.res|| goto ErrLable

goto end
:ErrLable
echo Error
:end
pause