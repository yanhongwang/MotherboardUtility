;---------------------------------------------------
;    Standard macro file version 1.33   <Seed Fu>
;---------------------------------------------------
@PUSH MACRO A,B,C,D,E,F,G,H,I
        IRP CHAR,<A,B,C,D,E,F,G,H,I>
        IFNB <CHAR>
        PUSH    CHAR
        ENDIF
        ENDM
ENDM
;**************************************************
@POP MACRO A,B,C,D,E,F,G,H,I
        IRP CHAR,<I,H,G,F,E,D,C,B,A>
        IFNB <CHAR>
        POP     CHAR
        ENDIF
        ENDM
ENDM
;***************************************************
;* DOS FUNCTION CALL 02H:印字至螢幕                *
;***************************************************
OutChar MACRO OutCharData
        @PUSH   ax, dx
        xor     dh, dh
        mov     ah, 2h
        mov     dl, OutCharData
        int     21h
        @POP    ax, dx
ENDM
;**************************************************
;    輸出字串
;**************************************************
Print MACRO WORD
        @PUSH   ax, dx
        mov     dx, offset WORD
        mov     ah, 9h
        int     21h
        @POP    ax, dx
ENDM
;**************************************************
;    等待按鍵
;**************************************************
WaitKey MACRO
        xor     ax, ax
        int     16h
ENDM
;*************************************************
;*DOS FUNCTION CALL 06H:讀取按鍵不回映不等候     *
;*傳回: (AL)=鍵入字鍵之 ASCII 碼                 *
;*************************************************
WAITKEY2 MACRO  ;JZ = NO KEY
        mov     ah, 06h
        mov     dl, -1
        int     21h
ENDM
;*************************************************
;*BIOS FUNCTION CALL 01H:讀取按鍵不回映不等候    *
;*傳回: (AL)=鍵入字鍵之 ASCII 碼                 *
;*************************************************
WAITKEY3 MACRO  ;JZ = NO KEY
        mov     ah, 01h
        int     16h
ENDM
;***************************************************
;* DOS FUNCTION CALL 0AH 在螢幕上輸入一字串        *
;***************************************************
InputKey MACRO INDATA
        mov     dx, offset INDATA
        mov     ah, 0Ah
        int     21h
ENDM
;****************************************************************************
;*  GetStringLength                                                         *
;*  Entry:                                                                  *
;*  DS:SI= Buffer for search                                                *
;*  AX=String Length                                                        *
;*  BP= Function Flag                                                       *
;*  Bit0 = 0 Forward search / 1 Back search                                 *
;*  Bit2:1 = 00= JZ exit / 01= JNZ exit /02= JA exit /03= JB exit           *
;*  None                                                                    *
;****************************************************************************
GetStringLength MACRO SegChar, Mode
        Local   SearchSegChar, GetLength, NotStd, NotStd1, ContinueGo, IsJzExit, \
                IsJaExit, IsJbExit, IsJnzExit, LabelTbl
        @PUSH   bx, cx, si, bp
        pushf
        CLD
        mov     bp, Mode
        push    si				; save the initial index into stack
        mov     cx, -1
SearchSegChar:
        mov     ax, bp
        and     ax, 6
        mov     bx, ax
        mov     ax, LabelTbl[bx]
        jmp     ax
LabelTbl dw offset IsJzExit
         dw offset IsJnzExit
         dw offset IsJaExit
         dw offset IsJbExit
IsJaExit:
        cmp     byte ptr ds:[si], SegChar
        ja      GetLength
        jmp     ContinueGo
IsJbExit:
        cmp     byte ptr ds:[si], SegChar
        jb      GetLength
        jmp     ContinueGo
IsJnzExit:
        cmp     byte ptr ds:[si], SegChar
        jnz     GetLength
        jmp     ContinueGo
IsJzExit:
        cmp     byte ptr ds:[si], SegChar
        jz      GetLength
ContinueGo:
        test    bp, 1
        jz      NotStd
        dec     si
        dec     si
NotStd:
        inc     si
        jmp     SearchSegChar
        
GetLength:
        pop     cx				; take the initial index from stack into cx
        mov     ax, si
        sub     ax, cx				; string length into ax
        test    bp, 1
        jz      NotStd1
        not     ax
NotStd1:
        popf
        @POP    bx, cx, si, bp
ENDM
;****************************************************************************
;*  SearchStringLength                                                           *
;*  Entry:                                                                  *
;*  DS:SI= Buffer for search                                                *
;*  AX=String Length                                                        *
;*  None                                                                    *
;****************************************************************************
SearchStringLength MACRO SegChar, Mode
        Local   SearchSegChar, GetLength, NotStd, NotStd1
        @PUSH   cx, si, bp
        pushf
        CLD
        mov     bp, Mode
        push    si				; save the initial index into stack
        mov     cx, -1
SearchSegChar:
        cmp     word ptr ds:[si], SegChar
        jz      GetLength
        or      bp, bp
        jz      NotStd
        dec     si
        dec     si
NotStd:
        inc     si
        jmp     SearchSegChar
GetLength:
        pop     cx				; take the initial index from stack into cx
        mov     ax, si
        sub     ax, cx				; string length into ax
        or      bp, bp
        jz      NotStd1
        not     ax
NotStd1:
        popf
        @POP    cx, si, bp
