class_code	STRUC
	base_class_code		db	0
	sub_class_code		db	0
	programming_interface	db	0
	string_address		dw	0
class_code	ENDS

include utility.inc
.model small
.386
.data

include data.inc

vga_only_one    equ     1
scan_all        equ     0

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
        

initialize:
                                          
        @cls                            ; clear the screen
        @print_string   main_banner
	@print_string   pci_banner	; Vendor ID    Device ID   Bus# Dev# Fun# Name

        mov     conf_address, 80000000h ; initialize conf_address, MSB make valid will enable configuration address port
        mov     display_index, 00h      ; the show line indicator 

	mov	ax, offset class_code_table_end
	mov	di, offset class_code_table_start
	sub	ax, di                  ; calculate class_code_table capacity
	mov	bl, size class_code     ; size of structure class_code
	div	bl
	mov	count_class, al         ; copy count of class_code_table to count_class

scan:
        mov     dx,  pci_index_port     ; index port: 0CF8h
        mov     eax, conf_address                  
        out     dx,  eax
        mov     dx,  pci_data_port      ; data port:0CFCh
        in      eax, dx

        cmp     eax, invalid_value      ; if invalid, eax will be FFFFFFFFh
        jne     show_value              ; valid value

        add     conf_address, 0100h     ; invalid value, next index, i.e. next function number

        ; when you want to scan all whole position, please compare 81000000h 
if      scan_all
        cmp     conf_address, 81000000h ; check if index is reached end, i.e. bus number FFh, Device number FFh, function number FFh
else
        cmp     conf_address, 80080000h ; check if index is reached end, i.e. bus number 07h, Device number FFh, function number FFh
endif

        je      show_done
        jmp     scan

show_value:                             ; valid value

        mov     dl, arrow_index           
        cmp     dl, display_index       ; check if the screen needed to show arrow in front of vendor id
        jnz     no_arrow                  
                                          
        @print_char     10h             ; show right-arrow symbol point to item
        mov     edx, conf_address
        mov     conf_address_indicator, edx  ; save the conf_address, in order to use in pci_detail

no_arrow:

        inc     display_index           ; only use for compare with arrow_index

;0CF8:pci index port
;0CFC:pci data port
;below is configuration address port at 0CF8

;                    0CFBh                     0CFAh                       0CF9h                      0CF8h
; 31 30 29 28 27 26 25 24   23 22 21 20 19 18 17 16   15 14 13 12 11   10 09 08   07 06 05 04 03 02   01 00 
;  1  0  0  0  0  0  0  0 |      bus number         | device number  | function | index double word |  0  0
;       80 constant       |        0  - 255         |     0 - 31     |   0 - 7  |      0 - 64       | 0 constant

        @print_string   space_2         ; indent ahead
                                          
        mov     edx, eax                ; in case of eax changed by display process
        @on_visable     dh              ; high byte of Vendor ID
        @on_visable     dl              ; low byte of Vendor ID
        shr     edx, 10h                ; shift right 16 positions
                                          
        @print_string   space_6         ; put space between data
                                          
        @on_visable     dh              ; high byte of Device ID
        @on_visable     dl              ; low byte of Device ID
                                          
        mov     edx, conf_address       ; extract Bus number, Device number, Function number
        shr     edx, 08h                ; in order to put Bus number in dh, device number and function number in dl
                                          
        @print_string   space_6         ; put space between data
        @on_visable     dh              ; show bus number

        mov     dh, dl
        shr     dh, 03h                 ; truncate function number, take device number
        @print_string   space_3
        @on_visable     dh              ; show device number

        mov     dh, dl
        and     dh, 07h                 ; mask device number, take function number
        @print_string   space_3
        @on_visable     dh              ; show function number
	                                  
	@print_string   space_3		; put space between data


        add     conf_address, 08h       ; indicate class register, i.e. add one to programming interface
        mov     dx, pci_index_port                      
        mov     eax, conf_address                  
        out     dx, eax
        mov     dx, pci_data_port
        in      eax, dx                 ; class register in eax, structure list below
        sub     conf_address, 08h       ; unspecific class register
                                          
