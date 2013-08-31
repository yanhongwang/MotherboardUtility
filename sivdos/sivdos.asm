	;---------------------------------------------------
; SR147 Fan Control version 1.0  <Bobby Chiu>
;---------------------------------------------------
.model small
.386
include inc\standard.inc
;
.DATA
A0_AX		    dw	    0
A0_BX		    dw	    0
A0_CX		    dw	    0
C0_CX		    dw	    0
D0_CX		    dw	    0
;
MsgBufferData       db      10 dup(0), 24h
;
KeyTable            db      1Bh
                    dw      Esc_Key
                    db      0
box db 'ีออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ'
    db 'ณ                        SR147 SIV Test                                Ver 0.1 ณ'
    db 'ิออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ'
    db '            CPU TEMP       = N/A   C                                            '
    db '            SYS TEMP       = N/A   C                                            '
    db '            CPUFan Speed   = N/A   PRM                                          '
    db '            SYSFan1 Speed  = N/A   PRM                                          '
    db '            SYSFan2 Speed  = N/A   PRM                                          '
    db '            SYSFan3 Speed  = N/A   PRM                                          '
    db '            SYSFan4 Speed  = N/A   PRM                                          '
    db '            SYSFan5 Speed  = N/A   PRM                                          '
    db '            PWRFan Speed   = N/A   PRM                                          ' 
    db '            12V	           = N/A   V					        '
    db '            5V		   = N/A   V					        '
    db '            VCORE	   = N/A   V					        '
    db '            VCC3	   = N/A   V					        '
    db '            5VSB           = N/A   V					        '
    db '	    VBAT	   = N/A   V					        '
    db 'ีออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ'
    db 'ณ                               ESC KEY: Exit                                  ณ'
    db 'ิออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ$'

.CODE  
;;---------------------------------------------------
CmpKey macro
    local ReTest1, Contine, Find, InKey

        waitkey2
ReTest1:
        cmp     byte ptr [si], 0
        jnz     Contine
        jmp     InKey
Contine:
        cmp     al, [si]
        je      Find
        inc     si
        inc     si
        inc     si
        jmp     ReTest1
Find:
        inc     si
        jmp     word ptr [si]
InKey:
endm

Begin:	mov  ax, @data
	mov  ds, ax
;
        Cursor_Off
;
        call    Display_Menu
;
        mov    ah, 0a0h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al 
	mov    A0_AX, ax
	mov    A0_BX, bx
	mov    A0_CX, cx
;
        mov    ah, 0c0h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al 
	mov    C0_CX, cx
;
        mov    ah, 0d0h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al 
	mov    D0_CX, Cx
;
Display_Sensor_Loop:
        call    Display_Sensor
;
Wait_Key:
        mov     si, offset KeyTable
        CmpKey
	jmp     short Display_Sensor_Loop
Esc_Key:
        Cursor_On
        mov     ax, 3
        int     10h
        popa
;
        mov     ah, 4ch
        int     21h
;;---------------------------------------------------
Display_Menu proc
        pusha
;
        SCROLL_UP 0, 00BH,  0,  0, 17, 79
        SCROLL_UP 0, 01FH,  0,  0,  2, 79
        SCROLL_UP 0, 02FH,  3, 29, 17, 33
        SCROLL_UP 0, 04FH, 18,  0, 20, 79
;
        Locate  0, 0
        Print   box
;
        popa
        ret
Display_Menu endp

Display_Sensor proc
        pusha
; 
        call   GetSystemTemp 
	call   GetCPUTemp 
;
	call   GetCPUFanSpeed
	call   GetPowerFanSpeed 
	call   GetSystem1FanSpeed
	call   GetSystem2FanSpeed
	call   GetSystem3FanSpeed
	call   GetSystem4FanSpeed
	call   GetSystem5FanSpeed
; 
	call   GetVCORE
	call   Get5V
	call   Get12V
	call   GetVBAT
	call   Get5VSB
	call   GetVCC3
;
        popa
        ret
Display_Sensor endp
;=============================================================================
GetCPUTemp proc
 	pusha
	test   	A0_BX, 00000010b
	jz      @F
;
        Locate  3, 29
;
        mov    ah, 0a1h
	mov    bl, 0a1h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al
;        
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 6
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetCPUTemp endp
;=============================================================================
GetSystemTemp proc
 	pusha
	test   	A0_BX, 00000001b
	jz      @F
;
        Locate  4, 29
;
        mov    ah, 0a1h
	mov    bl, 0a0h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al
;        
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 6
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetSystemTemp endp
;=============================================================================
GetCPUFanSpeed proc
 	pusha
	test   	A0_CX, 00000001b
	jz      @F
