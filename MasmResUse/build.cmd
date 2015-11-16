@echo off

md build

\masm32\bin\rc /Fo build\rsrc.res src\res\rsrc.rc || goto ErrLable

\masm32\bin\ml /c /coff /D LOG_LEVEL=4 /Fo build\ResUse.obj src\main\ResUse.asm || goto ErrLable
\masm32\bin\link /subsystem:windows build\ResUse.obj build\rsrc.res || goto ErrLable

\masm32\bin\ml /c /coff /D LOG_LEVEL=4 /Fo build\Dial.obj src\main\Dial.asm || goto ErrLable
\masm32\bin\link /subsystem:windows build\Dial.obj build\rsrc.res || goto ErrLable

goto end
:ErrLable
echo Error

:end
pause