;31 30 29 28 27 26 25 24   23 22 21 20 19 18 17 16   15 14 13 12 11 10 09 08   07 06 05 04 03 02 01 00 
;     Base Class Code    |      Sub Class Code     |  Programming Interface  |       Revision ID 

        mov     base_sub_program, eax
        @table_match    eax             ; eax include base class code, sub class code, programming interface
                                        ; table_match search appropriate suite
        mov     ah, 09h                 ; finally put string address into dx
        int     21h

        @print_string	newline




if      vga_only_one       

        and     base_sub_program, 0FFFFFF00h    ; mask revision id
        cmp     base_sub_program, 03000000h     ; check if 03000000
        jnz     not_vga_device

        or      conf_address, 0700h     ; fill with remainder
                                        ; this process will play one time
not_vga_device:

endif


        add     conf_address, 0100h

        ; when you want to scan all whole poistion, please compare 81000000
if      scan_all
        cmp     conf_address, 81000000h ; check if index is reached end, i.e. bus number FFh, Device number FFh, function number FFh
else
        cmp     conf_address, 80080000h ; check if index is reached end, i.e. bus number 07h, Device number FFh, function number FFh
endif

        jnz     scan                    ; if needed to scan again

show_done:

	@cursor_hidden                  ; hidden the cursor

        @get_invisable_key              ; get user command
        cmp     ah, 50h                 ; arrow down
        jnz     if_arrow_up

if_arrow_down:

        inc     arrow_index
        mov     al, arrow_index         
        cmp     al, display_index       ; if arrow point out of last item, rotate to first one 
        jb      rotate_to_first
        mov     arrow_index, 00h        ; rotate to first one

rotate_to_first:

        jmp     initialize              ; show all routine again and again

if_arrow_up:

        cmp     ah, 48h                 ; arrow up
        jnz     if_enter_key
        dec     arrow_index             ; in case of arrow point out of first item, rotate to fast one 
        js      rotate_to_last          ; when sign flag become negative mean overhead happen in arrow_index
        jmp     initialize              ; show all routine again and again

rotate_to_last:

        dec     display_index           ; in order to revise boundary problem
        mov     al, display_index       ; turn arrow to last item
        mov     arrow_index, al
        jmp     initialize              

if_enter_key:

        cmp     ah, 1Ch                 ; if user press "Enter" key , pci detail will appear on screen
        jz      pci_detail
        cmp     ah, 01h                 ; "Esc"
        jnz     initialize
        jmp     exit


pci_detail:                             ; show pci detail

        @cls                            ; usage like command "cls" under DOS envirnment
	
        and     conf_address_indicator, 0FFFFFF00h      ; mask all index byte in configuration address port register
        mov     row_bar_count, 00h      ; initialize row bar number

        @print_string   device_banner   ; Device:


        @print_string   newline
        @print_string   newline
        @print_string   newline

	@print_string	pci_detail_banner       ;     00 01 02 .......0F
        @print_string   separate_bar            ; ----------------------

read_pci_detail:        

        mov     dx,  pci_index_port                      
        mov     eax, conf_address_indicator     ; choose the pci detail indicated by user             
        out     dx,  eax
        mov     dx,  pci_data_port
        in      eax, dx                 	; class register in eax, structure list below

        mov     ebx, eax                	; copy data to ebx in case of taint eax

; the data receive from eax is double word ,i.e. 32 bits
; remember! small-endian sequence

;                                                 ebx
; 31 30 29 28 27 26 25 24   23 22 21 20 19 18 17 16   15 14 13 12 11 10 09 08   07 06 05 04 03 02 01 00 
;                        |                         |             bh          |             bl

