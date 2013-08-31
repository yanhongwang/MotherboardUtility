#include <stdio.h>
#include <string.h>

#include "SDR.h"
#include "KCS.c"

#define DEBUG

FILE *fp;
unsigned int  Key;
unsigned int SDR_Next = 0;
unsigned int SDR_Total;
unsigned int SDR_Free;
unsigned char SDR_ID;
unsigned char SDR_Time;
unsigned char SDR_Temp;
unsigned char SDR_Value[ 128 ][ 64 ];
unsigned char SDR_Record[ 10 ] = { 0x01, 0x02, 0x08, 0x09, 0x10, 0x11, 0x12, 0x13, 0x14, 0xC0 };

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

unsigned char *comment_Full_or_Compact_Sensor[] = // 0x01 or 0x02
				{
					"// Sensor Owner ID",
					"// Sensor Owner LUN",
					"// Sensor Number",
					"// Entity ID",
					"// Entity Instance",
					"// Sensor Initialization",
					"// Sensor Capabilities",
					"// Sensor Type",
					"// Event / Reading Type Code",
					"// Assertion Event Mask / Lower Threshold Reading Mask",
					"// Deassertion Event Mask / Upper Threshold Reading Mask",
					"// Discrete Reading Mask / Settable",
					"// Sensor Units 1",
					"// Sensor Units 2 - Base Unit",
					"// Sensor Units 3 - Modifier Unit",
					
					"// Positive hysterisis value",
					"// Negative hysterisis value",
					"// Reserved1",
					"// Reserved2",
					
					"// OEM",
					"// Type/Length Code"
				};

unsigned char *comment_Full_Sensor[] = // only for 0x01
				{
					"// Linearization",
					"// M",
					"// M, Tolerance",
					"// B",
					"// B, Accuracy",
					"// Accuracy, Accuracy Exp",
					"// R exp, B exp",
					"// Analog characteristic flags",
					"// Nominal Reading",
					"// Normal Maximum",
					"// Normal Minimum",
					"// Sensor Maximum Reading",
					"// Sensor Minimum Reading",
					"// Upper non-recoverable Threshold",
					"// Upper critical Threshold",
					"// Upper non-critial Threshold",
					"// Lower non-recoverable Threshold",
					"// Lower critical Threshold",
					"// Lower non-critical Threshold"
				};

unsigned char *comment_Entity_Association[] = //0x08
				{
					"// Container Entity ID",
					"// Container Entity Instance",
					"// flags",
					"// Contained Entity 1 / Range 1 entity",
					"// Contained Entity 1 Instance Range 1 first entity instance",
					"// Contained Entity 2 / Range 1 entity",
					"// Contained Entity 2 Instance / Range 1 last entity Instance",
					"// Contained Entity 3 / Range 2 entity",
					"// Contained Entity 3 Instance / Range 2 first entity Instance",
					"// Contained Entity 4 / Range 2 entity",
					"// Contained Entity 4 Instance / Range 2 last entity Instance",
				};

unsigned char *comment_Device_relative_Entity_Assocation[] = //0x09
				{
					"// Container Entity ID",
					"// Container Entity Instance",
					"// Container Entity Device Address",
					"// Container Entity Device Channel",
					"// flags",
					"// Container Entity 1 Device Address",
					"// Container Entity 1 Device Channel",
					"// Contained Entity 1 / Range 1 Entity ID",
					"// Contained Entity 1 Instance Range 1 first entity instance",
					"// Contained Entity 2 Device Address", 
					"// Contained Entity 2 Device Channel",
					"// Contained Entity 2 / Range 1 Entity ID",
					"// Contained Entity 2 Instance / Range 1 last Entity Instance",
					"// Contained Entity 3 Device Address",
					"// Contained Entity 3 Device Channel",
					"// Contained Entity 3 / Range 2 entity",
					"// Contained Entity 3 Instance / Range 2 first entity Instance",
					"// Contained Entity 4 Device Address",
					"// Contained Entity 4 Device Channel",
					"// Contained Entity 4 / Range 2 entity",
					"// Contained Entity 4 Instance / Range 2 last entity Instance",
					"// Reserved1",
					"// Reserved2",
					"// Reserved3",
					"// Reserved4",
					"// Reserved5",
					"// Reserved6"
				};

