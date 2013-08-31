;---------------------------------------------------
;    File macro file version 1.24   <Seed Fu>
;---------------------------------------------------
include inc\standard.inc
File_ReadOnly EQU 00000001b                                ;Bit 0  
File_Hidden   EQU 00000010b                                ;Bit 1
File_System   EQU 00000100b                                ;Bit 2
File_Volume   EQU 00001000b                                ;Bit 3
Subdirectory  EQU 00010000b                                ;Bit 4
File_archived EQU 00100000b                                ;Bit 5

;****************************************************************************
;*  OpenFile                                                                *
;*  Entry:                                                                  *
;*  AL = 0 File opened for reading                                          *
;*  AL = 1 File opened for writting                                         *
;*  AL = 2 File opened for reading and writting                             *
;*  DS:DX= Point at a zero terminated string containing the filename        *
;*  Exit:                                                                   *
;*  AX= File handle                                                         *
;*  Jnc = Open Ok                                                           *
;****************************************************************************
OpenFile MACRO NAME, MODE
        @PUSH   bx, dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        xor     bx, bx
        mov     dx, offset NAME
        mov     ah, 3Dh
        mov     al, MODE
        int     21h
;
        @POP    bx, dx, ds
ENDM
;****************************************************************************
;*  CreateFile                                                              *
;*  Entry:                                                                  *
;*  DS:DX= Address of zero terminated pathname                              *
;*  CX= File attribute                                                      *
;*  Bit 0 = File is a Read-Only file                                        *
;*  Bit 1 = File is a Hidden file                                           *
;*  Bit 2 = File is a System file                                           *
;*  Bit 3 = File is a Volume label name                                     *
;*  Bit 4 = File is a Subdirectory                                          *
;*  Bit 5 = File has been archived (all regular files)                      *
;*  Exit:                                                                   *
;*  AX= File handle                                                         *
;*  Jnc = Create Ok                                                         *
;****************************************************************************
CreateFile MACRO NAME, ATTRIB
        @PUSH   cx, dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        mov     dx, offset NAME
        mov     cx, ATTRIB
        mov     ah, 3Ch
        int     21h
;
        @POP    cx, dx, ds
ENDM
;****************************************************************************
;*  FileExist                                                               *
;*  Entry:                                                                  *
;*  DS:DX= Address of zero terminated pathname                              *
;*  CX= File attribute                                                      *
;*  Bit 0 = File is a Read-Only file                                        *
;*  Bit 1 = File is a Hidden file                                           *
;*  Bit 2 = File is a System file                                           *
;*  Bit 3 = File is a Volume label name                                     *
;*  Bit 4 = File is a Subdirectory                                          *
;*  Bit 5 = File has been archived (all regular files)                      *
;*  Exit:                                                                   *
;*  AX= File handle                                                         *
;*  Jnc = File does not exist and create it                                 *
;*  Jc = File exist                                                         *
;****************************************************************************
FileExist MACRO NAME, ATTRIB
        @PUSH   cx, dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        mov     dx, offset NAME
        mov     cx, ATTRIB
        mov     ah, 5Bh
        int     21h
;
        @POP    cx, dx, ds
ENDM
;****************************************************************************
;*  CreateTempFile                                                          *
;*  Entry:                                                                  *
;*  DS:DX= Pointer to temporary path                                        *
;*  CX= File attribute                                                      *
;*  Bit 0 = File is a Read-Only file                                        *
;*  Bit 1 = File is a Hidden file                                           *
;*  Bit 2 = File is a System file                                           *
;*  Bit 3 = File is a Volume label name                                     *
;*  Bit 4 = File is a Subdirectory                                          *
;*  Bit 5 = File has been archived (all regular files)                      *
;*  Exit:                                                                   *
;*  AX= File handle                                                         *
;*  Jnc = Create Ok                                                         *
;****************************************************************************
CreateTempFile MACRO PATH, ATTRIB
        @PUSH   cx, dx, ds
