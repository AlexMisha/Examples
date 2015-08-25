.686P
.model flat, stdcall
option casemap:none

	include \masm32\include\windows.inc
	include \masm32\include\user32.inc
	include \masm32\include\kernel32.inc
	include \masm32\include\gdi32.inc
	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\gdi32.lib
	include \masm32\projects\Examples\TryMasm 2-0\src\include\common.inc
	include \masm32\projects\Examples\TryMasm 2-0\src\include\Log.inc

.data
	hPaint dword 0
	hPaint1 dword 0
	hBrush dword 0
	
	Paint PAINTSTRUCT <?>
	
	sInfoMessageString db 'Left click for message',0

.code
TextOutHandler proc hwnd, mes, lParam, wParam
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
Finish:
ret
TextOutHandler endp

RectangleHandler proc hwnd, mes, lParam, wParam

		invoke CreateSolidBrush, Blue
		mov hBrush, eax
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "CreateSolidBrush error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "CreateSolidBrush success, eax[%08X]", eax
		.endif

		invoke BeginPaint, hwnd, offset Paint
		mov hPaint1, eax
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "BeginPaint error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "BeginPaint success, eax[%08X]", eax
		.endif
		
		invoke SelectObject, hPaint1, hBrush
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "SelectObject error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "SelectObject success, eax[%08X]", eax
		.endif
			
		invoke Rectangle, hPaint1, 300, 300, 500, 500
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "Rectangle error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "Rectangle success, eax[%08X]", eax
		.endif
			
		invoke EndPaint, hwnd, offset Paint
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "EndPaint error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "EndPaint success, eax[%08X]", eax
		.endif
		mov PaintMessage, 0
		
		invoke UpdateWindow, hWindow
		.if eax == 0
			invoke GetLastError
			LOG_ERROR "UpdateWindow error code:[%08X]", eax
			jmp Finish
		.else
			LOG_INFO "UpdateWindow success, eax[%08X]", eax
		.endif

Finish:
ret
RectangleHandler endp 
end