unsigned char *comment_Generic_Device_Locator[] = //0x10
				{
					"// Device Access Address",
					"// Device Slave Address",
					"// Access LUN / Bus ID",
					"// Record Body Bytes",
					"// Address span",
					"// Reserved",
					"// Device Type",
					"// Device Type Modifier",
					"// Entity ID",
					"// Entity Instance",
					"// OEM",
					"// Device ID String Type / Length"
				};
				
unsigned char *comment_FRU_Device_Locator[] = //0x11
				{
					"// Device Access Address",
					"// FRU Device ID / Device Slave Address",
					"// Logical-Physical / Access LUN / Bus ID",
					"// Channel Number",
					"// Reserved",
					"// Device Type",
					"// Device Type Modifier",
					"// FRU Entity ID",
					"// FRU Entity Instance",
					"// OEM",
					"// Device ID String Type / Length",
				};
				
unsigned char *comment_Management_Controller_Device_Locator[] = //0x12
				{
					"// Device Slave Address",
					"// Channel Number",
					"// Power State Notification Global Initialization",
					"// Device Capabilities",
					"// reserve",
					"// reserve",
					"// reserve",
					"// Entity ID",
					"// Entity Instance",
					"// OEM",
					"// Device ID String Type/Length"
				};
				
unsigned char *comment_Management_Controller_Confirmation[] = //0x13
				{
					"// Device Slave Address",
					"// Device ID",
					"// Channel Number / Device Revision",
					"// Firmware Revision 1",
					"// Firmware Revision 2",
					"// IPMI Version",
					"// Manufacturer ID",
					"// Product ID",
					"// Device GUID",
				};
				
unsigned char *comment_BMC_Message_Channel_Info[] = //0x14
				{
					"// Message Channel 0 Info",
					"// Channel 1 Info",
					"// Channel 2 Info",
					"// Channel 3 Info",
					"// Channel 4 Info",
					"// Channel 5 Info",
					"// Channel 6 Info",
					"// Channel 7 Info"
				};
unsigned char *comment_OEM[] = //0xC0
				{
					"//Manufacturer ID"
				};

void Get_SDR_Repository_Info( void )//get sdr version, record count, free space...........
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,2028h//get sdr repository info
	asm mov cs:[si],bx
	asm mov cs:BMCPackageCount,2
	SendBMCCommand();
}

char Read_SDR( void )
{
	unsigned int j;
	Get_SDR_Repository_Info();
	asm mov si,Return_value
	asm add si,4
	asm mov ax,cs:[si]
	asm mov SDR_Total,ax
	asm add si,2
	asm mov ax,cs:[si]
	asm mov SDR_Free,ax
	//cputs_g(1,2,0x5F,"SDR_Total  :");
	//dputs_g(13,2,0x5E,SDR_Total,3);
	//cputs_g(30,2,0x5F,"SDR_Free   :");
	//dputs_g(44,2,0x5E,SDR_Free,0);
	//cputs_g(48,2,0x5E,"Bytes");
	if( SDR_Total <= 0 )
	{
		printf( "No SDR data!\n" );
		return -1;
	}
	
	while( SDR_Next != 0xFFFF )
	{
		KCS_RD_PTR = 0;
		asm mov si,offset BMCSendPackageBuffer
		asm mov di,offset BMCReturnPackageBuffer
		asm mov bx,2328h//Get SDR
		asm mov cs:[si],bx//put 2328h into BMCSendPackageBuffer
		asm push si
		asm add si,2
		asm mov bx,0
		asm mov cs:[si],bx//put Reservation ID into BMCSendPackageBuffer
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
		asm mov di,Return_value
		asm add di,3
		asm mov ax,cs:[di]
		asm mov SDR_Next,ax
		asm inc di
		for( j = 5; j <= KCS_RD_PTR; j++ )
		{
			asm inc di
			asm mov al,cs:[di]
			asm mov SDR_Temp,al
			SDR_Value[ SDR_Time ][ j - 5 ] = SDR_Temp;
		}
		SDR_Time++;//sdr total count
	}
	return 0;//mean complete normally
}