; Due to intel structure so we need to show our data reversely, i.e. from low byte to high byte


        mov     edx, conf_address_indicator
        shr     dl, 02h                         ; grap address index
        mov     double_word_index, dl           ; let register space free

if_address_0:

        cmp     double_word_index, 04h  	; if this loop is base address 0, catch it, double word address is 4
        jnz     if_address_1
        mov     address_0, ebx
        jmp     byte_LSB

if_address_1:

        cmp     double_word_index, 05h  	; if this loop is base address 1, catch it, double word address is 5
        jnz     if_address_2
        mov     address_1, ebx
        jmp     byte_LSB

if_address_2:

        cmp     double_word_index, 06h  	; if this loop is base address 2, catch it, double word address is 6
        jnz     if_address_3
        mov     address_2, ebx
        jmp     byte_LSB

if_address_3:

        cmp     double_word_index, 07h  	; if this loop is base address 3, catch it, double word address is 7
        jnz     if_address_4
        mov     address_3, ebx
        jmp     byte_LSB

if_address_4:

        cmp     double_word_index, 08h  	; if this loop is base address 4, catch it, double word address is 8
        jnz     if_address_5
        mov     address_4, ebx
        jmp     byte_LSB

if_address_5:

        cmp     double_word_index, 09h  	; if this loop is base address 5, catch it, double word address is 9
        jnz     byte_LSB
        mov     address_5, ebx




byte_LSB:

        @on_visable     bl              
        @print_char     20h

if_revision_id_and_class_code:

        cmp     double_word_index, 02h  	; if this loop is revision_id, catch it, double word address is 2
        jnz     if_interrupt_line
        mov     revision_id, bl         	; save revision id


        mov     eax, ebx                	; save class code in eax
        @table_match    eax
        mov     name_address, dx        	; save string address into name_address in case of tain

        jmp     byte_Second

if_interrupt_line:

        cmp     double_word_index, 0Fh  	; if this loop is interrupt_line, catch it, double word address is F
        jnz     byte_Second
        mov     interrupt_line, bl

byte_Second:

        @on_visable     bh
        @print_char     20h

if_latency_timer:

        cmp     double_word_index, 03h  	; if this loop is latency_timer, catch it, double word address is 3
        jnz     if_interrupt_pin
        mov     latency_timer, bh
        jmp     byte_Third

if_interrupt_pin:

        cmp     double_word_index, 0Fh  	; if this loop is interrupt_pin, catch it, double word address is F
        jnz     byte_Third
        mov     interrupt_pin, bh


byte_Third:

        shr     ebx, 10h                	; take high position of extension bx

        @on_visable     bl
        @print_char     20h

byte_MSB:

        @on_visable     bh
        @print_char     20h


        add     conf_address_indicator, 04h     ; point to next address, range 0 - 64 , please refer to configuration address 
        test    conf_address_indicator, 0FFh    ; check if need to stop request
        jz      show_important_detail
        test    conf_address_indicator, 0Ch     ; check if need to make a newline
        jnz     read_pci_detail

        @print_string   newline
        add     row_bar_count, 10h

        @on_visable     row_bar_count

        @print_char     20h       		; put space between data
        @print_char     20h       		; put space between data

        jmp     read_pci_detail                 ; show all pci detail until 256 bytes is shown done


