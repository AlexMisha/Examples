;Try.asm
.386P
; плоская модель
.MODEL FLAT, stdcall
option casemap :none
;------------------------------------------------------------
include c:\masm32\projects\Examples\TryMasm\include\Try.inc
include c:\masm32\include\windows.inc
; подключения библиотек
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\gdi32.lib

dwStyle equ 000CF0000H
dwExStyle equ 4003h

SetTextColor PROTO :dword, :dword
EndPaint PROTO :dword, :dword
DispatchMessageA PROTO :dword
TranslateMessage PROTO :dword
GetMessageA PROTO :dword, :dword, :dword, :dword
CreateWindowExA PROTO :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
GetLastError PROTO
CreateSolidBrush PROTO :dword
LoadCursorA PROTO :dword, :dword
LoadIconA PROTO :dword, :dword
RegisterClassA PROTO :dword
ExitProcess PROTO :dword
GetModuleHandleA PROTO :dword
ShowWindow PROTO :dword, :dword
UpdateWindow PROTO :dword
PostQuitMessage PROTO :dword
BeginPaint PROTO :dword, :dword
SetBkColor PROTO :dword, :dword
DefWindowProcA PROTO :dword, :dword, :dword, :dword
TextOutA PROTO :dword, :dword, :dword, :dword, :dword
Try PROTO :dword, :dword, :dword, :dword
MessageBoxA PROTO :dword, :dword, :dword, :dword

.data
	lpText db 'Hello, world!', 0
	wc WNDCLASSA <?>
	lpClassName db 'Message', 0
	lpWindowName db 'Try', 0
	hInstance dword 0
	hWindow dword 0
	Msg MSG <?>
	Paint PAINTSTRUCT <?>
	sMessage db 'Hello, world!', 0
	lpTitle db 'Message', 0
	YT dword 30
	XT dword 30
.code
start:

invoke GetModuleHandleA, 0
mov hInstance, eax

mov [wc.style], dwStyle
mov [wc.lpfnWndProc], offset Try
mov [wc.cbClsExtra], 0
mov [wc.cbWndExtra], 0
mov eax, hInstance
mov [wc.hInstance], eax
invoke LoadIconA, 0, IDI_APPLICATION
mov [wc.hIcon], eax

invoke LoadCursorA, 0, IDC_CROSS
mov [wc.hCursor], eax

invoke CreateSolidBrush, RGBW
mov [wc.hbrBackground], eax

mov dword ptr [wc.lpszMenuName], 0
mov dword ptr [wc.lpszClassName], offset lpClassName

invoke RegisterClassA, offset wc
invoke CreateWindowExA, dwExStyle, offset lpClassName, offset lpWindowName, wc.style, 100, 100, 500, 200, 0, 0, hInstance, 0

.if eax == 0
jmp Err
.endif

mov hWindow, eax
invoke ShowWindow, hWindow, SW_SHOWNORMAL
invoke UpdateWindow, hWindow
invoke MessageBoxA, hWindow, offset sMessage, offset lpTitle, 0

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

Err:
jmp Finish

Try proc hwnd:dword, mes:dword, lParam:dword, wParam:dword

.if mes == WM_DESTROY
invoke PostQuitMessage, 0
mov eax, 0
.else
invoke DefWindowProcA, hwnd, mes, lParam, wParam
.endif

ret
Try endp



end start
	