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
	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\gdi32.lib
	include \masm32\projects\Examples\TryMasm 2-0\src\include\PushButton.inc

.data
	lpClassName db 'Class32', 0
	lpWindowName db 'MasmTry-2', 0
	Butn1 db 'Exit', 0
	Butn2 db 'Message', 0
	Butn3 db 'Paint',0
	hInstance dword 0
	hButn1 dword 0
	hButn2 dword 0
	hButn3 dword 0
	hWindow dword 0
	hBrush dword 0
	wc WNDCLASSA <?>
	Paint PAINTSTRUCT <?>
	Msg MSG <?>
	hPaint dword 0
	sMessage db 'Message',0
	sInfoExitString db 'Right click for exit',0
	sInfoMessageString db 'Left click for message',0
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
	.else
		LOG_INFO "GetMessageA another message had got:[%08X]", eax
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
		invoke BeginPaint, hwnd, offset Paint
		mov hPaint, eax
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "BeginPaint error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "BeginPaint success, eax[%08X]", eax
		.endif

		invoke SetBkColor, addr hPaint, White	
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "SetBkColor error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "SetBkColor success, eax[%08X]", eax
		.endif

		invoke SetTextColor, addr hPaint, Black
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "SetTextColor error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "SetTextColor success, eax[%08X]", eax
		.endif
	
		invoke TextOutA, hPaint, 50, 50, offset sInfoExitString, lengthof sInfoExitString
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "TextOutA error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "TextOutA success, eax[%08X]", eax
		.endif
	
		invoke TextOutA, hPaint, 50, 100, offset sInfoMessageString, lengthof sInfoMessageString
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "TextOutA error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "TextOutA success, eax[%08X]", eax
		.endif
	
		invoke EndPaint, hwnd, offset Paint
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "EndPaint error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "EndPaint success, eax[%08X]", eax
		.endif
	
		mov eax, 0
	.elseif mes == WM_CREATE
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
		mov eax, hButn1
		.if wParam == eax
			invoke PostQuitMessage, 0
		.endif
		xor eax, eax
		mov eax, hButn2
		.if wParam == eax
			invoke MessageBox, hwnd, offset sMessage, offset sMessage, 0
			.if eax == 0
				invoke GetLastError
				LOG_ERROR "MessageBoxA error code:[%08X]", eax
				jmp Finish
			.else
				LOG_INFO "MessageBoxA success, eax[%08X]", eax
			.endif
		.endif
		xor eax,eax
		mov eax, hButn3
		.if wParam == eax
			invoke CreateSolidBrush, Black
			mov hBrush, eax
			.if eax == 0
				invoke GetLastError
				LOG_ERROR "CreateSolidBrush error code:[%08X]", eax
				jmp Finish
			.else
				LOG_INFO "CreateSolidBrush success, eax[%08X]", eax
			.endif 
		
			invoke BeginPaint, hwnd, offset Paint
			mov hPaint, eax
			.if eax == 0
				invoke GetLastError
				LOG_ERROR "BeginPaint error code:[%08X]", eax
				jmp Finish
			.else
				LOG_INFO "BeginPaint success, eax[%08X]", eax
			.endif 
		
			invoke SelectObject, hPaint, hBrush
			.if eax == 0
				invoke GetLastError
				LOG_ERROR "SelectObject error code:[%08X]", eax
				jmp Finish
			.else
				LOG_INFO "SelectObject success, eax[%08X]", eax
			.endif 	
		
			invoke Ellipse, hPaint, 100, 100, 200, 150
			.if eax == 0
				invoke GetLastError
				LOG_ERROR "Ellipse error code:[%08X]", eax
				jmp Finish
			.else
				LOG_INFO "Ellipse success, eax[%08X]", eax
			.endif	
	
			invoke EndPaint, hwnd, offset Paint
			.if eax == 0
				invoke GetLastError
				LOG_ERROR "EndPaint error code:[%08X]", eax
				jmp Finish
			.else
				LOG_INFO "EndPaint success, eax[%08X]", eax
			.endif
		.endif
		mov eax, 0
	.else
		invoke DefWindowProcA, hwnd, mes, lParam, wParam
	.endif

ret
MasmTry endp

end start