show_important_detail:

        @locate top_x, top_y
        mov     dx, name_address                ; show name in pci detail, device name
        mov     ah, 09h                         ; name_address is derived from table pattern match work
        int     21h

	@locate right_x, right_y                ; show data width, dev id, int line, int pin, latency timer, etc.....
        mov     al, right_y
        add     al, 02h

        @locate right_x, al                     ; data width
        @print_string   data_width_banner         
        @on_visable     08h                       
                                                  
        add     al, 02h                           
        @locate right_x, al                     ; revision id
        @print_string   rev_id_banner             
        @on_visable     revision_id               
                                                  
                                                  
        inc     al                                
        @locate right_x, al                     ; interrupt line
        @print_string   int_line_banner
        @on_visable     interrupt_line

        inc     al
        @locate right_x, al                     ; interrupt pin
        @print_string   int_pin_banner            
        @on_visable     interrupt_pin             
                                                  
        inc     al                                
        @locate right_x, al                     ; latency timer
        @print_string   latency_timer_banner      
        @on_visable     latency_timer             
                                                  
        add     al, 02h                           
        @locate right_x, al                     ; address_0_banner
        @print_string   address_0_banner          
        @print_32_bits  address_0                 
                                                  
        inc     al                                
        @locate right_x, al                     ; address_1_banner
        @print_string   address_1_banner          
        @print_32_bits  address_1                 
                                                  
        inc     al                                
        @locate right_x, al                     ; address_2_banner
        @print_string   address_2_banner          
        @print_32_bits  address_2                 
                                                  
        inc     al                                
        @locate right_x, al                     ; address_3_banner
        @print_string   address_3_banner          
        @print_32_bits  address_3                 
                                                  
        inc     al                                
        @locate right_x, al                     ; address_4_banner
        @print_string   address_4_banner          
        @print_32_bits  address_4                 
                                                  
        inc     al                                
        @locate right_x, al                     ; address_5_banner
        @print_string   address_5_banner          
        @print_32_bits  address_5                 
                                                  
        add     al, 02h                           
        @locate right_x, al                     ; rom
        @print_string   rom_banner                
                                                  
                                                  
        @locate bottom_x, bottom_y              ; put the cursor to bottom
        @print_string    type_pci_banner          
        @print_string    bus_banner               
        mov     ebx, conf_address_indicator     ; extract bus number, device number, function number
        shr     ebx, 08h                          
        dec     bl                                
        @on_visable     bh                        
        @print_string   device_banner             
        mov     bh, bl                          ; copy device number and function number to bh
        shr     bh, 03h                         ; kick off function  number, take device number
        @on_visable     bh                        
        @print_string   function_banner           
        and     bl, 07h                         ; kick off device number, take function number
        @on_visable     bl



; 43 26 15          
;
; first of all, cursor move to figure '4' position, call int 10h to read char '4', Reverse it, 
; back one space to figure '3' position, call int 10h to read char '3', Reverse it 
; finally, take cursor back  to figure '4'
; When user press any action key( up down left right ), repeat the behave prior expression 

        cmp     save_flag, 00h          ; revision due to input_data_process make cursor shift right one position
        jz      no_revise_position
        dec     current_x               ; revise x position
        and     save_flag, 00h

no_revise_position:

        @locate current_x, current_y

        mov     ah, 08h                 
        mov     bh, 00h
        int     10h                     	; read char code at cursor position
                                        	; char in al
                                        	  
        mov     ah, 09h                 	  
        mov     bl, 70h                 	  
        mov     cx, 01h                 	  
        int     10h                     	; reverse char attribution
                                        	  
        inc     current_x               	  
        @locate current_x, current_y    	; move cursor to adjacent position in order to read char code
                                        	  
        mov     ah, 08h                 	  
        mov     bh, 00h                 	  
        int     10h                     	; read char code at cursor position
                                        	  
        mov     ah, 09h                 	  
        mov     bl, 70h                 	  
        mov     cx, 01h                 	  
        int     10h                     	; reverse char attribution
                                        	  
        dec     current_x               	  
        @locate current_x, current_y    	; move back the cursor to original position

;        @cursor_hidden                                                         

input_data_process:                     ; input data process 

        ; user can input 0-9, A-F at pci register until user press enter key to save
        ; otherwise, the direction key or pageup / pagedown or other key would escape save condition
        @get_invisable_key

