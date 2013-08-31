include inc\file.inc
.model small
.386
.data
;EEPROM_Address  EQU     05Eh
EEPROM_Address  EQU     0A8h
FRU_Size        EQU     256
PSP             dw      0
help0           db      0Dh,0Ah,'GIGABYTE FRU EEPROM read/write utility Ver 0.1 for SR147 platform only.'
	        db      0dh,0ah,"Usage: FRURW /a"
                db      0dh,0ah,"where: /a:    /R Read FRU data from EEPROM"
                db      0dh,0ah,"              /W Write FRU data to EEPROM", 0dh,0ah,24h
File_Err        db      'Error! cannot open the "SR147.FRU" file!!', 13, 10, 24h
UserData        db      ?
FRU_Buffer      db      FRU_Size     dup (0)
FRU_Name        db      'SR147.FRU', 0
Handle          dw      ?
OEM_SMB_DEFAULT_IO      dw      ?
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
	call    GetParameter
        jnc     short StartToRead			; if carry flag is clear, read process is start.
        Print   Help0					; show usage
        jmp     ext_dos
        
StartToRead:
        call    Get_SMBUS_IO
        mov     al, UserData				; duplicate the option to al
        cmp     al, 'r'
        jz      short IS_Read_Function
        OpenFile FRU_Name, 0				; open file read only
        jnc     short Open_OK
        Print   File_Err
        jmp     ext_dos
Open_OK:
        mov     Handle, ax
        ReadFile Handle, FRU_Buffer, FRU_Size, 0	; read fru binary into FRU_Buffer
        CloseFile Handle
        call    Update_To_EEPROM
        jmp     ext_dos
IS_Read_Function:
        OpenFile FRU_Name, 1				; open file write only
        jnc     short Open_OK1
        CreateFile FRU_Name, 0
Open_OK1:
        mov     Handle, ax    
        WriteFile Handle, FRU_Buffer, 0
        call    Read_From_EEPROM
        WriteFile Handle, FRU_Buffer, FRU_Size		; write FRU_Buffer into file
        CloseFile Handle
;
ext_dos:
        ret
Testa endp
;;---------------------------------------------------
EmptyRoutine    proc FAR
        ret
EmptyRoutine    endp
;;---------------------------------------------------
GetParameter proc  near
        push    di
        push    ax
        
        mov     di, 80h
        or      byte ptr es:[80h], 0
        jz      short NoData			; it means invalid value, no any arugment
        
        cmp     byte ptr es:[80h], 3
        jb      short NoData			; it means invalid value
        
        add     di, 3
        mov     al, byte ptr es:[di]		; now, option 'R' or 'W' in al
        cmp     al, 'z'
        ja      short NoData			; it means invalid value, higher than 'z'
        
        cmp     al, 'A'
        jb      short NoData			; it means invalid value, lower than 'A'
        
        or      al, 20h				; force all alphabetic become lower letter
        cmp     al, 'r'
        jz      short Correct_Parameter
        cmp     al, 'w'
        jz      short Correct_Parameter
        jmp     short NoData			; it means invalid value
        
Correct_Parameter:

        mov     UserData, al
        clc					; clear CF of flag prove argument is correspond to usage
        jmp     exit
NoData:
        stc					; set CF of flag prove argument is NOT correspond to usage
exit:
        pop     ax
        pop     di
        ret
GetParameter endp
;;---------------------------------------------------
Update_To_EEPROM PROC 
        push    cx
        mov     cx, FRU_Size
        xor     bx, bx				; initialize bx
        xor     dh, dh				; initialize dh
        mov     al, EEPROM_Address
loop_To_Write:
        mov     bl, dh
        mov     dl, byte ptr FRU_Buffer[bx]
        call    Check_SMBUS_READY
        call    Check_SMBUS_READY
        push    ax
        push    dx
        call    IO_Write
        pop     dx
        pop     ax
        inc     dh
        loop    loop_To_Write
        pop     cx
        ret
Update_To_EEPROM ENDP
;;---------------------------------------------------
Get_SMBUS_IO proc
        push    eax
        push    dx
        mov     eax, 8000FB20h			; Bus number: 00h, Device number: 1Fh, Function number: 03h, 
						; index: 08h, SMBus( System Management Bus )
						
        mov     dx, 0cf8h			; pci index port: 0CF8h
        out     dx, eax				; send 8000FB20h to port 0cf8 to request
	
        out     0edh, al			; same as "NEWIODELAY"
        add     dx, 4				; pci data port: 0CFCh
        in      ax, dx				; receive data from dx, result into ax
        and     ax, not 1			; ??
        mov     OEM_SMB_DEFAULT_IO, ax
        pop     dx
        pop     eax
        ret
Get_SMBUS_IO endp
;;---------------------------------------------------
Read_From_EEPROM proc
        push    cx
        mov     cx, FRU_Size 
        mov     dh, EEPROM_Address
        xor     dl, dl
        xor     bx, bx
