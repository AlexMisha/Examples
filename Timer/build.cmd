@echo off

md build

\masm32\bin\ml /c /coff /D LOG_LEVEL=4 /Fo build\Timer.obj src\main\Timer.asm || goto ErrLable
\masm32\bin\link /subsystem:windows build\Timer.obj|| goto ErrLable

goto end
:ErrLable
echo Error

:end
pause