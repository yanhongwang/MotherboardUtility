//documents  ftp://download.intel.com/design/servers/ipmi/fru
#include <stdio.h>//basic I/O
#include <string.h>

#include "KCS.c"
#include "fru.h"

/*

FRU Inventory Device Commands 
The following sections describe the FRU (Field Replaceable Unit) Inventory Device format and access commands. 
The FRU Inventory data contains information such as the serial number, part number, asset tag, and short descriptive 
string for the FRU. The contents of a FRU Inventory Record are specified in the Platform Management FRU 
Information Storage Definition. 
 
Get FRU Inventory Area Info Command 
Returns overall the size of the FRU Inventory Area in this device, in bytes. 


byte data field 
Request Data 1 FRU Device ID. FFh = reserved. 
Response Data 	1 Completion Code 
		2 FRU Inventory area size in bytes, LS Byte 
		3 FRU Inventory area size in bytes, MS Byte 
		4 [7:1] - reserved 
		  [0] 0b = Device is accessed by bytes, 1b = Device is accessed by words 

*/
void Get_FRU_Inventory_Area_Info(unsigned char FRU_ID)//get fru size and unit
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,1028h
	asm mov cs:[si],bx//put 1028 into BMCSendPackageBuffer
	asm push si
	asm add si,2
	asm mov al,FRU_ID
	asm mov cs:[si],al
	asm pop si
	asm mov cs:BMCPackageCount,3
	SendBMCCommand();
}

/*
Read FRU Data Command 
The command returns the specified data from the FRU Inventory Info area. This is effectively a ‘low level’ direct 
interface to a non-volatile storage area. This means that the interface does not interpret or check any semantics or 
formatting for the data being accessed. The offset used in this command is a ‘logical’ offset that may or may not 
correspond to the physical address used in device that provides the non-volatile storage. For example, FRU 
information could be kept in FLASH at physical address 1234h, however offset 0000h would still be used with this 
command to access the start of the FRU information. IPMI FRU device data (devices that are formatted per 
[FRU]) as well as processor and DIMM FRU data always starts from offset 0000h unless otherwise noted. 
Note that while the offsets are 16-bit values, allowing FRU devices of up to 64K words, the count to read, count 
returned, and count written fields are only 8-bits. This is in recognition of the limitations on the sizes of messages. 
For example, as of this writing, IPMB messages are limited to 32-bytes total. 

		byte	data field 
Request Data	1	FRU Device ID. FFh = reserved. 
		2	FRU Inventory Offset to read, LS Byte 
		3	FRU Inventory Offset to read, MS Byte 
			Offset is in bytes or words per device access type returned in the 
			Get FRU Inventory Area Info command. 
		4	Count to read --- count is ‘1’ based 
Response Data 	1	Completion code 
		2	Count returned --- count is ‘1’ based 
		3:2+N Requested data 
*/
void Read_FRU(unsigned char FRU_ID,unsigned int x,unsigned char y)//read fru from hardware
{
	asm mov si,offset BMCSendPackageBuffer
	asm mov di,offset BMCReturnPackageBuffer
	asm mov bx,1128h
	asm mov cs:[si],bx//put 1128h into BMCSendPackageBuffer
	asm push si
	asm add si,2
	asm mov al,FRU_ID
	asm mov cs:[si],al//put fru device id into BMCSendPackageBuffer
	asm inc si
	asm mov ax,x
	asm mov cs:[si],ax//put fru inventory offset into BMCSendPackageBuffer
	asm add si,2
	asm mov al,y//put "count to read" into BMCSendPackageBuffer
	asm mov cs:[si],al
	asm pop si
	asm mov cs:BMCPackageCount,6
	SendBMCCommand();
}


/*
Write FRU Data Command

The command writes the specified byte or word to the FRU Inventory Info area. This is a ‘low level’ direct 
interface to a non-volatile storage area. This means that the interface does not interpret or check any semantics or 
formatting for the data being written. The offset used in this command is a ‘logical’ offset that may or may not 
correspond to the physical address used in device that provides the non-volatile storage. For example, FRU 
information could be kept in FLASH at physical address 1234h, however offset 0000h would still be used with this 
command to access the start of the FRU information. IPMI FRU device data (devices that are formatted per 
[FRU]) as well as processor and DIMM FRU data always starts from offset 0000h unless otherwise noted. 
Updating the FRU Inventory Data is presumed to be a system level, privileged operation. There is no requirement 
for devices implementing this command to provide mechanisms for rolling back the FRU Inventory Area in the 
case of incomplete or incorrect writes. 

Table 28-4, Write FRU Data Command 
byte data field 

Request Data 
1 FRU Device ID. FFh = reserved. 
2 FRU Inventory Offset to write, LS Byte 
3 FRU Inventory Offset to write, MS Byte 
4:3+N Data to write 

Response Data 
1 Completion code 
  80h = write-protected offset 
2 Count written --- count is ‘1’ based 

*/
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
	asm mov al,FRU_ID//Request Data 1 FRU Device ID. FFh = reserved
	asm mov cs:[si],al
	asm inc si
	asm mov ax,x//Request Data 2,3 FRU Inventory Offset to write, LS and MS Byte
	asm mov cs:[si],ax
	asm add si,2
	for(i=0;i<y;i++)
	{
		j=FRU_Value[x+i];
		asm mov al,j//Request Data 4 Data to write
		asm mov cs:[si],al
		asm inc si
	}
	asm pop si
	asm mov al,y
	asm add al,5
	asm mov cs:BMCPackageCount,al
	SendBMCCommand();
}

