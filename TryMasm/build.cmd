@echo off

ml /c /coff c:\masm32\projects\Examples\TryMasm\src\main\Try.asm || goto ErrLable
move c:\masm32\projects\Examples\TryMasm\Try.obj c:\masm32\projects\Examples\TryMasm\src\object || goto ErrLable
link /subsystem:windows c:\masm32\projects\Examples\TryMasm\src\object\Try.obj || goto ErrLable
move c:\masm32\projects\Examples\TryMasm\Try.exe c:\masm32\projects\Examples\TryMasm\exe || goto ErrLable
goto end
:ErrLable
echo Error
:end
pause