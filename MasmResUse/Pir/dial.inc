; файл dial.inc
; константы

; сообщение приходит при закрытии окна
WM_CLOSE      equ 10h
WM_INITDIALOG equ 110h
WM_SETICON    equ 80h
; прототипы внешних процедур
EXTERN      MessageBoxA@16:NEAR
EXTERN      ExitProcess@4:NEAR
EXTERN      GetModuleHandleA@4:NEAR
EXTERN      DialogBoxParamA@20:NEAR
EXTERN      EndDialog@8:NEAR
EXTERN      LoadStringA@16:NEAR
EXTERN      LoadIconA@8:NEAR
EXTERN      SendMessageA@16:NEAR
; структуры
; структура сообщения
MSGSTRUCT STRUC
     MSHWND      DD ?
     MSMESSAGE   DD ?
     MSWPARAM    DD ?
     MSLPARAM    DD ?
     MSTIME      DD ?
     MSPT        DD ?
MSGSTRUCT ENDS