PSP             dw      0
pci_index_port  dw      0CF8h
pci_data_port   dw      0CFCh
conf_address    dd      080000000h
conf_address_indicator	dd      0
arrow_index     db      0
display_index   db      0
invalid_value   dd      0FFFFFFFFh
base_sub_program	dd	0
double_word_index	db	0
origin_x	db	4
origin_y	db	5
top_x		db	11
top_y		db	0
right_x		db	55
right_y		db	3
bottom_x	db	0
bottom_y	db	23
current_x	db	4
current_y	db	5
save_value	dd	0
nibble_value	db	0
save_flag	db	0
data_interval	db	3
dd_length	db	4
suite_16	db	0
main_banner	db	'  Gigabyte bios team pci utility by hong.wang',0dh, 0ah, 0dh, 0ah, '$'
pci_banner      db      '  Vendor ID Device ID Bus# Dev# Fun# Name', 0dh, 0ah, 0dh, 0ah, '$'
data_width_banner       db      'Data Width : $'
rev_id_banner   db      'Rev ID        : $'
int_line_banner    db      'Int Line (IRQ): $'
int_pin_banner  db      'Int Pin       : $'
latency_timer_banner    db      'Latency Timer : $'
address_0_banner        db      '#0: $'
address_1_banner        db      '#1: $'
address_2_banner        db      '#2: $'
address_3_banner        db      '#3: $'
address_4_banner        db      '#4: $'
address_5_banner        db      '#5: $'
address_0	        dd      0
address_1	        dd      0
address_2	        dd      0
address_3	        dd      0
address_4	        dd      0
address_5	        dd      0
rom_banner      db      'ROM: $'
type_pci_banner	db	'Type:PCI   $'
bus_banner	db	'   Bus:$'
device_banner	db	'   Device:$'
function_banner	db	'   Function:$'
pci_detail_banner       db      '    00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F', 0Dh, 0Ah, '$'
separate_bar	db	'---------------------------------------------------', 0dh, 0ah, '00  $'
newline         db      0Dh, 0Ah, '$'
space_6         db      '      $'
space_3         db      '   $'
space_2         db      '  $'
count_class	db	0
row_bar_count   db      0
revision_id     db      0
interrupt_line  db      0
interrupt_pin   db      0
latency_timer   db      0
name_address    dw      0

class_00_00_00	db	'All devices except VGA-compatible devices$'
class_00_01_00	db	'VGA-compatible device$'

class_01_00_00	db	'SCSI bus controller$'
;class_01_01_xx	db	'IDE controller$'
class_01_01_8A	db	'IDE controller$'
class_01_02_00	db	'Floppy disk controller$'
class_01_03_00	db	'IPI bus controller$'
class_01_04_00	db	'RAID controller$'
class_01_80_00	db	'Other mass storage controller$'

class_02_00_00	db	'Ethernet controller$'
class_02_01_00  db	'Token Ring controller$'
class_02_02_00  db	'FDDI controller$'
class_02_03_00  db	'ATM controller$'
class_02_04_00  db	'ISDN controller$'
;class_02_06_xx  db	'PICMG 2.14 Multi Computing$'
class_02_80_00  db	'Other network controller$'

class_03_00_00	db	'VGA-compatible controller$'
class_03_00_01	db	'8514-compatible controller$'
class_03_01_00	db	'XGA controller$'
class_03_02_00	db	'3D controller$'
class_03_80_00	db	'Other display controller$'

class_04_00_00	db	'Video device$'
class_04_01_00	db	'Audio device$'
class_04_02_00	db	'Computer phone device$'
class_04_80_00	db	'Other multimedia device$'

class_05_00_00	db	'RAM$'
class_05_01_00	db	'Flash$'
class_05_80_00	db	'Other memory controller$'

class_06_00_00	db	'Host bridge$'
class_06_01_00	db	'ISA bridge$'
class_06_02_00	db	'EISA bridge$'
class_06_03_00	db	'MCA bridge$'
class_06_04_00	db	'PCI-to-PCI bridge$'
class_06_04_01	db	'Subtractive decode PCI-to-PCI bridge'
class_06_05_00	db	'PCMCIA bridge$'
class_06_06_00	db	'NuBus bridge$'
class_06_07_00	db	'CardBus bridge$'
;class_06_08_xx	db	'RACEway bridge$'
class_06_80_00	db	'Other bnridge device$'

