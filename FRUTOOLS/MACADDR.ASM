include inc\file.inc
LAN_VENDOR_ID		EQU	08086H
LAN_DEVICE_ID		EQU	01075H
LAN_Chip_ID_For_UUID	EQU	18-16

.model small
.386
.data?
INI_Size        EQU     10*1024
INI_Buffer      db      INI_Size     dup (?)
.data
PSP             dw      0
Handle          dw      ?
MSG2            db      'Lan Mac address = $'
MAC_String      db      12 dup (0)
Month           db      2 dup (0)
Day             db      2 dup (0)
Hour            db      4 dup (0)
Min             db      4 dup (0)
Sec             db      4 dup (0)
Year            db      4 dup (0)
BaseAddr        dd      0
INI_Name        db      'FRU.INI', 0
Read_Size       dw      0
SearchSoureNameS  db     'UUID(MAC)'
SearchSoureName2  db     'RECODE CHECKSUM'
SearchSoureName3  db     'OFFSET=08'
Checksum1       db      0
.stack
.code
EXTERN  DisplayHexDBValue(EmptyRoutine):FAR
EXTERN  SetRealModeLimit(EmptyRoutine):FAR
MacAddr proc far
        push    ds
        xor     ax, ax
        push    ax 
        mov     ax, @data
        mov     ds, ax
        mov     ax, es
        mov     PSP, ax
;        
	call    GetDate				; save value to Month
						; save value to Day
						; save value to Hour
						; save value to Min
						; save value to Sec
						; save value to Year


; finding a device on the PCI bus:

; there are 2 ways of finding a PCI device on the bus.
; You can either use the PCI BIOS interface call, or direct hardware I/O.
; Here's the BIOS way:

	xor	si, si				; start 1st match device, 0=1st device, 1=2nd etc.
						; SI will normally be zero
						; unless you are trying to locate the 2nd or more instance of the same PCI device.

SearchDevice:
	mov	cx, LAN_DEVICE_ID		; device ID, 01075H, PCI device, ethernet controller
	mov	dx, LAN_VENDOR_ID		; vendor ID, 08086H, intel's unique sig
	mov	ax, 0B102H			; find PCI device, interrupt 1a function b102

	int	1AH				; invoke BIOS
						; once returned from this call
						; BH=bus number, BL=device/function
						
	jc	short SearchDevice

	mov	di, 10h   	                ; get ethernet controller LAN Memory Base Address, register number
	mov	ax, 0B10AH		        ; PCI double word in ecx
	int	1AH				; AX = B10Ah
						; BH = bus number
						; BL = device/function number (bits 7-3 device, bits 2-0 function)
						; DI = register number 
						; Return:	CF clear if successful
						;		ECX = dword read
						; ecx has memory base address

	and	ecx, not 0fh
	mov     BaseAddr, ecx
;
        or      al, 1				; force bit0 of al is set
        call    SetRealModeLimit		; when al = 1, disable a20
        mov     edi, BaseAddr
        Print   MSG2				; 'Lan Mac address = $'
	
	mov     ecx, 6
        add     di, 40h
        push    di

Display6:
        push    ecx
        mov     ax, es:[edi]
        push    edi
        push    bp
        mov     bp,1				; if you assign 1 to bp after calling DisplayHexDBValue
        					; it will save MsgBuferData address into eax
        					; but, no symbol '$' at the end of the string
	
	call    DisplayHexDBValue
        pop     bp
        pop     edi
        inc     edi
        pop     ecx
        loop    Display6
        pop     di




        mov     bx, offset MAC_String
        mov     ecx, 6
        push    edi

Display6_2:
        push    ecx
        mov     ax, es:[edi]
        push    edi
        push    bp
        mov     bp, 3				; if you assign 3 to bp after calling DisplayHexDBValue
        					; it will save MsgBuferData address into eax
        					; symbol '$' at the end of the string
        
        call    DisplayHexDBValue		; if bp == 3 after calling DisplayHexDBValue, visable char address will put into eax 
        push    si
        push    es
        mov     si, ax
        shr     eax, 16
        mov     es, ax
        mov     ax, es:[si]
        mov     [bx], ax			; write to MAC_String
        inc     bx
        inc     bx
        pop     es
        pop     si
        pop     bp
        pop     edi
        inc     edi
        pop     ecx
        loop    Display6_2
;
        pop     edi
        mov     ecx, 6
CaleCheckSum:
        mov     al, es:[edi]
        add     Checksum1, al
        inc     edi
        loop    CaleCheckSum
;
        xor     al, al
        call    SetRealModeLimit		; when al = 0, disable a20

        OpenFile INI_Name, 2			; 'FRU.INI'
        jnc     short Open_OK1
        ret
Open_OK1:
        mov     Handle, ax    
        ReadFile  Handle, INI_Buffer, INI_Size, 0	; put 'FRU.INI' all content into INI_Buffer
        mov     Read_Size, ax