if_figure_1:

        cmp     ah, 02h                 ; figure 1
        jnz     if_figure_2               
        mov     nibble_value, 31h         
        jmp     input_data                
                                          
if_figure_2:                              
                                          
        cmp     ah, 03h                 ; figure 2
        jnz     if_figure_3               
        mov     nibble_value, 32h         
        jmp     input_data                
                                          
if_figure_3:                              
                                          
        cmp     ah, 04h                 ; figure 3
        jnz     if_figure_4               
        mov     nibble_value, 33h         
        jmp     input_data                
                                          
if_figure_4:                              
                                          
        cmp     ah, 05h                 ; figure 4
        jnz     if_figure_5               
        mov     nibble_value, 34h         
        jmp     input_data                
                                          
if_figure_5:                              
                                          
        cmp     ah, 06h                 ; figure 5
        jnz     if_figure_6               
        mov     nibble_value, 35h         
        jmp     input_data                
                                          
if_figure_6:                              
                                          
        cmp     ah, 07h                 ; figure 6
        jnz     if_figure_7               
        mov     nibble_value, 36h         
        jmp     input_data                
                                          
if_figure_7:                              
                                          
        cmp     ah, 08h                 ; figure 7
        jnz     if_figure_8               
        mov     nibble_value, 37h         
        jmp     input_data                
                                          
if_figure_8:                              
                                          
        cmp     ah, 09h                 ; figure 8
        jnz     if_figure_9               
        mov     nibble_value, 38h         
        jmp     input_data                
                                          
if_figure_9:                              
                                          
        cmp     ah, 0Ah                 ; figure 9
        jnz     if_figure_0
        mov     nibble_value, 39h
        jmp     input_data

if_figure_0:

        cmp     ah, 0Bh                 ; figure 0
        jnz     if_figure_A
        mov     nibble_value, 30h
        jmp     input_data

if_figure_A:

        cmp     ah, 1Eh                 ; figure A
        jnz     if_figure_B
        mov     nibble_value, 41h
        jmp     input_data

if_figure_B:

        cmp     ah, 30h                 ; figure B
        jnz     if_figure_C
        mov     nibble_value, 42h
        jmp     input_data

if_figure_C:

        cmp     ah, 2Eh                 ; figure C
        jnz     if_figure_D
        mov     nibble_value, 43h
        jmp     input_data

if_figure_D:

        cmp     ah, 20h                 ; figure D
        jnz     if_figure_E
        mov     nibble_value, 44h
        jmp     input_data

if_figure_E:

        cmp     ah, 12h                 ; figure E
        jnz     if_figure_F
        mov     nibble_value, 45h
        jmp     input_data

if_figure_F:

        cmp     ah, 21h                 ; figure F
        jnz     not_data_key
        mov     nibble_value, 46h
        jmp     input_data

not_data_key:

        cmp     ah, 1Ch                 ; enter key
        jnz     control_key
        cmp     save_flag, 01h          ; check if user had already input data
        jz      enter_save_process

control_key:

        cmp     ah, 4Dh                 ; right move symbol "->"
        jz      right_move              

        cmp     ah, 50h                 ; down move symbol "v"
        jz      down_move

        cmp     ah, 4Bh                 ; left move symbol "<-"
        jz      left_move

        cmp     ah, 48h                 ; up move symbol "^"
        jz      up_move

        cmp     ah, 51h                 ; page down
        jz      pci_detail_page_down

        cmp     ah, 49h                 ; page up
        jz      pci_detail_page_up

        cmp     ah, 01h                 ; escape pci_detail
        jz      initialize

        sub     conf_address_indicator, 100h    ; minus one in order to use original configuration address value
        jmp     pci_detail              ; show pci_detail again

input_data:

        mov     al, nibble_value        ; mean data replace it
        mov     ah, 09h
        mov     bl, 70h                 ; reverse char attribution
        mov     cx, 01h
        int     10h

        cmp     save_flag, 01h          ; if equal 1, it mean save process
        jz      cursor_no_move

        inc     current_x               
        @locate current_x, current_y    ; move cursor to adjacent position in order to read char code

        or      save_flag, 01h

