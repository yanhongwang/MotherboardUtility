
include asm.inc
.model small
.586p
.stack
.data
ReadBuffer              DB      1024 dup(0)
ReadSize                DW      1024			; 1K
Multi                   DW	1024                    ; 1M
file_name               DB      16 dup (0)
Resault			DB	13,10,'CHECKSUM = $'
OpenErr                 DB      13, 10, 'No  file Name !!',13 ,10,'$'
CheckSum                DW      0
table                   DB      '0123456789ABCDEF'
handle                  DW      ?
Actual_Read             DW      0
.code
Start:
        mov     ax, @data
        mov     ds, ax

        mov     si, 80h
        mov     al, es:[si]
        or      al, al
        jz      No_File
        sub     al, 1
        xor     cx, cx
        mov     cl, al
        add     si, 2
        mov     di, offset file_name
GetFileName:
        mov     al, es:[si]
        mov     [di], al
        inc     di
        inc     si
        loop    GetFileName

        f_open  file_name, 2
        Printf  file_name
        jnc     OpenOK
        jmp     No_File
OpenOK:
        mov     handle, ax
        mov     cx, Multi
Multiloop:
        push    cx
        f_read  ReadBuffer, ReadSize, handle
        mov     Actual_Read, ax
        or      ax, ax
        jz      ReadDone
        mov     cx, Actual_Read
        mov     si, offset ReadBuffer
        xor     ax, ax
caculoop:
        mov     al, [si]
        add     Checksum, ax
        inc     si
        loop    caculoop
        pop     cx
        loop    Multiloop
ReadDone:
        mov     ax, Checksum
        HexWord
        f_close handle
        jmp     Exit
No_File:
        Printf  OpenErr
Exit:
        mov     ah, 4ch
        int     21h
end     Start
