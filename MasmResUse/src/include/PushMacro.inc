STYLBTN equ WS_CHILD + BS_DEFPUSHBUTTON + WS_VISIBLE + WS_TABSTOP
STYLEDIT equ WS_CHILD+WS_VISIBLE+WS_BORDER+WS_TABSTOP

.code
PushButton macro lpText,hParent,a,b,wd,ht
	LOCAL ButtonClass
	szText ButtonClass, "Button"
    invoke CreateWindowEx, 0, addr ButtonClass, lpText, STYLBTN, a, b, wd, ht, hParent, 0, hInstance, 0
ENDM

PushEdit macro lpNameEdit,hParent,a,b,wd,ht
	LOCAL EditClass
	szText EditClass, "Edit"
	invoke CreateWindowExA, 0, addr EditClass, lpNameEdit, STYLEDIT, a, b, wd, ht, hParent, 0, hInstance, 0
ENDM