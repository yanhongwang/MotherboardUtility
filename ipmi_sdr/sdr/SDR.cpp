#include <stdio.h>
#include <string.h>

#include "SDR.h"
#include "KCS.c"

#define DEBUG
#define GET_WHOLE_LINE 256//get characters or till a newline

FILE *fp;
unsigned char string[ 256 ];
unsigned int  Key;
unsigned int SDR_Next = 0;
unsigned int SDR_Total;
unsigned int SDR_Free;
unsigned char SDR_ID;
unsigned char SDR_Time;
unsigned char SDR_Temp;
unsigned char SDR_Value[ 128 ][ 64 ];
unsigned char SDR_Record[ 10 ] = { 0x01, 0x02, 0x08, 0x09, 0x10, 0x11, 0x12, 0x13, 0x14, 0xC0 };
unsigned int Reservation_ID = 0xff;
unsigned char Completion = 1;

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

unsigned char *comment_SENSOR_RECORD_HEADER[] =
				{
					"/* Record ID*/",
					"/* SDR Version*/",
					"/* Record Type*/",
					"/* Record Length*/"
				};


unsigned char *comment_Full_or_Compact_Sensor[] = // 0x01 or 0x02
				{
					"/* Sensor Owner ID*/",
					"/* Sensor Owner LUN*/",
					"/* Sensor Number*/",
					"/* Entity ID*/",
					"/* Entity Instance*/",
					"/* Sensor Initialization*/",
					"/* Sensor Capabilities*/",
					"/* Sensor Type*/",
					"/* Event / Reading Type Code*/",
					"/* Assertion Event Mask / Lower Threshold Reading Mask*/",
					"/* Deassertion Event Mask / Upper Threshold Reading Mask*/",
					"/* Discrete Reading Mask / Settable Threshold Mask, Readable Threshold Mask*/",
					"/* Sensor Units 1*/",
					"/* Sensor Units 2 - Base Unit*/",
					"/* Sensor Units 3 - Modifier Unit*/",
					
					"/* Positive hysterisis value*/",
					"/* Negative hysterisis value*/",
					"/* Reserved1*/",
					"/* Reserved2*/",
					
					"/* OEM*/",
					"/* ID String Type/Length Code*/"
				};

unsigned char *comment_Full_Sensor[] = // only for 0x01
				{
					"/* Linearization*/",
					"/* M*/",
					"/* M, Tolerance*/",
					"/* B*/",
					"/* B, Accuracy*/",
					"/* Accuracy, Accuracy Exp*/",
					"/* R exp, B exp*/",
					"/* Analog characteristic flags*/",
					"/* Nominal Reading*/",
					"/* Normal Maximum*/",
					"/* Normal Minimum*/",
					"/* Sensor Maximum Reading*/",
					"/* Sensor Minimum Reading*/",
					"/* Upper non-recoverable Threshold*/",
					"/* Upper critical Threshold*/",
					"/* Upper non-critial Threshold*/",
					"/* Lower non-recoverable Threshold*/",
					"/* Lower critical Threshold*/",
					"/* Lower non-critical Threshold*/"
				};

unsigned char *comment_Entity_Association[] = //0x08
				{
					"/* Container Entity ID*/",
					"/* Container Entity Instance*/",
					"/* flags*/",
					"/* Contained Entity 1 / Range 1 entity*/",
					"/* Contained Entity 1 Instance Range 1 first entity instance*/",
					"/* Contained Entity 2 / Range 1 entity*/",
					"/* Contained Entity 2 Instance / Range 1 last entity Instance*/",
					"/* Contained Entity 3 / Range 2 entity*/",
					"/* Contained Entity 3 Instance / Range 2 first entity Instance*/",
					"/* Contained Entity 4 / Range 2 entity*/",
					"/* Contained Entity 4 Instance / Range 2 last entity Instance*/"
				};

