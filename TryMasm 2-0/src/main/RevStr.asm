.686P
.model flat,stdcall
option casemap:none

	PUBLIC RevStr
	
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\user32.lib
	include \masm32\include\kernel32.inc
	include \masm32\include\user32.inc
	
.data

.code
;Function for revering given string
;lpSrcString - pointer to source string, terminated with 0
;lpResBuf - pointer to result buffer, where inverted string will be located
;_Size - size of given string
;End_error = 0, End_success = 1
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