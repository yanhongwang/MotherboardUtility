;---------------------------------------------------
; Display Message module file version 1.2  <Seed Fu>
;---------------------------------------------------
include inc\Standard.inc
.model small
.386
.data
MsgBufferData   db 8 dup (0), 'H', 24h, 10 dup(?)
MsgBufferData1  db 10 dup(0), 'D', 24h, 10 dup(?)

.stack
.code
PUBLIC          DisplayHexDDValue
PUBLIC          DisplayHexDWValue
PUBLIC          DisplayHexDBValue
PUBLIC          DisplayDecValue
;;---------------------------------------------------
;; DisplayHexDDValue
;; Entry: 
;; EAX = Data for transfer
;; BP  = Function Flag
;; Bit0 = Don't Show "D" Char
;; Bit1 = Don't Show the result string
;; Exit:
;; EAX = String buffer address if BP= 2
;; BP  = String Length if BP= 2
;;---------------------------------------------------
DisplayHexDDValue    proc Far
        @push   si, dx, ebx
        xor     si, si					; clean the index, make it 0
        xchg    ebx, eax				; original data is in eax
        push    ebx
	shr     ebx, 16					; shift to take extension of bx
        mov     dl, bh					; put high byte of extension of bx into dl
        call    HexToAscii				; after call HextToAscii, transfrer result at dx
        mov     byte ptr MsgBufferData[si], dh
        inc     si
        mov     byte ptr MsgBufferData[si], dl
        mov     dl, bl					; put low byte of extension of bx into dl
        call    HexToAscii				; after call HextToAscii, transfrer result at dx
        inc     si
        mov     byte ptr MsgBufferData[si], dh
        inc     si
        mov     byte ptr MsgBufferData[si], dl
	pop     ebx
;
        mov     dl, bh					; put high byte of bx into dl
        call    HexToAscii				; after call HextToAscii, transfrer result at dx
;
        inc     si
        mov     byte ptr MsgBufferData[si], dh
        inc     si
        mov     byte ptr MsgBufferData[si], dl
        mov     dl, bl					; put low byte of bx into dl
        call    HexToAscii				; after call HextToAscii, transfrer result at dx
        inc     si
        mov     byte ptr MsgBufferData[si], dh
        inc     si
        mov     byte ptr MsgBufferData[si], dl
	
	
	test    Bp, 1					; if bp is equal 2, show MsgBufferData; if bp equal 1 or other, save MsgBuferData address into eax
        jz      ShowChar2
        inc     si
        mov     byte ptr MsgBufferData[si], '$'		; make 'end' sig of string
ShowChar2:
        test    Bp, 2					; if bp is equal 2, show MsgBufferData; if bp equal 1 or other, save MsgBuferData address into eax
        jz      ShowString2
        mov     bp, si
        mov     ax, seg MsgBufferData
        shl     eax, 16
        mov     ax, offset MsgBufferData
        jmp     ExitDisplay2
ShowString2:
	mov     ah, 9
	mov     dx, offset MsgBufferData
	int     21h
ExitDisplay2:
        @pop    si, dx, ebx
        ret
DisplayHexDDValue    endp
;;---------------------------------------------------
;; DisplayHexDWValue
;; Entry: 
;; AX  = Data for transfer
;; BP  = Function Flag
;; Bit0 = Don't Show "D" Char
;; Bit1 = Don't Show the result string
;; Exit:
;; EAX = String buffer address if BP= 2
;; BP  = String Length if BP= 2
;;---------------------------------------------------
DisplayHexDWValue    proc Far
        @push   si, dx, bx
        mov     si, 4					; make it start from 4
        xchg    bx, ax					; original data is in ax
        mov     dl, bh
        call    HexToAscii				; after call HextToAscii, transfrer result at dx
        mov     byte ptr MsgBufferData[si], dh
        inc     si
        mov     byte ptr MsgBufferData[si], dl
        mov     dl, bl
        call    HexToAscii				; after call HextToAscii, transfrer result at dx
        inc     si
        mov     byte ptr MsgBufferData[si], dh
        inc     si
        mov     byte ptr MsgBufferData[si], dl
	
	test    Bp, 1					; if bp is equal 2, show MsgBufferData; if bp equal 1 or other, save MsgBuferData address into eax
        jz      ShowChar1
        inc     si
        mov     byte ptr MsgBufferData[si], '$'		; make 'end' sig of string
