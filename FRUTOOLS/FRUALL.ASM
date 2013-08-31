include inc\standard.inc
.model small
.386
.data
PSP             dw      0
EXEName0        db      'MACADDR.EXE', 0 
ParmBlock0      dw      0
                dd      ParaLineSize0
                dd      Dummy
                dd      Dummy
ParaLineSize0   db      0
ParameterLine0  db      0
Parameter0      db      80 dup(0)
;
EXEName         db      'BUILD.EXE', 0 
ParmBlock       dw      0
                dd      ParaLineSize
                dd      Dummy
                dd      Dummy
ParaLineSize    db      0
ParameterLine   db      0
Parameter       db      80 dup(0)
;
EXEName1        db      'KCS.EXE', 0 
ParmBlock1      dw      0
                dd      ParaLineSize1
                dd      Dummy
                dd      Dummy
ParaLineSize1   db      0
ParameterLine1  db      ' C0 25 01', 0dh
Parameter1      db      80 dup(0)
;
EXEName2        db      'FRURW.EXE', 0 
ParmBlock2      dw      0
                dd      ParaLineSize2
                dd      Dummy
                dd      Dummy
ParaLineSize2   db      0
ParameterLine2  db      ' /W', 0dh
Parameter2      db      80 dup(0)
;
EXEName3        db      'KCS.EXE', 0 
ParmBlock3      dw      0
                dd      ParaLineSize3
                dd      Dummy
                dd      Dummy
ParaLineSize3   db      0
ParameterLine3  db      ' C0 25 00', 0dh
Parameter3      db      80 dup(0)
;
Dummy           db      20 dup(?)
MemoryFail      db      7,7,7,'Memory not enough!!',10, 13, 24h
.stack
.code
; EXTERN  (EmptyRoutine):FAR
Testa proc far
        push    ds
        xor     ax, ax
        push    ax 
        mov     ax, @data
        mov     ds, ax
        mov     ax, es
        mov     PSP, ax
;        
        mov     bx, seg TempSegment
        mov     ax, es
        sub     bx, ax
        mov     ah, 4ah
        int     21h
        jnc     Allocate_OK
        Print   MemoryFail
        jmp     exit
Allocate_OK:
;
        mov     al, sizeof ParameterLine0	; ParameterLine0  db      0
        mov     ParaLineSize0, al
        mov     ax, 4B00H			; Load or execute (INT 21h, 4Bh - EXEC)
        mov     dx, offset EXEName0		; filename 'MACADDR.EXE'
        mov     bx, offset ParmBlock0
        push    ds
        pop     es
        int     21h
        jc      exit

        outchar 0ah
        outchar 0dh
        mov     al, sizeof ParameterLine	; ParameterLine   db      0
        mov     ParaLineSize, al
        mov     ax, 4B00H
        mov     dx, offset EXEName		; filename 'BUILD.EXE'
        mov     bx, offset ParmBlock
        push    ds
        pop     es
        int     21h
        jc      exit

        call    CheckBMCPresent                 
	jz	@f
        outchar 0ah
        outchar 0dh
        mov     al, sizeof ParameterLine1	; ParameterLine1  db      ' C0 25 01', 0dh
        mov     ParaLineSize1, al
        mov     ax, 4B00H
        mov     dx, offset EXEName1		; filename 'KCS.EXE'
        mov     bx, offset ParmBlock1
        push    ds
        pop     es
        int     21h
        jc      exit
@@:
        outchar 0ah
        outchar 0dh
        mov     al, sizeof ParameterLine2	; ParameterLine2  db      ' /W', 0dh
        mov     ParaLineSize2, al
        mov     ax, 4B00H
        mov     dx, offset EXEName2		; filename 'FRURW.EXE'
        mov     bx, offset ParmBlock2
        push    ds
        pop     es
        int     21h
        jc      exit

        call    CheckBMCPresent                 
	jz	@f
        outchar 0ah
        outchar 0dh
        mov     al, sizeof ParameterLine3	; ParameterLine3  db      ' C0 25 00', 0dh
        mov     ParaLineSize3, al
        mov     ax, 4B00H
        mov     dx, offset EXEName3		; filename 'KCS.EXE'
        mov     bx, offset ParmBlock3
        push    ds
        pop     es
        int     21h
        jc      exit
@@:
exit:
;       
        ret
Testa endp
;;---------------------------------------------------
CheckBMCPresent	PROC NEAR PUBLIC
	mov     dx, 0CA2h
	in      al, dx
	xchg    al, ah
	inc     dx
	in      al, dx
	inc     ax
	ret
CheckBMCPresent	ENDP
;;---------------------------------------------------
EmptyRoutine    proc
        ret
EmptyRoutine    endp
;;---------------------------------------------------
TempSegment Segment
TempSegment ends
end Testa