ENDM
;****************************************************************************
;*  Hex2Dec                                                                 *
;*  Entry:                                                                  *
;*  EAX= Data of will be transfer                                           *
;*  Exit:                                                                   *
;*  AX = Buffer Length                                                      *
;****************************************************************************
Hex2Dec MACRO   OutPutBuffer
        local   Cmp1, No_Sub
        @push   si, dx, ebx
        xor     si, si
        xor     dx, dx
        mov     ebx, 100000000
        mov     cx, 8
Cmp1:
        cmp     eax, ebx
        jb      No_Sub
        sub     eax, ebx
        inc     dx
        jmp     Cmp1
No_Sub:
        push    eax
        or      dl, 30h
	mov     byte ptr es:[di], al
        inc     di
        xor     edx, edx
        mov     eax, ebx
        push    ecx
        mov     ecx, 10
        div     ecx
        pop     ecx
        mov     ebx, eax
        pop     eax
        xor     dx, dx
        loop    Cmp1
        mov     edx, eax
        xor     dl, 30h
        mov     byte ptr OutPutBuffer[si], dl
        mov     ax, si
        @pop    si, dx, ebx
ENDM
;*************************************************
;*INT 10H (AH)=02:設定游標位置                   *
;*        (DH)=游標列數,範圍在 0-24 之間.        *
;*        (DL)=游標行數,範圍在 0-79 之間.        *
;*        (BX)=頁數.                             *
;*************************************************
Locate MACRO A1,A2
        mov     ah, 02h
        xor     bh, bh
        mov     dh, A1
        mov     dl, A2
        int     10h
ENDM
;*************************************************
;*INT 10H (AH)=03:設定游標位置                   *
;*        (DH)=游標列數,範圍在 0-24 之間.        *
;*        (DL)=游標行數,範圍在 0-79 之間.        *
;*        (BX)=頁數.                             *
;*************************************************
ReLocate MACRO
        @push   ax, bx
        mov     ah, 03h
        xor     bh, bh
        int     10h
        @pop    ax, bx
ENDM
;*************************************************
;*INT 10H (AH)=06:把指定的視窗範圍捲動           *
;*        (AL)=捲動的列數                        *
;*        (BH)=捲動後空出位置放入的屬性          *
;*        (CH,CL)=捲動範圍的左上 (列,行)         *
;*        (DH,DL)=捲動範圍的右下 (列,行)         *
;*************************************************
Scroll_Up MACRO UP,AT,LY,LX,RY,RX
        mov     ah, 06H
        mov     al, UP
        mov     bh, AT
        mov     ch, LY
        mov     cl, LX
        mov     dh, RY
        mov     dl, RX
        int     10h
ENDM
;*************************************************
;*INT 10H (AH)=01:設定游標形狀                   *
;*        (CH)=游標起始線,範圍在 0-F 之間.       *
;*        (CL)=游標終止線,範圍在 0-F 之間.       *
;*************************************************
Cursor_Shape    MACRO   UP,DOWN
        mov     ah, 1
        mov     ch, UP
        mov     cl, DOWN
        int     10h
ENDM
;*************************************************
;*   恢復正常 游標形狀                           *
;*************************************************
Cursor_On       MACRO
        Cursor_Shape 11,12   ;NORMAL CURSOR SHAPE
ENDM
;*************************************************
;*   熄滅游標                                    *
;*************************************************
Cursor_Off      MACRO
        Cursor_Shape 00100000B,0 ;UP LINE'S FIFTH ;BIT SET 1 CURSOR
ENDM                     
;**************************************************
;    PUSH 四個暫存器
;**************************************************
CLSC MACRO HIGH,L,ATTRIB
        @push   ax, bx, cx, dx
        xor     al, al
        mov     ah, 06h
        mov     bh, ATTRIB
        xor     cx, cx
        mov     dh, L
        mov     dl, HIGH
        int     10h
        @pop    ax, bx, cx, dx
ENDM
;**************************************************
;    清除螢幕
;**************************************************
CLS MACRO
        @push   ax, bx, cx, dx
        xor     al, al
        mov     ah, 06h
        mov     bh, 0Fh
        xor     cx, cx
        mov     dx, 7924h
        int     10h
        @pop    ax, bx, cx, dx
ENDM
;**************************************************
Beep MACRO
        OutChar 07h
ENDM
;**************************************************
NEWIODELAY     	MACRO
		out	0edh,al              
		out	0edh,al              
		out	0edh,al              
		out	0edh,al              
	       	ENDM  
;**************************************************
ASCII2HEX      MACRO
        push    bx
        xchg    bx, ax				; original data in ax
        mov     al, bh				; copy to al, due to proc ASCII_4Bit operate with al
        ASCII_4Bit				; the result of ASCII_4Bit will put in al
        mov     bh, al
        mov     al, bl				; copy to al, due to proc ASCII_4Bit operate with al
        ASCII_4Bit
        shl     bh, 4
        or      al, bh				; the result of ASCII2HEX will put in al
        pop     bx
ENDM
;**************************************************
ASCII_4Bit      MACRO
        Local   No_Need_Adjust, No_Need_Adjust2
        cmp     al, 'F'
        jbe     No_Need_Adjust
        xor     al, 20h				; it means small letter, equal sub al, 20h
No_Need_Adjust:
        cmp     al, '9'				; if it is a numeric or not
        jbe     No_Need_Adjust2
        sub     al, 7				; letter
No_Need_Adjust2:
        and     al, 0Fh
ENDM
;**************************************************

