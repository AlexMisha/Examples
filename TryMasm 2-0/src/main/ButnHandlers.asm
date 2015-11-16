.686p
.model flat, stdcall
option casemap:none

	include \masm32\include\windows.inc
	include \masm32\include\user32.inc
	include \masm32\include\kernel32.inc
	include \masm32\macros\macros.asm
	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib
	includelib build\szrev.lib
	include \masm32\projects\Examples\TryMasm 2-0\src\include\common.inc
	include \masm32\projects\Examples\TryMasm 2-0\src\include\Log.inc
;	includelib build\RevStr.lib
RevStr PROTO :dword, :dword, :dword
.data
	sMessage db 'Message',0 

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
	invoke SendMessage, hwnd, WM_PAINT, 0, 1
ret
Butn3Handler endp

RevStr proc lpSrcString:dword, lpResBuf:dword, _Size:dword
	.if lpSrcString == 0
		mov eax, 0
		jmp Finish
	.elseif lpResBuf == 0
		mov eax, 0
		jmp Finish
	.elseif _Size == 0
		mov eax, 0
		jmp Finish
	.elseif _Size > 256
		mov eax, 0
		jmp Finish
	.endif
	mov ecx, _Size
	mov esi, lpSrcString
	mov edi, lpResBuf
	add edi, ecx
	mov byte ptr [edi], 0
	dec edi
	xor eax, eax
InverCicle:
	.if ecx == 0
		jmp EndCicle
	.else
		mov al, byte ptr [esi]
		mov byte ptr [edi], al
		inc esi
		dec edi
		dec ecx
		xor eax, eax
		jmp InverCicle
	.endif
EndCicle:

	mov eax, 1
Finish:
ret
RevStr endp
end