;
        mov     ax, seg PATH
        mov     ds, ax
        mov     dx, offset PATH
        mov     cx, ATTRIB
        mov     ah, 5Ah
        int     21h
;
        @POP    cx, dx, ds
ENDM
;****************************************************************************
;*  CloseFile                                                               *
;*  Entry:                                                                  *
;*  BX= File handle                                                         *
;*  Exit:                                                                   *
;*  none                                                                    *
;*  Jnc = Close Ok                                                          *
;****************************************************************************
CloseFile MACRO HANDLE
        @PUSH   bx, ds
;
        mov     ax, seg HANDLE
        mov     ds, ax
        mov     ah, 3Eh
        mov     bx, HANDLE
        int     21h
;
        @POP    bx, ds
ENDM
;****************************************************************************
;*  ReadFile                                                                *
;*  Entry:                                                                  *
;*  BX= File handle                                                         *
;*  CX= number of bytes to read                                             *             *
;*  DS:DX= Array large enough to hold bytes read                            *
;*  Exit:                                                                   *
;*  AX= number of bytes actually read from the file                         *
;*  Jnc = Read Ok                                                           *
;****************************************************************************
ReadFile MACRO HANDLE, BUFF, BYTE, ADJUST
        @PUSH   bx, dx, cx, ds
;
        mov     ax, seg HANDLE
        mov     ds, ax
        mov     bx, HANDLE
        mov     cx, BYTE
        sub     cx, ADJUST
        mov     ax, seg BUFF
        mov     ds, ax
        mov     dx, offset BUFF
        add     dx, ADJUST
        mov     ah, 3Fh
        int     21h
;
        @POP    bx, dx, cx, ds
ENDM
;****************************************************************************
;*  WriteFile                                                               *
;*  Entry:                                                                  *
;*  BX= File handle                                                         *
;*  CX= number of bytes to write                                            *             *
;*  DS:DX= Address of buffer containing data to write                       *
;*  Exit:                                                                   *
;*  AX= number of bytes actually write to the file                          *
;*  Jnc = Write Ok                                                          *
;****************************************************************************
WriteFile MACRO HANDLE, BUFF, BYTE
        @PUSH   bx, dx, cx, ds
;
        mov     ax, seg HANDLE
        mov     ds, ax
        mov     bx, HANDLE
        mov     cx, BYTE
        mov     ax, seg BUFF
        mov     ds, ax
        mov     dx, offset BUFF
        mov     ah, 40h
        int     21h
;
        @POP    bx, dx, cx, ds
ENDM
;****************************************************************************
;*  SeekFile                                                                *
;*  Entry:                                                                  *
;*  AL= 0  Offset specified is from the beginning of the file               *
;*  AL= 1  Offset specified is distance from the currecnt file point        *
;*  AL= 2  The point is moved to end of the file minus the specified offset * 
;*  BX= File handle                                                         *
;*  CX:DX= Distance to move, In bytes.                                      *
;*  Exit:                                                                   *
;*  DX:AX= Contains the new file position                                   *
;*  Jnc = Seek Ok                                                           *
;****************************************************************************
SeekFile MACRO HANDLE, MODE, HighAddress, LowAddress
        @PUSH   ds, bx, cx
;
        mov     ax, seg HANDLE
        mov     ds, ax
        mov     bx, HANDLE
        mov     cx, HighAddress			; CX:DX = offset in bytes
        mov     dx, LowAddress			; CX:DX = offset in bytes
        
	mov     al, MODE			; AL = method value
						;	0 = offset from beginning of file
						;	1 = offset from present location
						;	2 = offset from end of file      

        mov     ah, 42H
        int     21h
;
        @POP    ds, bx, cx
