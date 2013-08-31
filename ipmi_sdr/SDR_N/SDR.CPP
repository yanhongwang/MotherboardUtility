#include "GBSBT.h"
#include "SDR.h"
#include "SDR.dat"
#include "KCS.c"
unsigned int  Key,SDR_Next=0,SDR_Total,SDR_Free;
unsigned char SDR_ID,SDR_Time,SDR_Temp,SDR_Value[256][64];
unsigned char SDR_Record[10]={0x01,0x02,0x08,0x09,0x10,0x11,0x12,0x13,0x14,0xC0};

//SDR_Type_String
//0x01:full sensor record
//0x02:compact sensor record
//0x08:entity association record
//0x09:device-relative entity association
//0x10:generic device locator record
//0x11:fru device locator record
//0x12:management controller device locator record
//0x13:management controller confirmation record
//0x14:bmc message channel info record
//0xC0:oem record

void main()
{
	int i,j,k;
	unsigned char o;
	AutoCheckPort();
	if(KCS_Yes!=0)
	{
		asm mov si,offset BMCSendPackageBuffer
		asm mov di,offset BMCReturnPackageBuffer
		asm mov bx,2028h//get sdr repository info
		asm mov cs:[si],bx
		asm mov cs:BMCPackageCount,2
		SendBMCCommand();
		asm mov si,return
		asm add si,4
		asm mov ax,cs:[si]
		asm mov SDR_Total,ax
		asm add si,2
		asm mov ax,cs:[si]
		asm mov SDR_Free,ax
		/*cputs_g(1,2,0x5F,"SDR_Total  :");
		dputs_g(13,2,0x5E,SDR_Total,3);
		cputs_g(30,2,0x5F,"SDR_Free   :");
		dputs_g(44,2,0x5E,SDR_Free,0);
		cputs_g(48,2,0x5E,"Bytes");*/
		if(SDR_Total>0)
		{
			while(SDR_Next!=0xFFFF)
			{
				KCS_RD_PTR=0;
				asm mov si,offset BMCSendPackageBuffer
				asm mov di,offset BMCReturnPackageBuffer
				asm mov bx,2328h
				asm mov cs:[si],bx
				asm push si
				asm add si,2
				asm mov bx,0
				asm mov cs:[si],bx
				asm add si,2
				asm mov ax,SDR_Next
				asm mov cs:[si],ax
				asm add si,2
				asm mov cs:[si],bl
				asm inc si
				asm mov bl,0xFF
				asm mov cs:[si],bl
				asm pop si
				asm mov cs:BMCPackageCount,8
				SendBMCCommand();
				asm mov di,return
				asm add di,3
				asm mov ax,cs:[di]
				asm mov SDR_Next,ax
				asm inc di
				for(j=5;j<=KCS_RD_PTR;j++)
				{
					asm inc di
					asm mov al,cs:[di]
					asm mov SDR_Temp,al
					SDR_Value[SDR_Time][j-5]=SDR_Temp;
				}
				SDR_Time++;
			}
		}
		else
		{
			cputs_g(1,1,0x0C,"No SDR data!");
		}
		clrscr_g(1,1,80,25);
		ListSDR();
		GetKey();
		clrscr_g(1,1,80,25);
	}
	else
	{
		cputs_g(1,1,0x0C,"Not found KCS interface or KCS is fail!");
	}
}

void GetKey()
{
	Key=getch_g();
	switch(Key)
	{
		case 0x4E2B://+
		case 0x5000://down arrow
		case 0x5100://PgDn
		{
			if(SDR_ID<SDR_Time-1)
			{
				clrscr_g(1,1,80,25);
				SDR_ID++;
				ListSDR();
			}
			GetKey();
			break;
		}
		case 0x4A2D://-
		case 0x4800://up arrow
		case 0x4900://PgUp
		{
			if(SDR_ID>0)
			{
				clrscr_g(1,1,80,25);
				SDR_ID--;
				ListSDR();
			}
			GetKey();
			break;
		}
		case 0x011B://esc
		{
			break;
		}
		default:
		{
			//hputs_g(1,25,0x0E,Key,4);
			GetKey();
		}
	}
}

