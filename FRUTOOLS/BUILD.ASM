include inc\file.inc
.model small
.386
.data
PSP             dw      0
help0           db      'GIGABYTE FRU Data Builder Ver 0.5 for SR147 platform only.',24h
FRU_Size        EQU     256
INI_Size        EQU     10*1024
FRU_Buffer      db      FRU_Size     dup (0FFh)
INI_Buffer      db      INI_Size     dup (0)
FRU_Name        db      'SR147.FRU', 0
INI_Name        db      'FRU.INI', 0
File_Err        db      'Error! cannot open the "FRU.INI" file!!', 13, 10, 24h
Year            dw      ?
Month           db      ?
Day             db      ?
Hour            db      ?
Min             db      ?
month_table	db	31
FEB		db	28
		db	31
		db	30
		db	31
		db	30
		db	31
		db	31
		db	30
		db	31
		db	30
		db	31
Lunar_Day       db      0
Total_day       dw      ?
Total_Min       dd      ?
Adjust_Flag     db      0
Handle          dw      ?
DebugFlag       db      0
INI_Read_Size   dw      ?
INI_last        dw      ?
Temp_SI         dw      ?
Temp_CX         dw      ?
Base_Offset_Flag db      ?
Offset_Flag      db      ?
Field_Attrib    db      ?
Field_Value     db      ?
Field_Length    db      ?
Only_One_Byte   db      0
;       Bit 7:6= 00=Common,01=Special, 10=Not thing,11=Exit
;       Bit 5=Number/Char, bit 4:0 = Value
Opcode_Tbl      db      7, '[Start]'
                db      80h                     ; Not Thing
                db      5, '[End]'
                db      0C0h                    ; Exit
                db      10, 'Break_Here'
                db      40h                     ; Special Func 0
                db      8, '@STRUCT='
                db      41h                     ; Special Func 2
                dd      0
Special_Func_Tbl dw     offset  DebugFun
                 dw     offset  BuildStructFun
Size_Special_Tbl EQU     ($-Special_Func_Tbl) /2	;
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
;        
        Print   help0
        OpenFile INI_Name, 0			; open "FRU.INI"
        jnc     short Open_OK                   ; if open success, jmp to Open_OK
        Print   File_Err                        ; open file fail
        jmp     ext_dos
Open_OK:
        mov     Handle, ax
        ReadFile Handle, INI_Buffer, INI_Size, 0	; INI_Buffer: "fru.ini" content in this buffer, INI_Size: the byte you want read in 
        mov     INI_Read_Size, ax		; save actual amount of bytes reading
        mov     si, offset INI_Buffer		; take the beginning address of INI buffer to si
        add     ax, si
        mov     INI_last, ax			; save end address of INI buffer to INI_last
        CloseFile Handle
        					; now,	INI_Read_Size: actual amount of bytes reading
        						INI_Buffer: the beginning address of INI buffer
        						INI_last: end address of INI buffer

        OpenFile FRU_Name, 1			; open binary file "SR147.FRU" in order to write in
        jnc     short Open_OK1
        CreateFile FRU_Name, 0			; no binary file "SR147.FRU" under this folder, create it 
Open_OK1:
        mov     Handle, ax
        WriteFile Handle, FRU_Buffer, 0		; ?
        call    Build_Fru_Data			; fill out fru data into FRU_Buffer
        WriteFile Handle, FRU_Buffer, FRU_Size
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
Build_Fru_Data  proc 
        mov     di, offset INI_Buffer		; take the beginning address of INI buffer to di
        mov     bx, offset FRU_Buffer		; fru binary data store in FRU_Buffer, take the beginning address of FRU_Buffer to bx
        push    ds
        pop     es				; equal mov es, ds
Cmp_Data:
        cmp     INI_last, di			; INI_last: end address of INI buffer, check if comparison is reach end
        ja      Not_Last_Byte
        jmp     finish_Job			; it means all ini data is read completely
Not_Last_Byte:
        mov     si, offset Opcode_Tbl
next_Item:
        mov     al, [di]			; put INI buffer content into al
        cmp     al, ';'				; it means "comment" in the INI buffer, ignore behind semicolon
        jz      Next_Line
        cmp     al, 0dh				; it means the end of the line
        jz      Next_Line
        jmp     Not_Next_Line			; it present index at non-end of line or semicolon
Next_Line:
        cmp     word ptr [di], 0a0dh		; if [di] is end of the line
        jnz     not_CR
        add     di, 2				; it means the end of the line, add 2 in order to skip 0d0a;
        jmp     Not_Next_Line
