;---------------------------------------------------
; Windows edit interface file version 1.1  <Seed Fu>
;---------------------------------------------------
include inc\standard.inc
.model small
.386
.data
tot_regs        equ     70h
;----------------------------------------------------------------------------
.data
param	db	4 DUP (0)
men_msg db   ' ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»',0dh,0ah
        db   ' º                                                      º',0dh,0ah
        db   ' ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶',0dh,0ah
        db   ' ºÚÄÄÄ¿ ²²²²²²±±±±±±°°°°° 12:00:00 °°°°°°±±±±±±±²²²²²²² º',0dh,0ah
        db   ' º³ | ³ 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F º',0dh,0ah
        db   ' ºÀÄÄÄÙ------------------------------------------------ º',0dh,0ah
it_str  db   ' º 00 | 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 º',0dh,0ah
it_10   db   ' º 10 | 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 º',0dh,0ah
it_20   db   ' º 20 | 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 º',0dh,0ah
it_30   db   ' º 30 | 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 º',0dh,0ah
it_40   db   ' º 40 | 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 º',0dh,0ah
it_50   db   ' º 50 | 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 º',0dh,0ah
it_end  db   ' º 60 | 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 º',0dh,0ah
        db   ' ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶',0dh,0ah
        db   ' º <Ä  Ä> MoveCursor  0..F=Edit  Enter=Save  Esc=Exit º',0dh,0ah
line_@  db   ' ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼'
line_leng       equ     $ + 2 - line_@
tot_leng        equ     $ + 2 - men_msg                 ;End Of String
tot_line        equ     tot_leng / line_leng
row_last        equ     (it_end - it_str) / line_leng
bar_item        equ     16
col_last        equ     bar_item - 1
curs_begin      equ     0000h
clk_posi        equ     curs_begin + 0404h
time_posi       equ     031ah
str_posi        equ     curs_begin + 0608h
curs_end        equ     curs_begin + (tot_line - 1) * 100h
up_pos          equ     str_posi / 100h
down_pos        equ     up_pos + row_last
left_pos        equ     8
right_pos       equ     left_pos + col_last * 3
curs_size       dw      ?
cur_curs        dw      ?
pointer         dw      0
clk_point       dw      0
clk_msg         label   byte
                db      '|/Ä\'
ClkItem         equ     $ - clk_msg
ClkDiv          equ     6
cur_regs        db      0
editing         db      0
;----------------------------------------------------------------------------
.stack
.code
;EXTERN (EmptyRoutine):FAR
Win_Edit proc far
        push    ds
        xor     ax, ax
        push    ax 
        mov     ax, @data
        mov     ds, ax
        mov     ax, es
;        
        call    clr_screen
        lea     si,men_msg
        mov     cx,tot_leng-2
        mov     dx,curs_begin
        call    dsp_string
        call    set_no_curs
        mov     dx,str_posi
        mov     cur_curs,dx
        call    prt_out_regs
        mov     dx,cur_curs
        call    dsp_reverse

wait_key:
        mov     ah,1
        int     16h
        jnz     l_10                    ;key pressed
        call    update_scrn
        mov     dx,time_posi
        call    set_curs
        call    dsp_rtc_tm              ;12:00:00
        jmp     short wait_key
l_10:
        mov     ah,0
        int     16h
        cmp     al,30h                  ;'0' key ?
        jb      not_digit
        cmp     al,39h                  ;'1' key ?
        jna     is_digit
        and     al,NOT 20h              ;convert into upper case
        cmp     al,41h                  ;'A' key ?
        jb      not_digit
        cmp     al,46h                  ;'F' key ?
        ja      not_digit
is_digit:
        cmp     pointer,01
        ja      not_want                ;key in buff overflow
        push    ax
        mov     dx,cur_curs
        add     dx,pointer
        call    set_curs
        pop     ax
        call    prt_char_r
        inc     pointer
        or      editing,01h
        jmp     short wait_key
not_digit:                              ;not 0...F key
        cmp     ah,48h
        je      up_key
        cmp     ah,50h
        je      down_key
        cmp     ah,4bh
        jne     l_30
        jmp     left_key
l_30:
        cmp     ah,4dh
        jne     l_40
        jmp     right_key
l_40:
        cmp     ah,01                   ;<Esc> ?
        jne     l_50
        jmp     exit_
l_50:
        cmp     ah,0eh                  ;<BackSpace> ?
        jne     l_60
        jmp     back_space
l_60:
        cmp     ah,1ch                  ;<Enter> key ?
        jne     l_70
        jmp     enter_key
l_70:
        cmp     ah,3Bh                  ;<F1> key ?
        jne     not_want
        jmp     wait_key
not_want:
        call    err_music
        mov     pointer,0
        and     editing,NOT 01h
        jmp     wait_key
