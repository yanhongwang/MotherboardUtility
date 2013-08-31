#include "GBSBT.h"
#include "KCS.c"
#include "SDR.c"
#include "FRU.h"
#include <stdio.h>
#include <fcntl.h>
unsigned char Update_Flag,Completion,Use,Use2=1,Background,color,FRU_Unit,FRU_Value[5][2048],FRU_Update[2048],FRU_OLD[2048],FRU_Offset[5];

//Use: index of fru id option:
					//00
					//01
					//02
					//03
					//04

//Use2: index of fru string option: 
					//Command Header Format Version,
					//Internal Use Area Offset,
					//Chassis Info Area Offset,
					//Board Area Offset,
					//Product Info Area Offset,
					//MultiRecord Area Offset


//Update_Flag: if fru binary changed, it should be set 1 vice versa.

//FRU_Value[][]: fru data in

unsigned int  Key,Key2=1,Size_temp,FRU_Max=255,FRU_Min=0,Count,FRU_Size[5][2],FRU_State[5][2];

//key2: e.g. 0x34 ,when key2 is odd , 3 is implied. when key2 is even, 4 is implied.
//Count: 0-255
//FRU_State[][1]:1 fru is present;0 fru is not present
//FRU_State[][0]:1 FRU_Unit is available words/bytes;0 N/A

//FRU_Size[][0]=Size_temp;63
//FRU_Size[][1]=(FRU_Unit+1)*4;4

unsigned char FileName[12]={'F','R','U','0','0','0','0','0','.','B','I','N'};
unsigned int  year,month,date,hour,min,sec;
unsigned int month_table[15]={0,31,59,90,120,151,181,212,243,273,304,334};
unsigned long FRU_Time;
FILE *fp;
#ifdef  ForBIOS
void main1(void)
#else
void main(void)
#endif
{
	clrscr_g(1,1,80,25);
	AutoCheckPort();               // Check 0x66 & 0xCA3 port
	if(KCS_Yes==0)
	{
		FRU_Tital();
		cputs_g(20,5,0x0C,"Not found KCS interface or KCS is fail!");
		//FRU_End();
	}
	else
	{
		Get_SDR();
		FRU_Tital();
		FRU_Start();
	}
}