/*
read fru digit, e.g. as following

00
03
f0
11

*/

// function fru_hex will grasp text line, extract the data we need until the desired limit is reached
void fru_hex( unsigned char fru_index )
{
	fgets( string, GET_WHOLE_LINE, fp );//get new lineß
	sscanf( string, "%x", &FRU_Value[ fru_index ] );
}

/*
read fru string, e.g as following
	
'N/A'
'Gigabyte'
'fuck'

*/
unsigned char fru_string( unsigned char fru_index )
{
	unsigned char i;
	unsigned char size;
	unsigned char pattern[ 255 ];
	
	fscanf( fp, "%s", pattern );
	for( i = 1; pattern[ i ] != '\''; i++, fru_index++ )
		FRU_Value[ fru_index ] = pattern[ i ];
	FRU_Value[ fru_index - i ] = ( 0xc0 | i ) - 1;
	
	return fru_index;
}

/*
add all number in their section , take 2'complement of their sum. e.g. as following

   01					// Common Header Format Version
   00					// Internal Use Area Offset in multiples of 8 bytes
   01					// Chassis Information Area Starting Offset in multiples of 8 bytes
   03					// Board Area Starting Offset in multiples of 8 bytes
   08					// Product Information Area Starting Offset in multiples of 8 bytes
   0f					// MultiRecord Information Area Starting Offset in multiples of 8 bytes
   00					// PAD (1 byte)
   e4					// Common Header Checksum (2's complement)

1 + 0 + 1 + 3 + 8 + 15 + 0 = 28

2's of 28 is 0xe4

*/
void calculate_checksum( unsigned char fru_index, unsigned char offset, unsigned char checksum_position )
{
	unsigned int checksum = 0;
	for( ; fru_index >= offset; fru_index-- )
		checksum += FRU_Value[ fru_index ];
	
	FRU_Value[ checksum_position ] = ~checksum + 1;
}

unsigned char write_string( unsigned char fru_index )
{
	unsigned char length;
	unsigned char string_end;
	unsigned char pattern[ 16 ];
	unsigned char i;
	
	length = FRU_Value[ fru_index ] & 0x0f;
	string_end = fru_index + length;
	
	for( fru_index++, i = 0; fru_index <= string_end; fru_index++, i++ )
		sprintf( pattern + i, "%c", FRU_Value[ fru_index ] ); 
	
	fprintf( fp, "   '%s'\n", pattern );
	return fru_index;
}