;
        mov     di, offset INI_Buffer		; copy starting address of INI_Buffer to di
        mov     ax, seg INI_Buffer
        mov     es, ax				; due to instruction 'cmps' need to operate between DS:SI and ES:DI
NotFound2:
        mov     si, offset SearchSoureNameS	; 'UUID(MAC)'
        mov     cx, Sizeof SearchSoureNameS     ; Length of Source name string, ready to compare char one by one
        repe    cmpsb                           ; Continuous to compare string
        jnz     NotFound2                       ; Jump if can't found the source string
						; always search until compare is match
						; di, si is added automatically after 'cmpsb'
						
Found2:                                         ; Got the source string
        inc     di
        call    Search_Next			; search next comma ',' symbol after proc 'Search_Next' string length into ax
	
	add     di, ax				
        inc     di
        call    Search_Next			; search next comma ',' symbol after proc 'Search_Next' string length into ax
	
	add     di, ax
        inc     di
        call    Search_Next			; search next comma ',' symbol after proc 'Search_Next' string length into ax
	
	add     di, ax
        inc     di
        call    Search_Not_Space		; search next non-space symbol after proc 'Search_Next' string length into ax
	
	add     di, ax
        mov     si, offset MAC_String		; ready save MAC to MAC_String
        mov     cx, sizeof MAC_String
	rep     movsb				; copy string of MAC
	
        call    Next_Line
        mov     eax, dword ptr Month
        mov     es:[di], eax
        
        call    Next_Line
        mov     eax, dword ptr Hour
        mov     es:[di], eax

        call    Next_Line
        mov     eax, dword ptr Min
        mov     es:[di], eax
        
        call    Next_Line
        mov     eax, dword ptr Sec
        mov     es:[di], eax
	
	add     di, 4
        mov     eax, dword ptr year
        mov     es:[di], eax
;
        mov     di, offset INI_Buffer		; turn to initial position
        mov     ax, seg INI_Buffer
        mov     es, ax
NotFound2A:
        mov     si, offset SearchSoureName2	; 'RECODE CHECKSUM'
        mov     cx, Sizeof SearchSoureName2	; Length of Source name string, ready to compare char one by one
        repe    cmpsb                           ; Continuous to compare string
        jnz     NotFound2A                      ; Jump if can't found the source string
						; always search until compare is match
						; di, si is added automatically after 'cmpsb'

Found2A:                                        
	inc     di                              
	call    Search_Next			; search next comma ',' symbol after proc 'Search_Next' string length into ax
	
	add     di, ax
	inc     di
	call    Search_Next			; search next comma ',' symbol after proc 'Search_Next' string length into ax
	
	add     di, ax
	inc     di
	call    Search_Next			; search next comma ',' symbol after proc 'Search_Next' string length into ax
	
	add     di, ax
	inc     di
	call    Search_Not_Space		; search next non-space symbol after proc 'Search_Next' string length into ax
	
	add     di, ax				; now, di is at checksum position
	mov     ah, Checksum1
	xor     al, al
	sub     al, ah				; take checksum calculate by 2's complement, e.g. 45 -> -45 = 211
						; put checksum result into al
	push    edi
	push    bp
	mov     bp, 3				; if bp == 3 after calling DisplayHexDBValue, visable char address will put into eax 
	call    DisplayHexDBValue
	push    si
	push    es
	mov     si, ax
	shr     eax, 16
	mov     es, ax
	mov     ax, es:[si]			; take visable char from the result of proc DisplayHexDBValue
	pop     es
	pop     si
	pop     bp
	pop     edi
	mov     es:[di], ax			; RECODE CHECKSUM, replace the original checksum with new value
	
	mov     di, offset INI_Buffer		; initialize the original ini buffer address
	mov     ax, seg INI_Buffer
	mov     es, ax
NotFound2B:
        mov     si, offset SearchSoureName3	; 'OFFSET=08'
        mov     cx, Sizeof SearchSoureName3	; Length of Source name string, ready to compare char one by one
                                                ; Continuous to compare string
                                                ; Jump if can't found the source string
                                                ; always search until compare is match
                                                ; di, si is added automatically after 'cmpsb'
	
        repe    cmpsb
        jnz     NotFound2B
Found2B:
        inc     di
        call    Next_Line
        xor     al, al
        mov     Checksum1, al			; initialize checksum1
        mov     cx, 4
CaleChecksumLoop:
        push    cx
        call    Next_Line
        mov     ax, es:[di]
        xchg    ah, al
        ASCII2HEX				; the result of ASCII2HEX will put in al
        add     Checksum1, al
        pop     cx				
        loop    CaleChecksumLoop		; calculate value include below:
        					; FORMAT
						; RECORD ID TYPE
						; UUID FORMAT
						; RECORD LENGTH
	
	call    Next_Line
        mov     ah, Checksum1
        xor     al, al
        sub     al, ah				; the result of checksum1 is in  al
