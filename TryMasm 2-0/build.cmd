@echo off

RC src\resource\rsrc.rc || goto ErrLable

ml /c /coff /Zp4 /D LOG_LEVEL=4 src\main\MasmTry-2.asm || goto ErrLable
link /subsystem:windows /debug MasmTry-2.obj ignore\rsrc.res || goto ErrLable

move MasmTry-2.obj ignore
move MasmTry-2.ilk ignore
move MasmTry-2.pdb ignore
move MasmTry-2.exe ignore
move src\resource\rsrc.res ignore
goto end
:ErrLable
echo Error
:end
pause