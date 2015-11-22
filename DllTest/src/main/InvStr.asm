.686p
.model flat,stdcall
option casemap:none
;--------------------------------------------------------------------
	PUBLIC InvStr

	include \masm32\include\windows.inc
	include \masm32\include\user32.inc
	include \masm32\include\kernel32.inc
	includelib c:\masm32\lib\user32.lib
	includelib c:\masm32\lib\kernel32.lib
.data
	lpText1 db 'Entry in library',0
	lpText2 db 'Way out from library',0
	lpMsg db 'Message from library',0
	lpText db 'DLL active',0
.code
DllEntry:
mov eax, dword ptr[0Ch]
.if eax == 0
mov eax, 1
.endif
ret 12

InvStr proc EXPORT lpSrcString:dword, lpResBuf:dword, _Size:dword
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
InvStr endp
end DllEntry