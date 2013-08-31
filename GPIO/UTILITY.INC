
@print_char MACRO character
	push	ax
        push    dx
        mov     ah, 02h
        mov     dl, character
        int     21h
        pop	dx
        pop     ax
ENDM

@print_string MACRO string
        push    dx
        push    ax
        mov     ah, 09h
        mov     dx, offset string
        int     21h
        pop     ax
        pop     dx
ENDM

;-deal with figure and display
@on_visable MACRO data 
        local letter_hi, letter_lo, num_hi, show_hi, num_lo, show_lo
        push    ax
        push    dx

        xor	ax, ax
        mov     al, data
        shl     ax, 04h                 ;shift high nibble of al into ah
        shr     al, 04h                 ;shift low nibble of al back to original position

        cmp     ah, 09h
        jbe     num_hi
letter_hi:                              ;it should be a english letter
        sub     ah, 0ah
        add     ah, 41h
        jmp     show_hi
num_hi: 				;it shoudl be a number 
        add     ah, 30h
show_hi:
        mov     dl, ah
        @print_char        dl
  
        cmp     al, 09h
        jbe     num_lo
letter_lo:
        sub     al, 0ah
        add     al, 41h
        jmp     show_lo
num_lo:        
        add     al, 30h
show_lo:
        @print_char      al

        pop     dx
        pop     ax
ENDM

@cls MACRO
        pusha
        mov     ax, 3
        int     10h
        popa
ENDM

@get_invisable_key MACRO
        xor	ax, ax
        int     16h
endm

@cursor_hidden MACRO
	push	cx
	push	ax
        xor     cx, cx
        mov     ch, 20h
        mov     ah, 01h
        int     10h
        pop	ax
        pop	cx
endm

@cursor_visable MACRO
	push	cx
	push	ax
        mov     ch, 0Bh                 ;recovery the hidden cursor to visable
        mov     cl, 0Ch
        mov     ah, 01h
        int     10h
        pop	ax
        pop	cx
endm

@locate MACRO x, y
	push	ax
	push	bx
	push	dx
        mov     ah, 02h
        xor     bh, bh
        mov     dh, y
        mov     dl, x
        int     10h
        pop	dx
        pop	bx
        pop	ax
ENDM

@print_32_bits MACRO double_word
	push	ebx
	mov	ebx, double_word
	shr	ebx, 10h
	@on_visable	bh
	@on_visable	bl
	mov	ebx, double_word
	@on_visable	bh
	@on_visable	bl
	pop	ebx
ENDM

@hex2dec MACRO data

        local   figure, alphabet, transfer_ok
        mov     al, data
        cmp     al, 39h                 ;compare with '9', if less, it indicated a number
        ja      alphabet

figure:

        sub     al, 30h
        jmp     transfer_ok

alphabet:

        sub     al, 41h
        add     al, 0Ah

transfer_ok:

ENDM

@table_match MACRO data

;31 30 29 28 27 26 25 24   23 22 21 20 19 18 17 16   15 14 13 12 11 10 09 08   07 06 05 04 03 02 01 00 
;     Base Class Code    |      Sub Class Code     |  Programming Interface  |       Revision ID 


        local get_next, exit, next_table

        push    cx
        
	mov     edx, data                                     
        shr     edx, 10h                ;shift Base Class Code to dh, Sub Class Code to dl
					;Programming interface in ah

	xor     cx, cx
	mov	cl, count_class		;count_class is number of table
	mov	di, offset class_code_table_start

get_next:

	mov	al, [di].class_code.base_class_code
	cmp	dh, al                  ;compare with base class code 
	jnz	next_table
	mov	al, [di].class_code.sub_class_code
	cmp	dl, al                  ;compare with sub class code
	jnz	next_table
	mov	al, [di].class_code.programming_interface
      	cmp	ah, al                  ;compare with programming interface
	jnz 	next_table
                                        ;if base class code and sub class code  
                                        ;and programming interface all match
                                        ;the table suite, it indicated the pattern
                                        ;recognized is done.

	mov	dx, [di].class_code.string_address

	;mov	ah, 09h                 ;show name on screen for this item
	;int	21h

	jmp	exit
	
next_table:
        add     di, size class_code     ;add di, indicate next patten item 
        loop    get_next

exit:        
        pop     cx

ENDM