up_key:
        call    normal_curr
        cmp     dh,up_pos
        je      uk_10
        dec     dh
        jmp     short uk_20
uk_10:
        mov     dh,down_pos
uk_20:
        mov     cur_curs,dx
        call    dsp_reverse
        jmp     wait_key
down_key:
        call    normal_curr
        cmp     dh,down_pos
        je      dk_10
        inc     dh
        jmp     short dk_20
dk_10:
        mov     dh,up_pos
dk_20:
        mov     cur_curs,dx
        call    dsp_reverse
        jmp     wait_key
left_key:
        call    normal_curr
        cmp     dl,left_pos
        je      lk_10
        sub     dl,03
        jmp     short lk_20
lk_10:
        mov     dl,right_pos
lk_20:
        mov     cur_curs,dx
        call    dsp_reverse
        jmp     wait_key
right_key:
        call    normal_curr
        cmp     dl,right_pos
        je      rk_10
        add     dl,03
        jmp     short rk_20
rk_10:
        mov     dl,left_pos
rk_20:
        mov     cur_curs,dx
        call    dsp_reverse
        jmp     wait_key
back_space:
        cmp     pointer,0               ;buffer is empty ?
        je      not_want
        dec     pointer
        or      editing,01h
        mov     dx,cur_curs
        add     dx,pointer
        call    set_curs
        mov     al,255
        call    prt_char_b
        jmp     wait_key
enter_key:
        mov     dx,cur_curs
        push    dx
        call    get_value
        jnc     ek_10
        jmp     not_want
ek_10:
        mov     cl,04
        shl     al,cl
        mov     ch,al
        pop     dx
        inc     dl
        call    get_value
        jnc     ek_20
        jmp     not_want
ek_20:
        or      ch,al           ;ch = value
        call    curpos_2_reg    ;return: al = current curs position's reg #
	push	dx
; [Seed_11/26/2002] Add you code in here
;        call    IO_Write
; [Seed_11/26/2002] 
	pop	dx
        mov     pointer,0
        and     editing,NOT 01h
        jmp     wait_key
exit_:
        call    rest_curs
        call    clr_screen
;       
        ret
Win_Edit endp
;;---------------------------------------------------
curpos_2_reg    proc            ;return: al = current curs position's reg #
        mov     ax,cur_curs
        sub     ah,up_pos
        mov     cl,04
        shl     ah,cl
        mov     dl,ah
        mov     ah,0
        sub     al,left_pos
        mov     bl,03
        div     bl                      ;ax / bl = al ... ah
        or      al,dl                   ;al = index
        ret
curpos_2_reg    endp
;;---------------------------------------------------
update_scrn     proc
        call    prt_out_regs            ;print out all regs content
        mov     ax,clk_point
        xor     dx,dx
        mov     bx,ClkDiv
        div     bx                      ; dx:ax / bx = ax...dx
        mov     dx,clk_posi
        lea     si,clk_msg
        add     si,ax
        mov     cx,01                   ;1 characters
        call    dsp_string
        inc     clk_point
        cmp     clk_point,ClkItem*ClkDiv
        jne     us_ret
        mov     clk_point,00
us_ret:
        ret
update_scrn     endp
;;---------------------------------------------------
dsp_rtc_tm      proc
        mov     al,8ah                  ;rtc status register
        out     70h,al
        jmp     short $+2
        in      al,71h
        test    al,80h                  ;update in progress ?
        jnz     dt_ret                  ;yes, current time is invalid
        mov     al,04                   ;rtc hour
        call    prt_cmos_1
        call    next_curs
        mov     al,02                   ;rtc minute
        call    prt_cmos_1
        call    next_curs
        mov     al,00                   ;rtc second
        call    prt_cmos_1
dt_ret:
        ret
dsp_rtc_tm      endp
;;---------------------------------------------------
prt_cmos_1      proc                    ;Entry: al = cmos index #
        or      al,80h
        out     70h,al
        jmp     short $+2
        in      al,71h
        push    ax
        mov     cl,04
        shr     al,cl
        add     al,30h
        call    prt_char
        pop     ax
        and     al,0fh
        add     al,30h
        call    prt_char
        ret
prt_cmos_1      endp
;;---------------------------------------------------
err_music       proc
        mov     di,doh                  ;error beep
        mov     si,02
        call    sound
        mov     di,doh                  ;error beep
        mov     si,02
        call    sound
        ret
err_music       endp
;;---------------------------------------------------
get_value       proc            ;entry: dx = cursor position
        call    get_cur_char
        cmp     al,0ffh
        je      gv_ng
        cmp     al,39h
        ja      gv_10           ;not number key
        sub     al,30h
        clc
        jmp     short gv_ret
gv_10:
        and     al,NOT 20h      ;convert into upper case
        sub     al,55
        clc
        jmp     short gv_ret
