@echo off

ml /c /coff src\main\Try.asm || goto ErrLable || goto ErrLable
link /subsystem:windows Try.obj || goto ErrLable
del Try.obj
del Try.exe
goto end
:ErrLable
echo Error
:end
pause