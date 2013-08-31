.addr16
		.dw 0x32				/* Record ID*/
		.db 0x51				/* SDR Version*/
		.db 0x12				/* Record Type*/
		.db 11 + sizeof "BMC/SDR13xxhx"		/* Record Length = 11 + string length */

		/* Record Key Bytes*/
		.db 0x20				/* Sensor Owner ID*/
	
		/* Record Body Bytes*/
		.db 0x88				/* power state notification*/
		.db 0xBF				/* Entity Instance*/
		.db 0					/* RESERVED*/
		.db 0					/* RESERVED*/
		.db 0					/* RESERVED*/
		.db 0					/* RESERVED*/
		.db 0x00				/* Entity ID*/
		.db 0x00				/* Entity Instance*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "BMC/SDR13xxhx"	/* ID String Type / Length Code*/
		.db "BMC/SDR13xxhx"
		


		.dw 0x01				/* Record ID*/
		.db 0x51				/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db 43 + sizeof "Baseboard Temp1"	/* Record Length = 43 + string length */

		/* Record Key Bytes*/

		.db 0x20				/* Sensor Owner ID*/
		.db 0					/* Sensor Owner LUN*/
		.db 0x00				/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x3					/* Entity ID*/
		.db 0x1					/* Entity Instance*/
		.db 0x7F				/* Sensor Initialization*/
		.db 0x68				/* Sensor Capabilities*/
		.db 0x01				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285				/* Lower Threshold Reading Mask*/
		.dw 0x0285				/* Upper Threshold Reading Mask*/
		.dw 0x1B1B				/* Settable/Readable Threshold Mask*/
		.db 0x80				/* Sensor Units 1*/
		.db 0x01				/* Sensor Units 2 - Base Unit*/
		.db 0x00				/* Sensor Units 3 - Modifier Unit*/
		.db 0x00				/* Linearization*/
		.db 0x01				/* M*/
		.db 0x00				/* M, Tolerance*/
		.db 0x00				/* B*/
		.db 0x00				/* B, Accuracy*/
		.db 0x00				/* Accuracy, Accuracy exponent*/
		.db 0x00				/* R exponent, B exponent*/
		.db 0x00				/* Analog Characteristics Flags*/
		.db 0x23				/* Nominal Reading*/
		.db 0x00				/* Normal Maximum*/
		.db 0x00				/* Normal Minimum*/
		.db 0x7F				/* Sensor Maximum Reading*/
		.db 0x80				/* Sensor Minimum Reading*/
		.db 0x7F				/* Upper Non-Recoverable Threshold*/
		.db 0x3C				/* Upper Critical Threshold*/
		.db 0x3B				/* Upper Non-Critical Threshold*/
		.db 0x80				/* Lower Non-Recoverable Threshold*/
		.db 0x00				/* Lower Critical Threshold*/
		.db 0x01				/* Lower Non-Critical Threshold*/
		.db 0x3					/* Positive - going threshold Hysteresis value*/
		.db 0x3					/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "Baseboard Temp1"	/* ID String Type / Length Code*/
		.db "Baseboard Temp1"	
		

		.dw 0x02			/* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db 43 + sizeof "Processor 1 Temp"	/* Record Length = 43 + string length */

		/* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0				/* Sensor Owner LUN*/
		.db 0x01		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x3			/* Entity ID*/
		.db 0x1			/* Entity Instance*/
		.db 0x7F			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x01				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x80		/* Sensor Units 1*/
		.db 0x01		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x01				/* M*/
		.db 0x00		/* M, Tolerance*/
		.db 0x00				/* B*/
		.db 0x00			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0x00		/* R exponent, B exponent*/
		.db 0x00				/* Analog Characteristics Flags*/
		.db 0x23		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0x7F		/* Sensor Maximum Reading*/
		.db 0x80		/* Sensor Minimum Reading*/
		.db 0x7F				/* Upper Non-Recoverable Threshold*/
		.db 0x47				/* Upper Critical Threshold*/
		.db 0x44				/* Upper Non-Critical Threshold*/
		.db 0x80				/* Lower Non-Recoverable Threshold*/
		.db	0x00				/* Lower Critical Threshold*/
		.db 0x01				/* Lower Non-Critical Threshold*/
		.db 0x3			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "Processor 1 Temp"	/* ID String Type / Length Code*/
		.db "Processor 1 Temp"	
		

		.dw	0x03			/* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "Processor 2 Temp"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0				/* Sensor Owner LUN*/
		.db 0x02		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x3			/* Entity ID*/
		.db 0x1			/* Entity Instance*/
		.db 0x7F			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x01				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x80		/* Sensor Units 1*/
		.db 0x01		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x01				/* M*/
		.db 0x00		/* M, Tolerance*/
		.db 0x00				/* B*/
		.db 0x00			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0x00		/* R exponent, B exponent*/
		.db 0x00				/* Analog Characteristics Flags*/
		.db 0x23		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0x7F		/* Sensor Maximum Reading*/
		.db 0x80		/* Sensor Minimum Reading*/
		.db 0x7F				/* Upper Non-Recoverable Threshold*/
		.db 0x47				/* Upper Critical Threshold*/
		.db 0x44				/* Upper Non-Critical Threshold*/
		.db 0x80				/* Lower Non-Recoverable Threshold*/
		.db	0x00				/* Lower Critical Threshold*/
		.db 0x01				/* Lower Non-Critical Threshold*/
		.db 0x3			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "Processor 2 Temp"	/* ID String Type / Length Code*/
		.db "Processor 2 Temp"	
		

        .dw 0x04           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "Vcore"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x03		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x31				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0x43				/* B*/
		.db 0x00			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xC2		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0xA0		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0xB0				/* Upper Critical Threshold*/
		.db 0xAA				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0x84				/* Lower Critical Threshold*/
		.db 0x8A				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "Vcore"	/* ID String Type / Length Code*/
		.db "Vcore"	
		

        .dw 0x05           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "Vcc2.5"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x04		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x10				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0xF7				/* B*/
		.db 0xC0			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xD1		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0xA2		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0xB5				/* Upper Critical Threshold*/
		.db 0xB2				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0x8F				/* Lower Critical Threshold*/
		.db 0x92				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "Vcc2.5"	/* ID String Type / Length Code*/
		.db "Vcc2.5"	
		

        .dw 0x06           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "Vcc3.3"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x05		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x10				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0xF9				/* B*/
		.db 0xC0			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xD1		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0xD3		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0xE8				/* Upper Critical Threshold*/
		.db 0xE4				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0xBE				/* Lower Critical Threshold*/
		.db 0xC2				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "Vcc3.3"	/* ID String Type / Length Code*/
		.db "Vcc3.3"	
		

        .dw 0x07           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "Vcc5"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x06		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x1B				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0xF9				/* B*/
		.db 0xC0			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xD1		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0xBC		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0xCF				/* Upper Critical Threshold*/
		.db 0xCB				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0xA9				/* Lower Critical Threshold*/
		.db 0xAC				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "Vcc5"	/* ID String Type / Length Code*/
		.db "Vcc5"	
		

        .dw 0x08           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "+12V"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x07		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x40				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0xE4				/* B*/
		.db 0xC0			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xD1		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0xBD		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0xD0				/* Upper Critical Threshold*/
		.db 0xCB				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0xAA				/* Lower Critical Threshold*/
		.db 0xAE				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "+12V"	/* ID String Type / Length Code*/
		.db "+12V"	
		

        .dw 0x09           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "VBAT"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x08		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x10				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0xF9				/* B*/
		.db 0xC0			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xD1		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0xC0		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0xE6				/* Upper Critical Threshold*/
		.db 0xDC				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0xA9				/* Lower Critical Threshold*/
		.db 0xAD				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "VBAT"	/* ID String Type / Length Code*/
		.db "VBAT"	
		

        .dw 0x0A           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "5VSB"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x09		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x1B				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0xF9				/* B*/
		.db 0xC0			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xD1		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0xBC		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0xD2				/* Upper Critical Threshold*/
		.db 0xCE				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0xA5				/* Lower Critical Threshold*/
		.db 0xA8				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "5VSB"	/* ID String Type / Length Code*/
		.db "5VSB"	
		

        .dw 0x0B           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "Vcc1.8"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x0A		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x10				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0xF9				/* B*/
		.db 0xC0			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xD1		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0x75		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0x7D				/* Upper Critical Threshold*/
		.db 0x7A				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0x6D				/* Lower Critical Threshold*/
		.db 0x6F				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "Vcc1.8"	/* ID String Type / Length Code*/
		.db "Vcc1.8"	
		

        .dw 0x0C           /* Record ID*/
		.db 0x51			/* SDR Version*/
		.db 0x01				/* Record Type*/
		.db	43 + sizeof "VTTDDR"	/* Record Length = 43 + string length */

	   /* Record Key Bytes*/

		.db 0x20			/* Sensor Owner ID*/
		.db 0x00				/* Sensor Owner LUN*/
		.db 0x0B		/* Sensor Number*/
	
		/* Record Body Bytes*/
		.db 0x07			/* Entity ID*/
		.db 0x01			/* Entity Instance*/
		.db 0x7f			/* Sensor Initialization*/
		.db 0x68			/* Sensor Capabilities*/
		.db 0x02				/* Sensor Type*/
		.db 0x01				/* Event / Reading Type*/
		.dw 0x0285		/* Lower Threshold Reading Mask*/
		.dw 0x0285		/* Upper Threshold Reading Mask*/
		.dw 0x1B1B		/* Settable/Readable Threshold Mask*/
		.db 0x00		/* Sensor Units 1*/
		.db 0x04		/* Sensor Units 2 - Base Unit*/
		.db 0x00		/* Sensor Units 3 - Modifier Unit*/
		.db 0x00	/* Linearization*/
		.db 0x10				/* M*/
		.db 0		/* M, Tolerance*/
		.db 0xF9				/* B*/
		.db 0xC0			/* B, Accuracy*/
		.db 0x00		/* Accuracy, Accuracy exponent*/
		.db 0xD1		/* R exponent, B exponent*/
		.db 0				/* Analog Characteristics Flags*/
		.db 0x53		/* Nominal Reading*/
		.db 0x00	/* Normal Maximum*/
		.db 0x00	/* Normal Minimum*/
		.db 0xFF		/* Sensor Maximum Reading*/
		.db 0x00		/* Sensor Minimum Reading*/
		.db 0xFF				/* Upper Non-Recoverable Threshold*/
		.db 0x58				/* Upper Critical Threshold*/
		.db 0x56				/* Upper Non-Critical Threshold*/
		.db 0x00				/* Lower Non-Recoverable Threshold*/
		.db	0x4D				/* Lower Critical Threshold*/
		.db 0x4F				/* Lower Non-Critical Threshold*/
		.db 0x03			/* Positive - going threshold Hysteresis value*/
		.db 0x3			/* Negative - going threshold Hysteresis value*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* Reserved*/
		.db 0x0					/* OEM*/
		.db 0xc0 + sizeof "VTTDDR"	/* ID String Type / Length Code*/
		.db "VTTDDR"	
		

			.dw	0x0E			/* Record ID*/
			.db 0x51			/* SDR Version*/
			.db	0x01				/* Record Type*/
			.db	43 + sizeof "Fan 1"/* Record Length = 43 + length */
		/* Record Key Bytes*/
			.db 0x20			/* Sensor Owner ID*/
			.db 0x00				/* Sensor Owner LUN*/
			.db 0x2B			/* Sensor Number*/

		/* Record Body Bytes*/
			.db 0x1D			/* Entity ID*/
			.db 0x01			/* Entity Instance*/
			.db 0x7F			/* Sensor Initialization*/
			.db 0x68			/* Sensor Capabilities*/
			.db 0x04				/* Sensor Type*/
			.db 0x01				/* Event / Reading Type*/
			.dw 0x0004		/* Lower Threshold Reading Mask*/
			.dw 0x0004		/* Upper Threshold Reading Mask*/
			.dw 0x0202		/* Settable/Readable Threshold Mask*/
			.db 0x00		/* Sensor Units 1*/
			.db 0x12		/* Sensor Units 2 - Base Unit*/
			.db 0x00		/* Sensor Units 3 - Modifier Unit*/
			.db 0x00	/* Linearization*/
			.db 0x01				/* M*/
			.db 0x01		/* M, Tolerance*/
			.db 0x00				/* B*/
			.db 0x00			/* B, Accuracy*/
			.db 0x00		/* Accuracy, Accuracy exponent*/
			.db 0x20		/* R exponent, B exponent*/
			.db 0x00				/* Analog Characteristics Flags*/
			.db 0x38		/* Nominal Reading*/
			.db 0x00	/* Normal Maximum*/
			.db 0x00	/* Normal Minimum*/
			.db 0xFF		/* Sensor Maximum Reading*/
			.db 0x00		/* Sensor Minimum Reading*/
			.db 0xFF				/* Upper Non-Recoverable Threshold*/
			.db 0xFF				/* Upper Critical Threshold*/
			.db 0xFF				/* Upper Non-Critical Threshold*/
			.db 0x00				/* Lower Non-Recoverable Threshold*/
			.db 0x20				/* Lower Critical Threshold*/
			.db 0x28				/* Lower Non-Critical Threshold*/
			.db 0x05			/* Positive - going threshold Hysteresis value*/
			.db 0x00			/* Negative - going threshold Hysteresis value*/
			.db 0x0					/* Reserved*/
			.db 0x0					/* Reserved*/
			.db 0x0						/* OEM*/
			.db 0xc0 + sizeof "Fan 1"	/* ID String Type / Length Code*/
			.db "Fan 1"
			

			.dw	0x0F			/* Record ID*/
			.db 0x51			/* SDR Version*/
			.db	0x01				/* Record Type*/
			.db	43 + sizeof "Fan 2"/* Record Length = 43 + length */
		/* Record Key Bytes*/
			.db 0x20			/* Sensor Owner ID*/
			.db 0x00				/* Sensor Owner LUN*/
			.db 0x2C			/* Sensor Number*/

		/* Record Body Bytes*/
			.db 0x1D			/* Entity ID*/
			.db 0x02			/* Entity Instance*/
			.db 0x7F			/* Sensor Initialization*/
			.db 0x68			/* Sensor Capabilities*/
			.db 0x04				/* Sensor Type*/
			.db 0x01				/* Event / Reading Type*/
			.dw 0x0004		/* Lower Threshold Reading Mask*/
			.dw 0x0004		/* Upper Threshold Reading Mask*/
			.dw 0x0202		/* Settable/Readable Threshold Mask*/
			.db 0x00		/* Sensor Units 1*/
			.db 0x12		/* Sensor Units 2 - Base Unit*/
			.db 0x00		/* Sensor Units 3 - Modifier Unit*/
			.db 0x00	/* Linearization*/
			.db 0x01				/* M*/
			.db 0x01		/* M, Tolerance*/
			.db 0x00				/* B*/
			.db 0x00			/* B, Accuracy*/
			.db 0x00		/* Accuracy, Accuracy exponent*/
			.db 0x20		/* R exponent, B exponent*/
			.db 0x00				/* Analog Characteristics Flags*/
			.db 0x38		/* Nominal Reading*/
			.db 0x00	/* Normal Maximum*/
			.db 0x00	/* Normal Minimum*/
			.db 0xFF		/* Sensor Maximum Reading*/
			.db 0x00		/* Sensor Minimum Reading*/
			.db 0xFF				/* Upper Non-Recoverable Threshold*/
			.db 0xFF				/* Upper Critical Threshold*/
			.db 0xFF				/* Upper Non-Critical Threshold*/
			.db 0x00				/* Lower Non-Recoverable Threshold*/
			.db 0x20				/* Lower Critical Threshold*/
			.db 0x28				/* Lower Non-Critical Threshold*/
			.db 0x05			/* Positive - going threshold Hysteresis value*/
			.db 0x00			/* Negative - going threshold Hysteresis value*/
			.db 0x0					/* Reserved*/
			.db 0x0					/* Reserved*/
			.db 0x0						/* OEM*/
			.db 0xc0 + sizeof "Fan 2"	/* ID String Type / Length Code*/
			.db "Fan 2"
			

			.dw	0x10			/* Record ID*/
			.db 0x51			/* SDR Version*/
			.db	0x01				/* Record Type*/
			.db	43 + sizeof "Fan 3"/* Record Length = 43 + length */
		/* Record Key Bytes*/
			.db 0x20			/* Sensor Owner ID*/
			.db 0x00				/* Sensor Owner LUN*/
			.db 0x2D			/* Sensor Number*/

		/* Record Body Bytes*/
			.db 0x1D			/* Entity ID*/
			.db 0x03			/* Entity Instance*/
			.db 0x7F			/* Sensor Initialization*/
			.db 0x68			/* Sensor Capabilities*/
			.db 0x04				/* Sensor Type*/
			.db 0x01				/* Event / Reading Type*/
			.dw 0x0004		/* Lower Threshold Reading Mask*/
			.dw 0x0004		/* Upper Threshold Reading Mask*/
			.dw 0x0202		/* Settable/Readable Threshold Mask*/
			.db 0x00		/* Sensor Units 1*/
			.db 0x12		/* Sensor Units 2 - Base Unit*/
			.db 0x00		/* Sensor Units 3 - Modifier Unit*/
			.db 0x00	/* Linearization*/
			.db 0x01				/* M*/
			.db 0x01		/* M, Tolerance*/
			.db 0x00				/* B*/
			.db 0x00			/* B, Accuracy*/
			.db 0x00		/* Accuracy, Accuracy exponent*/
			.db 0x20		/* R exponent, B exponent*/
			.db 0x00				/* Analog Characteristics Flags*/
			.db 0x38		/* Nominal Reading*/
			.db 0x00	/* Normal Maximum*/
			.db 0x00	/* Normal Minimum*/
			.db 0xFF		/* Sensor Maximum Reading*/
			.db 0x00		/* Sensor Minimum Reading*/
			.db 0xFF				/* Upper Non-Recoverable Threshold*/
			.db 0xFF				/* Upper Critical Threshold*/
			.db 0xFF				/* Upper Non-Critical Threshold*/
			.db 0x00				/* Lower Non-Recoverable Threshold*/
			.db 0x20				/* Lower Critical Threshold*/
			.db 0x28				/* Lower Non-Critical Threshold*/
			.db 0x05			/* Positive - going threshold Hysteresis value*/
			.db 0x00			/* Negative - going threshold Hysteresis value*/
			.db 0x0					/* Reserved*/
			.db 0x0					/* Reserved*/
			.db 0x0						/* OEM*/
			.db 0xc0 + sizeof "Fan 3"	/* ID String Type / Length Code*/
			.db "Fan 3"
			

			.dw	0x11			/* Record ID*/
			.db 0x51			/* SDR Version*/
			.db	0x01				/* Record Type*/
			.db	43 + sizeof "Fan 4"/* Record Length = 43 + length */
		/* Record Key Bytes*/
			.db 0x20			/* Sensor Owner ID*/
			.db 0x00				/* Sensor Owner LUN*/
			.db 0x2E			/* Sensor Number*/

		/* Record Body Bytes*/
			.db 0x1D			/* Entity ID*/
			.db 0x04			/* Entity Instance*/
			.db 0x7F			/* Sensor Initialization*/
			.db 0x68			/* Sensor Capabilities*/
			.db 0x04				/* Sensor Type*/
			.db 0x01				/* Event / Reading Type*/
			.dw 0x0004		/* Lower Threshold Reading Mask*/
			.dw 0x0004		/* Upper Threshold Reading Mask*/
			.dw 0x0202		/* Settable/Readable Threshold Mask*/
			.db 0x00		/* Sensor Units 1*/
			.db 0x12		/* Sensor Units 2 - Base Unit*/
			.db 0x00		/* Sensor Units 3 - Modifier Unit*/
			.db 0x00	/* Linearization*/
			.db 0x01				/* M*/
			.db 0x01		/* M, Tolerance*/
			.db 0x00				/* B*/
			.db 0x00			/* B, Accuracy*/
			.db 0x00		/* Accuracy, Accuracy exponent*/
			.db 0x20		/* R exponent, B exponent*/
			.db 0x00				/* Analog Characteristics Flags*/
			.db 0x38		/* Nominal Reading*/
			.db 0x00	/* Normal Maximum*/
			.db 0x00	/* Normal Minimum*/
			.db 0xFF		/* Sensor Maximum Reading*/
			.db 0x00		/* Sensor Minimum Reading*/
			.db 0xFF				/* Upper Non-Recoverable Threshold*/
			.db 0xFF				/* Upper Critical Threshold*/
			.db 0xFF				/* Upper Non-Critical Threshold*/
			.db 0x00				/* Lower Non-Recoverable Threshold*/
			.db 0x20				/* Lower Critical Threshold*/
			.db 0x28				/* Lower Non-Critical Threshold*/
			.db 0x05			/* Positive - going threshold Hysteresis value*/
			.db 0x00			/* Negative - going threshold Hysteresis value*/
			.db 0x0					/* Reserved*/
			.db 0x0					/* Reserved*/
			.db 0x0						/* OEM*/
			.db 0xc0 + sizeof "Fan 4"	/* ID String Type / Length Code*/
			.db "Fan 4"
			

			.dw	0x12			/* Record ID*/
			.db 0x51			/* SDR Version*/
			.db	0x01				/* Record Type*/
			.db	43 + sizeof "Fan 5"/* Record Length = 43 + length */
		/* Record Key Bytes*/
			.db 0x20			/* Sensor Owner ID*/
			.db 0x00				/* Sensor Owner LUN*/
			.db 0x2F			/* Sensor Number*/

		/* Record Body Bytes*/
			.db 0x1D			/* Entity ID*/
			.db 0x04			/* Entity Instance*/
			.db 0x7F			/* Sensor Initialization*/
			.db 0x68			/* Sensor Capabilities*/
			.db 0x04				/* Sensor Type*/
			.db 0x01				/* Event / Reading Type*/
			.dw 0x0004		/* Lower Threshold Reading Mask*/
			.dw 0x0004		/* Upper Threshold Reading Mask*/
			.dw 0x0202		/* Settable/Readable Threshold Mask*/
			.db 0x00		/* Sensor Units 1*/
			.db 0x12		/* Sensor Units 2 - Base Unit*/
			.db 0x00		/* Sensor Units 3 - Modifier Unit*/
			.db 0x00	/* Linearization*/
			.db 0x01				/* M*/
			.db 0x01		/* M, Tolerance*/
			.db 0x00				/* B*/
			.db 0x00			/* B, Accuracy*/
			.db 0x00		/* Accuracy, Accuracy exponent*/
			.db 0x20		/* R exponent, B exponent*/
			.db 0x00				/* Analog Characteristics Flags*/
			.db 0x38		/* Nominal Reading*/
			.db 0x00	/* Normal Maximum*/
			.db 0x00	/* Normal Minimum*/
			.db 0xFF		/* Sensor Maximum Reading*/
			.db 0x00		/* Sensor Minimum Reading*/
			.db 0xFF				/* Upper Non-Recoverable Threshold*/
			.db 0xFF				/* Upper Critical Threshold*/
			.db 0xFF				/* Upper Non-Critical Threshold*/
			.db 0x00				/* Lower Non-Recoverable Threshold*/
			.db 0x20				/* Lower Critical Threshold*/
			.db 0x28				/* Lower Non-Critical Threshold*/
			.db 0x05			/* Positive - going threshold Hysteresis value*/
			.db 0x00			/* Negative - going threshold Hysteresis value*/
			.db 0x0					/* Reserved*/
			.db 0x0					/* Reserved*/
			.db 0x0						/* OEM*/
			.db 0xc0 + sizeof "Fan 5"	/* ID String Type / Length Code*/
			.db "Fan 5"
			

			.dw	0x13			/* Record ID*/
			.db 0x51			/* SDR Version*/
			.db	0x01				/* Record Type*/
			.db	43 + sizeof "Fan 6"/* Record Length = 43 + length */
		/* Record Key Bytes*/
			.db 0x20			/* Sensor Owner ID*/
			.db 0x00				/* Sensor Owner LUN*/
			.db 0x30			/* Sensor Number*/

		/* Record Body Bytes*/
			.db 0x1D			/* Entity ID*/
			.db 0x04			/* Entity Instance*/
			.db 0x7F			/* Sensor Initialization*/
			.db 0x68			/* Sensor Capabilities*/
			.db 0x04				/* Sensor Type*/
			.db 0x01				/* Event / Reading Type*/
			.dw 0x0004		/* Lower Threshold Reading Mask*/
			.dw 0x0004		/* Upper Threshold Reading Mask*/
			.dw 0x0202		/* Settable/Readable Threshold Mask*/
			.db 0x00		/* Sensor Units 1*/
			.db 0x12		/* Sensor Units 2 - Base Unit*/
			.db 0x00		/* Sensor Units 3 - Modifier Unit*/
			.db 0x00	/* Linearization*/
			.db 0x01				/* M*/
			.db 0x01		/* M, Tolerance*/
			.db 0x00				/* B*/
			.db 0x00			/* B, Accuracy*/
			.db 0x00		/* Accuracy, Accuracy exponent*/
			.db 0x20		/* R exponent, B exponent*/
			.db 0x00				/* Analog Characteristics Flags*/
			.db 0x38		/* Nominal Reading*/
			.db 0x00	/* Normal Maximum*/
			.db 0x00	/* Normal Minimum*/
			.db 0xFF		/* Sensor Maximum Reading*/
			.db 0x00		/* Sensor Minimum Reading*/
			.db 0xFF				/* Upper Non-Recoverable Threshold*/
			.db 0xFF				/* Upper Critical Threshold*/
			.db 0xFF				/* Upper Non-Critical Threshold*/
			.db 0x00				/* Lower Non-Recoverable Threshold*/
			.db 0x20				/* Lower Critical Threshold*/
			.db 0x28				/* Lower Non-Critical Threshold*/
			.db 0x05			/* Positive - going threshold Hysteresis value*/
			.db 0x00			/* Negative - going threshold Hysteresis value*/
			.db 0x0					/* Reserved*/
			.db 0x0					/* Reserved*/
			.db 0x0						/* OEM*/
			.db 0xc0 + sizeof "Fan 6"	/* ID String Type / Length Code*/
			.db "Fan 6"
			

            
            /*  SDR DATA    */
            .dw 0x20           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "CPU 1"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x11           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x03           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0xC1         /* Sensor Capabilities*/
            .db 0x07                /* Sensor Type*/
            .db 0x6F                /* Event / Reading Type*/
            .dw 0x001F   /* Lower Threshold Reading Mask*/
            .dw 0x0083/* Upper Threshold Reading Mask*/
            .dw 0x009F       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "CPU 1"   /* ID String Type / Length Code*/
            .db "CPU 1"
            

            
            /*  SDR DATA    */
            .dw 0x21           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "CPU 2"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x12           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x03           /* Entity ID*/
            .db 0x02         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0xC1         /* Sensor Capabilities*/
            .db 0x07                /* Sensor Type*/
            .db 0x6F                /* Event / Reading Type*/
            .dw 0x001F   /* Lower Threshold Reading Mask*/
            .dw 0x0083/* Upper Threshold Reading Mask*/
            .dw 0x009F       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "CPU 2"   /* ID String Type / Length Code*/
            .db "CPU 2"
            

            
            /*  SDR DATA    */
            .dw 0x22           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02		        /* Record Type*/
            .db 27 + sizeof "Key/Mouse Fuse"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x13       /* Sensor Number*/
            /* RECORD BODY BYTES*/
            .db 0x1B           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0x41         /* Sensor Capabilities*/
            .db 0xC0         /* Sensor Type*/
            .db 0x03        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0002/* Upper Threshold Reading Mask*/
            .dw 0x0002       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Key/Mouse Fuse"   /* ID String Type / Length Code*/
            .db "Key/Mouse Fuse"

            

            
            /*  SDR DATA    */
            .dw 0x23           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02		        /* Record Type*/
            .db 27 + sizeof "VGA Fuse"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x14       /* Sensor Number*/
            /* RECORD BODY BYTES*/
            .db 0x07           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0x41         /* Sensor Capabilities*/
            .db 0xC0         /* Sensor Type*/
            .db 0x03        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0002/* Upper Threshold Reading Mask*/
            .dw 0x0002       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "VGA Fuse"   /* ID String Type / Length Code*/
            .db "VGA Fuse"

            

            
            /*  SDR DATA    */
            .dw 0x24           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02		        /* Record Type*/
            .db 27 + sizeof "SCSI1 Fuse"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x15       /* Sensor Number*/
            /* RECORD BODY BYTES*/
            .db 0x1A           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0x41         /* Sensor Capabilities*/
            .db 0xC0         /* Sensor Type*/
            .db 0x03        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0002/* Upper Threshold Reading Mask*/
            .dw 0x0002       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "SCSI1 Fuse"   /* ID String Type / Length Code*/
            .db "SCSI1 Fuse"

            

            
            /*  SDR DATA    */
            .dw 0x25           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02		        /* Record Type*/
            .db 27 + sizeof "SCSI2 Fuse"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x16       /* Sensor Number*/
            /* RECORD BODY BYTES*/
            .db 0x1A           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0x41         /* Sensor Capabilities*/
            .db 0xC0         /* Sensor Type*/
            .db 0x03        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0002/* Upper Threshold Reading Mask*/
            .dw 0x0002       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "SCSI2 Fuse"   /* ID String Type / Length Code*/
            .db "SCSI2 Fuse"

            

            
            /*  SDR DATA    */
            .dw 0x26           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02		        /* Record Type*/
            .db 27 + sizeof "Back USB Fuse"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x17       /* Sensor Number*/
            /* RECORD BODY BYTES*/
            .db 0x28           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0x41         /* Sensor Capabilities*/
            .db 0xC0         /* Sensor Type*/
            .db 0x03        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0002/* Upper Threshold Reading Mask*/
            .dw 0x0002       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Back USB Fuse"   /* ID String Type / Length Code*/
            .db "Back USB Fuse"

            

            
            /*  SDR DATA    */
            .dw 0x27           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02		        /* Record Type*/
            .db 27 + sizeof "Front USB Fuse"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x18       /* Sensor Number*/
            /* RECORD BODY BYTES*/
            .db 0x29           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0x41         /* Sensor Capabilities*/
            .db 0xC0         /* Sensor Type*/
            .db 0x03        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0002/* Upper Threshold Reading Mask*/
            .dw 0x0002       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Front USB Fuse"   /* ID String Type / Length Code*/
            .db "Front USB Fuse"

            

            
            /*  SDR DATA    */
            .dw 0x2A           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "NMI"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x21           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x07           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x65         /* Sensor Initialization*/
            .db 0x40         /* Sensor Capabilities*/
            .db 0x13         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0009   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0009       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "NMI"   /* ID String Type / Length Code*/
            .db "NMI"
            

            
            /*  SDR DATA    */
            .dw 0x2B           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "A/C Lost"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x22           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x13           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x65         /* Sensor Initialization*/
            .db 0x40         /* Sensor Capabilities*/
            .db 0x09         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0010   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0010       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "A/C Lost"   /* ID String Type / Length Code*/
            .db "A/C Lost"
            

            
            /*  SDR DATA    */
            .dw 0x35           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "Watchdog"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x3B           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x06           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x23         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x23         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x000F   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Watchdog"   /* ID String Type / Length Code*/
            .db "Watchdog"
            

            
            /*  SDR DATA    */
            .dw 0x36           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "No Memory"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x20           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x3C           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x0C         /* Sensor Type*/
            .db 0x03        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "No Memory"   /* ID String Type / Length Code*/
            .db "No Memory"
            

            
            /*  SDR DATA    */
            .dw 0x40           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "Correctable ECC"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x00           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x0C         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0001   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x01       /* Sensor Units 1*/
            .db 0x01       /* Sensor Units 2 - Base Unit*/
            .db 0x01       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Correctable ECC"   /* ID String Type / Length Code*/
            .db "Correctable ECC"
            

            
            /*  SDR DATA    */
            .dw 0x41           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "Uncorrect ECC"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x01           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x0C         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x01       /* Sensor Units 1*/
            .db 0x01       /* Sensor Units 2 - Base Unit*/
            .db 0x01       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Uncorrect ECC"   /* ID String Type / Length Code*/
            .db "Uncorrect ECC"
            

            
            /*  SDR DATA    */
            .dw 0x42           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "MemErrLogDisable"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x30           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x02         /* Sensor Capabilities*/
            .db 0x10         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0001   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "MemErrLogDisable"   /* ID String Type / Length Code*/
            .db "MemErrLogDisable"
            

            
            /*  SDR DATA    */
            .dw 0x43           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "Post Error"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x03           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x0F         /* Sensor Type*/
            .db 0x00        /* Event / Reading Type*/
            .dw 0x0000   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Post Error"   /* ID String Type / Length Code*/
            .db "Post Error"
            

            
            /*  SDR DATA    */
            .dw 0x44           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "Parity Error"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0xE4           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x13         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0010   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0010       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Parity Error"   /* ID String Type / Length Code*/
            .db "Parity Error"
            

            
            /*  SDR DATA    */
            .dw 0x45           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "System Error"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0xE5           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x13         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0020   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0020       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "System Error"   /* ID String Type / Length Code*/
            .db "System Error"
            

            
            /*  SDR DATA    */
            .dw 0x46           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "Sys Reconfigure"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x20           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x12         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0001   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Sys Reconfigure"   /* ID String Type / Length Code*/
            .db "Sys Reconfigure"
            

            
            /*  SDR DATA    */
            .dw 0x47           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "OEM System Boot"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x21           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x12         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "OEM System Boot"   /* ID String Type / Length Code*/
            .db "OEM System Boot"
            

            
            /*  SDR DATA    */
            .dw 0x48           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "OS Boot"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x22           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x1F         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0004   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "OS Boot"   /* ID String Type / Length Code*/
            .db "OS Boot"
            

            
            /*  SDR DATA    */
            .dw 0x49           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "Memory Resize"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x02           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x0E         /* Sensor Type*/
            .db 0x00        /* Event / Reading Type*/
            .dw 0x0000   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Memory Resize"   /* ID String Type / Length Code*/
            .db "Memory Resize"
            

            
            /*  SDR DATA    */
            .dw 0x4A           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "BusUncorrectable"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0xE8           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x13         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0100   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0100       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "BusUncorrectable"   /* ID String Type / Length Code*/
            .db "BusUncorrectable"
            

            
            /*  SDR DATA    */
            .dw 0x4B           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "Fatal NMI"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0xE9           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x13         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0200   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0200       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "Fatal NMI"   /* ID String Type / Length Code*/
            .db "Fatal NMI"
            

            
            /*  SDR DATA    */
            .dw 0x4C           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "CPU1"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x11           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x07         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0104   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0104       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "CPU1"   /* ID String Type / Length Code*/
            .db "CPU1"
            

            
            /*  SDR DATA    */
            .dw 0x4D           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "CPU2"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x12           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x07         /* Sensor Type*/
            .db 0x6F        /* Event / Reading Type*/
            .dw 0x0104   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0104       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "CPU2"   /* ID String Type / Length Code*/
            .db "CPU2"
            

            
            /*  SDR DATA    */
            .dw 0x4E           /* Record ID*/
            .db 0x51          /* SDR Version*/
            .db 0x02				/* Record Type*/
            .db 27 + sizeof "MP table failure"/* Record Length = 27 + string length */
            /* RECORD KEY BYTES*/
            .db 0x01           /* Sensor Owner ID*/
            .db 0x00              /* Sensor Owner LUN*/
            .db 0x13           /* Sensor Number*/

            /* RECORD BODY BYTES*/
            .db 0x22           /* Entity ID*/
            .db 0x01         /* Entity Instance*/
            .db 0x22         /* Sensor Initialization*/
            .db 0x01         /* Sensor Capabilities*/
            .db 0x07         /* Sensor Type*/
            .db 0x03        /* Event / Reading Type*/
            .dw 0x0002   /* Lower Threshold Reading Mask*/
            .dw 0x0000/* Upper Threshold Reading Mask*/
            .dw 0x0000       /* Settable/Readable Threshold Mask*/
            .db 0x00       /* Sensor Units 1*/
            .db 0x00       /* Sensor Units 2 - Base Unit*/
            .db 0x00       /* Sensor Units 3 - Modifier Unit*/
            .dw 0x8101     /* Sensor Recodr Sharing*/
            .db 0x00         /* Positive - going threshold Hysteresis value*/
            .db 0x00         /* Negative - going threshold Hysteresis value*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* Reserved*/
            .db 0x0                 /* OEM*/
            .db 0xc0 + sizeof "MP table failure"   /* ID String Type / Length Code*/
            .db "MP table failure"