void ListSDR()
{
	unsigned char i;
	cputs_g(1,1,0x0A,"Record ID:");
	hputs_g(11,1,0x0B,SDR_Value[SDR_ID][0]+SDR_Value[SDR_ID][1]*256,4);//Record ID
	cputs_g(1,2,0x0A,"SDR Version:    ");
	hputs_g(13,2,0x0B,SDR_Value[SDR_ID][2]&0x0F,1);//SDR Version
	cputs_g(14,2,0x0B,".");
	hputs_g(15,2,0x0B,SDR_Value[SDR_ID][2]/16,1);//SDR Version
	cputs_g(1,3,0x0A,"Record Type:");
	hputs_g(13,3,0x0B,SDR_Value[SDR_ID][3],2);//Record Type
	for(i=0;i<10;i++)
	{
		if(SDR_Record[i]==SDR_Value[SDR_ID][3])
			cputs_g(15,3,0x0C,SDR_Type_String[i]);
	}
	cputs_g(1,4,0x0A,"Record Length:");
	dputs_g(14,4,0x0B,SDR_Value[SDR_ID][4]+5,0);//Record Length
	for(i=0;i<SDR_Value[SDR_ID][4]+5;i++)
	{
		hputs_g(i%16*4+1,i/16+22,0x07,SDR_Value[SDR_ID][i],2);//all sdr binary show
	}
	if(SDR_Value[SDR_ID][3]==0x01 || SDR_Value[SDR_ID][3]==0x02)//0x01:full sensor record, 0x02:compact sensor record
	{
		cputs_g(1,5,0x0A,"Sensor Owner ID:");
		hputs_g(17,5,0x0B,SDR_Value[SDR_ID][5],2);
		cputs_g(1,6,0x0A,"Sensor Owner LUN:");
		hputs_g(18,6,0x0B,SDR_Value[SDR_ID][6],2);
		cputs_g(1,7,0x0A,"Sensor Number:");
		hputs_g(15,7,0x0B,SDR_Value[SDR_ID][7],2);
		cputs_g(1,8,0x0A,"Entity ID:");
		hputs_g(11,8,0x0B,SDR_Value[SDR_ID][8],2);
		//cputs_g(14,8,0x0C,Entity_ID_String[SDR_Value[SDR_ID][8]]);
		cputs_g(1,9,0x0A,"Entity Instance:");
		hputs_g(17,9,0x0B,SDR_Value[SDR_ID][9],2);
		cputs_g(1,10,0x0A,"Sensor Initialization:");
		hputs_g(23,10,0x0B,SDR_Value[SDR_ID][10],2);
		cputs_g(1,11,0x0A,"Sensor Capabilities:");
		hputs_g(21,11,0x0B,SDR_Value[SDR_ID][11],2);
		cputs_g(1,12,0x0A,"Sensor Type:");
		hputs_g(13,12,0x0B,SDR_Value[SDR_ID][12],2);
		//cputs_g(16,12,0x0C,Sensor_Type_String[SDR_Value[SDR_ID][12]]);
		cputs_g(1,13,0x0A,"Event/Reading Type Code:");
		hputs_g(25,13,0x0B,SDR_Value[SDR_ID][13],2);
		for(i=0;i<SDR_Value[SDR_ID][63-SDR_Value[SDR_ID][3]*16]-0xC0;i++)
		{
			gotoxy_g(i+1,21);
			printf_g(0x0B,SDR_Value[SDR_ID][64-SDR_Value[SDR_ID][3]*16+i]);
		}
	}
	else if(SDR_Value[SDR_ID][3]==0x10)
	{
		cputs_g(1,5,0x0A,"Device Access Address:");
		hputs_g(23,5,0x0B,SDR_Value[SDR_ID][5],2);
		cputs_g(1,6,0x0A,"Device Slave Address:");
		hputs_g(22,6,0x0B,SDR_Value[SDR_ID][6],2);
		cputs_g(1,7,0x0A,"Access LUN / Bus ID:");
		hputs_g(21,7,0x0B,SDR_Value[SDR_ID][7],2);
		cputs_g(1,8,0x0A,"Access span:");
		hputs_g(13,8,0x0B,SDR_Value[SDR_ID][8],2);
		cputs_g(1,9,0x0A,"Device Type:");
		hputs_g(13,9,0x0B,SDR_Value[SDR_ID][10],2);
		cputs_g(1,10,0x0A,"Device Type Modifier:");
		hputs_g(22,10,0x0B,SDR_Value[SDR_ID][11],2);
		cputs_g(1,11,0x0A,"Entity ID:");
		hputs_g(11,11,0x0B,SDR_Value[SDR_ID][12],2);
		cputs_g(1,12,0x0A,"Entity Instance:");
		hputs_g(17,12,0x0B,SDR_Value[SDR_ID][13],2);
		for(i=0;i<SDR_Value[SDR_ID][15]-0xC0;i++)
		{
			gotoxy_g(i+1,21);
			printf_g(0x0B,SDR_Value[SDR_ID][16+i]);
		}
	}
	else if(SDR_Value[SDR_ID][3]==0x11)
	{
		cputs_g(1,5,0x0A,"Device Access Address:");
		hputs_g(23,5,0x0B,SDR_Value[SDR_ID][5],2);
		cputs_g(1,6,0x0A,"FRU Device ID / Device Slave Address:");
		hputs_g(38,6,0x0B,SDR_Value[SDR_ID][6],2);
		cputs_g(1,7,0x0A,"Logical-Physical / Access LUN / Bus ID:");
		hputs_g(40,7,0x0B,SDR_Value[SDR_ID][7],2);
		cputs_g(1,8,0x0A,"Channel Number:");
		hputs_g(16,8,0x0B,SDR_Value[SDR_ID][8],2);
		cputs_g(1,9,0x0A,"Device Type:");
		hputs_g(13,9,0x0B,SDR_Value[SDR_ID][10],2);
		cputs_g(1,10,0x0A,"Device Type Modifier:");
		hputs_g(22,10,0x0B,SDR_Value[SDR_ID][11],2);
		cputs_g(1,11,0x0A,"Entity ID:");
		hputs_g(11,11,0x0B,SDR_Value[SDR_ID][12],2);
		cputs_g(1,12,0x0A,"Entity Instance:");
		hputs_g(17,12,0x0B,SDR_Value[SDR_ID][13],2);
		for(i=0;i<SDR_Value[SDR_ID][15]-0xC0;i++)
		{
			gotoxy_g(i+1,21);
			printf_g(0x0B,SDR_Value[SDR_ID][16+i]);
		}
	}
	else if(SDR_Value[SDR_ID][3]==0x12)
	{
		cputs_g(1,5,0x0A,"Device Access Address:");
		hputs_g(23,5,0x0B,SDR_Value[SDR_ID][5],2);
		cputs_g(1,6,0x0A,"Channel Number:");
		hputs_g(16,6,0x0B,SDR_Value[SDR_ID][6],2);
		cputs_g(1,7,0x0A,"Power State Notification Global Initialization:");
		hputs_g(48,7,0x0B,SDR_Value[SDR_ID][7],2);
		cputs_g(1,8,0x0A,"Device Capabilities:");
		hputs_g(21,8,0x0B,SDR_Value[SDR_ID][8],2);
		cputs_g(1,9,0x0A,"Entity ID:");
		hputs_g(11,9,0x0B,SDR_Value[SDR_ID][12],2);
		cputs_g(1,10,0x0A,"Entity Instance:");
		hputs_g(17,10,0x0B,SDR_Value[SDR_ID][13],2);
		for(i=0;i<SDR_Value[SDR_ID][15]-0xC0;i++)
		{
			gotoxy_g(i+1,21);
			printf_g(0x0B,SDR_Value[SDR_ID][16+i]);
		}
	}
}