gv_ng:
        stc
gv_ret:
        ret
get_value       endp
;;---------------------------------------------------
normal_curr     proc
        mov     pointer,0
        and     editing,NOT 01h
        call    dsp_normal
        mov     dx,cur_curs
        ret
normal_curr     endp
;;---------------------------------------------------
;*** Entry: ds:[si] - string , dx - cursor position, cx = length ***
dsp_string      proc
        push    cx
        cmp     dx,-1           ;don't need set cursor position ?
        jne     ds_05
        call    get_curs
ds_05:
        call    set_curs        ;set cursor position
        pop     cx
ds_10:
        push    cx
        mov     al,[si]
        mov     ah,0eh          ;print character
        mov     bh,0            ;page 0
        mov     bl,07h          ;normal attribute
        int     10h
        inc     si
        pop     cx
        loop    ds_10
        ret
dsp_string      endp
;;---------------------------------------------------
clr_screen      proc
        mov     ah,06           ;scroll up
        mov     al,00
        mov     cx,0000h        ;cx = upper left
        mov     dx,184fh        ;dx = down right
        mov     bh,07
        int     10h
        mov     ah,02           ;set cursor position (0,0)
        mov     bh,0
        mov     dx,0000h
        int     10h
        ret
clr_screen      endp
;;---------------------------------------------------
set_no_curs     proc
        call    get_curs
        mov     curs_size,cx
        mov     ah,01h          ; set cursor size
        mov     ch,1fh          ; up
        mov     cl,0            ; down
        int     10h
        ret
set_no_curs     endp
;;---------------------------------------------------
rest_curs       proc
        mov     ah,01h
        mov     cx,curs_size
        int     10h
        mov     dx,curs_end             ;cursor position without setting
        call    set_curs
        ret
rest_curs       endp
;;---------------------------------------------------
next_curs       proc
        call    get_curs
        inc     dl
        cmp     dl,80
        jb      set_curs
        inc     dh
        mov     dl,0
set_curs:
        mov     ah,02           ;set cursor position
        mov     bh,0
        int     10h
        ret
next_curs       endp
;;---------------------------------------------------
get_curs        proc
        mov     ah,03h          ;get cursor
        mov     bh,0
        int     10h
        ret
get_curs        endp
;;---------------------------------------------------
;Entry: dx = cursor position
dsp_normal      proc
        mov     dx,cur_curs
        call    set_curs        ;set cursor position
dn_10:
        mov     ah,08h          ;get charter in al
        mov     bh,0
        int     10h
        cmp     al,20h          ;end of string ?
        je      dn_ret
        call    out_norm
        jmp     short dn_10
dn_ret:
        ret
out_norm:                       ;print out al
        mov     ah,09h          ;print character
        mov     bh,0            ;page 0
        mov     bl,07h          ;normal attribute
        mov     cx,01           ;repeat 1 char
        int     10h
        call    next_curs       ;set cursor position to next
        ret
dsp_normal      endp
;;---------------------------------------------------
;Entry: dx = cursor position
dsp_reverse     proc
        call    set_curs        ;set cursor position
dr_10:
        mov     ah,08h          ;get charter in al
        mov     bh,0
        int     10h
        cmp     al,20h          ;end of string ?
        je      dr_ret
        call    prt_char_b
        jmp     short dr_10
dr_ret:
        ret
out_reve:                       ;print out al
        mov     ah,09h          ;print character
        mov     bh,0            ;page 0
        mov     bl,70h          ;reverse attribute
        mov     cx,01           ;repeat 1 char
        int     10h
        call    next_curs       ;set cursor position to next
        ret
dsp_reverse     endp
;;---------------------------------------------------
prt_hex_al      proc            ;Entry: AL=Hex , Return:print out AL (ascii)
        push    ax
        mov     ah,0
        mov     dl,16
        div     dl              ;ax / dl = al ... ah
        add     al,30h
        cmp     al,39h
        jna     po_10
        add     al,07h
po_10:
        mov     dl,ah
        cmp     bl,cur_regs
        jne     po_12
        call    prt_char_b
        jmp     short po_14
po_12:
        call    prt_char        ;print out al
po_14:
        add     dl,30h
        cmp     dl,39h
        jna     po_20
        add     dl,07h
po_20:
        mov     al,dl
        cmp     bl,cur_regs
        jne     po_22
        call    prt_char_b
        jmp     short po_24
po_22:
        call    prt_char
po_24:
        pop     ax
        ret
prt_hex_al      endp
;;---------------------------------------------------
prt_char        proc            ;entry: al = desired char
        push    bx
        mov     ah,0eh
        mov     bx,0007h
        int     10h
        pop     bx
        ret
