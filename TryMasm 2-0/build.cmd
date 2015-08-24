@echo off

md build

RC /Fo build\rsrc.res src\resource\rsrc.rc || goto ErrLable

ml /c /coff /Fo build\szrev.obj src\main\szrev.asm || goto ErrLable
lib /subsystem:windows /export:szRev build\szrev.obj

ml /c /coff /Zp4 /D LOG_LEVEL=4 /Fo build\MasmTry-2.obj src\main\MasmTry-2.asm || goto ErrLable
link /subsystem:windows /debug build\MasmTry-2.obj build\rsrc.res || goto ErrLable

goto end
:ErrLable
echo Error
:end
pause