unsigned char *comment_Device_relative_Entity_Assocation[] = //0x09
				{
					"/* Container Entity ID*/",
					"/* Container Entity Instance*/",
					"/* Container Entity Device Address*/",
					"/* Container Entity Device Channel*/",
					"/* flags*/",
					"/* Container Entity 1 Device Address*/",
					"/* Container Entity 1 Device Channel*/",
					"/* Contained Entity 1 / Range 1 Entity ID*/",
					"/* Contained Entity 1 Instance Range 1 first entity instance*/",
					"/* Contained Entity 2 Device Address*/", 
					"/* Contained Entity 2 Device Channel*/",
					"/* Contained Entity 2 / Range 1 Entity ID*/",
					"/* Contained Entity 2 Instance / Range 1 last Entity Instance*/",
					"/* Contained Entity 3 Device Address*/",
					"/* Contained Entity 3 Device Channel*/",
					"/* Contained Entity 3 / Range 2 entity*/",
					"/* Contained Entity 3 Instance / Range 2 first entity Instance*/",
					"/* Contained Entity 4 Device Address*/",
					"/* Contained Entity 4 Device Channel*/",
					"/* Contained Entity 4 / Range 2 entity*/",
					"/* Contained Entity 4 Instance / Range 2 last entity Instance*/",
					"/* Reserved1*/",
					"/* Reserved2*/",
					"/* Reserved3*/",
					"/* Reserved4*/",
					"/* Reserved5*/",
					"/* Reserved6*/"
				};

unsigned char *comment_Generic_Device_Locator[] = //0x10
				{
					"/* Device Access Address*/",
					"/* Device Slave Address*/",
					"/* Access LUN / Bus ID*/",
					"/* Record Body Bytes*/",
					"/* Address span*/",
					"/* Reserved*/",
					"/* Device Type*/",
					"/* Device Type Modifier*/",
					"/* Entity ID*/",
					"/* Entity Instance*/",
					"/* OEM*/",
					"/* Device ID String Type / Length*/"
				};         
				           
unsigned char *comment_FRU_Device_Locator[] = //0x11
				{
					"/* Device Access Address*/",
					"/* FRU Device ID / Device Slave Address*/",
					"/* Logical-Physical / Access LUN / Bus ID*/",
					"/* Channel Number*/",
					"/* Reserved*/",
					"/* Device Type*/",
					"/* Device Type Modifier*/",
					"/* FRU Entity ID*/",
					"/* FRU Entity Instance*/",
					"/* OEM*/",
					"/* Device ID String Type / Length*/",
				};

unsigned char *comment_Management_Controller_Device_Locator[] = //0x12
				{
					"/* Device Slave Address*/",
					"/* Channel Number*/",
					"/* Power State Notification Global Initialization*/",
					"/* Device Capabilities*/",
					"/* reserve*/",
					"/* reserve*/",
					"/* reserve*/",
					"/* Entity ID*/",
					"/* Entity Instance*/",
					"/* OEM*/",
					"/* Device ID String Type/Length*/"
				};
				
unsigned char *comment_Management_Controller_Confirmation[] = //0x13
				{
					"/* Device Slave Address*/",
					"/* Device ID*/",
					"/* Channel Number / Device Revision*/",
					"/* Firmware Revision 1*/",
					"/* Firmware Revision 2*/",
					"/* IPMI Version*/",
					"/* Manufacturer ID*/",
					"/* Product ID*/",
					"/* Device GUID*/",
				};

unsigned char *comment_BMC_Message_Channel_Info[] = //0x14
				{
					"/* Message Channel 0 Info*/",
					"/* Channel 1 Info*/",
					"/* Channel 2 Info*/",
					"/* Channel 3 Info*/",
					"/* Channel 4 Info*/",
					"/* Channel 5 Info*/",
					"/* Channel 6 Info*/",
					"/* Channel 7 Info*/"
				};
unsigned char *comment_OEM[] = //0xC0
				{
					"/*Manufacturer ID*/"
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
	asm mov SDR_Total,ax//Number of possible allocation units
	asm add si,2
	asm mov ax,cs:[si]
	asm mov SDR_Free,ax//Number of free allocation units
	
	if( SDR_Total <= 0 )
	{
		printf( "No SDR data!\n" );
		return -1;
	}
	
	SDR_Next = 0;
	SDR_Time = 0;
	
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
		asm mov ax,SDR_Next//Record ID of record to Get, LS , MS byte
		asm mov cs:[si],ax
		asm add si,2
		asm mov cs:[si],bl
		asm inc si
		asm mov bl,0xFF// meaning read entire record
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

void Reserve_SDR_Repository()
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,2228h//Reserve SDR Repository
	asm mov cs:[si],bx
	asm mov cs:BMCPackageCount,2
	SendBMCCommand();
}