not_CR:
        call    Search_CR
        add     di, ax				; ax is distance between 0a0d and current index position
        jmp     Cmp_Data
Not_Next_Line:					; it present index at non-end of line or semicolon
						; si is store address of Opcode_Tbl
	mov     al, [si]			; put length of the compared string to al
        xor     ah, ah				; clear ah
        mov     Temp_CX, ax			; length of the compared string
        mov     ax, si				; put address of the compared string to al
        inc     ax				; point to starting address of the compared string
        mov     Temp_Si, ax			; starting address of the compared string
        push    si				; push address of the compared string to al
        push    cx
        mov     cx, Temp_CX
        mov     si, Temp_Si
        push    di
        Repe    CMPSB				; compare the source byte(DS:SI) and destination byte(ES:DI) byte by byte
        jcxz    Found_It			; when cx = 0, jmp Found_It
        pop     di
        pop     cx
        pop     si
        mov     ax, Temp_CX
        add     si, ax				; add index si to leap to next compared string
        inc     si
        inc     si
        jmp     next_Item
Found_It:
        pop     di
        pop     cx
        pop     si
        push    bx
        mov     bx, si				; put address of string length to bx
        mov     al, [si]			; Get String Length
        xor     ah, ah				; clear ah
        add     di, ax				; Adjust DI
						; di is pointer of INI buffer
        add     bx, ax				; bx is pointer of FRU_Buffer
        inc     bx
        mov     al, [bx]			; Get Flag
        pop     bx

;	structure of al describe type/length byte format as below
;	Bit 7:6= 00=Common,01=Special, 10=Not thing,11=Exit
;	Bit 5=Number/Char, bit 4:0 = Value

        mov     ah, al
        and     ah, 0c0h			; mask low nibble to calculate the length of string
        or      DebugFlag, 0
        jz      Not_Debug_Mode
Not_Debug_Mode:

        or      ah, 0
        jz      Is_Common
	
        cmp     ah, 040h			; if ah is '@'
        jz      Is_Special
        
        cmp     ah, 080h			; 
        jz      Cmp_Data
        
        jmp     finish_Job
        
Is_Common:
        call    Goto_Common			; al is used in Goto_Common, al is type/length byte format
        jmp     Cmp_Data
Is_Special:
        call    Goto_Special
        jmp     Cmp_Data
;
finish_Job:
        ret
Build_Fru_Data  endp
;;---------------------------------------------------
Search_CR proc near
        xchg    si, di			; proc 'SearchStringLength' need indicator "si" to operate so exchange
        SearchStringLength 0a0dh, 0
        xchg    si, di			; change back
        ret
Search_CR endp
;;---------------------------------------------------
;       Bit 7:6= 00=Common,01=Special, 10=Not thing,11=Exit
;       Bit 5=Number/Char, bit 4:0 = Value
Goto_Common proc near
        test    al, 20h			; ascii of 20h is space
        jnz     IS_Char
        xor     cx, cx
        and     al, 1Fh
        mov     cl, al
Get_Number_Value:
        cmp     cl, 1
        jnz     Not_One_Byte
        mov     ax, [di]
        xchg    al, ah
        call    ASCII2HEX_Near
        mov     [bx], al                ; Write to Buffer
        inc     bx
        inc     di
        inc     di
        inc     di
        jmp     finish_to_Get
Not_One_Byte:
        mov     ax, [di]
        xchg    al, ah
        call    ASCII2HEX_Near
        mov     [bx], al                ; Write to Buffer
        inc     bx
        inc     di
        inc     di
        inc     di
finish_to_Get:
        loop    Get_Number_Value
        jmp     finish_Job1
IS_Char:
        xchg    si, di
        GetStringLength 24h, 0
        xchg    si, di
        push    cx
        mov     cl, [bx]-1
        or      cl, al
        mov     [bx]-1, cl
        mov     cx, ax
        xchg    si, di
        xchg    bx, di
        rep     movsb
        xchg    bx, di
        xchg    si, di
        pop     cx
        inc     di
finish_Job1:
        ret
Goto_Common endp
;;---------------------------------------------------
Goto_Special proc near
        and     al, 1fh
        cmp     al, Size_Special_Tbl
        ja      No_Support
        push    bx
        xor     bx, bx
        movzx   bx, al
        shl     bx, 1
        jmp     word ptr Special_Func_Tbl[bx]
FuncReturn:
        pop     bx
No_Support:
        ret
DebugFun::
        or      DebugFlag, 1
        jmp     FuncReturn
BuildStructFun::
        call    BuildStruct
        jmp     FuncReturn
