void AutoCheckPort();
void SendBMCCommand();
void Wait_IBF();
void Clear_OBF();
void Wait_OBF();
void Is_Write_State();
void Is_Read_State();
void Is_Idle_State();

char    BMCPackageCount;
char    BMCSendPackageBuffer[20];
char    BMCReturnPackageBuffer[20];
char    BMCRetryCount;
char    BMCRetryLimit=1;
int     SendPackageBuffer;
int     ReturnPackageBuffer;

// KCS Control Codes
#define Get_Status_Code  0x60
#define Write_Start_Code 0x61
#define Write_End_Code   0x62
#define Read_Start_Code  0x68

// KCS status register - IPMI
#define IPMI_OBF         0x01
#define IPMI_IBF         0x02
#define IPMI_SMS_ATN     0x04
#define IPMI_C_D         0x08
#define IPMI_OEM1        0x10
#define IPMI_OEM2        0x20
#define IPMI_S0          0x40
#define IPMI_S1          0x80

void newiodelay()
{
  asm out 0edh, al
  asm out 0edh, al

}
void outportb(unsigned port,int data)
{
        _asm {
        mov     dx,port
        mov     al,byte ptr data
        out     dx,al
        }
}

int inportb(unsigned port)
{
	unsigned char i;
        _asm {
        mov     dx,port
        in      al, dx
        mov     i, al
        }
        return (int)i;
}