void FRU_Tital()
{
	cputs_g(1,1,0x1F,"   IPMI 1.0/1.5 Field Replaceable Unit Reader/Writer Ver 0.20  ");
	cputs_g(63,1,0x1E,"BETA2   ");
	cputs_g(69,1,0x1A,"G.B.S.B.T.  ");
	cputs_g(1,25,0x42,"  Esc:Exit  \x18\/\x19:Up/Dn  Enter:Edit  S/L:Save/Load Files  Space:FRU Area String  ");
}
void FRU_Start()
{
	unsigned int i=0,j;
	unsigned int  t;
	
	//for(i=0;i<5;i++)
	for( i = 0; i < 1; i++ )
	{
		Background=0;
		if(Use==i)
			Background=0x50;
		dputs_g(1,i+2,0x0E+Background,i,2);
		for(j=0;j<5;j++)
			if(FRU_Data[j][0]==0x00)
				FRU_Data[j][0]=0xFF;
		
		//FRU_Data[FRU_id][0]=SDR_Time;
		//SDR_String[SDR_Time][i]=SDR_Char;

		cputs_g(4,i+2,0x0B,SDR_String[FRU_Data[i][0]]);
		Get_FRU_Inventory_Area_Info(i);
		asm mov di,Return
		asm add di,2
		asm mov al,cs:[di]
		asm mov Completion,al
		if(Completion==0)//Get_FRU_Inventory_Area_Info successful
		{
			FRU_State[i][0]=1;//FRU_Unit is available
			asm inc di
			asm mov ax,cs:[di]
			asm mov Size_temp,ax
			FRU_Size[i][0]=Size_temp;
			dputs_g(20,i+2,0x0A,FRU_Size[i][0],4);//0255
			asm add di,2
			asm mov al,cs:[di]
			asm mov FRU_Unit,al
			if((FRU_Unit&0x01)==0)
				cputs_g(25,i+2,0x07,"Bytes");
			else
				cputs_g(25,i+2,0x07,"Words");
		}
		else
			cputs_g(27,i+2,0x06,"N/A");
	 /*for(j=0;j<=10;j++)
	 {
            hputs_g(j*3+47,i+2,0x08,FRU_Data[i][j],2);
         }*/
		if(Completion==0)
		{
			FRU_Size[i][1]=(FRU_Unit+1)*4;
			FRU_Size[i][0]/=FRU_Size[i][1];
			cputs_g(1,24,0x0E,"FRU ID:");
			hputs_g(8,24,0x0E,i,2);
			for(t=0;t<=FRU_Size[i][0]*FRU_Size[i][1];t+=FRU_Size[i][1])
			{
				dputs_g(11,24,0x0E,t*10/FRU_Size[i][1]*10/FRU_Size[i][0],0);//count from 0 to 100
				cputs_g(14,24,0x0E,"%");
				Read_FRU(FRU_Data[i][2],t,FRU_Size[i][1]);//read fru per section
				asm mov di,Return
				asm add di,2
				asm mov al,cs:[di]
				asm mov Completion,al
				if(Completion==0)
				{
					FRU_State[i][1]=1;
					asm add di,2
					for(j=0;j<=FRU_Size[i][1]-1;j++)
					{
						asm mov al,cs:[di]
						asm mov FRU_temp,al
						FRU_Value[i][t+j]=FRU_temp;//fill the FRU
						asm inc di
					}
				}
			}
		}
		if(FRU_State[i][1]==1)
			cputs_g(35,i+2,0x0F,"(Present)");
		else
			cputs_g(31,i+2,0x0C,"(Not present)");
		clrscr_g(1,24,20,24);
		/*if(FRU_Value[i][0]!=0xFF && FRU_Value[i][0]!=0x00)
		cputs_g(48,i+2,0x0F,"(String)");
	 else cputs_g(45,i+2,0x0C,"(No String)");*/
	}
	Get_Key();
	clrscr_g(1,1,80,25);
}
void Get_Key()
{
	unsigned int  i,t;
	unsigned char temp;
	Key=getch_g();
	switch(Key)
	{
		case 0x4800://up arrow
		{
			if(Use>0)
			{
				dputs_g(1,Use+2,0x0E,Use,2);
				//cputs_g(4,Use+2,0x0B,SDR_String[FRU_Data[Use][0]]);
				Use--;
				dputs_g(1,Use+2,0x5E,Use,2);
				//cputs_g(4,Use+2,0x5B,SDR_String[FRU_Data[Use][0]]);
			}
			Get_Key();
			break;
		}
		
		case 0x5000://down arrow
		{
			if(Use<4)
			{
				dputs_g(1,Use+2,0x0E,Use,2);
				//cputs_g(4,Use+2,0x0B,SDR_String[FRU_Data[Use][0]]);
				Use++;
				dputs_g(1,Use+2,0x5E,Use,2);
				//cputs_g(4,Use+2,0x5B,SDR_String[FRU_Data[Use][0]]);
			}
			Get_Key();
			break;
		}
		
		case 0x1C0D://enter
		{
			clrscr_g(1,7,80,23);
			if(FRU_State[Use][0]==1 && FRU_State[Use][1]==1)
			{
				cputs_g(1,25,0x42,"  Esc:Exit \x18\/\x19:Up/Dn \x1A/\x1B:Right/Left PgUp/PgDn:Previous/Next Page S/W:Save/Load ");
				for(i=0;i<2048;i++)
					FRU_OLD[i]=FRU_Value[Use][i];
				List_FRU(Use);
				Input_Key();
			}
			else
			{
				//cputs_g(1,24,0x0C,"FRU not found!");
				//delay_g(60000);
				//cputs_g(1,24,0x04,"              ");
				Get_Key();
			}
			break;
		}
		
		case 0x1F73://s
		case 0x1F53://S
		{
			//write fru to software
			if(FRU_State[Use][0]==1 &&  FRU_State[Use][1]==1)
			{
				//FRU_State[][1]:1 fru is present;0 fru is not present
				//FRU_State[][0]:1 FRU_Unit is available words/bytes;0 N/A
				
				//for(t=0;t<=1;t++)
				//{
				temp=Use;
				
				for(i=7;i>=3;i--)
				{
					FileName[i]=(temp%16)+0x30;
					temp/=16;
				}
				
				fp=fopen(FileName,"wb");
				fseek(fp,0,0);
				for(Count=0;Count<FRU_Size[Use][0]*FRU_Size[Use][1];Count++)
				{
					fwrite(&FRU_Value[Use][Count],sizeof(FRU_Value[Use][Count]),1,fp);
					//fputs(FRU_Value[Use],fp);
				}
				cputs_g(1,24,0x0E,"Save File OK!       ");
				delay_g(60000);
				clrscr_g(1,24,80,24);
				fclose(fp);
				//Input_File();
			}
			//}
			Get_Key();
			break;
		}
		case 0x266C://l
		case 0x264C://L
		{
			//read fru from software
			if(FRU_State[Use][0]==1 &&  FRU_State[Use][1]==1)
				//if(FRU_State[Use]==1)
			{
				//for(t=0;t<=1;t++)
				////{
				temp=Use;
				for(i=7;i>=3;i--)
				{
					FileName[i]=(temp%16)+0x30;
					temp/=16;
				}
				fp=fopen(FileName,"rb");
				fseek(fp,0,0);
				for(Count=0;Count<FRU_Size[Use][0]*FRU_Size[Use][1];Count++)
				{
					fread(&FRU_Value[Use][Count],sizeof(FRU_Value[Use][Count]),1,fp);
					//fputs(FRU_Value[Use],fp);
				}
				cputs_g(1,24,0x0E,"Load File OK!       ");
				delay_g(60000);
				clrscr_g(1,24,80,24);
				fclose(fp);
				//Input_File();
			}
			//}
			Get_Key();
			break;
		}
      /*case 0x3B00:
      {
	 clrscr_g(1,2,80,6);
	 FRU_Start();
	 break;
      }*/
		case 0x3920://space
		{
			cputs_g(1,25,0x42,"  Esc:Exit                      \x18\/\x19:Up/Dn                      Space:Sub Item   ");
			FRU_String();
			Get_Key();
			break;
		}
		case 0x011B://esc
		{
			break;
		}
		default:
		{
			//hputs_g(70,24,0x0E,Key,4);
			Get_Key();
		}
	}
}
void Get_Key2()//FRU_String menu get input
{
	unsigned int  i,j,k;
	unsigned char temp;
	Key=getch_g();
	
	switch(Key)
	{
		case 0x4800://up arrow
		{
			if(Use2>1)
				Use2--;
			FRU_String();
			break;
		}
		case 0x5000://down arrow
		{
			if(Use2<5)
			Use2++;
			FRU_String();
			break;
		}
		case 0x3920://space
		{
			clrscr_g(35,8,80,23);
			if(Use2==1 && FRU_Value[Use][1]!=0)
			{
				k=0;
				i=FRU_Value[Use][1]*8;
				for(j=1;j<=5;j++)
					if(FRU_Value[Use][j]!=0)
						FRU_Offset[k++]=FRU_Value[Use][j];
				temp=(FRU_Offset[1]-FRU_Offset[0])*8;
				cputs_g(35,8,0x03,"Internal use date:");
				for (j=0;j<temp;j++)
					hputs_g(54+j%8*3,8+j/8,0x02,FRU_Value[Use][i++],2);
			}
			else if(Use2==2 && FRU_Value[Use][2]!=0)//chassis
			{
				i=FRU_Value[Use][2]*8;
				cputs_g(35,8,0x03,"Chassis Info Area Length:");
				hputs_g(61,8,0x02,FRU_Value[Use][++i]*8,2);
				cputs_g(35,9,0x03,"Chassis Type:");
				hputs_g(61,9,0x02,FRU_Value[Use][++i],2);
				cputs_g(35,10,0x03,"Chassis Part Number:");
				cputs_g(35,11,0x03,"Chassis Serial Number:");
				i=FRU_Count(61,10,0x02,"",i,2,0);
				//hputs_g(1,24,0x02,FRU_Value[Use][i],2);
				i=FRU_Count(61,12,0x02,"Custom Chassis Info[ ]:",i,0,55);
			}
			else if(Use2==3 && FRU_Value[Use][3]!=0)//board
			{
				i=FRU_Value[Use][3]*8;
				cputs_g(35,8,0x03,"Board Info Area Length:");
				hputs_g(61,8,0x02,FRU_Value[Use][++i]*8,2);
				cputs_g(35,9,0x03,"Language Code:");
				hputs_g(61,9,0x02,FRU_Value[Use][++i],2);
				cputs_g(35,10,0x03,"Manufacturing Data/Time:");
				if(FRU_Value[Use][i+1]!=0)
				{
					FRU_Time=FRU_Value[Use][i+1]+FRU_Value[Use][i+2]*256+(FRU_Value[Use][i+3]+1)*65536;
					Dec2Time(61,10,0x02,FRU_Time);
					i+=3;
				}
				else
					i++;
				cputs_g(35,11,0x03,"Board Manufacturer:");
				cputs_g(35,12,0x03,"Board Product Name:");
				cputs_g(35,13,0x03,"Board Serial Number:");
				cputs_g(35,14,0x03,"Board Part Number:");
				cputs_g(35,15,0x03,"FRU File ID:");
				i=FRU_Count(61,11,0x02,"",i,5,0);
				//hputs_g(1,24,0x02,FRU_Value[Use][i],2);
				i=FRU_Count(61,16,0x02,"Custom Board Info[ ]:",i,0,53);
			}
			else if(Use2==4 && FRU_Value[Use][4]!=0)//product
			{
				i=FRU_Value[Use][4]*8;
				cputs_g(35,8,0x03,"Product Info Area Length:");
				hputs_g(61,8,0x02,FRU_Value[Use][++i]*8,2);
				cputs_g(35,9,0x03,"Language Code:");
				hputs_g(61,9,0x02,FRU_Value[Use][++i],2);
				cputs_g(35,10,0x03,"Manufacture Name:");
				cputs_g(35,11,0x03,"Product Name:");
				cputs_g(35,12,0x03,"Product Part/Model Number:");
				cputs_g(35,13,0x03,"Product Version:");
				cputs_g(35,14,0x03,"Product Serial Number:");
				cputs_g(35,15,0x03,"Asset Tag:");
				cputs_g(35,16,0x03,"FRU File ID:");
				i=FRU_Count(61,10,0x02,"",i,7,0);
				//hputs_g(1,24,0x02,FRU_Value[Use][i],2);
				i=FRU_Count(61,17,0x02,"Custom Product Info[ ]:",i,0,55);
			}
			Get_Key2();
			break;
		}
		case 0x011B://esc
		{
			FRU_Tital();
			clrscr_g(1,7,80,23);
			Use2=1;
			break;
		}
		default:
		{
			//hputs_g(1,24,0x0E,Key,4);
			Get_Key2();
		}
	}
}
void Input_Key()//cursor move around fru binary data
{
	unsigned int  i,j;
	unsigned int  t;
	Key=getch_g();
	switch(Key)
	{
		case 0x4800://up arrow
		{
			if(Count-FRU_Min>=16)
			{
				Count-=16;
				Key2=1;
				List_FRU(Use);
			}
			Input_Key();
			break;
		}
		case 0x4900://PgUp
		{
			if(FRU_Min>0)
			{
				FRU_Min-=256;
				FRU_Max-=256;
				Count=FRU_Min;
				Key2=1;
				List_FRU(Use);
			}
			Input_Key();
			break;
		}
		case 0x4B00://left arrow
		{
			if(Count%16!=0)
			{
				Count--;
				Key2=1;
				List_FRU(Use);
			}
			Input_Key();
			break;
		}
		case 0x4D00://right arrow
		{
			if(Count%16!=0x0F && (Count+1)<FRU_Size[Use][1]*FRU_Size[Use][0])
			{
				Count++;
				Key2=1;
				List_FRU(Use);
			}
			Input_Key();
			break;
		}
		case 0x5000://down arrow
		{
			if(FRU_Max-Count>=16 && (Count+16)<FRU_Size[Use][1]*FRU_Size[Use][0])
			{
				Count+=16;
				Key2=1;
				List_FRU(Use);
			}
			Input_Key();
			break;
		}
		case 0x5100://PgDn
		{
			if(FRU_Max<FRU_Size[Use][1]*FRU_Size[Use][0]-1)
			{
				FRU_Min+=256;
				FRU_Max+=256;
				Count=FRU_Min;
				Key2=1;
				List_FRU(Use);
			}
			Input_Key();
			break;
		}
		case 0x011B://esc
		{
Update:
			if(Update_Flag==1)
			{
				cputs_g(1,24,0x0C,"Updata FRU area data? (Y/N):");
				gotoxy_g(29,24);//let cursor go to (29,24)
				Key=getch_g();
				switch(Key)
				{
					case 0x1579://y
					case 0x1559://Y
					{
						cputs_g(29,24,0x0C,"Y");
						delay_g(60000);
						clrscr_g(1,24,80,24);
						asm jmp Update_Ready
						break;
					}
					case 0x316E://n
					case 0x314E://N
					{
						cputs_g(29,24,0x0C,"N");
						delay_g(60000);
						for(i=0;i<2048;i++)
							FRU_Value[Use][i]=FRU_OLD[i];
						asm jmp Update_Exit
						break;
					}
					default: asm jmp Update
				}
			}
Update_Exit:
			Clear_Update();
			clrscr_g(1,7,80,24);
			FRU_Min=0;
			FRU_Max=255;
			Count=FRU_Min;
			Key2=1;
			FRU_Tital();
			Get_Key();
			break;
		}
		
		case 0x0231://1
		case 0x0332://2
		case 0x0433://3
		case 0x0534://4
		case 0x0635://5
		case 0x0736://6
		case 0x0837://7
		case 0x0938://8
		case 0x0A39://9
		case 0x0B30://0
		{
			FRU_Update[Count]=1;Update_Flag=1;
			FRU_Value[Use][Count]=((0x000F&Key)*pow_g(16,(Key2%2)))+(FRU_Value[Use][Count]&0x0F*pow_g(16,((Key2-1)%2)));
			Key2++;
			if((Key2%2)==1 && (Count+1)<FRU_Size[Use][1]*FRU_Size[Use][0])
			{
				Count++;
				if(Count>FRU_Max)
				{
					FRU_Min+=256;
					FRU_Max+=256;
				}
			}
			List_FRU(Use);
			Input_Key();
			break;
		}
		case 0x1E61://a
		case 0x3062://b
		case 0x2E63://c
		case 0x2064://d
		case 0x1265://e
		case 0x2166://f
		case 0x1E41://A
		case 0x3042://B
		case 0x2E43://C
		case 0x2044://D
		case 0x1245://E
		case 0x2146://F
		{
			FRU_Update[Count]=1;Update_Flag=1;
			FRU_Value[Use][Count]=((0x000F&Key+9)*pow_g(16,(Key2%2)))+(FRU_Value[Use][Count]&0x0F*pow_g(16,((Key2-1)%2)));
			//e.g. change 0x41 to 0xFA
			
			//first Key2=1,an odd
			//Key=0x2146,(0x000F&Key+9)*pow_g(16,(Key2%2))= 0x0F*16 = 0xF0
			//Key=0x2146,FRU_Value[Use][Count]&0x0F*pow_g(16,((Key2-1)%2))= 0x41 & 0x0F * 1 = 0x01
			
			//second Key2=2,an even
			//Key=0x1E41,(0x000F&Key+9)*pow_g(16,(Key2%2))= 0x0A*1 = 0x0A
			//Key=0x1E41,FRU_Value[Use][Count]&0x0F*pow_g(16,((Key2-1)%2))= 0xF1 & 0x0F * 16 = 0xF1 & 0xF0 = 0xF0
			
			// operators * / % are prior to &
			
			Key2++;
			
			if((Key2%2)==1 && (Count+1)<FRU_Size[Use][1]*FRU_Size[Use][0])
			{
				Count++;
				if(Count>FRU_Max)
				{
					FRU_Min+=256;
					FRU_Max+=256;
				}
			}
			List_FRU(Use);
			Input_Key();
			break;
		}
		case 0x266C://l
		case 0x264C://L
		{
			//read fru from hardware
			//clrscr_g(1,7,80,23);
			cputs_g(1,24,0x0E,"FRU ID:");
			hputs_g(8,24,0x0E,Use,2);
			for(t=0;t<=FRU_Size[Use][0]*FRU_Size[Use][1];t+=FRU_Size[Use][1])
			{
				clrscr_g(11,24,20,24);
				dputs_g(11,24,0x0E,t*10/FRU_Size[Use][1]*10/FRU_Size[Use][0],0);
				cputs_g(14,24,0x0E,"%");
				Read_FRU(Use,t,FRU_Size[Use][1]);
				asm mov di,Return
				asm add di,2
				asm mov al,cs:[di]
				asm mov Completion,al
				//FRU_State[i]=Completion;
				if(Completion==0)
				{
					FRU_State[Use][1]=1;
					asm add di,2
					for(j=0;j<=FRU_Size[Use][1]-1;j++)
					{
						asm mov al,cs:[di]
						asm mov FRU_temp,al
						FRU_Value[Use][t+j]=FRU_temp;
						//hputs_g(21+j*3,24,0x08,FRU_State[i],2);
						asm inc di
					}
				}
			}
			Clear_Update();
			clrscr_g(1,24,80,24);
			Key2=1;
			//FRU_Min=0;
			//FRU_Max=255;
			//Count=FRU_Min;
			List_FRU(Use);
			Input_Key();
			break;
		}
		case 0x1F73://s
		case 0x1F53://S
		{
			//write fru to hardware
Update_Ready:
			cputs_g(1,24,0x0E,"FRU ID:");
			hputs_g(8,24,0x0E,Use,2);
			for(t=0;t<=FRU_Size[Use][0]*FRU_Size[Use][1];t+=FRU_Size[Use][1])
			{
				clrscr_g(11,24,20,24);
				dputs_g(11,24,0x0E,t*10/FRU_Size[Use][1]*10/FRU_Size[Use][0],0);
				cputs_g(14,24,0x0E,"%");
				Write_FRU(Use,t,FRU_Size[Use][1]);
			}
			for(i=0;i<2048;i++)
				FRU_OLD[i]=FRU_Value[Use][i];
			if(Update_Flag==1)
				asm jmp Update_Exit
			Clear_Update();
			clrscr_g(1,24,80,24);
			Key2=1;
			//FRU_Min=0;
			//FRU_Max=255;
			//Count=FRU_Min;
			List_FRU(Use);
			Input_Key();
			break;
		}
		default:
		{
			//hputs_g(70,24,0x0E,Key,4);
			////Key2=1;
			Input_Key();
		}
	}
}
void Clear_Update()// clear all flag about fru
{
	unsigned int x;
	for(x=0;x<2048;x++)
		FRU_Update[x]=0;
	Update_Flag=0;
}
void FRU_String()
{
	unsigned int  i;
	if(FRU_State[Use][0]==1 &&  FRU_State[Use][1]==1 && FRU_Value[Use][0]!=0xFF && FRU_Value[Use][0]!=0x00)
	{
		cputs_g(1,8,0x0B,"Command Header Format Version:");
		hputs_g(32,8,0x0A,FRU_Value[Use][0],2);
		cputs_g(1,9,0x0B,"  Internal Use Area Offset:");
		cputs_g(1,10,0x0B,"  Chassis Info Area Offset:");
		cputs_g(1,11,0x0B,"  Board Area Offset:");
		cputs_g(1,12,0x0B,"  Product Info Area Offset:");
		cputs_g(1,13,0x0B,"  MultiRecord Area Offset:");
		for(i=1;i<=5;i++)
		{
			if(FRU_Value[Use][i]==0)
				color=0x0C;//red
			else
				color=0x0A;//green
			hputs_g(32,8+i,color,FRU_Value[Use][i]*8,2);
			cputs_g(1,8+Use2,0x0E,"*");//0x0E yellow
		}
		Get_Key2();
	}
	else
		clrscr_g(1,7,80,23);
}
unsigned int FRU_Count(int x,int y,int attr,char *str,unsigned int i,char t,int x2)
{
	unsigned char j,k=0,temp;
	if(t!=0)
	{
		for(k=0;k<t;k++)
		{
			temp=FRU_Value[Use][++i];
			for(j=0;j<(temp&0x3F);j++)
			{
				if((temp&0xC0)==0xC0)
				{
					gotoxy_g(x+j,y+k);
					printf_g(attr,FRU_Value[Use][++i]);
				}
				else if((temp&0xC0)==0x00)
					hputs_g(x+j*3,y+k,attr,FRU_Value[Use][++i],2);
			}
		}
	}
	else if(t==0)
	{
		while(FRU_Value[Use][++i]!=0xC1)// && FRU_Value[Use][++i]!=0x00)
		{
			cputs_g(x-26,y+k,0x03,str);
			hputs_g(x2,y+k,0x02,k,1);
			temp=FRU_Value[Use][i];
			for(j=0;j<(temp&0x3F);j++)
			{
				if((temp&0xC0)==0xC0)
				{
					gotoxy_g(x+j,y+k);
					printf_g(attr,FRU_Value[Use][++i]);
				}
				else if((temp&0xC0)==0x00)
					hputs_g(x+j*3,y+k,attr,FRU_Value[Use][++i],2);
			}
			k++;
		}
	}
	return i;
}
void List_FRU(unsigned char x)//list binary data
{
	int i,j;
	for(i=FRU_Min;i<=FRU_Max;i+=16)
	{
		for(j=0;j<=15;j++)
		{
			Background=0;
			if(Count==i+j)
			{
				Background=0x50;
				hputs_g(1,7,0x03,i+j,4);//when cursor move , it count to its coordinate
			}
			color=0x07;
			hputs_g(j*3+6,7,0x03,j,2);//00 01 02 03 04 05 ...... 0E 0F
			if((i+j)<FRU_Size[Use][0]*FRU_Size[Use][1])
			{
				if((FRU_Value[x][i+j]==0xFF || FRU_Value[x][i+j]==0x00) && FRU_Update[i+j]!=1)
					color=0x08;//gray, indicate not changed
				else if(FRU_Update[i+j]==1)
					color=0x0F;//white , indicate changed by hand
				hputs_g(j*3+6,(i-FRU_Min)/16+8,color+Background,FRU_Value[x][i+j],2);//FRU binary
				hputs_g(j+54,7,0x03,j,1);//0123456789ABCDEF
				gotoxy_g(j+54,(i-FRU_Min)/16+8);
				if(FRU_Value[x][i+j]>=0x20 && FRU_Value[x][i+j]<=0x7A)
				//if((FRU_Value[x][i+j]>=0x30 && FRU_Value[x][i+j] <=0x39) || (FRU_Value[x][i+j]>=0x41 && FRU_Value[x][i+j] <=0x5A) || (FRU_Value[x][i+j]>=0x30 && FRU_Value[x][i+j] <=0x39))
					printf_g(color,FRU_Value[x][i+j]);
				else
					printf_g(color,0x2E);
			}
			else
			{
				cputs_g(j*3+6,(i-FRU_Min)/16+8,0x04,"XX");
				cputs_g(j+54,(i-FRU_Min)/16+8,0x04,"X");
			}
		}
		hputs_g(1,(i-FRU_Min)/16+8,0x03,i,4);
	}
	gotoxy_g((Count-FRU_Min)%16*3+7-Key2%2,(Count-FRU_Min)/16+8);
}
void Get_FRU_Inventory_Area_Info(unsigned char FRU_ID)//get fru size and unit
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,1028h
	asm mov cs:[si],bx
	asm push si
	asm add si,2
	asm mov al,FRU_ID
	asm mov cs:[si],al
	asm pop si
	asm mov cs:BMCPackageCount,3
	SendBMCCommand();
}
void Read_FRU(unsigned char FRU_ID,unsigned int x,unsigned char y)//read fru from hardware
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,1128h
	asm mov cs:[si],bx
	asm push si
	asm add si,2
	asm mov al,FRU_ID
	asm mov cs:[si],al
	asm inc si
	asm mov ax,x
	asm mov cs:[si],ax
	asm add si,2
	asm mov al,y
	asm mov cs:[si],al
	asm pop si
	asm mov cs:BMCPackageCount,6
	SendBMCCommand();
}
void Write_FRU(unsigned char FRU_ID,unsigned int x,unsigned char y)//write fru to hardware
{
	unsigned int  i;
	unsigned char j;
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,1228h
	asm mov cs:[si],bx
	asm push si
	asm add si,2
	asm mov al,FRU_ID
	asm mov cs:[si],al
	asm inc si
	asm mov ax,x
	asm mov cs:[si],ax
	asm add si,2
	for(i=0;i<y;i++)
	{
		j=FRU_Value[Use][x+i];
		asm mov al,j
		asm mov cs:[si],al
		asm inc si
	}
	asm pop si
	asm mov al,y
	asm add al,5
	asm mov cs:BMCPackageCount,al
	SendBMCCommand();
}
//---Dec Value to Time format-----------------------------------
void Dec2Time(int x,int y,int attr,unsigned long time)
{
	char i;
	year=((time/60/24/365)+1996);
	date=time/60/24%365-((time/60/24/365+1970)-1972)/4;
	for(i=0;i<=11;i++)
		if(date>month_table[i])
			month=i+1;
	
	date-=month_table[month-1];
	hour=time/60%24;
	min=time%60;
	dputs_g(x,y,attr,month,2);
	cputs_g(x+2,y,attr,"/");
	dputs_g(x+3,y,attr,date,2);
	cputs_g(x+5,y,attr,"/");
	dputs_g(x+6,y,attr,year,4);
	dputs_g(x+11,y,attr,hour,2);
	cputs_g(x+13,y,attr,":");
	dputs_g(x+14,y,attr,min,2);
	//sec=time%60;
}
