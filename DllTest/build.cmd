@echo off

md build

\masm32\bin\ml /c /coff /D LOG_LEVEL=4 /Fo build\DllTest.obj src\main\DllTest.asm || goto ErrLable
\masm32\bin\link /subsystem:windows build\DllTest.obj|| goto ErrLable

goto end
:ErrLable
echo Error

:end
pause