.686P
.MODEL FLAT, stdcall
option casemap :none
;------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\macros\macros.asm
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib
debug equ 0
dwStyle equ 000CF0000H
Style equ CS_HREDRAW + CS_VREDRAW + CS_GLOBALCLASS
 
log_message PROTO :dword

.data
	sString db 'Error code:', 0
	lpClassName db 'Class32', 0
	lpWindowName db 'Try', 0
	hInstance dword 0
	hWindow dword 0
	YT dword 30
	XT dword 30
	wc WNDCLASSA <?>
	Paint PAINTSTRUCT <?>
	Msg MSG <?>
.code
start:

invoke GetModuleHandleA, 0
mov hInstance, eax

mov [wc.style], Style
mov [wc.lpfnWndProc], offset MasmTry
mov [wc.cbClsExtra], 0
mov [wc.cbWndExtra], 0
mov eax, hInstance
mov [wc.hInstance], eax
invoke LoadIconA, 0, IDI_APPLICATION
mov [wc.hIcon], eax

invoke LoadCursorA, 0, IDC_ARROW
mov [wc.hCursor], eax

invoke CreateSolidBrush, COLOR_DESKTOP
mov [wc.hbrBackground], eax

mov dword ptr [wc.lpszMenuName], 0
mov dword ptr [wc.lpszClassName], offset lpClassName

invoke RegisterClassA, offset wc
.if eax == 0
invoke log_message, offset sString
jmp Finish
.endif
invoke CreateWindowExA, Style, offset lpClassName, offset lpWindowName, dwStyle, 100, 100, 500, 200, 0, 0, hInstance, 0

.if eax == 0
jmp Finish
.endif

mov hWindow, eax
invoke ShowWindow, hWindow, SW_SHOWNORMAL
invoke UpdateWindow, hWindow
MesLoop:
invoke GetMessageA, offset Msg, 0, 0, 0
.if eax == 0
jmp Finish
.endif
invoke TranslateMessage, offset Msg
invoke DispatchMessageA, offset Msg
jmp MesLoop

Finish:
invoke ExitProcess, [Msg.wParam]

log_message proc msg:dword
local buffer[256]:byte

invoke GetLastError
invoke wsprintfA, addr buffer, chr$("%s[%08X]"), msg, eax
invoke OutputDebugString, addr buffer

ret
log_message endp

MasmTry proc hwnd:dword, mes:dword, lParam:dword, wParam:dword

.if mes == WM_DESTROY
invoke PostQuitMessage, 0
mov eax, 0
.else
invoke DefWindowProcA, hwnd, mes, lParam, wParam
.endif

ret
MasmTry endp

end start
	