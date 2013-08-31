HexByte   macro 
      push 	bx
      push 	dx
      push 	cx
      push 	ax
      mov 	bx,offset table
      mov 	cl,4
      shr 	al,cl
      xlatb
      mov 	dl,al
      mov 	ah,02h
      int 	21h
      pop 	ax
      push	ax
      and 	al,00001111b
      xlatb
      mov 	dl,al
      mov 	ah,02h
      int 	21h
      pop 	ax
      pop 	cx
      pop 	dx
      pop 	bx
endm

HexWord macro
        push    ax
        xchg    ah, al
        HexByte
        xchg    ah, al
        HexByte
        pop     ax
endm

HexDWord macro
        push    eax
        shr     eax, 16
        HexWord
        pop     eax
        push    eax
        HexWord
        pop     eax
endm

Printf	macro   string
        push    ax
        push    dx
        mov     dx, offset string
        mov     ah, 9
        int     21h
        pop     dx
        pop     ax
endm

Putchar macro   CHAR
        push    ax
        push    dx
        mov     dl, CHAR
        mov     ah, 2
        int     21h
        pop     dx
        pop     ax
endm

CR_LF   macro
        putchar 0ah
        putchar 0dh
endm

setcurpos macro x_axis, y_axis
        push 	ax
        push 	dx
	mov 	ah,02h
	mov 	dh,x_axis
	mov 	dl,y_axis
	int 	10h
        pop 	dx
        pop 	ax
endm

clscreen macro
        push 	ax
        mov     ax, 3
	int 	10h
        pop 	ax
endm

cleancur macro
        push 	ax
        push 	cx
        mov 	ah,01h         
        mov 	ch,30h
        mov 	cl,0ch
        int 	10h
        pop 	cx
        pop 	ax
endm

showcur macro
        push 	ax
        push 	cx
        mov 	ah,01h
        mov 	ch,13
        mov 	cl,14
        int 	10h
        pop 	cx
        pop 	ax
endm

IODELAY macro
        out     0edh, al
        out     0edh, al
endm

NewLine macro
        Putchar 0ah
        Putchar 0dh
endm

delay_sec   macro
	 local lp
	push 	ax
	push 	bx
	push 	cx
	push 	dx
       
        mov 	al,0ah
        mov 	dx,70h
        out 	dx,al
        inc 	dx
        in 	al,dx
        mov 	al,10100110b
        out 	dx,al
        dec 	dx
        mov 	al,0bh
        out 	dx,al
        inc 	dx
        in 	al,dx
        or 	al,01000000b
        out 	dx,al
        mov 	cx,1024
   lp:
        dec 	dx
        mov 	al,0ch
        out 	dx,al
        inc 	dx
        in 	al,dx
        and 	al,01000000b
        cmp 	al,00h
        jz 	lp
        loop 	lp
	pop 	dx
	pop 	cx
	pop 	bx
	pop 	ax
endm

;**********************************************************
;       CPUID is 586 instruction
;**********************************************************
_RDMSR	MACRO
	DB	00Fh, 032h
	ENDM

_WRMSR	MACRO
	DB	00Fh, 030h
	ENDM

CPU_ID	MACRO
	DB	00Fh, 0A2h
	ENDM
;**********************************************************
;       Create File Macro
;       EXIT: ax=handle
;       C=fail
;**********************************************************
f_create  macro   f_name, attrib
        push    dx
        push    cx
        mov     dx, offset f_name
        mov     cx, attrib
        mov     ah, 3ch
        int     21h
        pop     cx
        pop     dx
endm
;**********************************************************
;       Open File Macro
;       EXIT: ax=handle
;       C=fail
;**********************************************************
f_open  macro   f_name, mode
        push    dx
        mov     dx, offset f_name
        mov     al, mode
        mov     ah, 3dh
        int     21h
        pop     dx
endm
;**********************************************************
;       Read File Macro
;       EXIT:
;  AX= number of bytes actually read from the file                         
;**********************************************************
f_read  macro   buff, length, handle
        push    dx
        push    cx
        push    bx
        lea     dx, buff
        mov     cx, length
        mov     bx, handle
        mov     ah, 3fh
        int     21h
        pop     bx
        pop     cx
        pop     dx
endm
;**********************************************************
;       Write File Macro
;       EXIT:
;  AX= number of bytes actually write from the file                        
;**********************************************************
f_write macro   buff, length, handle
        push    dx
        push    cx
        push    bx
        mov     dx, offset buff
        mov     cx, length
        mov     bx, handle
        mov     ah, 40h
        int     21h
        pop     bx
        pop     cx
        pop     dx
endm
;****************************************************************************
;*  DeleteFile                                                              *
;*  Entry:                                                                  *
;*  DS:DX= Address of pathname to delete                                    *
;*  Exit:                                                                   *
;*  Jnc = Delete Ok                                                         *
;****************************************************************************
f_delete macro  f_name
        push    dx
        push    ds

        mov     dx, offset f_name
        mov     ah, 41h
        int     21h

        pop     ds
        pop     dx
ENDM
;**********************************************************
;       Close File Macro
;**********************************************************
f_close macro   handle
        pusha
        mov     bx, handle
        mov     ah, 3eh
        int     21h
        popa
endm

;**********************************************************
;       File seek Macro
;       CX:DX - Distance to move in byte
;**********************************************************
f_point macro   Method, Handle, H_byte, L_byte
        mov     ah, 42h
        mov     al, Method      ; 0:from head 1:from now ponit 2:from end
        mov     bx, Handle
        mov     cx, H_byte      ; Zero out CX and DX so we stay 
        mov     dx, L_byte      ; right here
        int     21h
endm