cursor_no_move:

        jmp     input_data_process

enter_save_process:

        mov     ah, 03h
        mov     bh, 00h
        int     10h                     ; read cursor position
                                        ; dh: vertical position, y
                                        ; dl: horizontal postion, x

        sub     dh, origin_y
        shl     dh, 04h                 ; multiply 16

        sub     dl, origin_x
        dec     dl
        xor     ax, ax
        mov     al, dl                  ; dividend into ax
        div     data_interval           ; suite will place into al

        add     al, dh                  ; index suite accumulate into al
                                        ; in order to caculate quotient remainder

        div     dd_length               ; al: quotient mean suite number
                                        ; ah: remainder

        mov     suite_16, al

        mov     bl, current_x           ; save current_x value when save data process complete
                                        ; and then cursor can keep original position

cursor_move_to_MSB:

        inc     ah                      ; remainder derived from 
        cmp     ah, 04h
        jz      cursor_at_MSB
        add     bl, data_interval       ; add x, move to MSB position
        @locate bl, current_y
        jmp     cursor_move_to_MSB

cursor_at_MSB:

        xor     eax, eax
        mov     cx, 04h

read_screen_data:

        shl     save_value, 08h         ; shift save value in order to byte sequence, little endian

        mov     ah, 08h                 
        mov     dh, 00h
        int     10h                     ; read char code at cursor position
                                        ; char in al

        @hex2dec        al              ; low nibble of byte
        xor     ah, ah
        add     save_value, eax

        dec     bl
        @locate bl, current_y


        mov     ah, 08h                 
        mov     dh, 00h
        int     10h                     ; read char code at cursor position
                                        ; char in al

        @hex2dec        al              ; high nibble of byte
        xor     ah, ah
        shl     al, 04h
        add     save_value, eax


        sub     bl, 02h                 ; move to adjacent byte
        @locate bl, current_y

        loop    read_screen_data

        sub     conf_address_indicator, 100h    ; minus one in order to use original configuration address value

        shl     suite_16, 02h                   
        xor     eax, eax
        mov     al, suite_16
        add     conf_address_indicator, eax

        mov     dx,  pci_index_port                      
        mov     eax, conf_address_indicator     ; choose the pci detail indicated by user             
        out     dx,  eax
        mov     dx,  pci_data_port
        mov     eax, save_value
        out     dx,  eax


        jmp     pci_detail
  
right_move:

        add     current_x, 3
        cmp     current_x, 52
        jb      right_move_no_rotation
        mov     current_x, 4
        and     save_flag, 00h                  ; make save data situation disable

right_move_no_rotation:

        sub     conf_address_indicator, 100h    ; minus one in order to use original configuration address value
        jmp     pci_detail                      ; show pci_detail again

down_move:

        inc     current_y 
        cmp     current_y, 21
        jb      down_move_no_rotation
        mov     current_y, 5

down_move_no_rotation:

        sub     conf_address_indicator, 100h    ; minus one in order to use original configuration address value
        jmp     pci_detail                      ; show pci_detail again

left_move:

        sub     current_x, 03h
        cmp     current_x, 04h                  ; due to original current_x is set to 5, compare it check if needed to rotate
        jae     left_move_no_rotation
        mov     current_x, 49
        and     save_flag, 00h                  ; make save data situation disable

left_move_no_rotation:

        sub     conf_address_indicator, 100h    ; minus one in order to use original configuration address value
        jmp     pci_detail                      ; show pci_detail again

up_move:

        dec     current_y
        cmp     current_y, 05h                  ; due to original current_y is set to 5, compare it check if needed to rotate
        jae     up_move_no_rotation
        mov     current_y, 20

