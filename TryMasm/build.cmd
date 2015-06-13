@echo off

ml /c /coff Try.asm || goto ErrLable
link /subsystem:windows Try.obj || goto ErrLable
goto end
:ErrLable
echo Error
:end
pause