Goto_Special endp
;;---------------------------------------------------
ASCII2HEX_Near Proc near
        xchg    ah, al			; valid data should be in al
        ASCII2HEX			; the result of ASCII2HEX will put in al
        ret
ASCII2HEX_Near endp
;;---------------------------------------------------
BuildStruct Proc near
        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        add     di, ax			; Skip Common Header Info
        inc     di
        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        sub     ax, 2			; in order to grasp offset value
        add     di, ax			; to grap OFFSET value 
        mov     ax, [di]
        call    ASCII2HEX_Near		; ax will be used in ASCII2HEX_Near
					; the result of ASCII2HEX_Near will put in al
	
	mov     Base_Offset_Flag, al
        add     di, 3
        call    Search_CR
        add     di, ax			; ax is distance between 0a0d and current index position
        add     di, 2			; skip 0d0ah
        
Next_Search:
        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        add     di, ax			; Skip common header Info
        push    eax
        mov     eax,',,,,'
        cmp     eax, [di]		; check if reached an end of structure
        pop     eax
        jz      FinishJob		; end of structure
        inc     di
        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        sub     ax, 2
        add     di, ax			; Offset address
        mov     ax, [di]
        add     di, 3			; skip "offset address" area
	
	call    ASCII2HEX_Near		; ax will be used in ASCII2HEX_Near
					; the result of ASCII2HEX_Near will put in al
					
        mov     Offset_Flag, al
        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        sub     ax, 2
        add     di, ax			; Field Size
        mov     ax, [di]
        add     di, 3			; skip "Field Size" area
        
	call    ASCII2HEX_Near		; ax will be used in ASCII2HEX_Near
					; the result of ASCII2HEX_Near will put in al
					
        mov     Field_Length, al        ; Get Field Size
        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        dec     ax
        add     di, ax                  
        mov     al, [di]                ; Get Field Attrib
        mov     Field_Attrib, al	; no need to call proc ASCII2HEX_Near due to data is one symbol letter
        add     di, 2			; skip "Field Attrib" area
;
	cmp     al, 'T'
	jz      Time_Format		; if Field_Attrib is character 'T' i.e time format, the process below don't excute
	
	cmp     al, 'C'
	jz      CheckSum_Format		; if Field_Attrib is character 'C' i.e checksum format, the process below don't excute
	
	call    Search_Not_Space	; search next non-space symbol after proc 'Search_Next' string length into ax
	
	add     di, ax			; shift pointer to data
	mov     cl, Field_Length
	movzx   cx, cl			; moves content of the source operand into a destination of larger size, high order part of destination is fill with 0's
	push    bx
	mov     bl, Field_Attrib
	
        mov     Only_One_Byte, 0
        call    Search_CR		; result will put in ax
					; ax is distance between 0a0d and current index position
	
        cmp     bl, 'B'
        jnz     Not_Binary_Format	; if Field_Attrib is character 'B' i.e binary format, the process below excute
        shr     al, 1
	
Not_Binary_Format:

        cmp     al, cl
        jz      Get_Binary_Data
        
        cmp     al, 2
        ja      Get_Binary_Data
        
        or      Only_One_Byte, 1

Get_Binary_Data:
        push    cx
        cmp     bl, 'B'
        jz      Binary_Format
        cmp     cl, 1
        jnz     Not_Last_String
        call    Search_CR
        cmp     ax, 2
        jnz     Not_Last_String
        inc     di
Not_Last_String:
        mov     al, [di]
        or      Only_One_Byte, 0
        jz      Not_One_Byte_Mode
        cmp     cl, 1
        jz      Not_One_Byte_Mode
        jmp     Update_FRU
Not_One_Byte_Mode:
        inc     di           
        jmp     Update_FRU
Binary_Format:
        mov     ax, [di]
        or      Only_One_Byte, 0
        jz      Not_One_Byte_Mode1
        cmp     cl, 1
        jz      Not_One_Byte_Mode1
        jmp     TransferHex
Not_One_Byte_Mode1:
        add     di, 2      
TransferHex:
        call    ASCII2HEX_Near
Update_FRU:
        mov     bh, al
        push    bx
        mov     al, Base_Offset_Flag
        add     al, Offset_Flag
        mov     bl, al
        mov     al, bh
        movzx   bx, bl
        mov     FRU_Buffer[bx], al
        inc     Offset_Flag

        pop     bx
        pop     cx
        loop    Get_Binary_Data
        pop     bx
        jmp     Done
