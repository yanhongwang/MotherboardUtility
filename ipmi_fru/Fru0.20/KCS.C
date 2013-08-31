#include "KCS.h"
unsigned int state,Send,Return;
unsigned char SendBuffer,ReturnBuffer,KCS_WR_PTR,KCS_RD_PTR,KCS_Yes=0;
unsigned int KCS1_Data=0,KCS1_Command,KCS1_Status;
unsigned char KCS_temp,KCS_Value[128];
void AutoCheckPort()
{
   int check1,check2;
   outportb(0x0CA3,0x61);
   check1=inportb(0x0CA3);
   outportb(0x66,0x61);
   check2=inportb(0x66);
   if((check1!=0x00)&&(check1!=0xFF))
   {
      KCS1_Data=0x0CA2;
      KCS1_Command=KCS1_Data+1;
      KCS1_Status=KCS1_Data+1;
      KCS_Yes=1;
   }
   else if((check2!=0x00)&&(check2!=0x1C)&&(check2!=0xFF))
   {
      KCS1_Data=0x62;
      KCS1_Command=KCS1_Data+4;
      KCS1_Status=KCS1_Data+4;
      KCS_Yes=1;
   }
}
void SendBMCCommand()
{
        asm pushf
        asm cli
        asm push    cx
        asm push    dx
        asm dec     cs:BMCPackageCount
        asm mov     cs:SendPackageBuffer, si
        asm mov     cs:ReturnPackageBuffer, di
        asm mov     cs:BMCRetryCount, 0
        asm mov ax,cs:SendPackageBuffer
        asm mov Send,ax
        asm mov ax,cs:ReturnPackageBuffer
        asm mov Return,ax
        Wait_IBF();
        asm jc      SendBMCCmdFail
        Clear_OBF();
        asm jc      SendBMCCmdFail
        asm mov     dx, KCS1_Command
        asm mov     al, Write_Start_Code
        asm out     dx, al
        newiodelay();
        Wait_IBF();
        asm jc      SendBMCCmdFail
        Is_Write_State();
        asm jnc     Prepare_Write_To_BMC
        asm jmp     Error_Exit
Prepare_Write_To_BMC:
        Clear_OBF();
        asm jc      SendBMCCmdFail
Write_To_BMC:
        asm mov     dx, KCS1_Data
        asm mov     al, byte ptr cs:[si]
        asm out     dx, al
        newiodelay();
        Wait_IBF();
        asm jc      SendBMCCmdFail
        Is_Write_State();
        asm jnc     Yes_Write_State
        asm jmp     Error_Exit
Yes_Write_State:
        Clear_OBF();
        asm jc      SendBMCCmdFail
        asm inc     si
        asm dec     cs:BMCPackageCount
        asm jnz     Write_To_BMC
        asm mov     dx, KCS1_Command
        asm mov     al, Write_End_Code
        asm out     dx, al
        newiodelay();
        Wait_IBF();
        asm jc      SendBMCCmdFail
        Is_Write_State();
        asm jnc     Yes_Write_State2
        asm jmp     Error_Exit
Yes_Write_State2:
        Clear_OBF();
        asm jc      SendBMCCmdFail
        asm mov     dx, KCS1_Data
        asm mov     al, byte ptr cs:[si]
        asm out     dx, al
        newiodelay();
        asm mov     cs:BMCPackageCount, 0
Wait_To_Read:
        newiodelay();
        newiodelay();
        Wait_OBF();
        Is_Read_State();
        asm jc      Wait_To_Read
To_Read:
        Wait_IBF();
        asm jc      SendBMCCmdFail
        Is_Read_State();
        asm jnc     Yes_Read_State
        Is_Idle_State();
        asm jc      Yes_Idle_State
        asm jmp     Error_Exit
Yes_Idle_State:
        Wait_OBF();
        asm jc      SendBMCCmdFail
        asm mov     dx, KCS1_Data
        asm in      al, dx
        newiodelay();
        asm jmp     Exit_SendPackageToBMC
Yes_Read_State:
        Wait_OBF();
        asm jc      SendBMCCmdFail
        asm mov     dx, KCS1_Data
        asm in      al, dx
        asm mov     KCS_temp,al
        asm mov     byte ptr cs:[di], al
        asm inc     cs:BMCPackageCount
        asm inc     di
        asm mov     al, Read_Start_Code
        asm out     dx, al
        newiodelay();
        KCS_Value[KCS_RD_PTR]=KCS_temp;
        KCS_RD_PTR++;
        asm jmp     To_Read
Error_Exit:
        Wait_IBF();
        asm jc      SendBMCCmdFail
        asm mov     dx, KCS1_Command
        asm mov     al, Get_Status_Code
        asm out     dx, al
        newiodelay();
        Wait_IBF();
        asm jc      SendBMCCmdFail
        Clear_OBF();
        asm jc      SendBMCCmdFail
        asm mov     dx, KCS1_Data
        asm mov     al, 00
        asm out     dx, al
        newiodelay();
        Wait_IBF();
        asm jc      SendBMCCmdFail
        Is_Read_State();
        asm jnc     Yes_Read_State1
AddRetryCount:
        asm inc     cs:BMCRetryCount
        asm mov     al, cs:BMCRetryCount
        asm cmp     al, cs:BMCRetryLimit
        asm jnz     Error_Exit();
        asm jmp     SendBMCCmdFail
Yes_Read_State1:
        Wait_OBF();
        asm jc      SendBMCCmdFail
        asm mov     dx, KCS1_Data
        asm in      al, dx
        asm mov     al, Read_Start_Code
        asm out     dx, al
        newiodelay();
        Wait_IBF();
        asm jc      SendBMCCmdFail
        Is_Idle_State();
        asm jnc     Yes_Idle_State2
        asm jmp     AddRetryCount
Yes_Idle_State2:
        Wait_OBF();
        asm jc      SendBMCCmdFail
        Clear_OBF();
        asm jc      SendBMCCmdFail
Exit_SendPackageToBMC:
        asm mov     si, cs:SendPackageBuffer
        asm mov     ah, cs:[si]
        asm mov     di, cs:ReturnPackageBuffer
        asm cmp     al, cs:[di]
        asm jnz     Function_OK
        asm jmp     SendBMCCmdFail
Function_OK:
        asm clc
SendBMCCmdFail:
        asm pop     dx
        asm pop     cx
        asm popf
        asm stc
}
//---------------------------------------------------
void Wait_IBF()                   // Wait for IBF = 0
{
        asm mov     dx, KCS1_Status
Wait_IBF_To_Zero:
        asm in      al, dx
        asm test    al, IPMI_IBF
        asm jz      IBF_Is_Zero
        newiodelay();
        asm jmp     Wait_IBF_To_Zero
IBF_Is_Zero:
}
//---------------------------------------------------
void Clear_OBF()                      // Clear OBF =0
{
Wait_OBF_To_Zero:
        asm mov     dx, KCS1_Status
        asm in      al, dx
        asm test    al, IPMI_OBF
        asm jz      OBF_Is_Zero
        newiodelay();
        asm mov     dx, KCS1_Data
        asm in      al, dx
        asm jmp     Wait_OBF_To_Zero
OBF_Is_Zero:
}
//---------------------------------------------------
void Wait_OBF()                   // Wait for OBF = 1
{
        asm mov     dx, KCS1_Status
Wait_OBF_To_One:
        asm in      al, dx
        asm test    al, IPMI_OBF
        asm jnz     OBF_Is_One
        newiodelay();
        asm jmp     Wait_OBF_To_One
OBF_Is_One:
}
//---------------------------------------------------
void Is_Write_State()
{
        asm mov     dx, KCS1_Status
        asm in      al, dx
        asm mov     ah, al
        asm and     ah, 0c0h
        asm cmp     ah, 80h
        asm jz      Under_Write_State
        asm stc
        asm jmp     Exit_Write_State
Under_Write_State:
        asm clc
Exit_Write_State:
}
//---------------------------------------------------
void Is_Read_State()
{
        asm mov     dx, KCS1_Status
        asm in      al, dx
        asm mov     ah, al
        asm and     ah, 0c0h
        asm cmp     ah, 40h
        asm jz      Under_Read_State
        asm stc
        asm jmp     Exit_Read_State
Under_Read_State:
        asm clc
Exit_Read_State:
}
//---------------------------------------------------
void Is_Idle_State()
{
        asm mov     dx, KCS1_Status
        asm in      al, dx
        asm mov     ah, al
        asm and     ah, 0c0h
        asm or      ah, 0h
        asm jz      Under_Idle_State
        asm stc
        asm jmp     Exit_Idle_State
Under_Idle_State:
        asm clc
Exit_Idle_State:
}
