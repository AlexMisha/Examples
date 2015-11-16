.686p
.MODEL FLAT, stdcall
option casemap :none
;----------------------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\macros\macros.asm
include \masm32\projects\Examples\MasmResUse\src\include\Log.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib

EXTERN DialogBoxParamA@20:near

.data
	PA db "DIAL1", 0
	sStr db 'Hello', 0
	hInstance dword 0
.code
start:
invoke GetModuleHandleA, 0
mov hInstance, eax

.if eax == 0
	invoke GetLastError
	LOG_ERROR "GetModuleHandleA error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "GetModuleHandleA success, eax[%08X]", eax
.endif


push 0
push offset DialProc
push 0
push offset PA
push hInstance
call DialogBoxParamA@20
.if eax == 0
	invoke GetLastError
	LOG_ERROR "DialogBoxParamA error code:[%08X]", eax
	jmp Finish
.elseif eax == -1
	invoke GetLastError
	LOG_ERROR "DialogBoxParamA error code:[%08X]", eax
	jmp Finish
.else
	LOG_INFO "DialogBoxParamA, eax[%08X]", eax
.endif

Finish:
invoke ExitProcess, 0

DialProc proc hwnd:dword, msg:dword, lParam:dword, wParam:dword

.if msg == WM_CLOSE
	invoke EndDialog, hwnd, 0
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "EndDialog error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "EndDialog success, eax[%08X]", eax
	.endif
    jmp finish
.elseif msg == WM_INITDIALOG
	invoke LoadIconA, hInstance, 3
	push eax
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "LoadIconA error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "LoadIconA success, eax[%08X]", eax
	.endif	
	pop eax
	invoke SendMessage, hwnd, WM_SETICON, 0, eax
.else
	invoke DefWindowProc,hwnd,msg,lParam,wParam
.endif
finish:
ret
DialProc endp
end start