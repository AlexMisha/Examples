.686P
.model flat, stdcall
option casemap:none
;-------------------------------------
dwStyle equ 000CF0000H
Style equ CS_HREDRAW + CS_VREDRAW + CS_GLOBALCLASS

	include \masm32\include\windows.inc
	include \masm32\include\user32.inc
	include \masm32\include\kernel32.inc
	include \masm32\include\gdi32.inc
	include \masm32\macros\macros.asm
	include \masm32\projects\Examples\TryMasm 2-0\src\include\Log.inc
	include \masm32\projects\Examples\TryMasm 2-0\src\include\PushMacro.inc
	include \masm32\projects\Examples\TryMasm 2-0\src\include\ButnHandlers.inc
	include \masm32\projects\Examples\TryMasm 2-0\src\include\PaintHandlers.inc
	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\gdi32.lib

	PaintMessageHandler PROTO :dword, :dword, :dword, :dword
	CreateMessageHandler PROTO :dword, :dword, :dword, :dword
	CommandMessageHandler PROTO :dword, :dword, :dword, :dword
	
.data
	lpClassName db 'Class32', 0
	lpWindowName db 'MasmTry-2', 0
	Butn1 db 'Exit', 0
	Butn2 db 'Message', 0
	Butn3 db 'Paint',0
	Butn4 db 'Enter',0
	Edit db 'Edit',0
	sStringForTest db 'Set up your string...',0
	sGotString db 255
	
	hInstance dword 0
	hButn1 dword 0
	hButn2 dword 0
	hButn3 dword 0
	hButn4 dword 0
	hWindow dword 0
	hEdit dword 0
	PaintMessage dword 0
	
	wc WNDCLASSA <?>
	Msg MSG <?>
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

	invoke LoadIconA, hInstance, 1
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
	
	invoke CreateWindowExA, Style, offset lpClassName, offset lpWindowName, dwStyle, 100, 100, 650, 400, 0, 0, hInstance, 0
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
	.endif
	invoke TranslateMessage, offset Msg
	invoke DispatchMessageA, offset Msg
jmp MesLoop
	
Finish:
	invoke ExitProcess, 0

MasmTry proc hwnd:dword, mes:dword, lParam:dword, wParam:dword
	.if mes == WM_DESTROY
		invoke PostQuitMessage, 0
		mov eax, 0
	.elseif mes == WM_PAINT
		invoke PaintMessageHandler, hwnd, mes, lParam, wParam
		mov eax, 0
		
	.elseif mes == WM_CREATE
		invoke CreateMessageHandler, hwnd, mes, lParam, wParam
		mov eax, 0
		
	.elseif mes == WM_RBUTTONDOWN
		invoke PostQuitMessage, 0
		mov eax, 0
		
	.elseif mes == WM_LBUTTONDOWN
		invoke MessageBoxA, hwnd, offset sInfoExitString, offset lpWindowName,0
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "MessageBoxA error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "MessageBoxA success, eax[%08X]", eax
		.endif
		
	.elseif mes == WM_COMMAND
		invoke CommandMessageHandler, hwnd, mes, lParam, wParam
		mov eax, 0
		
	.else
		invoke DefWindowProcA, hwnd, mes, lParam, wParam
	.endif
ret
MasmTry endp

PaintMessageHandler proc hwnd, mes, lParam, wParam

	invoke TextOutHandler, hwnd, mes, lParam, wParam
	invoke RectangleHandler, hwnd, mes, lParam, wParam
	mov eax, 0
	
ret
PaintMessageHandler endp

CreateMessageHandler proc hwnd, msg, lParam, wParam

	PushButton addr Butn1, hwnd, 500, 300, 100, 25
	mov hButn1, eax
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "CreateWindowExA error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "CreateWindowExA success, eax[%08X]", eax
	.endif

	PushButton addr Butn2, hwnd, 500, 50, 100, 25
	mov hButn2, eax
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "CreateWindowExA error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "CreateWindowExA success, eax[%08X]", eax
	.endif
	
	PushButton addr Butn3, hwnd, 500, 100, 100, 25
	mov hButn3, eax
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "CreateWindowExA error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "CreateWindowExA success, eax[%08X]", eax
	.endif
	
	PushButton addr Butn4, hwnd, 305, 150, 50, 20
	mov hButn4, eax
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "CreateWindowExA error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "CreateWindowExA success, eax[%08X]", eax
	.endif
	
	PushEdit addr Edit, hwnd, 50, 150, 250, 20
	mov hEdit, eax
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "CreateWindowExA error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "CreateWindowExA success, eax[%08X]", eax
	.endif
	mov esi, offset hEdit
	mov edi, offset hEdit_
	movsd 
	
	invoke SendMessage, hEdit, WM_SETTEXT, 0, offset sStringForTest
	
ret
CreateMessageHandler endp

CommandMessageHandler proc hwnd, mes, lParam, wParam
	mov eax, hButn1
	.if wParam == eax
		invoke Butn1Handler, hwnd, mes, lParam, wParam
	.endif
	xor eax, eax
	mov eax, hButn2
	.if wParam == eax
		invoke Butn2Handler, hwnd, mes, lParam, wParam
	.endif
	xor eax,eax
	mov eax, hButn3
	.if wParam == eax
		invoke Butn3Handler, hwnd, mes, lParam, wParam
	.endif
	xor eax,eax
	mov eax, hButn4
	.if wParam == eax
		invoke Butn4Handler, hwnd, mes, lParam, wParam
	.endif
ret

CommandMessageHandler endp
end start