class_07_00_00	db	'Generic XT-compatible serial controller$'
class_07_00_01	db	'16450-compatible serial controller$'
class_07_00_02	db	'16550-compatible serial controller$'
class_07_00_03	db	'16650-compatible serial controller$'
class_07_00_04	db	'16750-compatible serial controller$'
class_07_00_05	db	'16850-compatible serial controller$'
class_07_00_06	db	'16950-compatible serial controller$'
class_07_01_00	db	'Parallel port$'
class_07_01_01	db	'Bidirectional parallel port$'
class_07_01_02	db	'ECP 1.X compliant parallel port$'
class_07_01_03	db	'IEEE 1284 controller$'
class_07_01_FE	db	'IEEE 1284 Target device$'
class_07_02_00	db	'Multiport serial controller$'
class_07_03_00	db	'Generic modem$'
class_07_03_01	db	'Hayes compatible modem, 16450-compatible$'
class_07_03_02	db	'Hayes compatible modem, 16550-compatible$'
class_07_03_03	db	'Hayes compatible modem, 16650-compatible$'
class_07_03_04	db	'Hayes compatible modem, 16750-compatible$'
class_07_80_00	db	'Other communications device$'

class_08_00_00	db	'Generic 8259 PIC$'
class_08_00_01	db	'ISA PIC$'
class_08_00_02	db	'EISA PIC$'
class_08_00_10	db	'I/O APIC interrupt controller$'
class_08_00_20	db	'I/O(x) APIC interrupt controller$'
class_08_01_00	db	'Generic 8237 DMA controller$'
class_08_01_01	db	'ISA DMA controller$'
class_08_01_02	db	'EISA DMA controller$'
class_08_02_00	db	'Generic 8254 system timer$'
class_08_02_01	db	'ISA system timer$'
class_08_02_02	db	'EISA system timers$'
class_08_03_00	db	'Generic RTC controller$'
class_08_03_01	db	'ISA RTC controller$'
class_08_04_00	db	'Generic PCI hot-plug controller$'
class_08_80_00	db	'Other system peripheral$'

class_09_00_00	db	'Keyboard controller$'
class_09_01_00	db	'Digitizer(pen)$'
class_09_02_00	db	'Mouse controller$'
class_09_03_00	db	'Scanner controller$'
class_09_04_00	db	'Gameport controller(generic)$'
class_09_04_10	db	'Gameport controller$'
class_09_80_00	db	'Other input controller$'

class_0A_00_00	db	'Generic docking station$'	
class_0A_80_00	db	'Other type of docking station$'

class_0B_00_00	db	'386$'
class_0B_01_00	db	'486$'
class_0B_02_00	db	'Pentium$'
class_0B_10_00	db	'Alpha$'
class_0B_20_00	db	'PowerPC$'
class_0B_30_00	db	'MIPS$'
class_0B_40_00	db	'Co-processor$'

class_0C_00_00	db	'IEEE 1394(Fire Wire)$'
class_0C_00_10	db	'IEEE 1394 following the 1394 OpenHCI$'
class_0C_01_00	db	'ACCESS.bus$'
class_0C_02_00	db	'SSA$'
class_0C_03_00	db	'USB following the UHC Specification$'
class_0C_03_10	db	'USB follwing the OHC Specification$'
class_0C_03_20	db	'USB2 host controller following intel EHC$'
class_0C_03_80	db	'USB with no specific programming interface$'
class_0C_03_FE	db	'USB(non host controller)$'
class_0C_04_00	db	'Fibre Channel$'
class_0C_05_00	db	'SMBus(System Management Bus)$'

class_0D_00_00	db	'iRDA compatible controller$'
class_0D_01_00	db	'Consumer IR controller$'
class_0D_10_00	db	'RF controller$'
class_0D_80_00	db	'Other type of wireless controller$'

class_0E_00_xx	db	'Intelligent I/O(I2O)Architecture 1.0$'
class_0E_00_00	db	'Message FIFO at offset 040h$'

class_0F_01_00	db	'TV$'
class_0F_02_00	db	'Audio$'
class_0F_03_00	db	'Voice$'
class_0F_04_00	db	'Data$'

class_10_00_00	db	'Network and computing en/decryption$'
class_10_10_00	db	'Entertainment en/decryption$'
class_10_80_00	db	'Other en/decryption$'

class_11_00_00	db	'DPIO modules$'
class_11_80_00	db	'Other data /signal controllers$'

