@echo off

md build

\masm32\bin\RC /Fo build\rsrc.res src\resource\rsrc.rc || goto ErrLable

\masm32\bin\ml /c /coff /D LOG_LEVEL=4 /Fo build\PaintHandlers.obj src\main\PaintHandlers.asm || goto ErrLable

\masm32\bin\ml /c /coff /D LOG_LEVEL=4 /Fo build\ButnHandlers.obj src\main\ButnHandlers.asm || goto ErrLable

\masm32\bin\ml /c /coff /Fo build\szrev.obj src\main\szrev.asm || goto ErrLable
\masm32\bin\lib /subsystem:windows /export:szRev build\szrev.obj

\masm32\bin\ml /c /coff /Zp4 /D LOG_LEVEL=4 /Fo build\MasmTry-2.obj src\main\MasmTry-2.asm || goto ErrLable
\masm32\bin\link /subsystem:windows /debug build\MasmTry-2.obj build\PaintHandlers.obj build\ButnHandlers.obj build\rsrc.res || goto ErrLable

goto end
:ErrLable
echo Error
:end
pause