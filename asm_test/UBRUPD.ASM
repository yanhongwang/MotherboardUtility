include inc\file.inc
.model small
.486p
.data
;NEC_Customer    EQU     1
IFDEF  NEC_Customer
UserBinaryAddr  EQU     0FFF20000h
ELSE   ;NEC_Customer
UserBinaryAddr  EQU     0FFF80000h
ENDIF  ;NEC_Customer
OEM_GPIO_DEFAULT_IO EQU 1180h
XAddr           db      0
ReadBuffer      db      4*1024  dup(?)
Handle          dw      ?
SourceName      db      16 dup(0)               ; Buffer for Source file name use
PSP             dw      0
pmio            dw      1000h
Reg59h          db      0
Reg5ch          dd      0
PMIO2           dw      0
PMIO2e          dw      0
PMIO30          dw      0
help0           db      "User Binary Update utility ver 0.2 Written by GBT-Server BIOS Team.$"
UpdateMsg       db      20h
UpdateMsg1      db      30h
UpdateMsg2      db      30h ,"%$"
UpdateOK        db      0ah,0dh,'Updated OK!$'
RestartMsg      db      0ah,0dh,'Press any key to reboot system.....$'
ShutdownMsg     db      0ah,0dh,'Press any key to shutdown system.....$'
NoParameter     db      10, 13, 'Please keyin Parameter the same as "ubrupd filename"$'
FailMsg         db      0ah,0dh,7,7,7,'Error! Cannot updated User Binary ROM!'
                db      0ah,0dh,'Please remove the protection Jumper and retry again!!$'
FileNotExist    db      10, 13, 'Can not found the file!$'
Write_Size      dw      0
SourceNameLength dw     0                       ; Length of Source file name use
.stack
.code
EXTERN  SetRealModeLimit(EmptyRoutine):FAR
Logo     proc far
        push    ds
        xor     ax, ax
        push    ax 
        mov     ax, @data
        mov     ds, ax
        mov     ax, es
        mov     PSP, ax
;        
        mov     ax, 3
        int     10h
        Print   help0
        Call    CommandLineParameter
        jc      exit                            ; Jump if no any parameter
        OpenFile SourceName, 0                  
        jnc     Open_Ok
        Print   FileNotExist
        jmp     exit
Open_Ok:
        mov     Handle, ax
        Relocate 
        inc     dh
        mov     Xaddr, dh
        mov     al, 1
        call    SetRealModeLimit
        call    Flash_Write_Enable
;        call    Disable_Something_Before_Flash
        call    sst_block_unlock
        mov     edi, UserBinaryAddr
        call    Erase_Secotr
        call    Update_UserBinary_File
        call    Enable_Something_Afrer_Flash
;       
exit:
;        xor     al, al
;        call    SetRealModeLimit
        ret
Logo     endp
;;---------------------------------------------------
EmptyRoutine    proc FAR
        ret
EmptyRoutine    endp
;;---------------------------------------------------
sst_block_unlock proc
        push    ds
	pushf
	pushad				     
	push	0000h
	pop	ds
IFDEF  NEC_Customer
	mov	cx, 16
	mov	edi, 0ffb00002h
ELSE   ;NEC_Customer
	mov	cx, 8
	mov	edi,0ffb80002h
ENDIF  ;NEC_Customer
unlock:
	mov	al,0
	mov	es:[edi],al
	add	edi,10000h
	loop	unlock
	popad				     
	popf
        pop     ds
	ret
sst_block_unlock endp
;;---------------------------------------------------
Disable_All_SMI proc
        ret
Disable_All_SMI endp
;;--------------------------------------------------
Disable_Shadow  proc
        ret
Disable_Shadow  endp
;;---------------------------------------------------
Erase_Secotr    proc
IFDEF  NEC_Customer
        out     0edh, al
        out     0edh, al
        out     0edh, al

        push    edi
        push    esi
	mov	esi,0FFFF5555H
	mov	edi,0FFFF2AAAH
        mov     byte ptr es:[esi], 0AAh
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        mov     byte ptr es:[edi], 055h
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        mov     byte ptr es:[esi], 080h
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        mov     byte ptr es:[esi], 0AAh
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        mov     byte ptr es:[edi], 055h
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        pop     esi
        pop     edi
;
        mov     byte ptr es:[edi], 050h
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
	push	ax
	call	SST49LFA_Check_Toggle_Ready
        out     0e0h, al
        pop     ax