int main( int argc, char *argv[] )
{
	unsigned char *pattern;
	unsigned int i;
	unsigned int j;
	unsigned char fru_index;
	unsigned char FRU_Size[1][2];
	unsigned char Completion;
	unsigned int Size_temp;
	unsigned char FRU_Unit;
	unsigned char FRU_temp;
	unsigned int checksum;
	unsigned char filename[ 20 ];
	unsigned char option = 0;
	unsigned char onlyonetime = 0;
	unsigned char i_want_to_read = 1;
	unsigned char i_want_to_write = 1;
	unsigned char i_want_to_convert = 1;
	unsigned char remainder;
	unsigned char MultiRecord_index = 0;
	unsigned char *trim;
	
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
				i_want_to_convert = 0;// in case of somebody wants to bullshit program.
			}
			else if( !strncmp( argv[ i ], "-r=", 3 ) && i_want_to_read )//specify file read from eeprom
			{
				strcpy( filename, argv[ 1 ] + 3 );
				onlyonetime = 1;
				option = '1';
				i_want_to_write = 0;// in case of somebody wants to bullshit program.
				i_want_to_convert = 0;// in case of somebody wants to bullshit program.
			}
			else if( !strncmp( argv[ i ], "-c=", 3 ) && i_want_to_convert )//specify binary filename so that convert fru text file to binary
			{
				strcpy( filename, argv[ 1 ] + 3 );
				onlyonetime = 1;
				option = '2';
				i_want_to_write = 0;// in case of somebody wants to bullshit program.
				i_want_to_read = 0;// in case of somebody wants to bullshit program.
			}
			else if( !strncmp( argv[ i ], "-p1=", 4 ) )//specify control_code
				sscanf( argv[ i ] + 4, "%x", &control_code );
			else if( !strncmp( argv[ i ], "-p2=", 4 ) )//specify command port
				sscanf( argv[ i ] + 4, "%x", &command_port );
			else
			{
				fprintf( stdout, "usage: fru.exe -w/-r=filename -p1=data_port_num -p2=cmd_port_num.\n" );
				fprintf( stdout, "\t-p1=0x?? -p2=0x????\n" );
				return -1;
			}
			i++;
		}
	}
	
	AutoCheckPort();// Check 0x66 & 0xCA3 port
	
	if( KCS_Yes == 0 )
	{
		fprintf( stdout, "Not found KCS interface or KCS is fail!\n" );
		return -1;
	}
	
	Get_FRU_Inventory_Area_Info( 0 );
	asm mov di,Return_value
	asm add di,2
	asm mov al,cs:[di]
	asm mov Completion,al
	
	if( Completion == 0 )//Get_FRU_Inventory_Area_Info successful
	{
		asm inc di
		asm mov ax,cs:[di]
		asm mov Size_temp,ax
		FRU_Size[ 0 ][ 0 ] = Size_temp;
		asm add di,2
		asm mov al,cs:[di]
		asm mov FRU_Unit,al
		FRU_Size[ 0 ][ 1 ] = ( FRU_Unit + 1 ) * 4;
		FRU_Size[ 0 ][ 0 ] /= FRU_Size[ 0 ][ 1 ];
	}
	else
	{
		fprintf( fp, "Get_FRU_Inventory_Area_Info fail!\n" );
		return -1;
	}
	
	while( '3' != option )
	{
		memset( FRU_Value, '\0', sizeof( FRU_Value ) );
		
		if( !onlyonetime )
		{
			fprintf( stdout, " 1 : Read fru\n" );
			fprintf( stdout, " 2 : Write fru\n" );
			fprintf( stdout, " 3 : Quit\n" );
			fscanf( stdin, "%c", &option );
		}
		
		if( '2' == option )//read text file to write eeprom
		{
			if( !onlyonetime )
			{
				fprintf( stdout, "file name:\n" );
				fscanf( stdin, "%s", filename );
			}
			
			if( ( fp = fopen( filename, "r" ) ) == NULL )
			{
				fprintf( fp, "open error.\n" );
				return -1;
			}
			
			fseek( fp, 0, SEEK_SET );
			while( !feof( fp ) )
			{
				fgets( string, GET_WHOLE_LINE, fp );
				if( !strncmp( string, "_SEE_COMMON", 11 ) )
				{
					fscanf( fp, "%02X", &FRU_Value[ 0 ] );// Common Header Format Version
					break;
				}
			}
			
			fseek( fp, 0, SEEK_SET );
			while( !feof( fp ) )
			{
				fgets( string, GET_WHOLE_LINE, fp );
				//else if( !strncmp( string, "_SEE_INTERNAL", 13 ) )
				if( !strncmp( string, "_SEE_CHASSIS", 12 ) )
				{
					FRU_Value[ 2 ] = 0x01;
					
					fru_index = FRU_Value[ 2 ] * 8;
					
					fru_hex( fru_index++ );// Chassis info area format version
					
					fru_index++;//skip "Chassis info area length in multiples of 8 bytes" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					fru_hex( fru_index++ );// Chassis type (Main server chassis)
					
					fru_index++;//skip "Chassis part number type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					fru_index = fru_string( fru_index );//Chassis part number
					
					fru_index++;//skip "Chassis serial number type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					fru_index = fru_string( fru_index );//Chassis serial number
					
					FRU_Value[ fru_index ] = 0xc1;//0xc1 mean no more fields type/length byte
					
					i = 0;
					while( i * 8 < fru_index - 8 * FRU_Value[ 2 ] + 2 )					
						i++;
					FRU_Value[ FRU_Value[ 2 ] * 8 + 1 ] = i;//chassis size
					
					//calculate_checksum( unsigned char fru_index, unsigned char offset, unsigned char checksum_position )
					calculate_checksum( fru_index, FRU_Value[ 2 ] * 8, i * 8 + FRU_Value[ 2 ] * 8 - 1 );
					break;
				}
			}
			
			fseek( fp, 0, SEEK_SET );
			while( !feof( fp ) )
			{
				fgets( string, GET_WHOLE_LINE, fp );
				if( !strncmp( string, "_SEE_BOARD", 10 ) )
				{
					if( 0 == FRU_Value[ 2 ] )
						FRU_Value[ 3 ] = 0x01;
					else
						FRU_Value[ 3 ] =  FRU_Value[ 2 ] + FRU_Value[ ( FRU_Value[ 2 ] * 8 + 1 ) ];
					
					fru_index = FRU_Value[ 3 ] * 8;
					
					// Board Area Format Version
					fru_hex( fru_index++ );
					
					fru_index++;//skip Board Area Length (in multiples of 8 bytes)
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// Language Code (See section 15)
					fru_hex( fru_index++ );
					
					// Mfg. Date / Time
					fscanf( fp, "%02X", &FRU_Value[ fru_index++ ] );
					fscanf( fp, "%02X", &FRU_Value[ fru_index++ ] );
					fscanf( fp, "%02X", &FRU_Value[ fru_index++ ] );
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					fru_index++;//skip "Board Manufacturer type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					//Board Manufacturer type
					fru_index = fru_string( fru_index );
					
					fru_index++;//skip "Board Product Name type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					//Board Product Name type
					fru_index = fru_string( fru_index );
					
					fru_index++;//skip "Board Serial Number type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					//Board Serial Number type
					fru_index = fru_string( fru_index );
					
					fru_index++;//skip "Board Part Number type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					//Board Part Number type
					fru_index = fru_string( fru_index );
					
					fru_index++;//skip "FRU File ID type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					//FRU File ID type
					fru_index = fru_string( fru_index );
					
					FRU_Value[ fru_index ] = 0xc1;//0xc1 mean no more fields type/length byte
					
					i = 0;
					while( i * 8 < fru_index - 8 * FRU_Value[ 3 ] + 2 )					
						i++;
					FRU_Value[ FRU_Value[ 3 ] * 8 + 1 ] = i;//board size
					
					//calculate_checksum( unsigned char fru_index, unsigned char offset, unsigned char checksum_position )
					calculate_checksum( fru_index, FRU_Value[ 3 ] * 8, i * 8 + FRU_Value[ 3 ] * 8 - 1 );
					
					break;
				}
			}
			
			fseek( fp, 0, SEEK_SET );
			while( !feof( fp ) )
			{
				fgets( string, GET_WHOLE_LINE, fp );
				if( !strncmp( string, "_SEE_PRODUCT", 12 ) )
				{
					if( 0 != FRU_Value[ 3 ] )
						FRU_Value[ 4 ] =  FRU_Value[ 3 ] + FRU_Value[ ( FRU_Value[ 3 ] * 8 + 1 ) ];
					else if( 0 != FRU_Value[ 2 ] )	
						FRU_Value[ 4 ] =  FRU_Value[ 2 ] + FRU_Value[ ( FRU_Value[ 2 ] * 8 + 1 ) ];
					else
						FRU_Value[ 4 ] = 0x01;
					
					fru_index = FRU_Value[ 4 ] * 8;
					
					// Product Area Format Version
					fru_hex( fru_index++ );
					
					fru_index++;//skip Product Area Length (in multiples of 8 bytes)
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// Language Code (See section 15)
					fru_hex( fru_index++ );
					
					fru_index++;//skip "Manufacturer Name type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// Manufacturer Name type
					fru_index = fru_string( fru_index );
					
					fru_index++;//skip "Product Name type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// Product Name type/length byte
					fru_index = fru_string( fru_index );
	
					fru_index++;//skip "Product Part/Model Number type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// Product Part/Model Number
					fru_index = fru_string( fru_index );
					
					fru_index++;//skip "Product Version type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// Product Version
					fru_index = fru_string( fru_index );				
					
					fru_index++;//skip "Product Serial Number type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// Product Serial Number
					fru_index = fru_string( fru_index );
					
					fru_index++;//skip "Asset Tag type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// Asset Tag
					fru_index = fru_string( fru_index );
					
					fru_index++;//skip "FRU File ID type/length byte" value
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
					
					// FRU File ID type/length byte
					fru_index = fru_string( fru_index );
					
					FRU_Value[ fru_index ] = 0xc1;//0xc1 mean no more fields type/length byte
					
					i = 0;
					while( i * 8 < fru_index - 8 * FRU_Value[ 4 ] + 2 )					
						i++;
					FRU_Value[ FRU_Value[ 4 ] * 8 + 1 ] = i;//board size
					
					//calculate_checksum( unsigned char fru_index, unsigned char offset, unsigned char checksum_position )
					calculate_checksum( fru_index, FRU_Value[ 4 ] * 8, i * 8 + FRU_Value[ 4 ] * 8 - 1 );
					
					break;
				}
			}
			
			fseek( fp, 0, SEEK_SET );
			while( !feof( fp ) )
			{
				fgets( string, GET_WHOLE_LINE, fp );
				if( !strncmp( string, "_SEE_MultiRecord", 16 ) )
				{
					if( 0 != FRU_Value[ 4 ] )
						FRU_Value[ 5 ] = FRU_Value[ 4 ] + FRU_Value[ ( FRU_Value[ 4 ] * 8 + 1 ) ];
					else if( 0 != FRU_Value[ 3 ] )	
						FRU_Value[ 5 ] = FRU_Value[ 3 ] + FRU_Value[ ( FRU_Value[ 3 ] * 8 + 1 ) ];
					else if( 0 != FRU_Value[ 2 ] )
						FRU_Value[ 5 ] = FRU_Value[ 2 ] + FRU_Value[ ( FRU_Value[ 2 ] * 8 + 1 ) ];
					else
						FRU_Value[ 5 ] = 0x01;
					
					MultiRecord_index = 0;
					
					fru_index = FRU_Value[ 5 ] * 8;
					
					do
					{
						fru_hex( fru_index++ );// Record Type ID
						
						fru_hex( fru_index++ );// End of list/Version
						
						if( ( ( FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 1 ] ) & 0x80 ) == 0 )
							remainder = 1;// it mean still one or more suite record after this record
						else
							remainder = 0;// it mean no any suite record after this record
						
						fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning, escape "Record Length"
						fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning, escape "Record Checksum"
						fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning, espcae "Header Checksum"
						
						fru_index += 3;
						
						switch( FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 0 ] )//Record Type ID
						{
							case 0x00: // Power Supply Information
							{
								
								FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 2 ] = 24; //Record Length
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Overall capacity( Watts ) ( LSB )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Overall capacity( Watts ) ( MSB )
								fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Peak VA( LSB )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Peak VA( MSB )
								fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
								
								fru_hex( fru_index++ );// Inrush current
								fru_hex( fru_index++ );// Inrush interval in ms
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Low end Input voltage range 1( 10mV, LSB )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Low end Input voltage range 1( 10mV, MSB )
								fgets( string, GET_WHOLE_LINE, fp );
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// High end Input voltage range 1( 10mV, LSB )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// High end Input voltage range 1( 10mV, MSB )
								fgets( string, GET_WHOLE_LINE, fp );
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Low end Input voltage range 2( 10mV, LSB, Zero if single range )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Low end Input voltage range 2( 10mV, MSB, Zero if single range )
								fgets( string, GET_WHOLE_LINE, fp );
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// High end Input voltage range 2( 10mV, LSB, Zero if single range )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// High end Input voltage range 2( 10mV, MSB, Zero if single range )
								fgets( string, GET_WHOLE_LINE, fp );
								
								fru_hex( fru_index++ );// Low end Input frequency range
								fru_hex( fru_index++ );// High end Input frequency range
								fru_hex( fru_index++ );// A/C dropout tolerance in ms
								fru_hex( fru_index++ );// Binary flags
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Peak Wattage, LSB
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Peak Wattage, MSB
								fgets( string, GET_WHOLE_LINE, fp );
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Combined Wattage, LSB
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Combined Wattage
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Combined Wattage, MSB
								fgets( string, GET_WHOLE_LINE, fp );
								
								fru_hex( fru_index++ );// Predictive fail tachometer lower threshold( RPS )
								
								calculate_checksum( fru_index - 1, FRU_Value[ 5 ] * 8 + MultiRecord_index + 5, FRU_Value[ 5 ] * 8 + MultiRecord_index + 3 );// Record Checksum( zero checksum )
								
								calculate_checksum( FRU_Value[ 5 ] * 8 + MultiRecord_index + 3, FRU_Value[ 5 ] * 8 + MultiRecord_index + 0, FRU_Value[ 5 ] * 8 + MultiRecord_index + 4 );// Header Checksum( zero checksum )
								
								MultiRecord_index += ( 5 + 24 );// length of header and record data
								
								break;
							}
							
							case 0x01: // DC Output
							case 0x02: // DC Load
							{
								FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 2 ] = 13; // Record Length;
								
								fru_hex( fru_index++ );// 0x01: Output information; 0x02: Voltage required
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Norminal voltage( 10 mV ); 0x02: Norminal voltage( 10 mV )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Norminal voltage( 10 mV ); 0x02: Norminal voltage( 10 mV )
								fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Maximun negative voltage deviation( 10 mV ); 0x02: Spec'd minimum voltage( 10 mV )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Maximun negative voltage deviation( 10 mV ); 0x02: Spec'd minimum voltage( 10 mV )
								fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Maximun positive voltage deviation( 10 mV ); 0x02: Spec'd maximum voltage( 10 mV )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Maximun positive voltage deviation( 10 mV ); 0x02: Spec'd maximum voltage( 10 mV )
								fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Ripple and Noise pk-pk 10Hz to 30 MHz( 10 mV ); 0x02: Spec'd Ripple and Noise pk-pk 10Hz to 30MHz( mV )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Ripple and Noise pk-pk 10Hz to 30 MHz( 10 mV ); 0x02: Spec'd Ripple and Noise pk-pk 10Hz to 30MHz( mV )
								fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Minimum current draw( mA ); 0x02: Minimum current load( mA )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Minimum current draw( mA ); 0x02: Minimum current load( mA )
								fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Maximum current draw( mA ); 0x02: Maximum current load( mA )
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// 0x01: Maximum current draw( mA ); 0x02: Maximum current load( mA )
								fgets( string, GET_WHOLE_LINE, fp );//in order to go to newline, no other meaning
								
								calculate_checksum( fru_index - 1, FRU_Value[ 5 ] * 8 + MultiRecord_index + 5, FRU_Value[ 5 ] * 8 + MultiRecord_index + 3 );// Record Checksum( zero checksum )
								
								calculate_checksum( FRU_Value[ 5 ] * 8 + MultiRecord_index + 3, FRU_Value[ 5 ] * 8 + MultiRecord_index + 0, FRU_Value[ 5 ] * 8 + MultiRecord_index + 4 );// Header Checksum( zero checksum )
								
								MultiRecord_index += ( 5 + 13 );// length of header and record data
								
								break;
							}
							
							case 0x03: // Management Access Record
							{
								fru_hex( fru_index++ );// Sub-Record Type
								
								if( 0x07 == FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 5 ] )// Sub-record Type == 0x07
								{
									fru_hex( fru_index++ );
									FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 2 ] = 2;// Record Length;
								}
								else// Sub-record Type == 0x01 or 0x02 or 0x03 or 0x04 or 0x05 or 0x06
								{
									fgets( string, GET_WHOLE_LINE, fp );//get new line
									pattern = strchr( string, '\'' );//find the first double quote from string
									trim = strrchr( pattern, '\'' );//find the last double quote from model
									*trim = '\0';
									strncpy( &FRU_Value[ fru_index ], pattern + 1, strlen( pattern ) - 1 );//copy vailable amount of "ID String Type" to SDR_Value
									fru_index += strlen( pattern ) - 1;
									FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 2 ] = strlen( pattern ); // Record Length;
								}
								
								calculate_checksum( fru_index - 1, FRU_Value[ 5 ] * 8 + MultiRecord_index + 5, FRU_Value[ 5 ] * 8 + MultiRecord_index + 3 );// Record Checksum( zero checksum )
								
								calculate_checksum( FRU_Value[ 5 ] * 8 + MultiRecord_index + 3, FRU_Value[ 5 ] * 8 + MultiRecord_index + 0, FRU_Value[ 5 ] * 8 + MultiRecord_index + 4 );// Header Checksum( zero checksum )
								
								MultiRecord_index += ( 5 + strlen( pattern ) );// length of header and record data
								
								break;
							}
							
							case 0x04: // Base Compatibility Record, 
							case 0x05: // Extended Compatibility Record
							{
								FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 2 ] = 7; // Record Length;
								
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Manufacturer ID, LSB
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Manufacturer ID
								fscanf( fp, "%x", &FRU_Value[ fru_index++ ] );// Manufacturer ID, MSB
								fgets( string, GET_WHOLE_LINE, fp );
								
								fru_hex( fru_index++ );// Entity ID
								fru_hex( fru_index++ );// Compatibility base
								fru_hex( fru_index++ );// Code start
								fru_hex( fru_index++ );// Code range mask
								
								calculate_checksum( fru_index - 1, FRU_Value[ 5 ] * 8 + MultiRecord_index + 5, FRU_Value[ 5 ] * 8 + MultiRecord_index + 3 );// Record Checksum( zero checksum )
								
								calculate_checksum( FRU_Value[ 5 ] * 8 + MultiRecord_index + 3, FRU_Value[ 5 ] * 8 + MultiRecord_index + 0, FRU_Value[ 5 ] * 8 + MultiRecord_index + 4 );// Header Checksum( zero checksum )
								
								MultiRecord_index += ( 5 + 7 );// length of header and record data
								
								break;
							}
							
							default: // OEM Record Types
							{
								if( FRU_Value[ FRU_Value[ 5 ] * 8 + 0 ] >= 0xc0 )
									break;
							}
						}
					}while( remainder );
				}
			}
			
			fclose( fp );
			
			for( checksum = 0, i = 0; i <= 6; i++ )
				checksum += FRU_Value[ i ];
			FRU_Value[ i ] = ~checksum + 1;
			
			if( i_want_to_convert )//convert to binary
			{
				strncat( filename, "_binary", 7 );
				
				if( ( fp = fopen( filename, "w" ) ) == NULL )
				{
					fprintf( stdout, "open error\n" );
					return -1;
				}
				
				for( i = 0; i < FRU_Size[ 0 ][ 0 ] * FRU_Size[ 0 ][ 1 ]; i++ )
					fputc( FRU_Value[ i ], fp );
				
				fclose( fp );	
			}
			else// write to eeprom
			{
				for( i = 0; i <= FRU_Size[ 0 ][ 0 ] * FRU_Size[ 0 ][ 1 ]; i += FRU_Size[ 0 ][ 1 ] )
					Write_FRU( 0, i, 4 );
			}
