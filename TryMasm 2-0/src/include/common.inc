Butn1Handler PROTO :dword, :dword, :dword, :dword
Butn2Handler PROTO :dword, :dword, :dword, :dword
Butn3Handler PROTO :dword, :dword, :dword, :dword
Butn4Handler PROTO :dword, :dword, :dword, :dword
TextOutHandler PROTO :dword, :dword, :dword, :dword
RectangleHandler PROTO :dword, :dword, :dword, :dword


.data
	hCreateEdit dword 0
	PaintMessage dword 0
	hInstance dword 0
	hButn1 dword 0
	hButn2 dword 0
	hButn3 dword 0
	hButn4 dword 0
	hWindow dword 0
	hEdit dword 0
	hEdit2 dword 0
	hBrush dword 0
	
	sInfoExitString db 'Right click for exit',0
	sReveredString db 256 dup (0)
	sGotString db 255