

;���� dial.asm
.386P

; ������� ������
.MODEL FLAT, stdcall
include dial.inc

; ��������� ������������ ��� ����������� ���������
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
;--------------------------------------------------

; ������� ������
_DATA SEGMENT DWORD PUBLIC USE32 'DATA'
     MSG       MSGSTRUCT <?>
     HINST     DD 0 ; ���������� ����������
     PA        DB "DIAL1",0
     BUF1      DB 40 dup(0)
     BUF2      DB 40 dup(0)
_DATA ENDS

; ������� ����
_TEXT SEGMENT DWORD PUBLIC USE32 'CODE'
START:
; �������� ���������� ����������
     PUSH  0
     CALL  GetModuleHandleA@4
     MOV  [HINST],EAX
;------
; ��������� ������
     PUSH 40
     PUSH OFFSET BUF1
     PUSH 1
     PUSH [HINST]
     CALL LoadStringA@16
; ��������� ������
     PUSH 40
     PUSH OFFSET BUF2
     PUSH 2
     PUSH [HINST]
     CALL LoadStringA@16
;------------------------------------------------------------
     PUSH 0         ; MB_OK
     PUSH OFFSET BUF1
     PUSH OFFSET BUF2
     PUSH 0
     CALL MessageBoxA@16
; ������� ���������� ����
     PUSH 0
     PUSH OFFSET WNDPROC ; ��������� ����
     PUSH 0
     PUSH OFFSET PA   ; �������� ������� (DIAL1)
     PUSH [HINST]
     CALL DialogBoxParamA@20
     CMP EAX,-1
     JNE KOL
KOL:
     PUSH 0
     CALL ExitProcess@4
;--------------------------

; ��������� ����������� ����
; ������������ ���������� � �����
; [EBP+014�]  ; LPARAM
; [EBP+10H]   ; WAPARAM
; [EBP+0C�]   ; MES
; [EBP+8]     ; HWND
WNDPROC     PROC
     PUSH EBP
     MOV EBP,ESP
     PUSH EBX
     PUSH ESI
     PUSH EDI
;-----
     CMP DWORD PTR [EBP+0CH], WM_CLOSE
     JNE L1
     PUSH 0
     PUSH DWORD PTR [EBP+08H]
     CALL EndDialog@8
     JMP FINISH
L1:
     CMP DWORD PTR [EBP+0CH], WM_INITDIALOG
     JNE FINISH
; ��������� ������
     PUSH 3 ; ������������� ������
     PUSH [HINST] ; ������������� ��������
     CALL LoadIconA@8
; ���������� ������
     PUSH EAX
     PUSH 0 ; ��� ������ (���������)
     PUSH WM_SETICON
     PUSH DWORD PTR [EBP+08H]
     CALL SendMessageA@16
FINISH:
     POP EDI
     POP ESI
     POP EBX
     POP EBP
     MOV EAX, 0
     RET 16
WNDPROC    ENDP
_TEXT ENDS
END START

