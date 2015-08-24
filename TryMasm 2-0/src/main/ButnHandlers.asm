Butn1Handler PROTO :dword, :dword, :dword, :dword
Butn2Handler PROTO :dword, :dword, :dword, :dword
Butn3Handler PROTO :dword, :dword, :dword, :dword
Butn4Handler PROTO :dword, :dword, :dword, :dword
szRev PROTO :dword, :dword

.data
	sMessage db 'Message',0
	hEdit_ dword 0
	sGotString db 256 dup (?)
	sReveredString db 256 dup (?) 

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
ret
Butn2Handler endp

Butn3Handler proc hwnd, mes, lParam, wParam
	mov PaintMessage, 1
	invoke SendMessage, hwnd, WM_PAINT, 0, 0
ret
Butn3Handler endp

Butn4Handler proc hwnd, mes, lParam, wParam
	invoke SendMessage, hEdit_, WM_GETTEXT, 150, addr sGotString
	invoke szRev, offset sGotString, offset sReveredString
	.if eax == 0
		invoke GetLastError
		LOG_ERROR "szRev error code:[%08X]", eax
		jmp Finish
	.else
		LOG_INFO "szRev success, eax[%08X]", eax
	.endif
	mov hCreateEdit, 1
	invoke SendMessage, hwnd, WM_CREATE, 0, 0
ret
Butn4Handler endp

