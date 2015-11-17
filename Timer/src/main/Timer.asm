.686p
.model flat, stdcall
option casemap:none
;------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\macros\macros.asm
include \masm32\projects\Examples\Timer\src\include\Log.inc
include \masm32\projects\Examples\Timer\src\include\PushMacro.inc
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
	hExitButton dword 0
	YT dword 30
	XT dword 30
	wc WNDCLASSA <?>
	Paint PAINTSTRUCT <?>
	Msg MSG <?>
	ExitButton db 'Exit', 0
	count dword 0
	hPaint dword 0
	lpOut db 100
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
mov [wc.lpfnWndProc], offset WndProc
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

mov dword ptr [wc.lpszMenuName], 0
mov dword ptr [wc.lpszClassName], offset lpClassName

invoke RegisterClassA, offset wc

.if eax == 0
invoke GetLastError
LOG_ERROR "RegisterClassA error code:[%08X]", eax
jmp Finish
.else
LOG_INFO "RegisterClassA success, eax[%08X]", eax
.endif

invoke CreateWindowExA, Style, offset lpClassName, offset lpWindowName, dwStyle, 100, 100, 500, 250, 0, 0, hInstance, 0
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
invoke ExitProcess, 0

WndProc proc hwnd:dword, uMsg:dword, wParam, lParam
.if uMsg == WM_CLOSE
	invoke KillTimer, hwnd, 1
	invoke PostQuitMessage, 0
.elseif uMsg == WM_CREATE
	PushButton addr ExitButton, hwnd, 400, 150, 75, 30
	mov hExitButton, eax
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "PushButton error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "PushButton success, eax[%08X]", eax
	.endif
	invoke SetTimer, hwnd, 1, 1000, 0
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "SetTimer error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "SetTimer success, eax[%08X]", eax
	.endif
.elseif uMsg == WM_TIMER
	inc count
	invoke SendMessage, hwnd, WM_PAINT, 0, 0
	.if count == 10
	invoke PostQuitMessage, 0
	.endif
.elseif uMsg == WM_COMMAND
	mov eax, hExitButton
	.if lParam == eax
	invoke PostQuitMessage, 0
	.endif
.else
	invoke DefWindowProc, hwnd, uMsg, wParam, lParam
.endif
ret
WndProc endp
end start