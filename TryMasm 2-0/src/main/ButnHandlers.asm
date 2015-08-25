.686p
.model flat, stdcall
option casemap:none

	include \masm32\include\windows.inc
	include \masm32\include\user32.inc
	include \masm32\include\kernel32.inc
	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib
	includelib build\szrev.lib
	includelib build\szlen.lib
	include \masm32\projects\Examples\TryMasm 2-0\src\include\common.inc
	include \masm32\projects\Examples\TryMasm 2-0\src\include\Log.inc
szRev PROTO :dword, :dword

.data
	sMessage db 'Message',0
	sGotString db 256 dup (?) 

.code
Butn1Handler proc hwnd, mes, lParam, wParam
	invoke PostQuitMessage, 0
ret
Butn1Handler endp

Butn2Handler proc hwnd, mes, lParam, wParam
	invoke MessageBox, hwnd, offset sMessage, offset sMessage, 0
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "MessageBoxA error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "MessageBoxA success, eax[%08X]", eax
	.endif
Finish:
ret
Butn2Handler endp

Butn3Handler proc hwnd, mes, lParam, wParam
	mov PaintMessage, 1
	invoke SendMessage, hwnd, WM_PAINT, 0, 0
ret
Butn3Handler endp

Butn4Handler proc hwnd, mes, lParam, wParam
LOG_DEBUG "Enter button activated", eax
	invoke SendMessage, hEdit, WM_GETTEXT, 150, offset sGotString
LOG_DEBUG "SendMessage OK", eax
	invoke szRev, addr sGotString, addr sReveredString
	push eax
LOG_DEBUG "szRev OK", eax
	pop eax
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "szRev error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "szRev success, eax[%08X]", eax
	.endif
	mov hCreateEdit, 1
	invoke SendMessage, hwnd, WM_CREATE, 0, 0
Finish:
ret
Butn4Handler endp
end