up_move_no_rotation:

        sub     conf_address_indicator, 100h    ; minus one in order to use original configuration address value
        jmp     pci_detail                      ; show pci_detail again

pci_detail_page_down:


page_down_scan:

        mov     dx,  pci_index_port             ; index port: 0CF8h                 
        mov     eax, conf_address_indicator                  
        out     dx,  eax
        mov     dx,  pci_data_port              ; data port:0CFCh
        in      eax, dx

        cmp     eax, invalid_value              ; if invalid, eax will be FFFFFFFFh

ife     vga_only_one

        jnz     pci_detail

else

        jz      down_next_one

        add     conf_address_indicator, 08h     ; indicate class register, i.e. add one to programming interface
        mov     dx, pci_index_port                      
        mov     eax, conf_address_indicator                  
        out     dx, eax
        mov     dx, pci_data_port
        in      eax, dx                         ; class register in eax, structure list below
        sub     conf_address_indicator, 08h     ; unspecific class register

        mov     base_sub_program, eax
        and     base_sub_program, 0FFFFFF00h    ; mask revision id
        cmp     base_sub_program, 03000000h     ; check if 03000000
        jnz     pci_detail

        test    conf_address_indicator, 0700h
        jz      pci_detail                      ; mean this is first one vga

        or      conf_address_indicator, 0700h   ; fill with remainder
                                                ; this process will play one time

down_next_one:

endif

        add     conf_address_indicator, 0100h     ; invalid value, next index, i.e. next function number

        ; when you want to scan all whole position, please compare 81000000h 
if      scan_all
        cmp     conf_address_indicator, 81000000h ; check if index is reached end, i.e. bus number FFh, Device number FFh, function number FFh
else
        cmp     conf_address_indicator, 80080000h ; check if index is reached end, i.e. bus number 07h, Device number FFh, function number FFh
endif

        jnz     page_down_scan
        mov     conf_address_indicator, 80000000h ; rotate to initial value
        jmp     page_down_scan



pci_detail_page_up:

        sub     conf_address_indicator, 200h    ; minus one in order to use original configuration address value
        cmp     conf_address_indicator, 80000000h
        jb      rotate_to_max
        jmp     page_up_scan

rotate_to_max:

if      scan_all
        mov     conf_address_indicator, 81000000h
else
        mov     conf_address_indicator, 80080000h
endif

page_up_scan:

        mov     dx,  pci_index_port     ; index port: 0CF8h                 
        mov     eax, conf_address_indicator                  
        out     dx,  eax
        mov     dx,  pci_data_port      ; data port:0CFCh
        in      eax, dx

        cmp     eax, invalid_value      ; if invalid, eax will, eax will be FFFFFFFFh

ife     vga_only_one

        jnz     pci_detail
else

        jz      up_next_one

        add     conf_address_indicator, 08h     ; indicate class register, i.e. add one to programming interface
        mov     dx, pci_index_port                      
        mov     eax, conf_address_indicator                  
        out     dx, eax
        mov     dx, pci_data_port
        in      eax, dx                         ; class register in eax, structure list below
        sub     conf_address_indicator, 08h     ; unspecific class register

        mov     base_sub_program, eax
        and     base_sub_program, 0FFFFFF00h    ; mask revision id
        cmp     base_sub_program, 03000000h     ; check if 03000000
        jnz     pci_detail

        test    conf_address_indicator, 0700h
        jz      pci_detail                      ; mean this is first one vga

up_next_one:

endif
        sub     conf_address_indicator, 0100h   ; invalid value, next index, i.e. next function number
        cmp     conf_address_indicator, 80000000h
        jb      rotate_to_max
        jmp     page_up_scan

exit:       

	@cursor_visable                 ;let cursor turn to original shape

        ret

Testa endp
;;---------------------------------------------------
EmptyRoutine    proc FAR
        ret
EmptyRoutine    endp
;;---------------------------------------------------
end Testa

