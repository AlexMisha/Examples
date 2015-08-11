.686P
.MODEL FLAT, stdcall
option casemap :none
;------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\macros\macros.asm
include \masm32\projects\Examples\TryMasm\src\include\Log.inc
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
	CreateWindowExA_Err db 'CreateWindowExA_Error', 0
	CreateWindowExA_SCS db 'CreateWindowExA_Success',0
	GetModuleHandleA_Err db 'GetModuleHandleA_Error', 0
	GetModuleHandleA_SCS db 'GetModuleHandleA_Success',0
	LoadIconA_Err db 'LoadIconA_Error',0
	LoadIconA_SCS db 'LoadIconA_Success',0
	LoadCursorA_Err db 'LoadCursorA_Error',0
	LoadCursorA_SCS db 'LoadCursorA_Success',0
	CreateSolidBrush_Err db 'CreateSolidBrush_Error',0
	CreateSolidBrush_SCS db 'CreateSolidBrush_Success',0
	RegisterClassA_Err db 'RegisterClassA_Error', 0
	RegisterClassA_SCS db 'RegisterClassA_Success',0
	UpdateWindow_Err db 'UpdateWindow_Error', 0
	UpdateWindow_SCS db 'UpdateWindow_Success',0
	QuitMessage db 'QuitMessagee had got',0
	GetMessageA_Err db 'GetMessageA_Error',0
	MessageGot db 'Another Message had got',0
.code
start:

invoke GetModuleHandleA, 0
mov hInstance, eax

.if eax == 0
invoke GetLastError
LOG_ERROR "%s[%08X]", addr GetModuleHandleA_Err, eax
jmp Finish
.else
LOG_INFO "%s", addr GetModuleHandleA_SCS
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
LOG_ERROR "%s[%08X]", addr LoadIconA_Err, eax
jmp Finish
.else
LOG_INFO "%s", addr LoadIconA_SCS
.endif

invoke LoadCursorA, 0, IDC_ARROW
mov [wc.hCursor], eax

.if eax == 0
invoke GetLastError
LOG_ERROR "%s[%08X]", addr LoadCursorA_Err, eax
jmp Finish
.else
LOG_INFO "%s", addr LoadCursorA_SCS
.endif

invoke CreateSolidBrush, COLOR_DESKTOP
mov [wc.hbrBackground], eax

.if eax == 0
invoke GetLastError
LOG_ERROR "%s[%08X]", addr CreateSolidBrush_Err, eax
jmp Finish
.else
LOG_INFO "%s", addr CreateSolidBrush_SCS
.endif

mov dword ptr [wc.lpszMenuName], 0
mov dword ptr [wc.lpszClassName], offset lpClassName

invoke RegisterClassA, offset wc

.if eax == 0
invoke GetLastError
LOG_ERROR "%s[%08X]", addr RegisterClassA_Err, eax
jmp Finish
.else
LOG_INFO "%s", addr RegisterClassA_SCS
.endif

invoke CreateWindowExA, Style, offset lpClassName, offset lpWindowName, dwStyle, 100, 100, 500, 200, 0, 0, hInstance, 0
mov hWindow, eax

.if eax == 0
invoke GetLastError
LOG_ERROR "%s[%08X]", addr CreateWindowExA_Err, eax
jmp Finish
.else
LOG_INFO "%s", addr CreateWindowExA_SCS
.endif

invoke ShowWindow, hWindow, SW_SHOWNORMAL
invoke UpdateWindow, hWindow

.if eax == 0
invoke GetLastError
LOG_ERROR "%s[%08X]", addr UpdateWindow_Err, eax
jmp Finish
.else
LOG_INFO "%s", addr UpdateWindow_SCS
.endif

MesLoop:
invoke GetMessageA, offset Msg, 0, 0, 0
.if eax == 0
LOG_INFO "%s", addr QuitMessage
jmp Finish
.elseif eax == -1
invoke GetLastError
LOG_ERROR "%s[%08X]", addr GetMessageA_Err, eax
jmp Finish
.else
LOG_INFO "%s", addr MessageGot
.endif
invoke TranslateMessage, offset Msg
invoke DispatchMessageA, offset Msg
jmp MesLoop

Finish:
invoke ExitProcess, [Msg.wParam]

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
	