ShowChar1:
        test    Bp, 2					; if bp is equal 2, show MsgBufferData; if bp equal 1 or other, save MsgBuferData address into eax
        jz      ShowString1
        sub     si, 4
        mov     bp, si
        mov     ax, seg MsgBufferData
        shl     eax, 16
        mov     ax, offset MsgBufferData+4
        jmp     ExitDisplay1
ShowString1:
	mov     ah, 9
	mov     dx, offset MsgBufferData+4		; Due to offset is start from 4
	int     21h
ExitDisplay1:
        @pop    si, dx, bx
        ret
DisplayHexDWValue    endp
;;---------------------------------------------------
;; DisplayHexDBValue
;; Entry: 
;; AL  = Data for transfer
;; BP  = Function Flag
;; Bit0 = Don't Show "D" Char
;; Bit1 = Don't Show the result string
;; Exit:
;; EAX = String buffer address if BP= 2
;; BP  = String Length if BP= 2
;;---------------------------------------------------
DisplayHexDBValue    proc Far
        @push   si, dx, bx
        mov     si, 6					; make it start from 6
        xchg    bx, ax					; original data is in ax
        mov     dl, bl
        call    HexToAscii				; after call HextToAscii, transfrer result at dx
        mov     byte ptr MsgBufferData[si], dh
        inc     si
        mov     byte ptr MsgBufferData[si], dl
        
        test    Bp, 1					; if bp is equal 2, show MsgBufferData; if bp equal 1 or other, save MsgBuferData address into eax
        jz      ShowChar
        inc     si
        mov     byte ptr MsgBufferData[si], '$'		; make 'end' sig of string
ShowChar:
        test    Bp, 2					; if bp is equal 2, show MsgBufferData; if bp equal 1 or other, save MsgBuferData address into eax
        jz      ShowString
        sub     si, 6
        mov     bp, si
        mov     ax, seg MsgBufferData
        shl     eax, 16
        mov     ax, offset MsgBufferData+6
        jmp     ExitDisplay
ShowString:
	mov     ah, 9
	mov     dx, offset MsgBufferData+6		; Due to offset is start from 6
	int     21h
ExitDisplay:
        @pop    si, dx, bx
        ret
DisplayHexDBValue    endp
;;---------------------------------------------------
HexToAscii     proc near
        push    cx
        push    dx
        and     dl, 0fh				; first manipulate low nibble of dl
        add     dl, 30h				; make visable
        cmp     dl, 3Ah				; if dl is a numeric
        jb      No_Add_Seven
        add     dl, 7				; add 7 in order to become alphabetic
No_Add_Seven:
        mov     cl, dl				; save dl to cl
        pop     dx
        and     dl, 0f0h			; senond manipulate high nibble of dl
        shr     dl, 4
        add     dl, 30h
        cmp     dl, 3Ah				; if dl is a numeric
        jb      No_Add_Seven1
        add     dl, 7				; add 7 in order to become alphabetic
No_Add_Seven1:
        mov     dh, dl				; save dl to dh
        mov     dl, cl				; save cl to dl
        					; now, dx already has HexToAscii result
        pop     cx
        ret
HexToAscii     endp
;;---------------------------------------------------
;; DisplayDecValue
;; Entry: 
;; EAX = Data for transfer
;; BP  = Function Flag
;; Bit0 = Don't Show "D" Char
;; Bit1 = Don't Show the result string
;; Exit:
;; EAX = String buffer address if BP= 2
;; BP  = String Length if BP= 2
;;---------------------------------------------------
DisplayDecValue    proc Far
        @push   dx, si
        Hex2Dec MsgBufferData1
        test    Bp, 1
        jz      ShowChar3
        inc     ax
        mov     si, ax
        mov     byte ptr MsgBufferData1[si], '$'
ShowChar3:
        test    Bp, 2
        jz      ShowString3
        mov     bp, ax
        mov     ax, seg MsgBufferData1
        shl     eax, 16
        mov     ax, offset MsgBufferData1
        jmp     ExitDisplay3
ShowString3:
	mov     ah, 9
	mov     dx, offset MsgBufferData1
	int     21h
ExitDisplay3:
        @pop    dx, si
        ret
DisplayDecValue    endp
;;---------------------------------------------------
end DisplayHexDDValue