ENDM
;****************************************************************************
;*  DeleteFile                                                              *
;*  Entry:                                                                  *
;*  DS:DX= Address of pathname to delete                                    *
;*  Exit:                                                                   *
;*  Jnc = Delete Ok                                                         *
;****************************************************************************
DeleteFile MACRO NAME
        @PUSH   dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        mov     dx, offset NAME
        mov     ah, 41h
        int     21h
;
        @POP    dx, ds
ENDM
;****************************************************************************
;*  RenameFile                                                              *
;*  Entry:                                                                  *
;*  DS:DX= Pointer to pathname of existing file                             *
;*  ES:DI= Pointer to new pathname                                          *
;*  Exit:                                                                   *
;*  none                                                                    *
;*  Jnc = Rename Ok                                                         *
;****************************************************************************
RenameFile MACRO OldNAME, NewNAME
        @PUSH   dx, ds, es
;
        mov     ax, seg OldNAME
        mov     ds, ax
        mov     dx, offset OldNAME
        mov     ax, seg NewNAME
        mov     es, ax
        mov     dx, offset NewNAME
        mov     ah, 56h
        int     21h
;
        @POP    dx, ds, es
ENDM
;****************************************************************************
;*  FileAttrib                                                              *
;*  Entry:                                                                  *
;*  AL = 0 Return file attributes in cx                                     *
;*  AL = 1 Set file attributes to those in cx                               *
;*  CX = Attributes to be if AL= 01                                         *
;*  DS:DX= Address of pathname                                              *
;*  Exit:                                                                   *
;*  CX = file's attributes if carry is clear                                *
;*  Jnc = Ok                                                                *
;****************************************************************************
FileAttrib MACRO NAME, MODE, Attrib
        @PUSH   cx, dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        mov     dx, offset NAME
        mov     cx, Attrib
        mov     al, MODE
        mov     ah, 43h
        int     21h
;
        @POP    cx, dx, ds
ENDM
;****************************************************************************
;*  FileDate                                                                *
;*  Entry:                                                                  *
;*  AL = 0 Get date and time                                                *
;*  AL = 1 Set date and time                                                *
;*  BX= File handle                                                         *
;*  CX = Time to be set if AL= 01                                           *
;*  DX = Date to be set if AL= 01                                           *
;*  Exit:                                                                   *
;*  CX /DX = is set to the time/date if AL= 00                              *
;*  Jnc = Ok                                                                *
;****************************************************************************
FileDate MACRO HANDLE, MODE, DateDATA, TimeDATA
        @PUSH   bx, ds
;
        mov     ax, seg HANDLE
        mov     ds, ax
        mov     bx, HANDLE
        mov     dx, DateDATA
        mov     cx, TimeDATA
        mov     al, MODE
        mov     ah, 57h
        int     21h
;
        @POP    bx, ds
ENDM
;****************************************************************************
;*  CreateDirectory                                                         *
;*  Entry:                                                                  *
;*  DS:DX = Pointer to zero terminated pathname.                            *
;*  Exit:                                                                   *
;*  none                                                                    *
;*  Jnc = Ok                                                                *
;****************************************************************************
CreateDirectory MACRO NAME
        @PUSH   dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        mov     dx, offset NAME
        mov     ah, 39h
        int     21h
;
        @POP    dx, ds
ENDM
;****************************************************************************
;*  RemoveDirectory                                                         *
;*  Entry:                                                                  *
;*  DS:DX = Pointer to zero terminated pathname.                            *
;*  Exit:                                                                   *
;*  none                                                                    *
;*  Jnc = Ok                                                                *
;****************************************************************************
RemoveDirectory MACRO NAME
        @PUSH   dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        mov     dx, offset NAME
        mov     ah, 3Ah
        int     21h
;
        @POP    dx, ds
