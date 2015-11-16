

;файл dial.asm
.386P

; плоская модель
.MODEL FLAT, stdcall
include dial.inc

; директивы компоновщику для подключения библиотек
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
;--------------------------------------------------

; сегмент данных
_DATA SEGMENT DWORD PUBLIC USE32 'DATA'
     MSG       MSGSTRUCT <?>
     HINST     DD 0 ; дескриптор приложения
     PA        DB "DIAL1",0
     BUF1      DB 40 dup(0)
     BUF2      DB 40 dup(0)
_DATA ENDS

; сегмент кода
_TEXT SEGMENT DWORD PUBLIC USE32 'CODE'
START:
; получить дескриптор приложения
     PUSH  0
     CALL  GetModuleHandleA@4
     MOV  [HINST],EAX
;------
; загрузить строку
     PUSH 40
     PUSH OFFSET BUF1
     PUSH 1
     PUSH [HINST]
     CALL LoadStringA@16
; загрузить строку
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
; создать диалоговое окно
     PUSH 0
     PUSH OFFSET WNDPROC ; процедура окна
     PUSH 0
     PUSH OFFSET PA   ; название ресурса (DIAL1)
     PUSH [HINST]
     CALL DialogBoxParamA@20
     CMP EAX,-1
     JNE KOL
KOL:
     PUSH 0
     CALL ExitProcess@4
;--------------------------

; процедура диалогового окна
; расположение параметров в стеке
; [EBP+014Н]  ; LPARAM
; [EBP+10H]   ; WAPARAM
; [EBP+0CН]   ; MES
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
; загрузить иконку
     PUSH 3 ; идентификатор иконки
     PUSH [HINST] ; идентификатор процесса
     CALL LoadIconA@8
; установить иконку
     PUSH EAX
     PUSH 0 ; тип иконки (маленькая)
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

