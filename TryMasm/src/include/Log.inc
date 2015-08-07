IFNDEF _loginc_
_loginc_ equ 1

DEBUG_LEVEL equ 4
INFO_LEVEL equ 3
WARN_LEVEL equ 2
ERROR_LEVEL equ 1

LOG_DEBUG macro FmtString, args:vararg
if LOG_LEVEL ge DEBUG_LEVEL
.data
 SymbString db "DEBUG: " 
 db FmtString, 0
 buffer db 255 dup(?)
.code
invoke wsprintfA, addr buffer, addr SymbString, args
invoke OutputDebugString, addr buffer
endif
ENDM

LOG_INFO macro FmtString, args:vararg
if LOG_LEVEL ge INFO_LEVEL
.data
 SymbString2 db "INFO: "
 db FmtString, 0
 buffer2 db 255 dup(?)
.code
invoke wsprintfA, addr buffer2, addr SymbString2, args
invoke OutputDebugString, addr buffer2
endif
ENDM

LOG_WARN macro FmtString, args:vararg
if LOG_LEVEL ge WARN_LEVEL
.data
 SymbString3 db "WARN: " 
 db FmtString, 0
 buffer3 db 255 dup(?)
.code
invoke wsprintfA, addr buffer3, addr SymbString3, args
invoke OutputDebugString, addr buffer3
endif
ENDM

LOG_ERROR macro FmtString, args:vararg
if LOG_LEVEL ge ERROR_LEVEL
.data
 SymbString4 db "ERROR: "
 db FmtString, 0
 buffer4 db 255 dup(?)
.code
invoke wsprintfA, addr buffer4, addr SymbString4, args
invoke OutputDebugString, addr buffer4
endif
ENDM

else 
echo ------------------------------------------
echo WARNING Duplicate include file Log.inc
echo ------------------------------------------
endif