;
ELSE   ;NEC_Customer
        out     0edh, al
        out     0edh, al
        out     0edh, al

        push    edi
        push    esi
	mov	esi,0FFFF5555H
	mov	edi,0FFFF2AAAH
        mov     byte ptr es:[esi], 0AAh
        mov     byte ptr es:[edi], 055h
        mov     byte ptr es:[esi], 080h
        mov     byte ptr es:[esi], 0AAh
        mov     byte ptr es:[edi], 055h
        pop     esi
        pop     edi
;
        mov     byte ptr es:[edi], 050h
	push	ecx
        push    ax
Wait_OK:
        mov     ecx, 4ffffh
Seed_L11:
        in      al, 80h
        dec     ecx
        jnz     Seed_L11

	call	SST49LFA_Check_Toggle_Ready
        jnc     Ready_ok
        jmp     Wait_OK
Ready_ok:
        pop     ax
	pop	ecx
ENDIF  ;NEC_Customer
        ret
Erase_Secotr    endp
;;---------------------------------------------------
Flash_Write_Enable      proc
        push    eax
        push    dx
        mov     eax, 8000F84Ch
        mov     dx, 0cf8h
        out     dx, eax
        out     0edh, al
        add     dx, 4
        in      eax, dx
        or      eax, 00010000h
        out     dx, eax
        out     0edh, al
;
        mov     dx, OEM_GPIO_DEFAULT_IO+38H     ; 
        in      eax, dx
	or	eax, (1 SHL 24)		; [Seed_F020] Disable TBL protect
	or	eax, (1 SHL 25)		; [Seed_F020] Disable Write protect
        out     dx, eax
        out     0edh, al
;
        pop     dx
        pop     eax
        ret
Flash_Write_Enable      endp
;;---------------------------------------------------
cacheFlush	PROC  NEAR
	cld
	mov	ecx, (2 * 1024 * (1024 / 4))	; CX = 2M in DWORDS
	mov	esi, 100000h			; Start at 1M boundary such
						; that UMB is not touched
	rep	lods DWORD PTR es:[esi] 	; Flush memory

	ret
cacheFlush	ENDP
;;---------------------------------------------------
SST49LFA_Check_Toggle_Ready	proc	near
		clc
Toggle_Bit	=	01000000b
		push	cx
		push	bx
		mov	ah, byte ptr es:[edi]
		mov	bx,1000h
Ststus_Read_Loop:  
		xor	cx,cx		
Ststus_Read_Loop_1:
		mov	al, byte ptr es:[edi]
		xor	ah,al
		test	ah,Toggle_Bit
		jz	short Toggle_End
		mov	ah,al
		loop	Ststus_Read_Loop_1
		dec	bx
		jnz	Ststus_Read_Loop
		stc				;Time out
		pop	bx
		pop	cx
		ret
Toggle_End:
		clc 				;Toggle end
		pop	bx
		pop	cx
;	push	cx
;	push	bx
;        push    ax
;still_toggling:
;        out     0edh, al
;        out     0edh, al
;        out     0edh, al
;	mov	al, byte ptr es:[edi]
;	mov	ah, byte ptr es:[edi]
;        and     ax, 4040h
;        cmp     al, ah
;        jnz     still_toggling
;        pop     ax
;	pop	bx
;	pop	cx
	ret
SST49LFA_Check_Toggle_Ready	endp
;;---------------------------------------------------
Write_One_Byte proc
IFDEF  NEC_Customer
        push    edi
        push    esi
	mov	esi,0FFFF5555H
	mov	edi,0FFFF2AAAH
        mov     byte ptr es:[esi], 0AAh
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        mov     byte ptr es:[edi], 055h
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        mov     byte ptr es:[esi], 0A0h
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        pop     esi
        pop     edi
;
        mov     byte ptr es:[edi], al
        out     0edh, al
        out     0edh, al
        out     0edh, al
        out     0edh, al
;
        push    ax
	push	ecx
        push    ax
Wait_OK1:
        mov     ecx, 0030h
Seed_L12:
        in      al, 80h
        dec     ecx
        jnz     Seed_L12

	call	SST49LFA_Check_Toggle_Ready
	out	0e0h,al			
	out	0e0h,al			
        jnc     Ready_ok1
        jmp     Wait_OK1
Ready_ok1:
        pop     ax
	pop	ecx
        pop     ax
