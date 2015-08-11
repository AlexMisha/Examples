IFNDEF _loginc_
_loginc_ equ 1

DEBUG_LEVEL equ 4
INFO_LEVEL equ 3
WARN_LEVEL equ 2
ERROR_LEVEL equ 1

LOG_DEBUG macro FmtString, args:vararg
LOCAL buffer, SymbString
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
LOCAL buffer, SymbString
if LOG_LEVEL ge INFO_LEVEL
.data
 SymbString db "INFO: "
 db FmtString, 0
 buffer db 255 dup(?)
.code
invoke wsprintfA, addr buffer, addr SymbString, args
invoke OutputDebugString, addr buffer
endif
ENDM

LOG_WARN macro FmtString, args:vararg
LOCAL buffer, SymbString
if LOG_LEVEL ge WARN_LEVEL
.data
 SymbString db "WARN: " 
 db FmtString, 0
 buffer db 255 dup(?)
.code
invoke wsprintfA, addr buffer, addr SymbString, args
invoke OutputDebugString, addr buffer
endif
ENDM

LOG_ERROR macro FmtString, args:vararg
LOCAL buffer, SymbString
if LOG_LEVEL ge ERROR_LEVEL
.data
 SymbString db "ERROR: "
 db FmtString, 0
 buffer db 255 
.code
invoke wsprintfA, addr buffer, addr SymbString, args
invoke OutputDebugString, addr buffer
endif
ENDM

else 
echo ------------------------------------------
echo WARNING Duplicate include file Log.inc
echo ------------------------------------------
endif