class_code_table_start LABEL BYTE

	class_code< 00h, 00h, 00h, offset class_00_00_00 >
	class_code< 00h, 01h, 00h, offset class_00_01_00 >

	class_code< 01h, 00h, 00h, offset class_01_00_00 >
	class_code< 01h, 01h, 8Ah, offset class_01_01_8A >
;	class_code< 01h, 01h, xxh, offset class_01_01_xx >
	class_code< 01h, 02h, 00h, offset class_01_02_00 >
	class_code< 01h, 03h, 00h, offset class_01_03_00 >
	class_code< 01h, 04h, 00h, offset class_01_04_00 >
	class_code< 01h, 80h, 00h, offset class_01_80_00 >

	class_code< 02h, 00h, 00h, offset class_02_00_00 >
	class_code< 02h, 01h, 00h, offset class_02_01_00 >
	class_code< 02h, 02h, 00h, offset class_02_02_00 >
	class_code< 02h, 03h, 00h, offset class_02_03_00 >
	class_code< 02h, 03h, 00h, offset class_02_03_00 >
;        class_code< 02h, 06h, xxh, offset class_02_06_xx >
	class_code< 02h, 80h, 00h, offset class_02_80_00 >

	class_code< 03h, 00h, 00h, offset class_03_00_00 >
	class_code< 03h, 00h, 01h, offset class_03_00_01 >
	class_code< 03h, 01h, 00h, offset class_03_01_00 >
	class_code< 03h, 02h, 00h, offset class_03_02_00 >
	class_code< 03h, 80h, 00h, offset class_03_80_00 >

	class_code< 04h, 00h, 00h, offset class_04_00_00 >
	class_code< 04h, 01h, 00h, offset class_04_01_00 >
	class_code< 04h, 02h, 00h, offset class_04_02_00 >
	class_code< 04h, 80h, 00h, offset class_04_80_00 >

	class_code< 05h, 00h, 00h, offset class_05_00_00 >
	class_code< 05h, 01h, 00h, offset class_05_01_00 >
	class_code< 05h, 80h, 00h, offset class_05_80_00 >

	class_code< 06h, 00h, 00h, offset class_06_00_00 >
	class_code< 06h, 01h, 00h, offset class_06_01_00 >
	class_code< 06h, 02h, 00h, offset class_06_02_00 >
	class_code< 06h, 03h, 00h, offset class_06_03_00 >
	class_code< 06h, 04h, 00h, offset class_06_04_00 >
	class_code< 06h, 04h, 01h, offset class_06_04_01 >
	class_code< 06h, 05h, 00h, offset class_06_05_00 >
	class_code< 06h, 06h, 00h, offset class_06_06_00 >
	class_code< 06h, 07h, 00h, offset class_06_07_00 >
