.686p
.model flat, stdcall
option casemap:none
;------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\macros\macros.asm
include \masm32\projects\Examples\DllTest\src\include\Log.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib

.data
	Libr db 'InvStr.dll',0
	lpProcName db '_InvStr@12',0
	lpBuf db 100 dup(0)
	lpOutString db 'Input:',13,10,0
	lpBuf2 db 100 dup(0)
	
	dwStdInHandle dword 0
	dwStdOutHandle dword 0
	hLib dword 0
	dwCallAddr dword 0
	dwSize dword 0
	dwTmp dword 0
.code
start:
invoke GetStdHandle, STD_INPUT_HANDLE
mov dwStdInHandle, eax
.if eax == 0
	invoke GetLastError
	LOG_ERROR "GetStdHandle error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "GetStdHandle success, eax[%08X]", eax
.endif

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov dwStdOutHandle, eax
.if eax == 0
	invoke GetLastError
	LOG_ERROR "GetStdHandle error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "GetStdHandle success, eax[%08X]", eax
.endif

invoke WriteConsoleA, dwStdOutHandle, addr lpOutString, lengthof lpOutString, addr dwTmp, 0
.if eax == 0
	invoke GetLastError
	LOG_ERROR "WriteConsoleA error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "WriteConsoleA success, eax[%08X]", eax
.endif

invoke ReadConsoleA, dwStdInHandle, addr lpBuf, 100, addr dwSize, 0
.if eax == 0
	invoke GetLastError
	LOG_ERROR "ReadConsoleA error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "ReadConsoleA success, eax[%08X]", eax
.endif

invoke LoadLibrary, addr Libr
mov hLib, eax
.if eax == 0
	invoke GetLastError
	LOG_ERROR "LoadLibrary error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "LoadLibrary success, eax[%08X]", eax
.endif

invoke GetProcAddress, hLib, addr lpProcName
mov dwCallAddr, eax
.if eax == 0
	invoke GetLastError
	LOG_ERROR "GetProcAddress error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "GetProcAddress success, eax[%08X]", eax
.endif

mov eax, dwCallAddr
mov ecx, dwSize
sub ecx, 2
push ecx
push offset lpBuf2
push offset lpBuf
call eax
.if eax == 0
	invoke GetLastError
	LOG_ERROR "InvStr error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "InvStr success, eax[%08X]", eax
.endif

invoke FreeLibrary, hLib
.if eax == 0
	invoke GetLastError
	LOG_ERROR "FreeLibrary error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "FreeLibrary success, eax[%08X]", eax
.endif

mov ecx, dwSize
sub ecx, 2
invoke WriteConsoleA, dwStdOutHandle, addr lpBuf2, ecx, addr dwTmp, 0
.if eax == 0
	invoke GetLastError
	LOG_ERROR "WriteConsoleA error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "WriteConsoleA success, eax[%08X]", eax
.endif

Finish:
invoke ExitProcess, 0
end start