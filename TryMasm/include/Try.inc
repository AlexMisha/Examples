
WM_DESTROY        equ 2
WM_CREATE         equ 1
WM_PAINT          equ 0FH
WM_LBUTTONDOWN    equ 201h
WM_RBUTTONDOWN    equ 204h 
; —в-ва окна
CS_VREDRAW        equ 1h
CS_HREDRAW        equ 2h
CS_GLOBALCLASS    equ 4000h
WS_EX_APPWINDOW equ 00040000h
stylcl        equ CS_HREDRAW + CS_VREDRAW + CS_GLOBALCLASS
DX0               equ 300
DY0               equ 200
; компоненты цветов
RED               equ 50
GREEN             equ 50
BLUE              equ 255
RGBW              equ (RED or (GREEN shl 8)) or (BLUE shl 16)
RGBT              equ 255 ; красный
; идентификатор стандартной иконки
IDI_APPLICATION   equ 32512
; идентификатор курсора
IDC_CROSS         equ 32515 
; режим показа окна Ч нормальный
SW_SHOWNORMAL     equ 1
; прототипы внешних процедур
