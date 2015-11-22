@echo off 

\masm32\bin\ml /c /coff /Fo build\InvStr.obj src\main\InvStr.asm || goto ErrLable
\masm32\bin\link /subsystem:windows /DLL /ENTRY:DllEntry build\InvStr.obj || goto ErrLable

goto end
:ErrLable
echo Error
:end
pause