void Clear_SDR_Repository()
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,2728h//Clear SDR Repository
	asm mov cs:[si],bx
	asm push si
	asm add si,2
	
	asm mov ax,Reservation_ID//Reservation ID LS,MS
	asm mov cs:[si],ax
	asm add si,2
	
	asm mov al, 'C'
	asm mov cs:[si],al
	asm inc si
	
	asm mov al, 'L'
	asm mov cs:[si],al
	asm inc si
	
	asm mov al, 'R'
	asm mov cs:[si],al
	asm inc si
	
	asm mov al, 0xaa
	asm mov cs:[si],al
	
	asm pop si
	asm mov cs:BMCPackageCount,8
	SendBMCCommand();
}

void Enter_SDR_Repository_Update_Mode()
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,2a28h//Enter SDR Repository Update Mode
	asm mov cs:[si],bx
	asm mov cs:BMCPackageCount,2
	SendBMCCommand();
}

void Exit_SDR_Repository_Update_Mode()
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,2b28h//Exit SDR Repository Update Mode
	asm mov cs:[si],bx
	asm mov cs:BMCPackageCount,2
	SendBMCCommand();
}

void Add_SDR( unsigned char sdr_id )
{
	unsigned char i;
	unsigned char sdr_value;
	
	asm mov si, offset BMCSendPackageBuffer
	asm mov di, offset BMCReturnPackageBuffer
	asm mov bx, 2428h//Add SDR
	asm mov cs:[si], bx
	asm push si
	asm add si,2
	
	for( i = 0; i < SDR_Value[ sdr_id ][ 4 ] + 5; i++ )
	{
		sdr_value = SDR_Value[ sdr_id ][ i ];
		asm mov al, sdr_value
		asm mov cs:[si], al
		asm inc si
	}
	
	asm pop si
	i = SDR_Value[ sdr_id ][ 4 ] + 5 + 2;//SDR_Value[ sdr_id ][ 4 ] + 5: mean whole one record number, + 2: mean "2428h"
	asm mov al, i
	asm mov cs:BMCPackageCount,al
	SendBMCCommand();
	
}

unsigned char write_multi_hex( unsigned char sdr_id, unsigned char sdr_index, unsigned char count )
{
	unsigned char pattern[ 16 ];
	unsigned char j;
	int i;
	
	for( i = sdr_index + count - 1, j = 0; i >= sdr_index; i--, j += 2 )
		sprintf( pattern + j, "%02X", SDR_Value[ sdr_id ][ i ] );// reverse the arrangement
	
	fprintf( fp, "%s", pattern );
	return sdr_index + count;
	
}

// function parser will grasp text line, extract the data we need until the desired limit is reached
unsigned char parser( unsigned char sdr_id, unsigned char sdr_index, unsigned char destination )
{
	unsigned char *pattern;
	
	while( sdr_index <= destination )
	{
		fgets( string, GET_WHOLE_LINE, fp );//get new lineß
		
		if( feof( fp ) != 0 )
			return 0;
		
		if( ( pattern = strstr( string, ".db" ) ) != NULL )//search if ".db" exist in string.
		{
			sscanf( pattern + 3, "%x", &SDR_Value[ sdr_id ][ sdr_index ] );// because ".db" is 3 character
			sdr_index += 1;
		}
		else if( ( pattern = strstr( string, ".dw" ) ) != NULL )//search if ".dw" exist in string.
		{
			sscanf( pattern + 3, "%x", &SDR_Value[ sdr_id ][ sdr_index ] );// because ".dw" is 3 character
			sdr_index += 2;
		}
	}
	
	return sdr_index;
}

