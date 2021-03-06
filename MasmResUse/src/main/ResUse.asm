.686P
.MODEL FLAT, stdcall
option casemap :none
;------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\macros\macros.asm
include \masm32\projects\Examples\MasmResUse\src\include\Log.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib
dwStyle equ 000CF0000H
Style equ CS_HREDRAW + CS_VREDRAW + CS_GLOBALCLASS

.data
	lpClassName db 'Class32', 0
	lpWindowName db 'Try', 0
	hInstance dword 0
	hWindow dword 0
	YT dword 30
	XT dword 30
	wc WNDCLASSA <?>
	Paint PAINTSTRUCT <?>
	Msg MSG <?>
	lpBuf db 40 dup(0)
	lpBuf2 db 40 dup(0)
	lpExitString db 'End of programm', 0
	Menu db "MENUP",0
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

mov [wc.style], Style
mov [wc.lpfnWndProc], offset MasmTry
mov [wc.cbClsExtra], 0
mov [wc.cbWndExtra], 0
mov eax, hInstance
mov [wc.hInstance], eax
invoke LoadIconA, 0, IDI_APPLICATION
mov [wc.hIcon], eax

.if eax == 0
invoke GetLastError
LOG_ERROR "LoadIconA error code:[%08X]", eax
jmp Finish
.else
LOG_INFO "LoadIconA success, eax[%08X]", eax
.endif

invoke LoadCursorA, 0, IDC_ARROW
mov [wc.hCursor], eax

.if eax == 0
invoke GetLastError
LOG_ERROR "LoadCursorA error code:[%08X]", eax
jmp Finish
.else
LOG_INFO "LoadCursorA success, eax[%08X]", eax
.endif

invoke CreateSolidBrush, White
mov [wc.hbrBackground], eax

.if eax == 0
invoke GetLastError
LOG_ERROR "CreateSolidBrush error code:[%08X]", eax
jmp Finish
.else
LOG_INFO "CreateSolidBrush success, eax[%08X]", eax
.endif

mov dword ptr [wc.lpszMenuName], offset Menu
mov dword ptr [wc.lpszClassName], offset lpClassName

invoke RegisterClassA, offset wc

.if eax == 0
invoke GetLastError
LOG_ERROR "RegisterClassA error code:[%08X]", eax
jmp Finish
.else
LOG_INFO "RegisterClassA success, eax[%08X]", eax
.endif

invoke CreateWindowExA, Style, offset lpClassName, offset lpWindowName, dwStyle, 100, 100, 1000, 500, 0, 0, hInstance, 0
mov hWindow, eax

.if eax == 0
invoke GetLastError
LOG_ERROR "CreateWindowExA error code:[%08X]", eax
jmp Finish
.else
LOG_INFO "CreateWindowExA success, eax[%08X]", eax
.endif

invoke ShowWindow, hWindow, SW_SHOWNORMAL
invoke UpdateWindow, hWindow

.if eax == 0
invoke GetLastError
LOG_ERROR "UpdateWindow error code:[%08X]", eax
jmp Finish
.else
LOG_INFO "UpdateWindow success, eax[%08X]", eax
.endif

MesLoop:
invoke GetMessageA, offset Msg, 0, 0, 0
.if eax == 0
LOG_INFO "GetMessageA quit message:[%08X]", eax
jmp Finish
.elseif eax == -1
invoke GetLastError
LOG_ERROR "GetMessageA error code:[%08X]", eax
jmp Finish
.else
LOG_INFO "GetMessageA another message had got:[%08X]", eax
.endif
invoke TranslateMessage, offset Msg
invoke DispatchMessageA, offset Msg
jmp MesLoop

Finish:
invoke ExitProcess, [Msg.wParam]

MasmTry proc hwnd:dword, mes:dword, lParam:dword, wParam:dword

.if mes == WM_LBUTTONDOWN

	invoke MessageBoxA, hwnd, offset lpBuf, offset lpBuf2, 0
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "MessageBoxA error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "MessageBoxA success, eax[%08X]", eax
	.endif

.elseif mes == WM_DESTROY
	invoke PostQuitMessage, 0
	mov eax, 0

.elseif mes == WM_COMMAND
	.if lParam == 5
		invoke MessageBoxA, hwnd, offset lpExitString, 0, 0
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "MessageBoxA error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "MessageBoxA success, eax[%08X]", eax
		.endif
		invoke PostQuitMessage, 0
	.endif
.else
	invoke DefWindowProcA, hwnd, mes, lParam, wParam
.endif

ret
MasmTry endp

end start