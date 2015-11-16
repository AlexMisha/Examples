@echo off

\masm32\bin\rc dial.rc || goto ErrLable

\masm32\bin\ml /c /coff dial.asm || goto ErrLable
\masm32\bin\link /subsystem:windows dial.obj dial.res || goto ErrLable

goto end
:ErrLable
echo Error

:end
pause