;	class_code< 06h, 08h, xxh, offset class_06_08_xx >
	class_code< 06h, 80h, 00h, offset class_06_80_00 >

	class_code< 07h, 00h, 00h, offset class_07_00_00 >
	class_code< 07h, 00h, 01h, offset class_07_00_01 >
	class_code< 07h, 00h, 02h, offset class_07_00_02 >
	class_code< 07h, 00h, 03h, offset class_07_00_03 >
	class_code< 07h, 00h, 04h, offset class_07_00_04 >
	class_code< 07h, 00h, 05h, offset class_07_00_05 >
	class_code< 07h, 00h, 06h, offset class_07_00_06 >
	class_code< 07h, 01h, 00h, offset class_07_01_00 >
	class_code< 07h, 01h, 01h, offset class_07_01_01 >
	class_code< 07h, 01h, 02h, offset class_07_01_02 >
	class_code< 07h, 01h, 03h, offset class_07_01_03 >
	class_code< 07h, 01h, 0FEh, offset class_07_01_FE >
	class_code< 07h, 02h, 00h, offset class_07_02_00 >
	class_code< 07h, 03h, 00h, offset class_07_03_00 >
	class_code< 07h, 03h, 00h, offset class_07_03_00 >
	class_code< 07h, 03h, 01h, offset class_07_03_01 >
	class_code< 07h, 03h, 02h, offset class_07_03_02 >
	class_code< 07h, 03h, 03h, offset class_07_03_03 >
	class_code< 07h, 03h, 04h, offset class_07_03_04 >
	class_code< 07h, 80h, 00h, offset class_07_80_00 >

	class_code< 08h, 00h, 00h, offset class_08_00_00 >
	class_code< 08h, 00h, 01h, offset class_08_00_01 >
	class_code< 08h, 00h, 02h, offset class_08_00_02 >
	class_code< 08h, 00h, 10h, offset class_08_00_10 >
	class_code< 08h, 00h, 20h, offset class_08_00_20 >
        class_code< 08h, 01h, 00h, offset class_08_01_00 >
	class_code< 08h, 01h, 01h, offset class_08_01_01 >
	class_code< 08h, 01h, 02h, offset class_08_01_02 >
	class_code< 08h, 02h, 00h, offset class_08_02_00 >
	class_code< 08h, 02h, 01h, offset class_08_02_01 >
	class_code< 08h, 02h, 02h, offset class_08_02_02 >
	class_code< 08h, 03h, 00h, offset class_08_03_00 >
	class_code< 08h, 03h, 01h, offset class_08_03_01 >
	class_code< 08h, 04h, 00h, offset class_08_04_00 >
	class_code< 08h, 80h, 00h, offset class_08_80_00 >

	class_code< 09h, 00h, 00h, offset class_09_00_00 >
	class_code< 09h, 01h, 00h, offset class_09_01_00 >
	class_code< 09h, 02h, 00h, offset class_09_02_00 >
	class_code< 09h, 03h, 00h, offset class_09_03_00 >
	class_code< 09h, 04h, 00h, offset class_09_04_00 >
	class_code< 09h, 04h, 10h, offset class_09_04_10 >
	class_code< 09h, 80h, 00h, offset class_09_80_00 >

	class_code< 0Ah, 00h, 00h, offset class_0A_00_00 >
	class_code< 0Ah, 80h, 00h, offset class_0A_80_00 >

	class_code< 0Bh, 00h, 00h, offset class_0B_00_00 >
	class_code< 0Bh, 01h, 00h, offset class_0B_01_00 >
	class_code< 0Bh, 02h, 00h, offset class_0B_02_00 >
	class_code< 0Bh, 10h, 00h, offset class_0B_10_00 >
	class_code< 0Bh, 20h, 00h, offset class_0B_20_00 >
	class_code< 0Bh, 30h, 00h, offset class_0B_30_00 >
	class_code< 0Bh, 40h, 00h, offset class_0B_40_00 >

	class_code< 0Ch, 00h, 00h, offset class_0C_00_00 >
	class_code< 0Ch, 00h, 10h, offset class_0C_00_10 >
	class_code< 0Ch, 01h, 00h, offset class_0C_01_00 >
	class_code< 0Ch, 02h, 00h, offset class_0C_02_00 >
	class_code< 0Ch, 03h, 00h, offset class_0C_03_00 >
	class_code< 0Ch, 03h, 10h, offset class_0C_03_10 >
	class_code< 0Ch, 03h, 20h, offset class_0C_03_20 >
	class_code< 0Ch, 03h, 80h, offset class_0C_03_80 >
	class_code< 0Ch, 03h, 0FEh, offset class_0C_03_FE >
	class_code< 0Ch, 04h, 00h, offset class_0C_04_00 >
	class_code< 0Ch, 05h, 00h, offset class_0C_05_00 >

	class_code< 0Dh, 00h, 00h, offset class_0D_00_00 >
	class_code< 0Dh, 01h, 00h, offset class_0D_01_00 >
	class_code< 0Dh, 10h, 00h, offset class_0D_10_00 >
	class_code< 0Dh, 80h, 00h, offset class_0D_80_00 >

;	class_code< 0Eh, 00h, xxh, offset class_0E_00_xx >
	class_code< 0Eh, 00h, 00h, offset class_0E_00_00 >

	class_code< 0Fh, 01h, 00h, offset class_0F_01_00 >
	class_code< 0Fh, 02h, 00h, offset class_0F_02_00 >
	class_code< 0Fh, 03h, 00h, offset class_0F_03_00 >
	class_code< 0Fh, 04h, 00h, offset class_0F_04_00 >

	class_code< 10h, 00h, 00h, offset class_10_00_00 >
	class_code< 10h, 10h, 00h, offset class_10_10_00 >
	class_code< 10h, 80h, 00h, offset class_10_80_00 >

	class_code< 11h, 00h, 00h, offset class_11_00_00 >
	class_code< 11h, 80h, 00h, offset class_11_80_00 >

class_code_table_end LABEL BYTE