;
        push    edi
        push    bp
        mov     bp, 3
        call    DisplayHexDBValue		; if bp == 3 after calling DisplayHexDBValue, visable char address will put into eax
        push    si
        push    es
        mov     si, ax
        shr     eax, 16
        mov     es, ax
        mov     ax, es:[si]			; take visable char from the result of proc DisplayHexDBValue
        pop     es
        pop     si
        pop     bp
        pop     edi
        mov     es:[di], ax			; RECODE CHECKSUM, replace the original checksum with new value
;
        SeekFile Handle, 0, 0, 0
        WriteFile Handle, INI_Buffer, Read_Size
        CloseFile Handle
;       
        ret
MacAddr endp
;;---------------------------------------------------
EmptyRoutine    proc FAR
        ret
EmptyRoutine    endp
;;---------------------------------------------------
Search_Next proc near
        xchg    si, di			; proc 'GetStringLength' need indicator "si" to operate so exchange
        GetStringLength ',', 0		; after GetSTringLength, length into ax
        xchg    si, di			; change back
        ret
Search_Next endp
;;---------------------------------------------------
Search_Not_Space proc near
        xchg    si, di			; proc 'GetStringLength' need indicator "si" to operate so exchange
        GetStringLength 20h, 2		; after GetSTringLength, length into ax
        xchg    si, di			; change back
        ret
Search_Not_Space endp
;;---------------------------------------------------
GetDate proc near
        xor     ax, ax
        mov     ah, 04h
        int     1ah			; Reads the date from the computer's real-time clock.
        				; Returns:	cf	Set if clock not operating; else cleared
					;		ch	Century (19 or 20) (BCD)
					;		cl	Year (BCD)
					;		dh	Month (BCD)
					;		dl	Day (BCD)

        mov     Checksum1, ch		;		ch	Century (19 or 20) (BCD)
        add     Checksum1, cl		;		cl	Year (BCD)
        add     Checksum1, dh		;		dh	Month (BCD)
        add     Checksum1, dl		;		dl	Day (BCD)
;
        mov     ax, cx			;		ch	Century (19 or 20) (BCD), cl	Year (BCD), cx: 20xx, e.g. 2005
        mov     cx, 4
        mov     bx, offset Year
        call    DEC2ASCII
;
        mov     ax, dx			;		dh	Month (BCD), dl	Day (BCD)
        mov     cx, 4
        mov     bx, offset Month
        call    DEC2ASCII

        xor     ax, ax
        mov     ah, 02h
        int     1ah			; Read real time clock
        				; Return:	ch = hours
					;		cl = minutes
					;		dh = seconds
;

        add     Checksum1, ch		; ch = hours
        add     Checksum1, cl		; cl = minutes
        add     Checksum1, dh		; dh = seconds
        push    cx
        mov     al, ch			; ch = hours
        xor     ah, ah
        mov     cx, 4
        mov     bx, offset Hour
        call    DEC2ASCII
;
        pop     cx
        mov     al, cl			; cl = minutes
        xor     ah, ah
        mov     cx, 4
        mov     bx, offset Min
        call    DEC2ASCII
;
        mov     al, dh			; dh = seconds
        xor     ah, ah
        mov     cx, 4
        mov     bx, offset Sec
        call    DEC2ASCII
        ret
GetDate endp
;;---------------------------------------------------
DEC2ASCII proc near
        push    cx
        push    ax
        push    bx
        push    dx
DEC2ASCII_Loop:

; e.g. ax: 2003

        rol     ax, 4
        mov     dl, al
        and     dl, 0fh
        or      dl, 30h			; make visable
        mov     [bx], dl
        inc     bx
        loop    DEC2ASCII_Loop
        pop     dx
        pop     bx
        pop     ax
        pop     cx
        ret
DEC2ASCII endp
;;---------------------------------------------------
Search_CR proc near
        xchg    si, di			; proc 'SearchStringLength' need indicator "si" to operate so exchange
        SearchStringLength 0a0dh, 0
        xchg    si, di			; change back
        ret
Search_CR endp
;;---------------------------------------------------
Next_Line proc
        call    Search_CR
        add     di, ax			; ax is distance between 0a0d and current index position
        add     di, 2			; skip 0d, 0ah

        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
	add     di, ax                  ; Skip Common Header Info
        inc     di

        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        add     di, ax                  ; Skip Offset
        inc     di

        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        add     di, ax                  ; Skip Length
        inc     di

        call    Search_Next		; search next comma ',' symbol after proc 'Search_Next' string length into ax
        add     di, ax                  ; Skip ID
        inc     di

        call    Search_Not_Space	; search next non-space symbol after proc 'Search_Next' string length into ax
        add     di, ax
        ret
Next_Line endp
end MacAddr