int main( int argc, char *argv[] )
{
	unsigned char i;
	unsigned char j;
	unsigned char filename[ 20 ];
	unsigned char option = 0;
	unsigned char sdr_index;
	unsigned char sdr_id;
	unsigned char endofidstring;
	unsigned char *model;
	unsigned char offset;
	unsigned char length;
	unsigned char *trim;
	unsigned char middle_number_byte;
	unsigned char string_exist;
	unsigned char remaining_record_bytes;
	unsigned char onlyonetime = 0;
	unsigned char i_want_to_read = 1;
	unsigned char i_want_to_write = 1;
	
	//it means user imply use argument to indicate.
	if( argc >= 2 )
	{
		i = 1;
		while( i < argc )
		{
			if( !strncmp( argv[ i ], "-w=", 3 ) && i_want_to_write )//specify file write to eeprom
			{
				strcpy( filename, argv[ 1 ] + 3 );
				onlyonetime = 1;
				option = '2';
				i_want_to_read = 0;// in case of somebody wants to bullshit program.
			}
			else if( !strncmp( argv[ i ], "-r=", 3 ) && i_want_to_read )//specify file read from eeprom
			{
				strcpy( filename, argv[ 1 ] + 3 );
				onlyonetime = 1;
				option = '1';
				i_want_to_write = 0;// in case of somebody wants to bullshit program.
			}
			else if( !strncmp( argv[ i ], "-p1=", 4 ) )//specify control_code
				sscanf( argv[ i ] + 4, "%x", &control_code );
			else if( !strncmp( argv[ i ], "-p2=", 4 ) )//specify command port
				sscanf( argv[ i ] + 4, "%x", &command_port );
			else
			{
				fprintf( stdout, "usage: sdr.exe -w/-r=filename -p1=data_port_num -p2=cmd_port_num.\n" );
				fprintf( stdout, "\t-p1=0x?? -p2=0x????\n" );
				return -1;
			}
			i++;
		}
	}
	
	AutoCheckPort();
	
	if( KCS_Yes == 0 )
	{
		printf( "Not found KCS interface or KCS is fail!\n" );
		return -1;
	}
	
	while( '3' != option )
	{
		memset( SDR_Value, '\0', sizeof( SDR_Value ) );
		
		if( !onlyonetime )
		{
			printf( " 1 : Read sdr\n" );
			printf( " 2 : Write sdr\n" );
			printf( " 3 : Quit\n" );
			scanf( "%c", &option );
		}
		
		if( '2' == option )//read text file to write eeprom
		{
			if( !onlyonetime )
			{
				printf( "file name:\n" );
				scanf( "%s", filename );
			}
			
			if( ( fp = fopen( filename, "r" ) ) == NULL )
			{
				fprintf( fp, "open error.\n" );
				return -1;
			}
			
			fseek( fp, 0, SEEK_SET );
			
			for( sdr_id = 0, sdr_index = 0;; sdr_id++, sdr_index = 0 )
			{
				// SENSOR RECORD HEADER
				sdr_index = parser( sdr_id, sdr_index, 3 );
				
				if( 0 != feof( fp ) )
					break;
				
				// Record Length at SENSOR RECORD HEADER
				while( 1 )
				{
					fgets( string, GET_WHOLE_LINE, fp );
					
					if( ( model = strstr( string, ".db" ) ) != NULL )//search if ".db" exist in string.
					{
						sscanf( model + 3, "%d", &SDR_Value[ sdr_id ][ sdr_index ] );// because ".db" is 3 byte
						offset = SDR_Value[ sdr_id ][ sdr_index ];
						break;
					}
				}
				
				sdr_index++;
				sdr_index = parser( sdr_id, sdr_index, sdr_index + offset - 1 );
				
				model = strchr( string, '"' );//find the first double quote from string
				trim = strrchr( model, '"' );//find the last double quote from model
				*trim = '\0';
				
				length = strlen( model ) - 1;// calculate number of "string", minus 2 mean two double quote
				SDR_Value[ sdr_id ][ 4 ] += length;//Record Length add length of "string"
				SDR_Value[ sdr_id ][ sdr_index - 1 ] |= length;//ID String Type / Length Code add length of "string"
				
				strncpy( &SDR_Value[ sdr_id ][ sdr_index ], model + 1, length );//copy vailable amount of "ID String Type" to SDR_Value
				
				//0x08,0x09,0x13,0x14 , have no type string id
				if( ( SDR_Value[ sdr_id ][ 3 ] != 0x08 ) && ( SDR_Value[ sdr_id ][ 3 ] != 0x09 ) && ( SDR_Value[ sdr_id ][ 3 ] != 0x13 ) && ( SDR_Value[ sdr_id ][ 3 ] != 0x14 ) )
					fgets( string, GET_WHOLE_LINE, fp );//get out the bottom of the record. Beside this, no other meaning
			}
			
			
			fclose( fp );
			
			Reserve_SDR_Repository();
			
			asm mov di,Return_value
			asm add di,2
			asm mov al,cs:[di]
			asm mov Completion,al
			
			if( Completion == 0 )//Reserve_SDR_Repository successful
			{
				asm inc di
				asm mov ax,cs:[di]
				asm mov Reservation_ID,ax//Reservation ID, LS Byte and MS Byte
			}
			else
			{
				fprintf( fp, "Reserve SDR Repository fail!\n" );
				getchar();
				return -1;
			}
			
			Clear_SDR_Repository();
			
			asm mov di,Return_value
			asm add di,2
			asm mov al,cs:[di]
			asm mov Completion,al
			
			if( Completion == 0 )//Clear SDR Repository successful
				printf( "SDR Repository all clear.\n" );
			
			else
			{
				fprintf( fp, "Clear SDR Repository fail!\n" );
				getchar();
				return -1;
			}
			
			Enter_SDR_Repository_Update_Mode();
			
			asm mov di,Return_value
			asm add di,2
			asm mov al,cs:[di]
			asm mov Completion,al
			
			if( Completion == 0 )//Enter SDR Repository Update Mode successful
				printf( "Now in updated mode\n" );
			else
			{
				printf( "why cannot into update mode: %d\n", Completion );
				return -1;
			}
			
			for( i = 0; i < sdr_id; i++ )
				Add_SDR( i );
			
			Exit_SDR_Repository_Update_Mode();
			
			asm mov di,Return_value
			asm add di,2
			asm mov al,cs:[di]
			asm mov Completion,al
			
			if( Completion == 0 )//Exit SDR Repository Update Mode successful
				printf( "Now out updated mode\n" );
			else
			{
				printf( "why cannot out update mode: %d\n", Completion );
				return -1;
			}
			
#undef DEBUG		
#ifdef DEBUG
			
			for( j = 0; j < sdr_id; j++ )
			{
				fprintf( stdout, "sdr_id = %d", j );
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
			if( !onlyonetime )
			{
				printf( "file name:\n" );
				scanf( "%s", filename );
			}
			
			if( -1 == Read_SDR() )
				return -1;
			
			if( ( fp = fopen( filename, "w" ) ) == NULL )
			{
				printf( "open error.\n" );
				getchar();
				return -1;
			}
			
			fseek( fp, 0, SEEK_SET );
			
			fprintf( fp, ".addr16\n" );
			
			for( sdr_id = 0, sdr_index = 0; sdr_id < SDR_Total; sdr_id++, sdr_index = 0 )
			{
				fprintf( fp, "\t\t.dw 0x" ); sdr_index = write_multi_hex( sdr_id, sdr_index, 2 ); fprintf( fp, "\t\t\t\t%s\n", comment_SENSOR_RECORD_HEADER[ 0 ] );
				fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index++ ], comment_SENSOR_RECORD_HEADER[ 1 ] );
				fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index++ ], comment_SENSOR_RECORD_HEADER[ 2 ] );
				
				string_exist = 0;
				
				switch( SDR_Value[ sdr_id ][ 3 ] )// Record Type
				{
					case 0x01: middle_number_byte = 43; string_exist = 1; break;	//Full Sensor, string
					case 0x02: string_exist = 1;					//Compact Sensor, string
					case 0x09:							//Device-relative Entity Assocation, no string
					case 0x13: middle_number_byte = 27; break;			//Management Controller Confirmation, no string
					
					case 0x10:							//Generic Device Locator, string
					case 0x11:							//FRU Device Locator, string
					case 0x12:							//Management Controller Device Locator, string
					case 0x14: string_exist = 1;					//BMC Message Channel Info, string
					case 0x08: middle_number_byte = 11; break;			//Entity Association, no string
					
					case 0xC0: middle_number_byte =  3; string_exist = 1; break;	//OEM, string
				}
				
				if( string_exist )
				{
					remaining_record_bytes = SDR_Value[ sdr_id ][ sdr_index ];
					SDR_Value[ sdr_id ][ remaining_record_bytes + 5 ] = '\0';// make end of string : '\0' so that fprintf can display string in the comment
					fprintf( fp, "\t\t.db %d + sizeof \"%s\"\t\t%s\n\n", middle_number_byte, SDR_Value[ sdr_id ] + middle_number_byte + 5, comment_SENSOR_RECORD_HEADER[ 3 ] );
					sdr_index++;
				}
				else
					fprintf( fp, "\t\t.db %d\t\t\t\t%s\n\n", SDR_Value[ sdr_id ][ sdr_index++ ], comment_SENSOR_RECORD_HEADER[ 3 ] );
				
				if( 0x14 != SDR_Value[ sdr_id ][ 3 ] )//only BMC Message Channel Info has no field of "Record Key Bytes"
					fprintf( fp, "\t\t/* Record Key Bytes*/\n\n" );
				
				switch( SDR_Value[ sdr_id ][ 3 ] )//Record Type,_SDR_TYPE
				{
					case 0x01: //Full Sensor
					case 0x02: //Compact Sensor
					{
						for( i = 0; i <= 2; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
						
						fprintf( fp, "\n\t\t/* Record Body Bytes*/\n" );
						
						for( ; i <= 8; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
						
						for( ; i <= 11; i++ )
						{fprintf( fp, "\t\t.dw 0x" ); sdr_index = write_multi_hex( sdr_id, sdr_index, 2 ); fprintf( fp, "\t\t\t\t%s\n", comment_Full_or_Compact_Sensor[ i ] );}
						
						for( ; i <= 14; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
						
						if( 0x01 == SDR_Value[ sdr_id ][ 3 ] )// only full sensor need them
						{
							for( i = 0; i <= 18; i++, sdr_index++ )
								fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_Sensor[ i ] );
						}
						else//only compact sensor need them
							{fprintf( fp, "\t\t.db 0x" ); sdr_index = write_multi_hex( sdr_id, sdr_index, 2 ); fprintf( fp, "\t\t\t\t/* Sensor Record Sharing*/\n" );}
						
						for( i = 15; i <= 18; i++, sdr_index++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
						
						if( 0x02 == SDR_Value[ sdr_id ][ 3 ] )//only compact sensor need them
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t/* Reserved3*/\n", SDR_Value[ sdr_id ][ sdr_index++ ] );
						
						
						for( ; i <= 19; i++, sdr_index++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Full_or_Compact_Sensor[ i ] );
						
						fprintf( fp, "\t\t.db 0x%02X + sizeof \"%s\"\t%s\n", SDR_Value[ sdr_id ][ sdr_index ] & 0xc0, SDR_Value[ sdr_id ] + middle_number_byte + 5, comment_Full_or_Compact_Sensor[ i ] );
						fprintf( fp, "\t\t.db \"%s\"\n\n", SDR_Value[ sdr_id ] + middle_number_byte + 5 );
						
						break;
					}
					
					case 0x08://Entity Association
					{
						for( i = 0; i <= 4; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Entity_Association[ i ] );
						
						fprintf( fp, "\n\t\t/* Record Body Bytes*/\n" );
						
						for( ; i <= 10; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Entity_Association[ i ] );
						
						break;
					}
					
					
					case 0x09://Device-relative Entity Assocation
					{
						for( i = 0; i <= 8; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Device_relative_Entity_Assocation[ i ] );
							
						fprintf( fp, "\n\t\t/* Record Body Bytes*/\n" );
						
						for( ; i <= 26; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Device_relative_Entity_Assocation[ i ] );
						
						break;
					}
					
					case 0x10://Generic Device Locator
					{
						for( i = 0; i <= 2; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Generic_Device_Locator[ i ] );
							
						fprintf( fp, "\n\t\t/* Record Body Bytes*/\n", SDR_Value[ sdr_id ][ sdr_index++ ] );
						
						for( ; i <= 10; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Generic_Device_Locator[ i ] );
						
						fprintf( fp, "\t\t.db 0x%02X + sizeof \"%s\"\t%s\n", SDR_Value[ sdr_id ][ sdr_index ] & 0xc0, SDR_Value[ sdr_id ] + middle_number_byte + 5, comment_Generic_Device_Locator[ i ] );
						fprintf( fp, "\t\t.db \"%s\"\n\n", SDR_Value[ sdr_id ] + middle_number_byte + 5 );
						
						break;
					}
					
					case 0x11://FRU Device Locator
					{
						for( i = 0; i <= 3; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_FRU_Device_Locator[ i ] );
						
						fprintf( fp, "\n\t\t/* Record Body Bytes*/\n" );
						
						for( ; i <= 9; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_FRU_Device_Locator[ i ] );
							
						fprintf( fp, "\t\t.db 0x%02X + sizeof \"%s\"\t%s\n", SDR_Value[ sdr_id ][ sdr_index ] & 0xc0, SDR_Value[ sdr_id ] + middle_number_byte + 5, comment_Generic_Device_Locator[ i ] );
						fprintf( fp, "\t\t.db \"%s\"\n\n", SDR_Value[ sdr_id ] + middle_number_byte + 5 );
						
						break;
					}
					
					case 0x12:
					{
						for( i = 0; i <= 1; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Management_Controller_Device_Locator[ i ] );
						
						fprintf( fp, "\n\n\t\t/* Record Body Bytes*/\n" );
						
						for( ; i <= 9; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Management_Controller_Device_Locator[ i ] );
						
						fprintf( fp, "\t\t.db 0x%02X + sizeof \"%s\"\t%s\n", SDR_Value[ sdr_id ][ sdr_index ] & 0xc0, SDR_Value[ sdr_id ] + middle_number_byte + 5, comment_Management_Controller_Device_Locator[ i ] );
						fprintf( fp, "\t\t.db \"%s\"\n\n", SDR_Value[ sdr_id ] + middle_number_byte + 5 );
						
						break;
					}
					
					case 0x13://Management Controller Confirmation
					{
						for( i = 0; i <= 2; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Management_Controller_Confirmation[ i ] );
						
						fprintf( fp, "\n\t\t/* Record Body Bytes*/\n" );
						
						for( ; i <= 5; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_Management_Controller_Confirmation[ i ] );
						
						//!!!!!!!!!!!!!!!!   I am not sure whether if this place can pass here
						fprintf( fp, "\t\t.dw 0x" ); sdr_index = write_multi_hex( sdr_id, sdr_index,  3 ); fprintf( fp, "\t\t\t\t%s\n", comment_Management_Controller_Confirmation[ i ] );
						fprintf( fp, "\t\t.dw 0x" ); sdr_index = write_multi_hex( sdr_id, sdr_index,  2 ); fprintf( fp, "\t\t\t\t%s\n", comment_Management_Controller_Confirmation[ i ] );
						fprintf( fp, "\t\t.dw 0x" ); sdr_index = write_multi_hex( sdr_id, sdr_index, 16 ); fprintf( fp, "\t\t\t\t%s\n", comment_Management_Controller_Confirmation[ i ] );
						
						break;
					}
					
					case 0x14://BMC Message Channel Info
					{
						fprintf( fp, "\n\t\t/* Record Body Bytes*/\n" );
						for( i = 0; i <= 7; sdr_index++, i++ )
							fprintf( fp, "\t\t.db 0x%02X\t\t\t\t%s\n", SDR_Value[ sdr_id ][ sdr_index ], comment_BMC_Message_Channel_Info[ i ] );
						
						break;
					}
					
					case 0xC0://OEM
					{
						//!!!!!!!!!!!!!!!!   I am not sure whether if this place can pass here
						fprintf( fp, "\t\t.dw 0x" ); sdr_index = write_multi_hex( sdr_id, sdr_index,  3 ); fprintf( fp, "\t\t\t\t%s\n", comment_OEM[ i ] );
						
						
						fprintf( fp, "\t\t/* Record Body Bytes*/\n" );
						
						//!!!!!!!!!!!!!!!!   I am not sure whether if this place can pass here
						for( i = 0; i <= SDR_Value[ sdr_id ][ 4 ] - 4; i++, sdr_index++ )// check specification how many "OEM Data" byte should you put in.
							fprintf( fp, "\t\t.db 0x%02X\t\t//\n", SDR_Value[ sdr_id ][ sdr_index ] );
						
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
		
		if( onlyonetime )
			break;//get out of fuckin infinite loop.
	}
	
	return 0;
}