#undef DEBUG
#ifdef DEBUG
			for( j = 0; j <= 15; j++ )
			{
				for( i = 0; i <= 15; i++ )
					fprintf( stdout, "%02X ", FRU_Value[ i + j * 16 ] );
				fprintf( stdout, "\n" );
			}
			getchar();
#endif
		}
		else if( '1' == option )//read eeprom to write text file
		{
			if( !onlyonetime )
			{
				fprintf( stdout, "file name:\n" );
				fscanf( stdin, "%s", filename );
			}
			
			for( j = 0; j <= FRU_Size[ 0 ][ 0 ] * FRU_Size[ 0 ][ 1 ]; j += FRU_Size[ 0 ][ 1 ] )
			{
				Read_FRU( 0, j, FRU_Size[ 0 ][ 0 ] );
				asm mov di,Return_value
				asm add di,2
				asm mov al,cs:[di]
				asm mov Completion,al
				
				if( Completion == 0 )
				{
					asm add di,2
					for( i = 0; i <= FRU_Size[ 0 ][ 1 ] - 1; i++ )
					{
						asm mov al,cs:[di]
						asm mov FRU_temp,al
						FRU_Value[ j + i ] = FRU_temp;
						asm inc di
					}
				}
			}
			
			if( ( fp = fopen( filename, "w" ) ) == NULL )
			{
				fprintf( stdout, "open error\n" );
				return -1;
			}
			
			fseek( fp, 0, SEEK_SET );
			
			fprintf( fp, "_LF_NAME\t'xxxx'\n" );
			fprintf( fp, "_LF_VERSION\t'1.011'\n" );
			fprintf( fp, "_LF_FMT_VER\t'1.0'\n" );
			fprintf( fp, "_SDR_VERSION\t'0100'\n" );
			fprintf( fp, "\n\n" );
			fprintf( fp, "_FRU {\n" );
			fprintf( fp, "_START_ADDR\t0000\n" );
			fprintf( fp, "_DATA_LEN\t0040\n" );
			fprintf( fp, "_NVS_TYPE\t'IMBDEVICE'\n" );
			fprintf( fp, "_DEV_BUS\tFF\n" );
			fprintf( fp, "_DEV_ADDRESS\t20\n" );
			fprintf( fp, "\n" );
			
			// COMMON is mandatory, it must be exist.
			fprintf( fp, "_SEE_COMMON\t\t\t\t// NVS Common Header area contents 00-07h (8 bytes)\n" );
			
			for( fru_index = 0; fru_index <= 7; fru_index++ )
				fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ], comment_COMMON[ fru_index ] );
			
			fprintf( fp, "\n" );
			
			if( FRU_Value[ 2 ] != 0 )// check whether if chassis exist
			{
				fprintf( fp, "_SEE_CHASSIS\t\t\t\t// NVS Chassis Info area contents 08h-40h  (56 bytes)\n" );
				
				for( i = 0, fru_index = FRU_Value[ 2 ] * 8; i <= 2; i++, fru_index++ )
					fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ] , comment_CHASSIS[ i ] );
				
				fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ] , comment_CHASSIS[ i++ ] );
				fru_index = write_string( fru_index );
				
				fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ] , comment_CHASSIS[ i++ ] );
				fru_index = write_string( fru_index );
				
				fprintf( fp, "   %02x\t\t\t\t\t%s\n\n", FRU_Value[ fru_index ] , comment_CHASSIS[ i++ ] );
			}
			
			if( FRU_Value[ 3 ] != 0 )// check whether if board exist
			{
				fprintf( fp, "_SEE_BOARD\t\t\t\t// NVS Board Info area contents 18h-40h  (40 bytes)\n" );
				
				for( i = 0, fru_index = FRU_Value[ 3 ] * 8; i <= 2; i++, fru_index++ )
					fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ] , comment_BOARD[ i ] );
				
				fprintf( fp, "   %02x %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], FRU_Value[ fru_index + 2 ], comment_BOARD[ i++ ] );
				
				for( fru_index += 3; i <= 8; i++ )
				{
					fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ], comment_BOARD[ i ] );
					fru_index = write_string( fru_index );
				}
				
				fprintf( fp, "   %02x\t\t\t\t\t%s\n\n", FRU_Value[ fru_index ] , comment_BOARD[ i ] );
			}
			
			if( FRU_Value[ 4 ] != 0 )// check whether if product exist
			{
				fprintf( fp,  "_SEE_PRODUCT\t\t\t\t// NVS Product Info area contents 40h-40h  (0 bytes)\n" );
				
				for( i = 0, fru_index = FRU_Value[ 4 ] * 8; i <= 2; i++, fru_index++ )
					fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ] , comment_PRODUCT[ i ] );
				
				for( ; i <= 9; i++ )
				{
					fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ], comment_PRODUCT[ i ] );
					fru_index = write_string( fru_index );
				}
				
				fprintf( fp, "   %02x\t\t\t\t\t%s\n\n", FRU_Value[ fru_index ], comment_PRODUCT[ i ] );
			}
			
			if( FRU_Value[ 5 ] != 0 )// check whether if MultiRecord exist
			{
				MultiRecord_index = 0;
				
				fprintf( fp,  "_SEE_MultiRecord\n" );
				
				do
				{
					for( i = 0, fru_index = FRU_Value[ 5 ] * 8 + MultiRecord_index; i <= 4; i++, fru_index++ )
						fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ] , comment_common_MultiRecord[ i ] );
					
					if( 0x00 == ( FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 1 ] & 0x80 ) )
						remainder = 1;
					else
						remainder = 0;
					
					switch( FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 0 ] )// Record Type ID
					{
						case 0x00://Power Supply Information
						{
							i = 0;
							fprintf( fp, "   %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], comment_Power_Supply_Information_MultiRecord[ i++ ] );// Overall capacity( Watts ) ( LSB First )
							fru_index += 2;
							fprintf( fp, "   %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], comment_Power_Supply_Information_MultiRecord[ i++ ] );// Peak VA
							fru_index += 2;
							fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index++ ] , comment_Power_Supply_Information_MultiRecord[ i++ ] );// Inrush current
							fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index++ ] , comment_Power_Supply_Information_MultiRecord[ i++ ] );// Inrush interval in ms
							
							for( ;i <= 7;i++, fru_index += 2 )
								fprintf( fp, "   %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], comment_Power_Supply_Information_MultiRecord[ i ] );// Overall capacity( Watts ) ( LSB First )
							
							for( ;i <= 11; i++, fru_index++ )
								fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ], comment_Power_Supply_Information_MultiRecord[ i ] );
							
							fprintf( fp, "   %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], comment_Power_Supply_Information_MultiRecord[ i++ ] );
							fru_index += 2;
							fprintf( fp, "   %02x %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], FRU_Value[ fru_index + 2 ],comment_Power_Supply_Information_MultiRecord[ i++ ] );
							fru_index += 3;
							
							fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index++ ], comment_Power_Supply_Information_MultiRecord[ i ] );
								
							MultiRecord_index += ( 5 + 24 );
							
							break;
						}
						
						case 0x01://DC Output
						{
							i = 0;
							fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index++ ], comment_DC_Output_MultiRecord[ i++ ] );// Output information
							
							for( ;i <= 6;i++, fru_index += 2 )
								fprintf( fp, "   %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], comment_DC_Output_MultiRecord[ i ] );
							
							MultiRecord_index += ( 5 + 13 );
							
							break;
						}
						
						case 0x02:// DC Load
						{
							i = 0;
							fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index++ ], comment_DC_Load_MultiRecord[ i++ ] );// Voltage required
							
							for( ;i <= 6;i++, fru_index += 2 )
								fprintf( fp, "   %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], comment_DC_Load_MultiRecord[ i ] );
							
							MultiRecord_index += ( 5 + 13 );
							
							break;
						}
						
						case 0x03://Management Access Record
						{
							fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index++ ], comment_Management_Access_Multirecord[ 0 ] );
							
							if( 0x07 == FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 5 ] )
							{
								fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index++ ], comment_Management_Access_Multirecord[ 2 ] );
								MultiRecord_index += ( 5 + 2 );
							}
							else
							{
								memset( string, '\0', sizeof( string ) );// make end of string '\0'
								strncpy( string, &FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 6 ], FRU_Value[ FRU_Value[ 5 ] * 8 + MultiRecord_index + 2 ] - 1 );
								fprintf( fp, "   '%s'\t\t\t%s\n", string, comment_Management_Access_Multirecord[ 1 ] );
								
								fru_index += strlen( string );
								MultiRecord_index += ( 5 + strlen( string ) + 1 );
							}
							
							break;
						}
						
						case 0x04: // Base Compatibility Record
						case 0x05: // Extended Compatibility Record
						{
							i = 0;
							
							fprintf( fp, "   %02x %02x %02x\t\t\t\t%s\n", FRU_Value[ fru_index ], FRU_Value[ fru_index + 1 ], FRU_Value[ fru_index + 2 ], comment_Base_Extended_Compatibility[ i++ ] );
							fru_index += 3;
							
							for( ;i <= 4; i++, fru_index++ )
								fprintf( fp, "   %02x\t\t\t\t\t%s\n", FRU_Value[ fru_index ], comment_Base_Extended_Compatibility[ i ] );
							
							MultiRecord_index += ( 5 + 7 );
							
							break;
						}
					}
				}while( remainder );
			}
			
			fprintf( fp, "}\n" );
			fclose( fp );
#undef DEBUG
#ifdef DEBUG
			for( j = 0; j <= 15; j++ )
			{
				for( i = 0; i <= 15; i++ )
					fprintf( stdout, "%02X ", FRU_Value[ i + j * 16 ] );
				fprintf( stdout, "\n" );
			}
			getchar();
#endif
		}
		if( onlyonetime )
			break;//get out of fuckin infinite loop.
	}
	
	return 0;
}