loop_To_Read:
        call    Check_SMBUS_READY
        push    dx
        call    IO_Read
        pop     dx
        mov     bl, dl
        mov     byte ptr FRU_Buffer[bx], al
        inc     dl
        loop    loop_To_Read
        pop     cx
        ret
Read_From_EEPROM endp
;;---------------------------------------------------
Read_From_SMBUS:
; ex.	  DB	address, data	or
;	  DW	( data shl 8 ) + address
;	  DB	00h,0FFh	; clear host status
IndexDat2 DB	03h,000h	; SMBUS regiseter index
AddrDat2  DB	04h,000h	; SMBUS Address, Write
	  DB	02h,048h	; Byte format
Len_Read_From_SMBUS  =  (($ - Read_From_SMBUS) / 2)
IO_Read	PROC
	push	cx
	push	dx
        push    si
	push	ax
;
        inc     dh
        mov     cs: IndexDat2+1, dl
        mov     cs: AddrDat2+1, dh
	mov	dx, OEM_SMB_DEFAULT_IO
	add	dx, 2                   ; SMBHSTCNT
	in	al, dx		        ; Clear index pointer to the block data storage array
        NEWIODELAY
;
	mov	cx, Len_Read_From_SMBUS
	mov	si, offset Read_From_SMBUS
	xor	ax, ax		       ; clear AH
smb_loop2:
	mov	dx, OEM_SMB_DEFAULT_IO
	mov	al, cs:[si]	       ; get index
	add	dx, ax		       ; actural address
;	   
	mov	al, cs:[si+1]	       ; get data
	out	dx, al		       ; out value
        NEWIODELAY
	add	si, 2
	loop	smb_loop2
;
	push	cx
	xor	cx,cx
	mov	cx,8000h
	and	dl,0f0h					;base + 00h
check_host_status:
	in	al,dx
        newiodelay
	dec	cx
	jz	time_out
	test	al,00000001b		;busy?
	jnz	check_host_status	;ZF = 0 for fail
	test	al,00000010b		;interrupt?
	jz	check_host_status
time_out:
        pop     cx
	out	dx,al			;Reset Host Status Registers
;
	mov	dx, OEM_SMB_DEFAULT_IO
        add     dx, 5
        in      al, dx
        NEWIODELAY
        mov     cx, 0800h
Delay1:
        NEWIODELAY
        loop    Delay1
        xchg    al, dl
        pop     ax
        xchg    al, dl
        pop     si
	pop     dx
	pop	cx
	ret
IO_Read	ENDP
;;---------------------------------------------------
Write_To_SMBUS:
; ex.	  DB	address, data	or
;	  DW	( data shl 8 ) + address
;	  DB	00h,0FFh	; clear host status
IndexData DB	03h,000h	; SMBUS regiseter index
WriteData DB    05h,000h        ; Value for write to to SMBUS register
SlaveAddr DB	04h,000h	; SMBUS Address, Write
;-------------------------------;
	  DB	02h,048h	; Byte format
Len_Write_To_SMBUS  =  (($ - Write_To_SMBUS) / 2)
;-----------------------------------
; Input	 : 	ah (Command address)
; 		al (write data)
;               dh (SMB ADDRESS)
; Output :	 
;-----------------------------------
IO_Write PROC
	push    ax
	push	cx
        push    si
;
        mov     cs:IndexData+1, dh
        mov     cs:WriteData+1, dl
        mov     cs:SlaveAddr+1, al
	mov	dx, OEM_SMB_DEFAULT_IO
	add	dx, 2                   ; SMBHSTCNT
	in	al, dx		        ; Clear index pointer to the block data storage array
        NEWIODELAY
;
	mov	cx, Len_Write_To_SMBUS
	mov	si, offset Write_To_SMBUS
	xor	ax, ax			; clear AH
smb_loop1:
	mov	dx, OEM_SMB_DEFAULT_IO
	mov	al, cs:[si]	       ; get index
	add	dx, ax		       ; actural address
;	   
	mov	al, cs:[si+1]	       ; get data
	out	dx, al		       ; out value
        NEWIODELAY
	add	si, 2
	loop	smb_loop1
;
        mov     cx, 0800h
Delay2:
        NEWIODELAY
        loop    Delay2
;
        pop     si
	pop	cx
	pop	ax
	ret
IO_Write ENDP
;;---------------------------------------------------
Check_SMBUS_READY proc 
        push    ax
        push    dx
	mov	dx, OEM_SMB_DEFAULT_IO
Check_SMBUS_Busy:
        in      al, dx				; read data from port(dx) to al
        test    al, 1
        jz      SMBUS_Ready
        newiodelay
        newiodelay
        newiodelay
        newiodelay
        newiodelay
        jmp     Check_SMBUS_Busy		; until SMBUS is free
SMBUS_Ready:
	mov	dx, OEM_SMB_DEFAULT_IO
        mov     al, -1				; put 255 to al
	out	dx, al				; send 255 to port(dx)
        newiodelay
        newiodelay
        newiodelay
        newiodelay
        newiodelay
        pop     dx
        pop     ax
        ret
Check_SMBUS_READY endp
;;---------------------------------------------------
end Testa