prt_char        endp
;;---------------------------------------------------
prt_char_b      proc            ;print out al with reversed attribute
        push    bx
        push    cx
        push    dx
        mov     ah,09h          ;print character
        mov     bx,0071h        ;reversed blue
        mov     cx,01           ;repeat 1 char
        int     10h
        call    next_curs       ;set cursor position to next
        pop     dx
        pop     cx
        pop     bx
        ret
prt_char_b      endp
;;---------------------------------------------------
prt_char_r      proc            ;print out al with reversed attribute
        push    bx
        push    cx
        push    dx
        mov     ah,09h          ;print character
        mov     bx,0074h        ;reversed red
        mov     cx,01           ;repeat 1 char
        int     10h
        call    next_curs       ;set cursor position to next
        pop     dx
        pop     cx
        pop     bx
        ret
prt_char_r      endp
;;---------------------------------------------------
get_cur_char    proc            ;entry: dx = cursor position
        call    set_curs        ;set cursor position
        mov     ah,08h          ;get charter in al
        mov     bh,0
        int     10h
        ret
get_cur_char    endp
;;---------------------------------------------------
prt_out_regs    proc
        test    editing,01h             ;editing now ?
        jnz     rc_ret
        call    curpos_2_reg            ;calculate current position ---> reg #
        mov     cur_regs,al             ;al = current regs#

        mov     dx,str_posi
        call    set_curs
        xor     bx,bx
rc_10:
        push    bx
        mov     al,bl
        push	dx
; [Seed_11/26/2002]  Add you code in here
;	call	IO_Read
; [Seed_11/26/2002] 
        pop	dx
        call    prt_hex_al
        call    next_curs
        cmp     dl,right_pos
        jna     rc_20
        mov     dl,left_pos
        inc     dh
        call    set_curs
rc_20:
        pop     bx
        cmp     bl,tot_regs - 1
        je      rc_ret
        inc     bl
        jmp     short rc_10
rc_ret:
        ret
prt_out_regs    endp
;;---------------------------------------------------
;Ú-----------------------------------------------------------------¿
;| Name: SOUND                                                     |
;| Entry: di=frequency(tone), bl=sound length                      |
;| Note: 8254 control register (i/o 43h)    O 43,b6                |
;|  b7b6 = 2 --- tc 2 (spk opt), b5b4 = 3 --- read hi & lo byte    |
;|  b3b2b1=3 --- mode 3 (clock generator), b0 = 0 --- binary count |
;À-----------------------------------------------------------------Ù
pit_regist      equ     43h
ctrl_8254       equ     0b6h
pit_tc_2        equ     42h
ppi_port_b      equ     61h     ; 8255-ppi spk ctrl port

lll     equ     128
sol     equ     391
lal     equ     439
sil     equ     493
do_     equ     523
re_     equ     587
me_     equ     659
fa_     equ     698
so_     equ     784
la_     equ     880
sih     equ     988
doh     equ     1048

sound   proc                    ;entry: di=frequency(tone), si=sound length
        mov     al,ctrl_8254
        out     pit_regist,al
        mov     dx,0014h
        mov     ax,4f38h
        div     di              ; dx:ax / di = ax .... dx
        out     pit_tc_2,al     ; load freq lo byte
        jmp     short $+2
        mov     al,ah
        out     pit_tc_2,al     ; load freq hi byte
        jmp     short $+2
        in      al,ppi_port_b
        mov     ah,al           ; save org value
        or      al,03           ; let spk ctrl by pit
        out     ppi_port_b,al   ; turn on speaker
        call    delay_time
        mov     al,ah
        out     ppi_port_b,al   ; restore org value (turn off spk)
        ret
sound   endp
;;---------------------------------------------------
delay_time      proc            ;entry: si = delay time tic
        mov     ah,0            ;read system timer tic
        int     1ah
        mov     bx,dx           ;save timer tic low word
wk_20:
        mov     ah,0
        int     1ah
        sub     dx,bx
        cmp     dx,si           ;is time over ?
        jb      wk_20           ;jump if not over
        ret
delay_time      endp
;;---------------------------------------------------
set_curs       proc
        mov     ah,02           ;set cursor position
        mov     bh,0
        int     10h
        ret
set_curs        endp
;-------------------------------------
;input  :	dh (PMU address Low)
;output :	dl (read data)
;-------------------------------------
IO_Read	PROC
; [Seed_11/26/2002]  Add your code in here

; [Seed_11/26/2002] 
	ret
IO_Read	ENDP
;-----------------------------------
; Input	 : 	al (Command address)
; 		cl (write data)
;               dh (SMB ADDRESS)
; Output :	 
;-----------------------------------
IO_Write PROC
; [Seed_11/26/2002]  Add your code in here
; [Seed_11/26/2002] 
	ret
IO_Write ENDP
;;---------------------------------------------------
EmptyRoutine proc far
        ret
EmptyRoutine endp
;;---------------------------------------------------
end Win_Edit