;        
        Locate  5, 29
;
        mov    ah, 0a2h
	mov    bl, 0a0h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al
;
	and     eax, 0FFFFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 4
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetCPUFanSpeed endp
;=============================================================================
GetSystem1FanSpeed proc
 	pusha
	test   	C0_CX, 00000001b
	jz      @F
;
        Locate  6, 29
;
        mov    ah, 0c2h
	mov    bl, 0a0h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	and     eax, 0FFFFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 4
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetSystem1FanSpeed endp
;=============================================================================
GetSystem2FanSpeed proc
 	pusha
	test   	C0_CX, 00000010b
	jz      @F
;
        Locate  7, 29
;
        mov    ah, 0c2h
	mov    bl, 0a1h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	and     eax, 0FFFFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 4
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetSystem2FanSpeed endp
;=============================================================================
GetSystem3FanSpeed proc
 	pusha
	test   	C0_CX, 00000100b
	jz      @F
;
        Locate  8, 29
;
        mov    ah, 0c2h
	mov    bl, 0a2h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	and     eax, 0FFFFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 4
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetSystem3FanSpeed endp
;=============================================================================
GetSystem4FanSpeed proc
 	pusha
	test   	D0_CX, 00000001b
	jz      @F

;
        Locate  9, 29
;
        mov    ah, 0d2h
	mov    bl, 0a0h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	and     eax, 0FFFFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 4
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetSystem4FanSpeed endp
;=============================================================================
GetSystem5FanSpeed proc
 	pusha
	test   	D0_CX, 00000010b
	jz      @F
;
        Locate 10, 29
;
        mov    ah, 0d2h
	mov    bl, 0a1h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	and     eax, 0FFFFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 4
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetSystem5FanSpeed endp
;=============================================================================
GetPowerFanSpeed proc
 	pusha
	test   	A0_CX, 00000100b
	jz      @F
;
        Locate 11, 29
;
        mov    ah, 0a2h
	mov    bl, 0a2h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	and     eax, 0FFFFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 4
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetPowerFanSpeed endp
;=============================================================================
Get12V proc
 	pusha
	test   	A0_AX, 00000001b
	jz      @F
;
        Locate 12, 29
;
        mov    ah, 0a3h
	mov    bl, 0a0h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	push    bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
        Locate 12, 31

;
	OutChar	'.'
;
        pop	bx
	mov     ax, bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
Get12V endp
;=============================================================================
Get5V proc
 	pusha
	test   	A0_AX, 00000010b
	jz      @F
;
        Locate 13, 29
;
        mov    ah, 0a3h
	mov    bl, 0a1h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	push    bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
        Locate 13, 31

;
	OutChar	'.'
;
        pop	bx
	mov     ax, bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
Get5V endp
;=============================================================================
GetVCORE proc
 	pusha
	test   	A0_AX, 00001000b
	jz      @F
;
        Locate 14, 29
;
        mov    ah, 0a3h
	mov    bl, 0a3h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	push    bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
        Locate 14, 31

;
	OutChar	'.'
;
        pop	bx
	mov     ax, bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetVCORE endp
;=============================================================================
GetVCC3 proc
 	pusha
	test   	A0_AX, 00010000b
	jz      @F
;
        Locate 15, 29
;
        mov    ah, 0a3h
	mov    bl, 0a4h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	push    bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
        Locate 15, 31

;
	OutChar	'.'
;
        pop	bx
	mov     ax, bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetVCC3 endp
;=============================================================================
Get5VSB proc
 	pusha
	test   	A0_AX, 00100000b
	jz      @F
;
        Locate 16, 29
;
        mov    ah, 0a3h
	mov    bl, 0a5h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	push    bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
        Locate 16, 31

;
	OutChar	'.'
;
        pop	bx
	mov     ax, bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
Get5VSB endp
;=============================================================================
GetVBAT proc
 	pusha
	test   	A0_AX, 01000000b
	jz      @F
;
        Locate 17, 29
;
        mov    ah, 0a3h
	mov    bl, 0a6h
	mov    al, 060h
	mov    dx, 0b2h
	out    dx, al        
;
	push    bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
        Locate 17, 31

;
	OutChar	'.'
;
        pop	bx
	mov     ax, bx
;
	and     eax, 0FFh
        Hex2Dec MsgBufferData
        mov     dx, offset MsgBufferData
	add     dx, 7
        mov     ah, 9h
        int     21h
;
@@:
	popa
        ret
GetVBAT endp
;=============================================================================

.STACK
;=============================================================================
        END     Begin
