;---------------------------------------------------
;  Big Real mode macro file version 1.2   <Seed Fu>
;---------------------------------------------------
.model small
.386
.data
.stack
.code
SegDescriptor   STRUC
  DescLimit        DW 0000            ; Segment Limit byte field
  DescBaseLo       DW 0000            ; Segment base address (15-0)
  DescBaseHi       DB 00              ; Segment base address (23-16)
  DescAccess       DB 00              ; Access Rights byte
  DescLimit386     DB 00              ; Extended Limit (386/486)
  DescBase386      DB 00              ; Extended Base (386/486)
SegDescriptor   ENDS
;
PUBLIC          SetRealModeLimit
SetRealModeLimit Proc Far
	or	al, al	 		;Set up as 64Kb limit?
	jz	short @f		;
	call    A20_On		        ;enable A20 for 4Gb limit
	jmp	short Enable4Gb
@@:
	call    A20_Off		        ;disable A20 for 64Kb limit
Enable4Gb:
        call    coreSetLimits
	ret
SetRealModeLimit	Endp
;;---------------------------------------------------
A20_ON	PROC	NEAR
        call    WaitReady
        jnz     FailEnable
        mov     al,0D1h
        out     64h, al
        call    WaitReady
        jnz     FailEnable
        mov     al,0DFh
        out     60h, al
        call    WaitReady
        jnz     FailEnable
        mov     al,0FFh
        out     64h, al
        call    WaitReady
        jnz     FailEnable
        xor     ax, ax
        jmp     Exit_A20_ON
FailEnable:
        mov     ax, 1
Exit_A20_ON:
        ret
A20_ON	ENDP
;;---------------------------------------------------
A20_OFF	PROC	NEAR
        call    WaitReady
        jnz     FailDisable
        mov     al,0D1h
        out     64h, al
        call    WaitReady
        jnz     FailDisable
        mov     al,0DDh
        out     60h, al
        call    WaitReady
        jnz     FailDisable
        mov     al,0FFh
        out     64h, al
        call    WaitReady
        jnz     FailDisable
        xor     ax, ax
        jmp     Exit_A20_OFF
FailDisable:
        mov     ax, 1
Exit_A20_OFF:
        ret
A20_OFF	ENDP
;;---------------------------------------------------
WaitReady	PROC	NEAR
        xor     cx, cx
Wait1:
        in      al, 64h
        and     al, 2
        loopne Wait1
        ret
WaitReady	ENDP
;;---------------------------------------------------
coreSetLimits PROC NEAR PUBLIC
	cli				; Disable external interrupts
	cld				; Initialize direction flag forward
	mov	SI, OFFSET GDTTableAdd
        mov     ax, cs
        movzx   eax, ax
        shl     eax, 4
        mov     bx, offset GDTTable
        movzx   ebx, bx
        add     eax, ebx
        mov     cs:[si]+2, eax
.386p
	lgdt	FWORD PTR cs:[si]	; Load the GDT descriptor
.386
	mov	eax, CR0		; Get CPU control word 0
	or	al, 01			; Enable CPU protected mode
	mov	CR0, eax		; Write back to CPU control word 0
	jmp	queueFlush1		; Flush

queueFlush1:
        mov     bx, 8
	mov	es, bx			; Set ES
	mov	eax, CR0		; Get CPU control word 0
	and	al, 0FEh		; Disable CPU protected mode
	mov	CR0, eax		; Write back to CPU control word 0
        Sti
	xor	ax, ax
	mov	es, ax			; zero ES
        ret
coreSetLimits ENDP
;--------------------------------------------------------------------------
;
;  Descriptor Table offsets
;
GDTTableAdd:
        dw 0Fh, 0, 0
GDTTable:
 SegDescriptor	<0h, 0h, 0h, 0h, 0h, 00h>
 SegDescriptor	<0FFFFh, 0000h, 00h, 93h, 8Fh, 00h>     ; Readable/Writeable
; SegDescriptor	<0FFFFh, 0000h, 00h, 92h, 8Fh, 00h>     ; Readable only
;;---------------------------------------------------
end     SetRealModeLimit