ENDM
;****************************************************************************
;*  ChangeDirectory                                                         *
;*  Entry:                                                                  *
;*  DS:DX = Pointer to zero terminated pathname.                            *
;*  Exit:                                                                   *
;*  none                                                                    *
;*  Jnc = Ok                                                                *
;****************************************************************************
ChangeDirectory MACRO NAME
        @PUSH   dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        mov     dx, offset NAME
        mov     ah, 3Bh
        int     21h
;
        @POP    dx, ds
ENDM
;****************************************************************************
;*  GetCurrentDirectory                                                     *
;*  Entry:                                                                  *
;*  DL= default                                                             *
;*  DL= 1 drive A                                                           *
;*  DL= 2 drive B                                                           *
;*  DL= 3 drive C                                                           *
;*  DL= 4 drive D                                                           *
;*  DS:SI = Pointer to buffer.                                              *
;*  Exit:                                                                   *
;*  none                                                                    *
;*  Jnc = Ok                                                                *
;****************************************************************************
GetCurrentDirectory MACRO Drive, BUFF
        @PUSH   dx, ds, si, di
;
        mov     ax, seg BUFF
        mov     ds, ax
        mov     cx, sizeof BUFF
        push    es
        push    ds
        pop     es
        xor     al, al
        mov     di, offset BUFF
        REP     STOSB
        pop     es
        mov     si, offset BUFF
        mov     dl, drive
        mov     ah, 47h
        int     21h
;
        @POP    dx, ds, si, di
ENDM
;****************************************************************************
;*  SetDiskTransferAddress                                                  *
;*  Entry:                                                                  *
;*  DS:DX= Pointer to Disk Transfer Address(DTA)                            *
;*  Exit:                                                                   *
;*  None                                                                    *
;****************************************************************************
SetDiskTransferAddress MACRO DTA
        Local   DTA, Start
        jmp     Start
DTA db 42 dup (?), 0
Start:
        @PUSH   dx, ds
;
        mov     ax, seg DTA
        mov     ds, ax
        mov     dx, offset DTA
        mov     ah, 1Ah
        int     21h
;
        @POP    dx, ds
ENDM
;****************************************************************************
;*  FindFirstFile                                                           *
;*  Entry:                                                                  *
;*  CX = Attributes                                                         *
;*  Bit 0 = File is a Read-Only file                                        *
;*  Bit 1 = File is a Hidden file                                           *
;*  Bit 2 = File is a System file                                           *
;*  Bit 3 = File is a Volume label name                                     *
;*  Bit 4 = File is a Subdirectory                                          *
;*  Bit 5 = File has been archived (all regular files)                      *
;*  DS:DX= Pointer to filename                                              *
;*  Exit:                                                                   *
;*  Jc & AL=2 File not found.  Jc & AL=18 No more files                     *
;****************************************************************************
FindFirstFile MACRO NAME, Attrib
        @PUSH   cx, dx, ds
;
        mov     ax, seg NAME
        mov     ds, ax
        mov     dx, offset NAME
        mov     cx, Attrib
        mov     ah, 4Eh
        int     21h
;
        @POP    cx, dx, ds
ENDM
;****************************************************************************
;*  FindNextFile                                                            *
;*  Entry:                                                                  *
;*  None                                                                    *
;*  Exit:                                                                   *
;*  Jnc = Ok                                                                *
;*  Jc & AL=2 File not found.  Jc & AL=18 No more files                     *
;****************************************************************************
FindNextFile MACRO
        mov     ah, 4Fh
        int     21h
ENDM
;****************************************************************************
;*  GetDefaultDrive                                                         *
;*  Entry:                                                                  *
;*  None                                                                    *
;*  Exit:                                                                   *
;*  AL= number of logical drives                                            *
;****************************************************************************
GetDefaultDrive MACRO
        mov     ah, 19h
        int     21h
