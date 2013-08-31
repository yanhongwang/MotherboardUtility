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
.stack
.code
; EXTERN  (EmptyRoutine):FAR
Testa proc far
beg:
;        push    ds
;        xor     ax, ax
;        push    ax 
;        mov     ax, @data
;        mov     ds, ax
;        mov     ax, es
;        mov     PSP, ax
        
        push    ds
        xor     ax, ax
        push    ax 
        mov     ax, @data
        mov     es, ax			; put data segment to es
        cld
        mov     cx, 80h 		; due to the structure of PSP, maximum volume is 80 count
        mov     si, 80h 		; ds:si=PSP:80h
        mov     di, offset argument_line        ; es:di
        rep     movsb			; copy argument to argument_line
        push    es
        pop     ds                      ; back to original ds state
        mov     di, 00h
        mov     si, offset argument_line
;        mov     ax, es
;        mov     PSP, ax
           
        mov     al, [ si + 0 ]
        cmp     al, 0                   ; judge whether if any argument exists
        je      usage

        lea     di, read_option         ; check if argument is equal ' r'
        inc     si
        mov     cx, 02h
        repe    cmpsb
        jz      read_process

        lea     di, write_option        ; check if argument is equal ' w'
        mov     si, offset argument_line
        inc     si
        mov     cx, 02h
        repe    cmpsb
        jnz     usage                   ; if option is neither ' r' nor ' w' 

write_process:

        @open_file       filename, 02h
        jc      open_fail
        mov     handle, ax
        @read_file      handle, data_buffer, 1000
        @close_file     handle

        mov     bx, offset data_buffer
;        add     bx, 106                ; move the index to valid data. If needed to write time in cmos
        add     bx, 160                 ; add 54 can skip next cycle
        mov     port_number, 16         ; Start from 0 will cause cmos time varied 

        add     bx, 04h                 ; offset, in order to put index at correct position
        xor     dx, dx 

next_data:

        xor     ax, ax                  ; initialize ax
        @off_visable    [ bx ]
        shl     al, 04h                 ; shift nibble of al four times
        xchg    ah, al                  ; save al to ah
        inc     bx                      ; add bx, point to low byte
        @off_visable    [ bx ]
        or      ah, al                  ; sum al to ah
        mov     al, bank
        mov     dl, al
        mov     al, port_number
        out     dx, al                  ; index port
        inc     dx                      ; add one into data port
        mov     al, ah
        out     dx, al                  ; data port

        inc     port_number             ; change to apply next port
        add     bx, 02h                 ; move index into next data

        test    port_number, 0fh        ; check if needed to skip the index of bx
        jne     next_data               ; it means that index has no need to take new line
        cmp     port_number, 80h        ; check if it is on end of bank, 128
        je      next_bank               ; when bank writing is whole complete
        add     bx, 06h                 ; move index into next newline
        jmp     next_data

next_bank:

        cmp     bank, 72h               ; it means bank1
        jz      exit                    ; when bank1 is complete, it means writing cmos work is complete 
        add     bank, 2                 ; change to bank1
        xor     dx, dx                  ; initialize dx 
        add     bx, 06h                 ; move index into next newline
        mov     port_number, 00h        ; initialize port_number
        jmp     next_data               ; do all routine again same as bank0

read_process:

        @print_string    ColumnBar      ;     00 01 02 .......0F
        @print_string    SeparateBar    ; ----------------------

        xor     dx, dx                  ; initialize
        mov     dl, 70h                 ; bank0, index port
        xor     ax, ax                  ; initialize
	mov	cx, 80h                 ; bank0: 70h has 128 values, bank1: 72h also.
        lea     si, data_buffer         ; data_buffer place data read from cmos

read:	
        xor     ah, ah  		; clear ah, in case of other accident   
	out	dx, al  		; select which register you want to read
        mov     ah, al  		; save al to ah
        inc     dl      		; add one to 71h data port
	in	al, dx  		; take the value
        dec     dl      		
        push    dx      		; save bank port
        mov     dl, al  		; put data to dl
        shr     ax, 8   		; shift ah to al,e.g. al has number of register
        push    ax      		; save the number of register
        mov     al, dl  		; put data to al

        @on_visable     al      	; let data visable

	pop	ax      		; take back the number of register
        inc     al
        test    al, 0fh 		; Is it dived complete by 16
        jne     nextone

        @print_string    newline 	; put "LF": line feed, "CR": carriage return

        mov     dl, 0dh
        mov     [si], dl
        inc     si

        mov     dl, 0ah
        mov     [si], dl
        inc     si

        add     RowBarCount, 10h        ; show row bar count 10->F0
        cmp     RowBarCount, 00h
        je      nextone                 ; when RowBarCount from F0 become 00,trim it
        @on_visable     RowBarCount

        @print_char      20h       	; put space between data

        mov     dl, 20h
        mov     [si], dl
        inc     si

nextone:
        pop     dx      		; take back bank port

        loop	go_read
        jmp     go_head

go_read:
        jmp     read    		; in case of the amount of bytes embedded loop-next exceed 128byte

go_head:
        dec     Count
        cmp     Count, 0
        je      writetofile
        mov     dl, 72h 		; bank1, index port
        xor     dh, dh  		; initial dh
        mov     cx, 80h 		; initial cx
        xor     ax, ax  		; initial ax
        jmp     read

open_fail:

        @print_string    file_error

usage:
        @print_string    usage1
        @print_string    usage2
        @print_string    usage3
        @print_string    usage4

        jmp     exit

writetofile:

        @create_file     filename, 00h
        @open_file       filename, 02h
        jc      open_fail
        mov     handle, ax        	; save the file handle
        @write_file      handle, ColumnBar, 53
        @write_file      handle, SeparateBar, 57
        @write_file      handle, data_buffer, 860
        @close_file      handle
        jmp     exit
        
exit:
        ret

Testa endp
                       
;;---------------------------------------------------
EmptyRoutine    proc FAR
        ret
EmptyRoutine    endp
;;---------------------------------------------------
end Testa




