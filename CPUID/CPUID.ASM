@create_file MACRO filename, mode
        mov     dx, offset filename
        mov     cx, mode
        mov     ah, 3ch
        int     21h
ENDM

@open_file MACRO filename, mode
        mov     dx, offset filename
        mov     ah, 3dh
        mov     al, mode
        int     21h
ENDM

@close_file MACRO handle
        mov     ah, 3eh
        mov     bx, handle
        int     21h
ENDM

@read_file MACRO handle, buffer, count
        mov     bx, handle
        mov     dx, offset buffer
        mov     cx, count
        mov     ah, 3fh
        int     21h
ENDM

@write_file MACRO handle, buffer, count
        pusha
        mov     bx, handle
        mov     dx, offset buffer
        mov     cx, count
        mov     ah, 40h
        int     21h
        popa
ENDM

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

@off_visable MACRO data
        local   figure, not_figure, upper_case, lower_case, transfer_ok
        mov     al, data
        cmp     al, 39h                 ;compare with '9', if less, it indicated a number
        ja      not_figure
figure:
        sub     al, 30h
        jmp     transfer_ok
not_figure:
        cmp     al, 46h                 ;compare with 'F', if less, it indicate a upper-case alphabet
        ja      lower_case
upper_case:
        sub     al, 41h
        add     al, 0ah
        jmp     transfer_ok
lower_case:
        sub     al, 61h
        add     al, 0ah

transfer_ok:

ENDM

;-deal with figure and display
@on_visable MACRO data 
        local letter_hi, letter_lo, num_hi, show_hi, num_lo, show_lo
        push    ax
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
    
        mov     [ si ], dl
        inc     si
  
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

        mov     [ si ], al
        inc     si

        @print_char      20h            ;put space between data

        mov     al, 20h
        mov     [ si ], al
        inc     si

        pop     ax
ENDM

;include inc\
include utility.inc
include standard.inc
.model small
.386
.data
PSP             dw      0
argument_line   db      256     dup(2)
data_buffer     db      1000    dup(5)
Count           db      2
RowBarCount     db      0
ColumnBar       db      '    00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F', 0dh, 0ah, '$'
SeparateBar     db	'---------------------------------------------------', 0dh, 0ah, '00  $'
filename        db      'cmos.txt', 00h
usage1          db      0dh, 0ah,'usage: cmos r/w', 0dh, 0ah, '$'
usage2          db      'option: r : read hardware cmos value, write to specified file name.', 0dh, 0ah, '$'
usage3          db      '        w : read context of specified file name, write to hardware cmos value.', 0dh, 0ah, '$'
usage4          db      0dh, 0ah,'BEWARE!! The file name you want to assign must be "cmos.txt". BE CAREFUAL!', 0dh, 0ah, '$'
file_error      db      0dh, 0ah, 'The file cannot open for use! Please check it!', 0dh, 0ah, '$' 
read_option     db      ' r'
write_option    db      ' w'
newline         db      0dh, 0ah, '$'
port_number     db      0
bank            db      70h     	; it mean bank0
handle          dw      ?
;GPIO_PORT	EQU	480h	;award
GPIO_PORT	EQU	1180h	;phoenix
.stack
.code
; EXTERN  (EmptyRoutine):FAR
Testa proc far
beg:
	push	ds
	xor	ax, ax
	push	ax 
	mov	ax, @data
	mov	ds, ax
	mov	ax, es
	mov	PSP, ax

	mov	eax, 80000002h
	db	0fh, 0a2h
	
	mov	eax, 80000003h
	db	0fh, 0a2h

	mov	eax, 80000004h
	db	0fh, 0a2h

exit:
        ret

Testa endp
                       
;;---------------------------------------------------
EmptyRoutine    proc FAR
        ret
EmptyRoutine    endp
;;---------------------------------------------------
end Testa