ELSE   ;NEC_Customer
        push    edi
        push    esi
	mov	esi,0FFFF5555H
	mov	edi,0FFFF2AAAH
        mov     byte ptr es:[esi], 0AAh
        mov     byte ptr es:[edi], 055h
        mov     byte ptr es:[esi], 0A0h
        pop     esi
        pop     edi
;
        mov     byte ptr es:[edi], al
;

	push	ecx
        push    ax
Wait_OK1:
        mov     ecx, 02ffh
Seed_L12:
        in      al, 80h
        dec     ecx
        jnz     Seed_L12

	call	SST49LFA_Check_Toggle_Ready
        jnc     Ready_ok1
        jmp     Wait_OK1
Ready_ok1:
        pop     ax
	pop	ecx
ENDIF  ;NEC_Customer
        ret
Write_One_Byte endp
;;---------------------------------------------------
Disable_Something_before_Flash proc
        call    Disable_All_SMI
	wbinvd
	call	cacheFlush		; Empty memory cache
	mov	eax, CR0		; Disable CPU cache
	or	eax, 60000000h
	mov	CR0, eax
	call	cacheFlush		; Empty memory cache

        call    Disable_Shadow
	call	cacheFlush		; Empty memory cache
        ret
Disable_Something_before_Flash endp
;;---------------------------------------------------
Enable_Something_Afrer_Flash proc
        Print   UpdateOK
;---------
; Restart
;---------
;        Print   RestartMsg
;        waitkey
;        mov     al,0FEh
;        out     64h, al
;---------
; Shutdown
;---------
;        Print   ShutdownMsg
;        waitkey
;        mov     dx, pmio
;        add     dx, 5
;        mov     al, 08h
;        shl     al, 2
;        out     dx, al
;        out     0edh, al
;        out     0edh, al
;        mov     al, 0fh
;        shl     al, 2
;        out     dx, al
;        out     0edh, al
;        jmp     $
        ret
Enable_Something_Afrer_Flash endp
;;---------------------------------------------------
CommandLineParameter proc
        mov     di, 80h                         ; Start address of Parameter 
	cmp     byte ptr es:[di], 0
	jnz     PreGetParameter                 ; Jump if the parameter exist.
        Print   NoParameter
        stc
        jmp     exit1
PreGetParameter:
        inc     di
        inc     di
;
        push    ds
        mov     ax, es
        pop     es
        push    ax
        pop     ds
        mov     si, offset SourceName
        xchg    si, di
        GetStringLength 0dh, 0
        xor     ah, ah
        mov     es:SourceNameLength, ax         ; Got the length of source string
        mov     cx, ax
        rep     movsb                           ; Copy the source string to buffer of SourceName
        inc     si
;
        push    ds
        mov     ax, es
        pop     es
        push    ax
        pop     ds

        clc
exit1:
        ret
CommandLineParameter endp
;;---------------------------------------------------
Update_UserBinary_File proc
        push    ecx
        push    si
        push    edi
;
        mov     edi, UserBinaryAddr
        mov     ecx, 4*4
Update_64k:
        push    ecx
        ReadFile Handle, ReadBuffer, sizeof ReadBuffer, 0
        mov     Write_Size, ax
        mov     si, offset ReadBuffer
        mov     cx, Write_Size
        movzx   ecx, cx
WriteData:
        push    ecx
Update_Again:
        mov     al, ds:[si]
        call    Write_One_Byte
        inc     si
        inc     edi
        pop     ecx
        loop    WriteData
        pop     ecx
        call    Update_Msg_Proc
        loop    Update_64k
        CloseFile Handle
;
        pop     edi
        pop     si
        pop     ecx
        ret
Update_UserBinary_File endp
;;---------------------------------------------------
Update_Msg_Proc proc
        pusha
        mov     ax, cx
        shl     ax, 1
        push    cx
        mov     cx, ax
        shl     ax, 1
        add     ax, cx
        pop     cx
        xchg    ax, cx
        mov     ax, 100
        sub     ax, cx
        add     ax, 4
        cmp     al, 100
        jb      No_100
        mov     UpdateMsg, 31h
        mov     UpdateMsg1, 30h
        mov     UpdateMsg2, 30h
        jmp     Print_Data
No_100:                   
        aam
        or      ax, 3030h
        xchg    al, ah
        mov     UpdateMsg1, al
        mov     UpdateMsg2, ah
Print_Data:
        Locate  XAddr, 0 
        Print UpdateMsg
        popa
        ret
Update_Msg_Proc endp
;;---------------------------------------------------
end Logo
