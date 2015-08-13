STYLBTN equ WS_CHILD + BS_DEFPUSHBUTTON + WS_VISIBLE + WS_TABSTOP

.code
PushButton macro lpText,hParent,a,b,wd,ht

szText ButtonClass, "Button"

    invoke CreateWindowEx, 0, addr ButtonClass , lpText, STYLBTN, a, b, wd, ht, hParent, 0, hInstance, 0

ENDM