void Write_SDR()
{
//	Get_SDR_Repository_Info();
	
}

unsigned char write_multi_hex( unsigned char sdr_id, unsigned char sdr_index, unsigned char count )
{
	unsigned char pattern[ 16 ];
	unsigned char j;
	int i;
	
	for( i = sdr_index + count - 1, j = 0; i >= sdr_index; i--, j += 2 )
		sprintf( pattern + j, "%02X", SDR_Value[ sdr_id ][ i ] );
	
	fprintf( fp, "%s", pattern );
	return sdr_index + count;
}

int main( int argc, char *argv[] )
{
	unsigned char i;
	unsigned char j;
	unsigned char filename[ 20 ];
	unsigned char option = 0;
	//unsigned char onlyonetime = 0;
	unsigned char sdr_index;
	unsigned char sdr_id;
	unsigned char endofidstring;
	
	AutoCheckPort();
	
	if( KCS_Yes == 0 )
	{
		printf( "Not found KCS interface or KCS is fail!\n" );
		return -1;
	}
	
	//it means user imply use argument to indicate.
	if( argc >= 2 )
	{
		if( !strncmp( argv[ 1 ], "-w=", 3 ) )
		{
			strcpy( filename, argv[ 1 ] + 3 );
			//onlyonetime = 1;
			option = '2';
		}
		else if( !strncmp( argv[ 1 ], "-r=", 3 ) )
		{
			strcpy( filename, argv[ 1 ] + 3 );
			//onlyonetime = 1;
			option = '1';
		}
		else
		{
			fprintf( stdout, "usage: sdr -w/-r=filename\n" );
			return -1;
		}
	}
	
	memset( SDR_Value, '\0', sizeof( SDR_Value ) );
	
	if( '2' == option )//read text file to write eeprom
	{
		
#undef DEBUG		
#ifdef DEBUG
		for( j = 0; j < SDR_Total; j++ )
		{	
			for( i = 0; i < SDR_Value[ j ][ 4 ] + 5; i++ )
			{
				if( 0 == i % 16 )
					fprintf( stdout, "\n" );
				fprintf( stdout, "%02X  ", SDR_Value[ j ][ i ]);//all sdr binary show
			}
			getchar();
		}
#endif
	}
	else if( '1' == option )//read eeprom to write text file
	{
		if( -1 == Read_SDR() )
			return -1;
		
		if( ( fp = fopen( filename, "w" ) ) == NULL )
		{
			printf( "open error.\n" );
			getchar();
			return -1;
		}
		
		fseek( fp, 0, SEEK_SET );
		
		fprintf( fp, "SYSTEM/IPMI\n" );
		fprintf( fp, "USER/1\n" );
		fprintf( fp, "// File Header Information\n" );
		fprintf( fp, "//\n" );
		fprintf( fp, "_LF_NAME	'xxxx'\n" );
		fprintf( fp, "_LF_PRODUCT	'xxxx'\n" );
		fprintf( fp, "_LF_VERSION	'1.011'\n" );
		fprintf( fp, "_LF_FMT_VER	'1.0'\n" );
		fprintf( fp, "_SDR_VERSION	'0100'\n\n\n" );
		fprintf( fp, "_SDR (\n" );
		fprintf( fp, "_START_ADDR	0E00\n" );
		fprintf( fp, "_DATA_LEN	1293\n" );
		fprintf( fp,  "_NVS_TYPE	'IMBDEVICE'\n" );
		fprintf( fp, "_DEV_BUS	FF\n" );
		fprintf( fp, "_DEV_ADDRESS	20\n\n" );
		
		for( sdr_id = 0, sdr_index = 0; sdr_id < SDR_Total; sdr_id++, sdr_index = 0 )
		{
			fprintf( fp,   "_SDR_TYPE	%02X\n", SDR_Value[ sdr_id ][ 3 ] );//SDR_TYPE
			fprintf( fp,   "_SDR_TAG	'ASPEN'\n" );
			fprintf( fp,   "_SDR_TAG	'BMC'\n" );
			fprintf( fp,   "_REC_LEN	00%02X\n\n", SDR_Value[ sdr_id ][ 4 ] + 5 );//REC_LEN
			
			fprintf( fp, "   // Sensor Record Header\n" );
			fprintf( fp, "   " ); sdr_index = write_multi_hex( sdr_id, sdr_index, 2 ); fprintf( fp, "\t\t\t\t\t// Record ID\n" );
			fprintf( fp, "   %02X\t\t\t\t\t// SDR Version\n", SDR_Value[ sdr_id ][ sdr_index++ ] );
			fprintf( fp, "   %02X\t\t\t\t\t// Record Type\n", SDR_Value[ sdr_id ][ sdr_index++ ] );
			fprintf( fp, "   %02X\t\t\t\t\t// Record Length\n\n", SDR_Value[ sdr_id ][ sdr_index++ ] );
			
			if( 0x14 != SDR_Value[ sdr_id ][ 3 ] )//only BMC Message Channel Info has no field of "Record Key Bytes"
				fprintf( fp, "   // Record Key Bytes\n" );
			
			switch( SDR_Value[ sdr_id ][ 3 ] )//Record Type,_SDR_TYPE
			{
				case 0x01://Full Sensor
				case 0x02://Compact Sensor
				{
					for( i = 0; i <= 2; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
					
					fprintf( fp, "\n   // Record Body Bytes\n" );
					
					
					for( ; i <= 8; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
					
					for( ; i <= 11; i++ )
					{fprintf( fp, "   " ); sdr_index = write_multi_hex( sdr_id, sdr_index, 2 ); fprintf( fp, "\t\t\t\t\t%s\n", comment_Full_or_Compact_Sensor[ i ] );}
					
					fprintf( fp, "\t\t\t\t\t\t// Threshold Mask, Readable\n\t\t\t\t\t\t// Threshold Mask\n" );
					
					for( ; i <= 14; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
					
					if( 0x01 == SDR_Value[ sdr_id ][ 3 ] )// only full sensor need them
					{
						for( i = 0; i <= 18; i++, sdr_index++ )
							fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_Sensor[ i ] );
					}
					else//only compact sensor need them
						{fprintf( fp, "   " ); sdr_index = write_multi_hex( sdr_id, sdr_index, 2 ); fprintf( fp, "\t\t\t\t\t// Sensor Record Sharing\n" );}
					
					for( i = 15; i <= 18; i++, sdr_index++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
					
					if( 0x02 == SDR_Value[ sdr_id ][ 3 ] )//only compact sensor need them
						fprintf( fp, "   %02X\t\t\t\t\t// Reserved3\n", SDR_Value[ sdr_id ][ sdr_index++ ] );
					
					for( ; i <= 20; i++, sdr_index++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
					
					endofidstring = SDR_Value[ sdr_id ][ sdr_index - 1 ] & 0x1f;
					SDR_Value[ sdr_id ][ sdr_index + endofidstring ] = '\0';
					fprintf( fp, "   '%s'\n\n", SDR_Value[ sdr_id ] + sdr_index );
					
					break;
				}
				
				case 0x08://Entity Association
				{
					for( i = 0; i <= 4; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Entity_Association[ i ] );
					
					fprintf( fp, "\n   // Record Body Bytes\n" );
					
					for( ; i <= 10; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Entity_Association[ i ] );
					
					break;
				}
				
				case 0x09://Device-relative Entity Assocation
				{
					for( i = 0; i <= 8; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Device_relative_Entity_Assocation[ i ] );
					
					fprintf( fp, "\n   // Record Body Bytes\n" );
					
					for( ; i <= 26; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Device_relative_Entity_Assocation[ i ] );
					
					break;
				}
				
				case 0x10://Generic Device Locator
				{
					for( i = 0; i <= 2; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Generic_Device_Locator[ i ] );
					
					fprintf( fp, "\n   // Record Body Bytes\n", SDR_Value[ sdr_id ][ sdr_index++ ] );
					
					for( ; i <= 11; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Generic_Device_Locator[ i ] );
					
					endofidstring = SDR_Value[ sdr_id ][ sdr_index - 1 ] & 0x1f;
					SDR_Value[ sdr_id ][ sdr_index + endofidstring ] = '\0';
					fprintf( fp, "   '%s'\n\n", SDR_Value[ sdr_id ] + sdr_index );
					
					break;
				}
				
				case 0x11://FRU Device Locator
				{
					for( i = 0; i <= 3; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_FRU_Device_Locator[ i ] );
					
					fprintf( fp, "\n   // Record Body Bytes\n" );
					
					for( ; i <= 10; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_FRU_Device_Locator[ i ] );
					
					endofidstring = SDR_Value[ sdr_id ][ sdr_index - 1 ] & 0x1f;
					SDR_Value[ sdr_id ][ sdr_index + endofidstring ] = '\0';
					fprintf( fp, "   '%s'\n\n", SDR_Value[ sdr_id ] + sdr_index );
					
					break;
				}
				
				case 0x12://Management Controller Device Locator
				{
					for( i = 0; i <= 1; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Management_Controller_Device_Locator[ i ] );
					
					fprintf( fp, "\n   // Record Body Bytes\n" );
					
					for( ; i <= 10; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Management_Controller_Device_Locator[ i ] );
					
					endofidstring = SDR_Value[ sdr_id ][ sdr_index - 1 ] & 0x1f;
					SDR_Value[ sdr_id ][ sdr_index + endofidstring ] = '\0';
					fprintf( fp, "   '%s'\n\n", SDR_Value[ sdr_id ] + sdr_index );
					
					break;
				}
				
				case 0x13://Management Controller Confirmation
				{
					for( i = 0; i <= 2; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Management_Controller_Confirmation[ i ] );
					
					fprintf( fp, "\n   // Record Body Bytes\n" );
					
					for( ; i <= 5; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Management_Controller_Confirmation[ i ] );
					
					fprintf( fp, "   " ); sdr_index = write_multi_hex( sdr_id, sdr_index,  3 ); fprintf( fp, "\t\t\t\t\t%s\n", comment_Management_Controller_Confirmation[ i++ ] );
					fprintf( fp, "   " ); sdr_index = write_multi_hex( sdr_id, sdr_index,  2 ); fprintf( fp, "\t\t\t\t\t%s\n", comment_Management_Controller_Confirmation[ i++ ] );
					fprintf( fp, "   " ); sdr_index = write_multi_hex( sdr_id, sdr_index, 16 ); fprintf( fp, "\t\t\t\t\t%s\n", comment_Management_Controller_Confirmation[ i++ ] );
					
					break;
				}
				
				case 0x14://BMC Message Channel Info
				{
					fprintf( fp, "\n   // Record Body Bytes\n" );
					for( i = 0; i <= 7; sdr_index++, i++ )
						fprintf( fp, "   %02X\t\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_BMC_Message_Channel_Info[ i ] );
					
					break;
				}
				
				case 0xC0://OEM
				{
					fprintf( fp, "   " ); sdr_index = write_multi_hex( sdr_id, sdr_index, 3 ); fprintf( fp, "\t\t\t\t%s\n\n", comment_OEM[ 0 ] );
					
					fprintf( fp, "   // Record Body Bytes\n" );
					for( i = 0; i <= SDR_Value[ sdr_id ][ 4 ] - 4; i++, sdr_index++ )// check specification how many "OEM Data" byte should you put in.
						fprintf( fp, "   %02X\t\t//\n", SDR_Value[ sdr_id ][ sdr_index ] );
					fprintf( fp, "\n" );
					break;
				}
			}
		}
		
		fclose( fp );
#undef DEBUG
#ifdef DEBUG
		
		for( j = 0; j < SDR_Total; j++ )
		{	
			for( i = 0; i < SDR_Value[ j ][ 4 ] + 5; i++ )
			{
				if( 0 == i % 16 )
					fprintf( stdout, "\n" );
				fprintf( stdout, "%02X  ", SDR_Value[ j ][ i ]);//all sdr binary show
			}
			getchar();
		}
		
#endif
	
	}
	
	return 0;
}