ENDM
;****************************************************************************
;*  SearchFile                                                              *
;*  Entry:                                                                  *
;*  None                                                                    *
;*  Exit:                                                                   *
;*  AX= currecnt Buffer offset address                                      *
;*  BX= numbers of file                                                     *
;****************************************************************************
SearchFile MACRO  SearchFileName, FileNameBuffer, OffsetAdjust
        Local   Beginning, NoMoreFile, NextEntry, DirLoop, DTA
        @PUSH   si, cx, di, es, bp
        xor     bp, bp
        mov     ax, seg FileNameBuffer
        mov     es, ax
        mov     di, offset FileNameBuffer
        add     di, OffsetAdjust
        jmp     Beginning                         
DTA db 42 dup (?), 0
Beginning:
;        
        SetDiskTransferAddress DTA
        FindFirstFile SearchFileName, Subdirectory      ; All files
        jc      NoMoreFile
DirLoop:
        mov     si, offset DTA +21
        cmp     byte ptr cs:[si], Subdirectory
        jz      NextEntry
        inc     bp
        mov     si, offset DTA +30
        push    ds
        push    cs
        pop     ds
        GetStringLength 0, 0
        mov     cx, ax
        REPNZ   MOVSB
        mov     byte ptr es:[di], 20h
        mov     ax, 0A0Dh
        mov     word ptr es:[di]+1, ax
        add     di, 3
        pop     ds
NextEntry:
        FindNextFile
        jnc     DirLoop
NoMoreFile:
        xchg    ax, di
        xchg    bx, bp
        @POP    si, cx, di, es, bp
ENDM
;****************************************************************************
;*  SearchDirectory                                                         *
;*  Entry:                                                                  *
;*  None                                                                    *
;*  Exit:                                                                   *
;*  AX= currecnt Buffer offset address                                      *
;*  BX= numbers of subdirectory                                             *
;****************************************************************************
SearchDirectory MACRO  SearchFileName, DirNameBuffer, OffsetAdjust
        Local   Beginning, NoMoreFile, NextEntry, DirLoop, DTA
        @PUSH   si, cx, di, es, bp
        mov     ax, seg DirNameBuffer
        mov     es, ax
        mov     di, offset DirNameBuffer
        add     di, OffsetAdjust
        jmp     Beginning                         
DTA db 42 dup (?), 0
Beginning:
;        
        SetDiskTransferAddress DTA
        FindFirstFile SearchFileName, Subdirectory      ; All files
        jc      NoMoreFile
DirLoop:
        mov     si, offset DTA +21
        cmp     byte ptr cs:[si], Subdirectory
        jnz     NextEntry
        mov     si, offset DTA +30
        cmp     byte ptr cs:[si], 2Eh
        jz      NextEntry
        inc     bp
        push    ds
        push    cs
        pop     ds
        GetStringLength 0, 0
        mov     cx, ax
        REPNZ   MOVSB
        mov     byte ptr es:[di], 20h
        mov     ax, 0A0Dh
        mov     word ptr es:[di]+1, ax
        add     di, 3
        pop     ds
NextEntry:
        FindNextFile
        jnc     DirLoop
NoMoreFile:
        xchg    ax, di
        xchg    bx, bp
        @POP    si, cx, di, es, bp
ENDM
;****************************************************************************
;*  GetCurrentPath                                                          *
;*  Entry:                                                                  *
;*  None                                                                    *
;*  Exit:                                                                   *
;*  AX= Path length                                                         *
;****************************************************************************
GetCurrentPath MACRO Drive, Path_Buffer0, Path_Buffer
        Local   Start, DrivesTable
        jmp     Start
    DrivesTable db      'A','B','C','D','E','F','G','H','I','J','K','L','M'
                db      'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
Start:
        @PUSH   bx
        GetCurrentDirectory Drive, Path_Buffer
        GetDefaultDrive
        mov     bl, al
        movzx   bx, bl
        mov     al, byte ptr cs:DrivesTable[bx]
        mov     Path_Buffer0, al
        mov     si, offset Path_Buffer0
        GetStringLength 0, 0
        @POP    bx
ENDM