Time_Format:
        pusha
        xor     ax, ax
        mov     ah, 04h
        int     1ah
        mov     bx, 2000
        mov     al, cl
        call    Dec2Hex
        add     bx, ax
        mov     year, bx
        mov     al, dh
        call    Dec2Hex
        mov     Month, al
        mov     al, dl
        call    Dec2Hex
        mov     Day, al
;
        xor     ax, ax
        mov     ah, 02h
        int     1ah
        mov     al, ch
        call    Dec2Hex
        mov     Hour, al
        mov     al, cl
        call    Dec2Hex
        mov     Min, al
;
        mov     ax, year
        xor     dx, dx
        call    check_lunar
        dec     dl                      ; [Seed_12/15/2003] 
        mov     Lunar_Day, dl

        mov     ax, year
        xor     dx, dx
        sub     ax, 1996
        mov     bx, 365
        mul     bx
        mov     dl, Lunar_Day
        movzx   dx, dl
        add     ax, dx                  ; Day
        mov     Total_day, ax
        mov     ax, year
        call    check_lunar2
        xor     ch, ch
        mov     cl, Month
        dec     cl
        xor     bx, bx
        xor     ah, ah
Add_Day:
        mov     al, month_table[bx]
        add     Total_day, ax
        inc     bx
        loop    Add_Day
        mov     al, Day
        xor     ah, ah
        add     Total_day, ax
;
        mov     ax, Total_day
        mov     bx, 24*60
        xor     dx, dx
        mul     bx
        shl     edx, 16
        mov     dx, ax
        mov     eax, edx
        mov     Total_Min, eax
;
        mov     al, Hour
        xor     ah, ah
        mov     bl, 60
        xor     dx, dx
        mul     bl
        mov     bl, Min
        xor     bh, bh
        add     ax, bx
        movzx   eax, ax
        add     Total_Min, eax
        mov     ecx, Total_Min
        mov     al, Base_Offset_Flag
        add     al, Offset_Flag
        mov     bl, al
        mov     al, bh
        movzx   bx, bl
        mov     FRU_Buffer[bx], cl
        shr     ecx, 8
        mov     FRU_Buffer[bx+1], cl
        shr     ecx, 8
        mov     FRU_Buffer[bx+2], cl
        popa
        jmp     Done
CheckSum_Format:
        push    cx
        push    bx
        mov     al, Base_Offset_Flag
        add     al, Offset_Flag
        mov     cl, al
        sub     cl, Base_Offset_Flag
        movzx   cx, cl
        mov     bl, Base_Offset_Flag
        movzx   bx, bl
        xor     al, al
CaleCheckSum:
        add     al, FRU_Buffer[bx]
        inc     bx
        loop    CaleCheckSum
        xor     ah, ah
        sub     ah, al
        xchg    al, ah
        pop     bx
        pop     cx
;
        mov     bh, al
        push    bx
        mov     al, Base_Offset_Flag
        add     al, Offset_Flag
        mov     bl, al
        mov     al, bh
        movzx   bx, bl
        mov     FRU_Buffer[bx], al
        pop     bx
        call    Search_CR
        add     di, ax				; ax is distance between 0a0d and current index position
        add     di, 2
Done:
        jmp     Next_Search
FinishJob:
        add     di, 4
        ret
BuildStruct endp
;;---------------------------------------------------
Search_Next proc near
	xchg    si, di				; proc 'GetStringLength' need indicator "si" to operate so exchange
	GetStringLength ',', 0                  ; after GetSTringLength, length into ax
	xchg    si, di                          ; change back
	ret
Search_Next endp
;;---------------------------------------------------
Search_Not_Space proc near
	xchg    si, di				; proc 'GetStringLength' need indicator "si" to operate so exchange
	GetStringLength 20h, 2			; after GetSTringLength, length into ax
	xchg    si, di				; change back
	ret
Search_Not_Space endp
;;---------------------------------------------------
Dec2Hex proc near
        mov     ah, al
        and     ax, 0F00Fh
        shr     ah, 4
        aad					; 
        xor     ah, ah
        ret
Dec2Hex endp
;;---------------------------------------------------
check_lunar proc
        push    ax
        push    bx
        mov     bx, 1996
        xchg    ax, bx
Cmp_Lunar:
        cmp     ax, bx
        jz      Exit_Lunar
	test	al, 3			
	jnz	short not_lunar
        inc     dx
not_lunar:
        inc     ax
        jmp     Cmp_Lunar
Exit_Lunar:
        pop     bx
        pop     ax
        ret
check_lunar endp
;;---------------------------------------------------
check_lunar2 proc
	test	al, 3			
	jnz	short not_lunar
        inc     Feb
not_lunar:
        ret
check_lunar2 endp
;;---------------------------------------------------
end Testa
