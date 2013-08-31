void Get_FRU_Inventory_Area_Info(unsigned char FRU_ID);
void Read_FRU(unsigned char FRU_ID,unsigned int x,unsigned char y);
void Write_FRU(unsigned char FRU_ID,unsigned int x,unsigned char y);

#define GET_WHOLE_LINE 100//get 1000 characters or till a newline
#define DEBUG

FILE *fp;
unsigned char string[ 128 ];
unsigned char FRU_Value[ 256 ];

unsigned char *comment_COMMON[] = {
					"// Common Header Format Version",//0
					"// Internal Use Area Offset in multiples of 8 bytes",//1
					"// Chassis Information Area Starting Offset in multiples of 8 bytes",//2
					"// Board Area Starting Offset in multiples of 8 bytes",//3
					"// Product Information Area Starting Offset in multiples of 8 bytes",//4
					"// MultiRecord Information Area Starting Offset in multiples of 8 bytes",//5
					"// PAD (1 byte)\0",//6
					"// Common Header Checksum (2's complement)\0"//7
				};


unsigned char *comment_CHASSIS[] = {
					"// Chassis info area format version",//0
					"// Chassis info area length in multiples of 8 bytes",//1
					"// Chassis type (Main server chassis)",//2
					"// Chassis part number type/length byte",//3
					"// Chassis serial number type/length byte",//4
					"// no more fields type/length byte"//5
				};

unsigned char *comment_BOARD[] = {	
					"// Board Area Format Version",//0
					"// Board Area Length (in multiples of 8 bytes)",//1
					"// Language Code (See section 15)",//2					"// Mfg. Date / Time",//4
					"// Mfg. Date / Time",//3
					"// Board Manufacturer type/length byte",//4
					"// Board Product Name type/length byte",//5
					"// Board Serial Number type/length byte",//6
					"// Board Part Number type/length byte",//7
					"// FRU File ID type/length byte",//8
					"// no more fields type/length byte"//9
				};

unsigned char *comment_PRODUCT[] = {	
					"// Product Area Format Version",//0
					"// Product Area Length (in multiples of 8 bytes)",//1
					"// Language Code (See section 15)",//2
					"// Manufacturer Name type/length byte",//3
					"// Product Name type/length byte",//4
					"// Product Part/Model Number type/length byte",//5
					"// Product Version type/length byte",//6
					"// Product Serial Number type/length byte",//7
					"// Asset Tag type/length byte",//8
					"// FRU File ID type/length byte",//9
					"// no more fields type/length byte"//10
				};
unsigned char *comment_common_MultiRecord[] = {
					"// Record Type ID",
					"// End of list/Version",
					"// Record Length",
					"// Record Checksum( zero checksum )",
					"// Header Checksum( zero checksum )"
				};

unsigned char *comment_Power_Supply_Information_MultiRecord[] = {
					"// Overall capacity( Watts ) ( LSB First )",
					"// Peak VA",
					"// Inrush current",
					"// Inrush interval in ms",
					"// Low end Input voltage range 1( 10mV, LSB First )",
					"// High end Input voltage range 1( 10mV, LSB First )",
					"// Low end Input voltage range 2( 10mV, LSB First, Zero if single range )",
					"// High end Input voltage range 2( 10mV, LSB First, Zero if single range )",
					"// Low end Input frequency range",
					"// High end Input frequency range",
					"// A/C dropout tolerance in ms",
					"// Binary flags",
					"// Peak Wattage",
					"// Combined Wattage",
					"// Predictive fail tachometer lower threshold( RPS )"
				};

unsigned char *comment_DC_Output_MultiRecord[] = {
					"// Output information",
					"// Norminal voltage( 10 mV )",
					"// Maximun negative voltage deviation( 10 mV )",
					"// Maximun positive voltage deviation( 10 mV )",
					"// Ripple and Noise pk-pk 10Hz to 30 MHz( 10 mV )",
					"// Minimum current draw( mA )",
					"// Maximum current draw( mA )"
				};

unsigned char *comment_DC_Load_MultiRecord[] = {
					"// Voltage required",
					"// Norminal voltage( 10 mV )",
					"// Spec'd minimum voltage( 10 mV )",
					"// Spec'd maximum voltage( 10 mV )",
					"// Spec'd Ripple and Noise pk-pk 10Hz to 30MHz( mV )",
					"// Minimum current load( mA )",
					"// Maximum current load( mA )"
				};

unsigned char *comment_Management_Access_Multirecord[] = {
					"// Sub-Record Type",
					"// String",
					"// Binary"
				};

unsigned char *comment_Base_Extended_Compatibility[] = {
					"// Manufacturer ID",
					"// Entity ID",
					"// Compatibility base",
					"// Code start",
					"// Code range mask"
				};

