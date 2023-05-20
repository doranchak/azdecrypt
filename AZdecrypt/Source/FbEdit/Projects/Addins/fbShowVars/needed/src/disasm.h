  /*


  ---------------------------------------
  DISIT - OPEN SOURCE DISASSEMBLER ENGINE
  ---------------------------------------
	   http://www.piotrbania.com



  Version:				01C-BETA
  Last revision:		09/09/2006


  DISCLAIMER
  ----------

  Author takes no responsibility for any actions with provided 
  informations or codes. The copyright for any material created by the 
  author is reserved. Any duplication of codes or texts provided here 
  in electronic or printed publications is not permitted without the 
  author's agreement. 



   
								2005 / 2006 - All rights reserved ®
									   Copyrights © - Piotr Bania


  */

#ifndef __DISASM_H
#define __DISASM_H



#define	MAX_PREFIXES  4


#define USE_CRS       1
#define USE_DRS       2
#define USE_SREG      3

#define R_CR0	      0x0
#define R_CR2         0x1
#define R_CR3         0x3
#define R_CR4         0x4

#define R_DR0         0x0
#define R_DR1         0x1
#define R_DR2         0x2
#define R_DR3         0x3
#define R_DRX         0x5 // reserved
#define R_DR6         0x6
#define R_DR7         0x7


#define R_AL          0x00000001
#define R_AH          0x00000002
#define R_AX          0x00000003
#define R_EAX         0x0000000F
#define R_CL          0x00000010
#define R_CH          0x00000020
#define R_CX          0x00000030
#define R_ECX         0x000000F0
#define R_DL          0x00000100
#define R_DH          0x00000200
#define R_DX          0x00000300
#define R_EDX         0x00000F00
#define R_BL          0x00001000
#define R_BH          0x00002000
#define R_BX          0x00003000
#define R_EBX         0x0000F000
#define R_SP          0x00010000
#define R_ESP         0x00030000
#define R_BP          0x00100000
#define R_EBP         0x00300000
#define R_SI          0x01000000
#define R_ESI         0x03000000
#define R_DI          0x10000000
#define R_EDI         0x30000000
#define R_ALL16       0x11113333
#define R_ALL32		  0x3333FFFF





#define WW             0x01            // Bit W
#define SS             0x02            // Bit S
#define WS             0x03            // Bits W and S
#define NA             0x0C            // Name depends on size
#define W3             0x08            // Bit W at position 3
#define DD             0x02			   // Operation Direction Bit

#define NNN            0               // No operand
#define MDR1           1			   // Register in field 1
#define MDR2           2               // Register in field 2 
#define MDR1R          3               // Register in field 1 (now source)
#define MDR2R          4               // Register in field 2 (now dest)
#define ACC            5               // Accumulator
#define IMM            6               // Immediate data
#define MM1            7               // Memory as dest
#define MM2            8               // Memory as src
#define IMMS		   9               // IMM after SIB (possible)
#define IMMC           10              // Immediate directly after op
#define MDR1R_16       11			   // Register in field 1 (16 bit super mode)
#define MDR2R_16       12              // Register in field 2 (16 bit super mode)
#define MM1_16		   13              // Memory (16 bit request)
#define MM2_E          14              // Extended mem (BOUND etc.)
#define IMM8           15              // 8 Bit Immediate
#define IMM16          16              // 16 Bit Immediate
#define IMM8S          17              // 8 Bit Immediate possible after SIB
#define IMM32C         18              // 32 Bit Immediate for call
#define IMM_SEL        19              // Selector (calls etc.)
#define MM2CE          20              // Memory source extended (CALLs)
#define MDR2_A         21              // Reg in field 2 (alternate)
#define IMM8E          22              // 8 Bit Immediate (ENTER style)
#define IMM_SEL_E      23              // Selector (ENTER)
#define IMMI           24              // Special for IMMuls
#define IMM8C          25              // 8 Bit Immediate directly after op
#define REG_DX         26              // REG EDX
#define JTTTN          27              // Jump decoding (tttn fields)
#define IMM32          28              // Immediate 32 bits (FULL)
#define IMM8CN         29              // 8 Bit immediate directly after op
#define MM2_EF         30              // Memory extended (LSF)
#define MDR1_16        31              // 16 bit reg
#define MDR2_16        32              // 16 bit reg
#define ACCR           33              // Acumulator as dest
#define MM1_FD         34              // Mem Full disp
#define MM2_FD         35              // Mem Full disp
#define CRX            36              // CR register
#define DRX            37              // DR register
#define SREG3          38              // SREG3 field
#define SREG2          39              // SREG2 field
#define IMM1           40              // Immediate - value = 1
#define REG_CL         41              // CL register
#define IMM16C         42              // 16 Bit immediate directly after op
#define MDR2R_8        43              // 8 Bit REG
#define JTTTNS         44              // JTTTNS for SETXX
#define MM2R_8         45              // 8 Bit MEM
#define IMMI8          46              // Immediate 8 (special)
#define REG_CL_I       47              // CL (flags update required, SHLD etc.)
#define MDR2_8		   48              // 8 Bit reg
#define MM_8		   49              // byte ptr [mem]
#define MM_16		   50			   // word ptr [mem]
#define MDR2_AA		   51			   // alternate register encoding (XCHG)

/* special flags */ 

#define   C_NNN        0            // Ordinary instruction
#define   C_D2S        1            // Dest regs are Src regs
#define   C_S2D        2            // Src regs are Dest regs
#define   C_D_ESP	   3            // ESP to destination
#define   C_DS_EAX     4            // Source=dest=EAX
#define   C_DS_EDX_EAX 5            // Dest=EDX | Source=EAX
#define   C_D2SN       6            // Dest to Source, then Dest = 0
#define   C_S_EDIESI   7            // EDI, ESI - the source
#define   C_D_EAX      8            // EAX = dest
#define   C_D2S_DEAX   9            // Src|=Dest, Dest|=EAX
#define   C_D_4R       10           // Dest = EAX | ECX | EDX | EBX (CPUID)
#define   C_DS_EAXEDX_EAX 11        // Dest = EDX/EAX | Source |= EAX
#define   C_S_EDX      12           // Src = EDX
#define   C_D_EBPESP   13           // Dest: ESP | EBP
#define   C_DS_EAX_ESI 14           // Dest: EAX, Src: ESI
#define   C_DS_ECX     15           // ECX = SRC = DEST
#define   C_DS_EDI_ESI 16           // Dest: EDI, Src: ESI
#define   C_D_ALL      17           // All regs as dest
#define   C_S_ALL      18           // All regs ar src
#define   C_DS_ESP     19           // Dest: ESP, Src: ESP
#define   C_S_EDIESIEAX   20        // SRC: EDI, ESI, EAX
#define   C_S_CL       21           // SRC: CL
#define   C_D_EAX_EDX  22           // Dest: EAX, EDX
#define   C_DS_EAXEDX_ECX 23        // Dest: EAX, EDX Src: ECX
#define	  C_D2S_NN     24           // Src |= Dest, Dest unchagned
#define   C_DS_ESP_N   25           // Dest |= ESP | Src |= old_DEST | ESP
#define   C_S_CL_N     26           // SRC: CL | Src |= Dest

/* some str flags */
#define F_CALL			1			// call flag
#define F_JMP			2			// jump flag
#define F_ENTER         3           // enter flag
#define F_SETXX         4           // set flag
#define F_SHL3          5           // shls (3 params)

typedef unsigned char  uchar;          // Unsigned character (byte)
typedef unsigned short ushort;         // Unsigned short
typedef unsigned int   uint;           // Unsigned integer
typedef unsigned long  ulong;          // Unsigned long



// this struct is pretty similiar to the one Oleh used, anyway that's
// the end of similiarities in the engine.

typedef struct _g_ddata {
  ulong          mask;                 
  ulong          code;                 
  char           len;                  
  char           bits;                 
  char           arg1;
  char           arg2;
  char           arg3;       
  char           s_flag;                 
  char           *name;                
} g_ddata;


typedef struct __dis_data {
	int		len;							// length of instruction

	unsigned char prefix[3];
	unsigned char seg;

	unsigned char  w_bit;
	unsigned char  s_bit;
	
	unsigned char	opcode;							// opcode value
	unsigned char	opcode2;						// second opcode value
	unsigned char	modrm;							// modrm value

	unsigned char   mem_act;                        // 0-dst / 1-src
	unsigned long   mem_regs;                       // registers for memory operations
	
	unsigned char   use_sib;						// sib usage flag
	unsigned char	sib;							// sib value
	unsigned char   sib_mul;                        // sib multipler
	unsigned long   sib_mul_reg;					// important

	unsigned long   mem_imm;						// immediate for mem
	unsigned long   mem_imm_size;					// immediate for mem size
	unsigned char   mem_super_size;                 // important only if not zero

	unsigned long   src_regs;						// normal regs
	unsigned long   dst_regs;

	unsigned long   i_src_regs;						// a view of instruction
	unsigned long   i_dst_regs;						// squad


	unsigned long   flags;


	unsigned char  spec_regs_on;					// special regs flag
	unsigned char  spec_regs;						// special regs (DRx/CRX/etc.)
													
	unsigned char   spec_flag;						// call/jump flags
	unsigned short  selector;                       // selector

	unsigned char	default_addr;
	unsigned char	default_data;

	unsigned long	imm_data;							// immediate data
	unsigned char   imm_size;                           // immediate size
	unsigned char   imm_signextend;						// sign extenstion was done?

	unsigned long   reserved;							// special super cases (tttn and others)  
	unsigned char   reserved_size;						// reserved


	char	instr_out[50];
	char	instr_dump[24];
	char	prefix_t[20];

} _dis_data;





const g_ddata i_data[] = {


	{ 0x00FFFF, 0x00320F, 2, 0,  NNN, NNN, NNN, C_DS_EAXEDX_ECX,    "RDMSR"},		// RDMSR -> 0000 1111: 0011 0010
	{ 0x00FFFF, 0x00330F, 2, 0,  NNN, NNN, NNN, C_DS_EAXEDX_ECX,    "RDPMC"},		// RDPMC -> 0000 1111: 0011 0011
	{ 0x00FFFF, 0x00310F, 2, 0,  NNN, NNN, NNN, C_D_EAX_EDX,        "RDTSC"},		// RDTSC -> 0000 1111: 0011 0001
	{ 0x00FFFF, 0x00AA0F, 2, 0,  NNN, NNN, NNN, C_NNN,              "RSM"},		// RSM -> 0000 1111: 1010 1010
	{ 0x0000FF, 0x00009E, 1, 0,  NNN, NNN, NNN, C_NNN,              "SAHF"},		// SAHF -> 1001110
	{ 0x38FFFF, 0x00010F, 2, 0,  MM2CE, NNN, NNN, C_NNN,            "SGDT"},		// SGDT -> 0000 1111: 0000 0001: mod^A 0000 r/m

	{ 0x0000FF, 0x000037, 1, 0,  NNN, NNN, NNN, C_D_EAX,            "AAA"},		// AAA -> 0011 0111
//	{ 0x00FFFF, 0x000AD5, 2, 0,  NNN, NNN, NNN, C_D_EAX,            "AAD"},		// AAD -> 1101 0101: 0000 1010
//	{ 0x00FFFF, 0x000AD4, 2, 0,  NNN, NNN, NNN, C_D_EAX,            "AAM"},		// AAM -> 1101 0100: 0000 1010
	{ 0x0000FF, 0x00003F, 1, 0,  NNN, NNN, NNN, C_D_EAX,            "AAS"},		// AAS -> 0011 1111
	
	{ 0x00C0FE, 0x00C010, 1, WW, MDR1R,MDR2R,  NNN, C_D2S_NN,		"ADC"},		// r1,r2 -> 0001 000w: 11 r1 r2
	{ 0x00C0FE, 0x00C012, 1, WW, MDR1, MDR2,   NNN, C_D2S_NN,		"ADC"},		// r2,r1 -> 0001 001w: 11 r1 r2
    { 0x0000FE, 0x000012, 1, WW, MDR1, MM2,    NNN, C_D2S_NN,       "ADC"},		// r1,MM -> 0001 001w: mod reg r/m
	{ 0x0000FE, 0x000010, 1, WW, MDR1R,MM1,    NNN, C_NNN,          "ADC"},		// MM,r1 -> 0001 000w: mod reg r/m
	{ 0x00F8FC, 0x00D080, 1, WS, MDR2R, IMM,   NNN, C_D2S_NN,       "ADC"},		// r1,IM -> 1000 00sw: 11 010 reg : IM
	{ 0x0000FE, 0x000014, 1, WW, ACC,  IMMC,   NNN, C_D2S_NN,       "ADC"},		// AC,IM -> 0001 010w: IM
	{ 0x0038FC, 0x001080, 1, WS, MM1,  IMMS,   NNN, C_NNN,          "ADC"},		// MM,IM -> 1000 00sw: mod 010 r/m : IM
	
	
	{ 0x00C0FE, 0x00C000, 1, WW, MDR1R,MDR2R,  NNN, C_D2S_NN,       "ADD"},		// r1,r2 -> 0000 000w: 11 reg1 reg2
	{ 0x00C0FE, 0x00C002, 1, WW, MDR1, MDR2,   NNN, C_D2S_NN,       "ADD"},		// r2,r1 -> 0000 001w: 11 reg1 reg2
	{ 0x0000FE, 0x000002, 1, WW, MDR1, MM2,    NNN, C_D2S_NN,       "ADD"},		// r1,MM -> 0000 001w: mod reg r/m
	{ 0x0000FE, 0x000000, 1, WW, MDR1R,MM1,    NNN, C_NNN,          "ADD"},		// MM,r1 -> 0000 000w: mod reg r/m
	{ 0x00F8FC, 0x00C080, 1, WS, MDR2R,IMM,    NNN, C_D2S_NN,       "ADD"},		// r1,IM -> 1000 00sw: 11 000 reg : 
	{ 0x0000FE, 0x000004, 1, WW, ACC,  IMMC,   NNN, C_D2S_NN,       "ADD"},		// AC,IM -> 0000 010w: IM
	{ 0x0038FC, 0x000080, 1, WS, MM1,  IMMS,   NNN, C_NNN,          "ADD"},		// MM,IM -> 1000 00sw: mod 000 r/m : IM

	{ 0x00C0FE, 0x00C020, 1, WW, MDR1R,MDR2R,  NNN, C_D2S_NN,       "AND"},		// r1,r2 -> 0010 000w: 11 r1 r2
	{ 0x00C0FE, 0x00C022, 1, WW, MDR1, MDR2,   NNN, C_D2S_NN,       "AND"},		// r2,r1 -> 0010 001w: 11 r1 r2
	{ 0x0000FE, 0x000022, 1, WW, MDR1, MM2,    NNN, C_D2S_NN,       "AND"},		// r1,MM -> 0010 001w: mod reg r/m
	{ 0x0000FE, 0x000020, 1, WW, MDR1R,MM1,    NNN, C_NNN,          "AND"},		// MM,r1 -> 0010 000w: mod reg r/m
	{ 0x00F8FC, 0x00E080, 1, WS, MDR2R,IMM,    NNN, C_D2S_NN,       "AND"},		// r1,IM -> 1000 00sw: 11 100 reg
	{ 0x0000FE, 0x000024, 1, WW, ACC,  IMMC,   NNN, C_D2S_NN,       "AND"},		// AC,IM -> 0010 010w: IM
	{ 0x0038FC, 0x002080, 1, WS, MM1,  IMMS,   NNN, C_NNN,          "AND"},		// MM,IM -> 1000 00sw: mod 100 r/m: IM
	
	{ 0x00C0FF, 0x00C063, 1, 0,  MDR1R_16, MDR2R_16, NNN, C_NNN,    "ARPL"},		// f.reg -> 0110 0011: 11 reg1 reg2
	{ 0x0000FF, 0x000063, 1, 0,  MDR1R_16, MM1_16,   NNN, C_NNN,    "ARPL"},		// f.mem -> 0110 0011: mod reg r/m

	{ 0x0000FF, 0x000062, 1, 0,  MDR1, MM2_E,  NNN, C_NNN,          "BOUND"},		// bound -> 0110 0010: mod^a reg r/m

	{ 0xC0FFFF, 0xC0BC0F, 2, 0,  MDR1, MDR2,   NNN, C_NNN,          "BSF"},		// r1,r2 -> 0000 1111: 1011 1100: 11 reg1 reg2
	{ 0x00FFFF, 0x00BC0F, 2, 0,  MDR1, MM2,    NNN, C_NNN,          "BSF"},		// r1,MM -> 0000 1111: 1011 1100: mod reg r/m

	{ 0xC0FFFF, 0xC0BD0F, 2, 0,  MDR1, MDR2,   NNN, C_NNN,          "BSR"},		// r1,r2 -> 0000 1111: 1011 1101: 11 reg1 reg2
	{ 0x00FFFF, 0x00BD0F, 2, 0,  MDR1, MM2,    NNN, C_NNN,          "BSR"},		// r1,MM -> 0000 1111: 1011 1101: mod reg r/m

	/* add flag: all regs from BSWAP are either source and dest */
	{ 0x00C8FF, 0x00C80F, 1, 0,  MDR2R, NNN,   NNN, C_D2S,          "BSWAP"},		// r1 -> 0000 1111: 1100 1 reg


	{ 0xF8FFFF, 0xE0BA0F, 2, 0,  MDR2R, IMM8,  NNN, C_NNN,          "BT"},		// r1,IM -> 0000 1111: 1011 1010: 11 100 reg: IMM8 DATA
	{ 0x38FFFF, 0x20BA0F, 2, 0,  MM1,   IMM8S, NNN, C_NNN,          "BT"},		// MM,IM -> 0000 1111: 1011 1010: mod 100 r/m
	{ 0xC0FFFF, 0xC0A30F, 2, 0,  MDR1R, MDR2R, NNN, C_NNN,          "BT"},		// r1,r2 -> 0000 1111: 1010 0011: 11 reg2 reg1
	{ 0x00FFFF,	0x00A30F, 2, 0,  MM1,   MDR1R, NNN, C_NNN,          "BT"},		// MM,r1 -> 0000 1111: 1010 0011: mod reg r/m

  
	{ 0xF8FFFF, 0xF8BA0F, 2, 0,  MDR2R, IMM8,  NNN, C_NNN,          "BTC"},		// r1,IM -> 0000 1111: 1011 1010: 11 111 reg: NNN DATA
	{ 0x38FFFF, 0x38BA0F, 2, 0,  MM1,   IMM8S, NNN, C_NNN,          "BTC"},		// MM,IM -> 0000 1111: 1011 1010: mod 111 r/m: NNN DATA
	{ 0xC0FFFF, 0xC0BB0F, 2, 0,  MDR1R, MDR2R, NNN, C_NNN,          "BTC"},		// r1,r2 -> 0000 1111: 1011 1011: 11 reg2 reg1
	{ 0x00FFFF, 0x00BB0F, 2, 0,  MM1,   MDR1R, NNN, C_NNN,          "BTC"},		// MM,r1 -> 0000 1111: 1011 1011: mod reg r/m

	{ 0xF8FFFF, 0xF0BA0F, 2, 0,  MDR2R, IMM8,  NNN, C_NNN,          "BTR"},		// r1,IM -> 0000 1111: 1011 1010: 11 110 reg: NNN DATA
	{ 0x38FFFF, 0x30BA0F, 2, 0,  MM1,   IMM8S, NNN, C_NNN,          "BTR"},		// MM,IM -> 0000 1111: 1011 1010: mod 110 r/m: NNN data
	{ 0xC0FFFF, 0xC0B30F, 2, 0,  MDR1R, MDR2R, NNN, C_NNN,          "BTR"},		// r1,r2 -> 0000 1111: 1011 0011: 11 reg2 reg1
	{ 0x00FFFF, 0x00B30F, 2, 0,  MM1,   MDR1R, NNN, C_NNN,          "BTR"},		// MM,r1 -> 0000 1111: 1011 0011: mod reg r/m

	{ 0xF8FFFF, 0xE8BA0F, 2, 0,  MDR2R, IMM8,  NNN, C_NNN,          "BTS"},		// r1,IM -> 0000 1111: 1011 1010: 11 101 reg: NNN DATA
	{ 0x38FFFF, 0x28BA0F, 2, 0,  MM1,   IMM8S, NNN, C_NNN,          "BTS"},		// MM,IM -> 0000 1111: 1011 1010: mod 101 r/m: NNN data
	{ 0xC0FFFF, 0xC0AB0F, 2, 0,  MDR1R, MDR2R, NNN, C_NNN,          "BTS"},		// r1,r2 -> 0000 1111: 1010 1011: 11 reg2 reg1
	{ 0x00FFFF, 0x00AB0F, 2, 0,  MM1,   MDR1R, NNN, C_NNN,          "BTS"},		// MM,r1 -> 0000 1111: 1010 1011: mod reg r/m


	/* add reg_dst = ESP for every call */
																			            // in the same segment
	{ 0x0000FF, 0x0000E8, 1, 0,  IMM32C,NNN,   NNN, C_DS_ESP,       "CALL"},		// call direct -> 1110 1000: full displacement
	{ 0x00F8FF, 0x00D0FF, 1, 0,  MDR2,  NNN,   NNN, C_DS_ESP,       "CALL"},		// call register indirect -> 1111 1111: 11 010 reg
	{ 0x0038FF, 0x0010FF, 1, 0,  MM2,   NNN,   NNN, C_DS_ESP,       "CALL"},		// call memory indirect -> 1111 1111: mod 010 r/m
																		            // in other segment
	{ 0x0000FF, 0x00009A, 1, 0,  IMM32C,IMM_SEL,NNN,C_DS_ESP,       "CALL FAR"},		// call direct -> 1001 1010: unsigned full offset, selector
	{ 0x0038FF, 0x0018FF, 1, 0,  MM2CE, NNN,   NNN, C_DS_ESP,       "CALL FAR"},		// call indirect -> 1111 1111: mod 010 r/m



	{ 0x0000FF, 0x000098, 1, NA, NNN,   NNN,   NNN, C_DS_EAX,        "CBW*"},	    // CBW/CWDE: 1001 1000
	{ 0x0000FF, 0x000099, 1, NA, NNN,   NNN,   NNN, C_DS_EDX_EAX,    "CD*"},	    // CDQ/CWD: 1001 1001
	{ 0x0000FF, 0x0000F8, 1, 0,  NNN,   NNN,   NNN, C_NNN,           "CLC"},		// CLC: 1111 1000
	{ 0x0000FF, 0x0000FC, 1, 0,  NNN,   NNN,   NNN, C_NNN,           "CLD"},		// CBW: 1111 1100
	{ 0x0000FF, 0x00009A, 1, 0,  NNN,   NNN,   NNN, C_NNN,           "CLI"},		// CBW: 1001 1010
	{ 0x00FFFF, 0x00060F, 2, 0,  NNN,   NNN,   NNN, C_NNN,           "CLTS"},		// CLTS: 0000 1111: 0000 0110
	{ 0x0000FF, 0x0000F5, 1, 0,  NNN,   NNN,   NNN, C_NNN,           "CMC"},		// CMC: 1111 0101

	{ 0x00C0FE, 0x00C038, 1, WW, MDR1R, MDR2R, NNN, C_D2SN,          "CMP"},		// r1,r2: 0011 100w: 11 reg1 reg2
	{ 0x00C0FE, 0x00C03A, 1, WW, MDR1,  MDR2,  NNN ,C_D2SN,          "CMP"},		// r2,r1: 0011 101w: 11 reg1 reg2
	{ 0x0000FE, 0x000038, 1, WW, MM1,   MDR1R, NNN, C_D2SN,          "CMP"},		// MM,r1 -> 0011 100w: mod reg r/m
	{ 0x0000FE, 0x00003A, 1, WW, MDR1,  MM2,   NNN, C_D2SN,          "CMP"},		// r1,MM -> 0011 101w: mod reg r/m
	{ 0x00F8FC, 0x00F880, 1, WS, MDR2R, IMM,   NNN, C_D2SN,          "CMP"},		// r1,IM -> 1000 00sw: 11 111 reg
	{ 0x0000FE, 0x00003C, 1, WW, ACC,   IMMC,  NNN, C_D2SN,          "CMP"},		// AC,IM -> 0011 110w: IM
	{ 0x0038FC, 0x003880, 1, WS, MM1,   IMMS,   NNN, C_NNN,          "CMP"},		// MM,IM -> 1000 00sw: mod 111 r/m: IM

	{ 0x0000FE, 0x0000A6, 1, WW|NA,NNN, NNN,   NNN, C_S_EDIESI,      "CMPS*"},		// CMPS(X) -> 1010 011w

	{ 0xC0FEFF, 0xC0B00F, 2, WW, MDR1R, MDR2R, NNN, C_D2S_DEAX,      "CMPXCHG"},	// r1,r2 -> 0000 1111: 1011 000w: 11 reg2 reg1
	{ 0x00FEFF, 0x00B00F, 2, WW, MM1,   MDR1R, NNN, C_D2S_DEAX,      "CMPXCHG"},	// MM,r1 -> 0000 1111: 1011 000w: mod reg r/m

	{ 0x00FFFF, 0x00A20F, 2, 0,  NNN,   NNN,   NNN, C_D_4R,          "CPUID"},    // CPUID -> 0000 1111: 1010 0010 

	{ 0x0000FF, 0x000027, 1, 0,  NNN,   NNN,   NNN, C_NNN,           "DAA"},		// DAA -> 0010 0111
	{ 0x0000FF, 0x00002F, 1, 0,  NNN,   NNN,   NNN, C_NNN,           "DAS"},		// DAS -> 0010 1111

	{ 0x00F8FE, 0x00C8FE, 1, WW, MDR2R, NNN,   NNN, C_D2S,           "DEC"},		// dec r1 -> 1111 111w: 11 001 reg
	{ 0x0000F8, 0x000048, 1, 0,  MDR2_A,NNN,   NNN, C_D2S,           "DEC"},		// dec r1 -> 0100 1 reg
	{ 0x0038FE, 0x0008FE, 1, WW, MM1,   NNN,   NNN, C_D2S,           "DEC"},		// dec MM -> 1111 111w: mod 0001 r/m

																	     
	{ 0x00F8FE, 0x00F0F6, 1, WW,  MDR2, NNN,   NNN, C_DS_EAXEDX_EAX, "DIV"},		// AC,r1 -> 1111 011w: 11 111 reg
	{ 0x0038FE, 0x0030F6, 1, WW,  MM2,  NNN,   NNN, C_DS_EAXEDX_EAX, "DIV"},		// AC,MM -> 1111 011w: mod 110 r/m

	{ 0x0000FF, 0x0000C8, 1, 0,   IMM_SEL_E, IMM8E, NNN, C_D_ESP,    "ENTER"},    // ENTER -> 1100 1000: 16 bit displacment: 8bit level(L)

	{ 0x0000FF, 0x0000F4, 1, 0,   NNN,  NNN,   NNN, C_NNN,           "HLT"},		// HLT ->	1111 0100

	{ 0x00F8FE, 0x00F8F6, 1, WW,  MDR2,  NNN,  NNN, C_DS_EAXEDX_EAX, "IDIV"},		// AC,r1 ->	1111 011w: 11 111 reg
	{ 0x0038FE, 0x0038F6, 1, WW,  MM2,   NNN,  NNN, C_DS_EAXEDX_EAX, "IDIV"},		// AC,MM ->	1111 011w: mod 111 r/m

	{ 0x00F8FE, 0x00E8F6, 1, WW,  MDR2,  NNN,  NNN, C_DS_EAXEDX_EAX, "IMUL"},		// AC,r1 -> 1111 011w: 11 101 reg
	{ 0x0038FE, 0x0028F6, 1, WW,  MM2,   NNN,  NNN, C_DS_EAXEDX_EAX, "IMUL"},      // AC,MM -> 1111 011w: mod 101 reg
	{ 0xC0FFFF, 0xC0AF0F, 2, 0,   MDR1,  MDR2, NNN, C_DS_EAXEDX_EAX, "IMUL"},      // r1,r2 -> 0000 1111: 1010 1111: 11: reg1 reg2
	{ 0x00FFFF, 0x00AF0F, 2, 0,   MDR1,  MM2,  NNN, C_DS_EAXEDX_EAX, "IMUL"},		// r1,MM -> 0000 1111: 1010 1111: mod reg r/m
	{ 0x0080FD, 0x008069, 1, SS,  MDR1,  MDR2, IMM, C_DS_EAXEDX_EAX, "IMUL"},      // r1,IM2r2 -> 0110 10s1: 11 reg1 reg2: IMM DATA
	{ 0x0000FD, 0x000069, 1, SS,  MDR1,  MM2,  IMMI,C_DS_EAXEDX_EAX, "IMUL"},		// MM,IM2reg -> 0110 10s1: mod reg r/m: IMM DATA


	{ 0x0000FE, 0x0000E4, 1, WW,  ACC,   IMM8C,NNN, C_NNN,           "IN"},		// fixed port -> 1110 010w: port number
	{ 0x0000FE, 0x0000EC, 1, WW,  ACC,   REG_DX,NNN, C_NNN,          "IN"},        // variable port -> 1110 110w

	{ 0x00F8FE, 0x00C0FE, 1, WW,  MDR2R, NNN,  NNN, C_D2S,           "INC"},		// r1 -> 1111 111w -> 11 000 reg
	{ 0x0000F8, 0x000040, 1, 0,   MDR2_A,NNN,  NNN, C_D2S,           "INC"},       // r1 (a.e) -> 0100 0 reg
	{ 0x0038FE, 0x0000FE, 1, WW,  MM1,   NNN,  NNN, C_D2S,           "INC"},       // MM -> 1111 111w: mod 000 r/m
	
	{ 0x0000FE, 0x00006C, 1, WW|NA,NNN,  NNN,  NNN,  C_S_EDX ,       "INSS*"},       // from DX port -> 0110 110w

	{ 0x0000FF, 0x0000CD, 1, 0,   IMM8CN,NNN,  NNN, C_D_ESP,         "INT"},		// INT N -> 1100 1101: n(type)
	{ 0x0000FF, 0x0000CC, 1, 0,   NNN,   NNN,  NNN, C_NNN,           "INT 0x3"},		// INT 3 -> 1100 1100
	{ 0x0000FF, 0x0000CE, 1, 0,   NNN,   NNN,  NNN, C_NNN,           "INTO"},		// INTO -> 1100 1110
	{ 0x00FFFF, 0x00080F, 2, 0,   NNN,   NNN,  NNN, C_NNN,           "INVD"},		// INVD -> 0000 1111: 0000 1000
	{ 0x38FFFF, 0x38010F, 2, 0,   NNN,   NNN,  NNN, C_NNN,           "INVLPG"},    // INVLPG -> 0000 1111: 0000 0001: mod 111 /rm
	{ 0x0000FF, 0x0000CF, 1, 0,   NNN,   NNN,  NNN, C_DS_ESP,        "IRET/IRETD"}, // IRET -> 1100 1111

	{ 0x0000F0, 0x000070, 1, NA,  JTTTN, IMM8C,NNN, C_NNN,           "JCC"},		// JCC -> 0111 tttn: 8 bit displacement
	{ 0x00F0FF, 0x00800F, 2, NA,  JTTTN, IMM32C,NNN,C_NNN,           "JCC"},       // JCC -> 0000 1111: 1000 tttn: full displacement
	{ 0x0000FF, 0x0000E3, 1, 0,   NNN,   IMM8C,  NNN, C_NNN,         "JECXZ"}, // JCXZ -> 1110 0011: 8 bit displacement

																			// JMP - same segment
	{ 0x0000FF, 0x0000EB, 1, 0,   IMM8C, NNN,  NNN, C_NNN,           "JMP SHORT"}, // JMP SHORT -> 1110 1011: 8 bit displacement
	{ 0x0000FF, 0x0000E9, 1, 0,   IMM32C,NNN,  NNN, C_NNN,           "JMP"},		// JMP DIRECT -> 1110 1001: full displacement
	{ 0x00F8FF, 0x00E0FF, 1, 0,   MDR2,  NNN,  NNN, C_NNN,           "JMP"},       // JMP R.INDIRECT -> 1111 1111: 11 100 reg
	{ 0x0038FF, 0x0020FF, 1, 0,   MM2,   NNN,  NNN, C_NNN,           "JMP"},       // JMP M.INDIRECT -> 1111 1111: mod 100 r/m

																			// JMP - other segment
	{ 0x0000FF, 0x0000EA, 1, 0,   IMM32C,IMM_SEL, NNN, C_NNN,        "JMP"},		// JMP DIRECT ISEG -> 1110 1010: unsigned full offset, selector
	{ 0x0038FF, 0x0028FF, 1, 0,   MM2CE, NNN,  NNN, C_NNN,           "JMP"},       // JMP INDIRECT ISEG -> 1111 1111: mod 101 r/m 

	{ 0x0000FF, 0x00009F, 1, 0,   NNN,   NNN,  NNN, C_D_EAX,         "LAHF"},      // LAHF -> 1001 1111

	{ 0xC0FFFF, 0xC0020F, 2, 0,   MDR1, MDR2,  NNN, C_NNN,           "LAR"},		// LAR from reg -> 0000 1111: 0000 0010: 11 reg1 reg2
	{ 0x00FFFF, 0x00020F, 2, 0,   MDR1, MM2,   NNN, C_NNN,           "LAR"},       // LAR from mem -> 0000 1111: 0000 0010: mod reg r/m

	{ 0x0000FF, 0x0000C5, 1, 0,   MDR1, MM2_EF,NNN, C_NNN,           "LDS"},       // LDS -> 1100 0101: mod^A reg r/m
	{ 0x0000FF, 0x00008D, 1, 0,   MDR1, MM2,   NNN, C_NNN,           "LEA"},       // LEA -> 1000 1101: mod^A reg r/m
	{ 0x0000FF, 0x0000C9, 1, 0,   NNN,  NNN,   NNN, C_D_EBPESP,      "LEAVE"},		// LEAVE -> 1100 1001
	{ 0x0000FF, 0x0000C4, 1, 0,   MDR1, MM2_EF,NNN, C_NNN,           "LES"},       // LES -> 1100 0100: mod^A reg r/m
	{ 0x00FFFF, 0x00B40F, 2, 0,   MDR1, MM2_EF,NNN, C_NNN,           "LFS"},       // LFS -> 0000 1111: 1011 0100: mod^A reg r/m
	{ 0x38FFFF, 0x10010F, 2, 0,   MM2CE,NNN,   NNN, C_NNN,           "LGDT"},      // LGDT -> 0000 1111: 0000 0001: mod^A 010 r/m
	{ 0x00FFFF, 0x00B50F, 2, 0,   MDR1, MM2_EF,NNN, C_NNN,           "LGS"},       // LGS -> 0000 1111: 1011 0101: mod^A reg r/m
	{ 0x38FFFF, 0x18010F, 2, 0,   MM2CE,NNN,   NNN, C_NNN,           "LIDT"},      // LIDT -> 0000 1111: 0000 0001: mod^A 011 r/m

	{ 0xF8FFFF, 0xD0000F, 2, 0,   MDR2R_16,NNN,NNN, C_NNN,           "LLDT"},      // LLDT from reg -> 0000 1111: 0000 0000: 11 010 reg
	{ 0x38FFFF, 0x10000F, 2, 0,   MM1_16,NNN,  NNN, C_NNN,           "LLDT"},      // LLDT from mem -> 0000 1111: 0000 0000: mod 010 r/m

	{ 0xF8FFFF, 0xF0010F, 2, 0,   MDR2R_16,NNN,NNN, C_NNN,           "LMSW"},      // LMSW from reg -> 0000 1111: 0000 0001: 11 110 reg
	{ 0x38FFFF, 0x30010F, 2, 0,   MM1_16,NNN,  NNN, C_NNN,           "LMSW"},      // LMSW from mem -> 0000 1111: 0000 0001: mod 110 r/m

	{ 0x0000FE, 0x0000AC, 1, WW|NA,NNN,  NNN,  NNN, C_DS_EAX_ESI,    "LODS*"},      // LODS(X) -> 1010 110w
	{ 0x0000FF, 0x0000E2, 1, 0,   IMM8C, NNN,  NNN, C_DS_ECX,        "LOOP"},      // LOOP -> 1110 0010: 8 bit displacement
	{ 0x0000FF, 0x0000E1, 1, 0,   IMM8C, NNN,  NNN, C_DS_ECX,        "LOOPE"},     // LOOPE/Z -> 1110 0001: 8 bit displacement
	{ 0x0000FF, 0x0000E0, 1, 0,   IMM8C, NNN,  NNN, C_DS_ECX,        "LOOPNE"},    // LOOPNE/NZ -> 1110 0000: 8 bit displacement

	{ 0xC0FFFF, 0xC0030F, 2, 0,   MDR1,  MDR2, NNN, C_NNN,           "LSL"},       // LSL from reg -> 0000 1111: 0000 0011: 11 reg1 reg2
	{ 0x00FFFF, 0x00030F, 2, 0,   MDR1,  MM2,  NNN, C_NNN,           "LSL"},       // LSL from mem -> 0000 1111: 0000 0011: mod reg r/m

	{ 0x00FFFF, 0x00B20F, 2, 0,   MDR1,  MM2_EF,NNN,C_NNN,           "LSS"},       // LSS -> 0000 1111: 1011 0010: mod^A reg r/m

	{ 0xF8FFFF, 0xD8000F, 2, 0,   MDR2R_16,NNN,NNN, C_D2SN,          "LTR"},       // LTR from reg -> 0000 1111: 0000 0000: 11 0111 reg
	{ 0x38FFFF, 0x18000F, 2, 0,   MM1_16,NNN,  NNN, C_NNN,           "LTR"},	   // LTR from mem -> 0000 1111: 0000 0000: mod 011 r/m

	{ 0x00C0FE, 0x00C088, 1, WW,  MDR1R,MDR2R, NNN, C_NNN,           "MOV"},		// MOV r1, r2  -> 1000 100w: 11 r1 r2
	{ 0x00C0FE, 0x00C08A, 1, WW,  MDR1, MDR2,  NNN, C_NNN,           "MOV"},		// MOV r2, r1  -> 1000 101w: 11 r1 r2
	{ 0x0000FE, 0x00008A, 1, WW,  MDR1, MM2,   NNN, C_NNN,           "MOV"},		// MOV reg, MM -> 1000 101w: mod reg r/m
	{ 0x0000FE, 0x000088, 1, WW,  MDR1R,MM1,   NNN, C_NNN,           "MOV"},		// MOV MM, reg -> 1000 100w: mod reg r/m
	{ 0x00F8FE, 0x00C0C6, 1, WW,  MDR2R,IMM,   NNN, C_NNN,           "MOV"},		// MOV reg, IM -> 1100 011w: 11 000 reg: IM
	{ 0x0000F0, 0x0000B0, 1, W3,  MDR2_A,IMMC, NNN, C_NNN,           "MOV"},		// MOV reg, IM -> 1011 w reg: IM
	{ 0x0038FE, 0x0000C6, 1, WW,  MM1,  IMMS,   NNN, C_NNN,          "MOV"},		// MOV MM, IM  -> 1100 011w: mod 000 r/m: IM
	{ 0x0000FE, 0x0000A0, 1, WW,  ACC,  MM2_FD,NNN, C_NNN,           "MOV"},		// MOV AC, MM  -> 1010 000w: FULL DISP
	{ 0x0000FE, 0x0000A2, 1, WW,  ACCR, MM1_FD,NNN, C_NNN,           "MOV"},		// MOV MM, AC  -> 1010 001w: FULL DISP
	
	{ 0xF8FFFF, 0xC0220F, 2, 0,   CRX, MDR2,   NNN, C_NNN,           "MOV"},		// MOV CR0, r1 -> 0000 1111: 0010 0010: 11 000 r1
	{ 0xF8FFFF, 0xD0220F, 2, 0,   CRX, MDR2,   NNN, C_NNN,           "MOV"},		// MOV CR2, r1 -> 0000 1111: 0010 0010: 11 010 r1
	{ 0xF8FFFF, 0xD8220F, 2, 0,   CRX, MDR2,   NNN, C_NNN,           "MOV"},		// MOV CR3, r1 -> 0000 1111: 0010 0010: 11 011 r1
	{ 0xF8FFFF, 0xE0220F, 2, 0,   CRX, MDR2,   NNN, C_NNN,           "MOV"},		// MOV CR4, r1 -> 0000 1111: 0010 0010: 11 100 r1
	{ 0xC0FFFF, 0xC0200F, 2, 0,   CRX, MDR2R,  NNN, C_NNN,           "MOV"},		// MOV r1, CRX -> 0000 1111: 0010 0000: 11 eee r1

	{ 0xC0FFFF, 0xC0230F, 2, 0,   DRX, MDR2,   NNN, C_NNN,           "MOV"},		// MOV D0/7,r1 -> 0000 1111: 0010 0011: 11 eee r1
	{ 0xC0FFFF, 0xC0210F, 2, 0,   DRX, MDR2R,  NNN, C_NNN,           "MOV"},		// MOV r1,D0/7 -> 0000 1111: 0010 0001: 11 eee r1

	{ 0x00C0FF, 0x00C08E, 1, 0,   SREG3,MDR2,  NNN, C_NNN,           "MOV"},		// MOV sR1, r2 -> 1000 1110: 11 sreg3 r2
	{ 0x0000FF, 0x00008E, 1, 0,   SREG3,MM2,   NNN, C_NNN,           "MOV"},		// MOV sR1, MM -> 1000 1110: mod sreg3 r/m
	{ 0x00C0FF, 0x00C08C, 1, 0,   MDR2R,SREG3, NNN, C_NNN,           "MOV"},		// MOV r2, sR1 -> 1000 1100: 11 sreg3 r2
	{ 0x0000FF, 0x00008C, 1, 0,   MM1,  SREG3, NNN, C_NNN,           "MOV"},		// MOV MM, sR1 -> 1000 1100: mod sreg3 r/m


	{ 0x0000FE, 0x0000A4, 1, WW|NA,NNN, NNN,   NNN, C_DS_EDI_ESI,    "MOVS*"},		// MOVS(B) -> 1010 010w


	{ 0xC0FFFF, 0xC0BE0F, 2, 0,    MDR1,MDR2_8,NNN,C_NNN,            "MOVSX"},		// MOVSX r1, r2 -> 0000 1111: 1011 111w: 11 r1 r2
	{ 0xC0FEFF, 0xC0BE0F, 2, WW,   MDR1,MDR2_16,NNN,C_NNN,           "MOVSX"},		// MOVSX r1, r2 -> 0000 1111: 1011 111w: 11 r1 r2
	{ 0x00FFFF, 0x00BE0F, 2, 0,    MDR1,MM_8,  NNN, C_NNN,           "MOVSX"},		// MOVSX r1, MM -> 0000 1111: 1011 111w: mod reg r/m
	{ 0x00FEFF, 0x00BE0F, 2, WW,   MDR1,MM_16, NNN, C_NNN,           "MOVSX"},		// MOVSX r1, MM -> 0000 1111: 1011 111w: mod reg r/m

	{ 0xC0FFFF, 0xC0B60F, 2, 0,    MDR1,MDR2_8,NNN,C_NNN,            "MOVZX"},		// MOVZX r1, r2 -> 0000 1111: 1011 011w: 11 r1 r2
	{ 0xC0FEFF, 0xC0B60F, 2, WW,   MDR1,MDR2_16,NNN,C_NNN,           "MOVZX"},		// MOVZX r1, r2 -> 0000 1111: 1011 011w: 11 r1 r2
	{ 0x00FFFF, 0x00B60F, 2, 0,    MDR1,MM_8,  NNN, C_NNN,           "MOVZX"},		// MOVZX r1, MM -> 0000 1111: 1011 011w: mod reg r/m
	{ 0x00FEFF, 0x00B60F, 2, WW,   MDR1,MM_16, NNN, C_NNN,           "MOVZX"},		// MOVZX r1, MM -> 0000 1111: 1011 011w: mod reg r/m

	{ 0x00F8FE, 0x00E0F6, 1, WW,  MDR2, NNN,   NNN, C_DS_EAXEDX_EAX, "MUL"},		// MUL AC with r1 -> 1111 011w: 11 100 r1
	{ 0x0038FE, 0x0020F6, 1, WW,  MM2,  NNN,   NNN, C_DS_EAXEDX_EAX, "MUL"},		// MUL AC with MM -> 1111 011w: mod 100 r1
	{ 0x00F8FE, 0x00D8F6, 1, WW,  MDR2R,NNN,   NNN, C_D2S,           "NEG"},		// NEG r1 -> 1111 011w: 11 011 r1
	{ 0x0038FE, 0x0018F6, 1, WW,  MM1,  NNN,   NNN, C_NNN,           "NEG"},		// NEG MM -> 1111 011w: mod 011 r/m
	{ 0x0000FF, 0x000090, 1, 0,   NNN,  NNN,   NNN, C_NNN,           "NOP"},		// NOP -> 1001 0000
	{ 0x00F8FE, 0x00D0F6, 1, WW,  MDR2R,NNN,   NNN, C_D2S,           "NOT"},		// NOT r1 -> 1111 011w: 11 010 r1
	{ 0x0038FE, 0x0010F6, 1, WW,  MM1,  NNN,   NNN, C_NNN,           "NOT"},		// NOT MM -> 1111 011w: mod 010 r/m

	{ 0x00C0FE, 0x00C008, 1, WW,  MDR1R,MDR2R, NNN, C_D2S_NN,        "OR"},		// OR r1, r2 -> 0000 100w: 11 r1 r2
	{ 0x00C0FE, 0x00C00A, 1, WW,  MDR1, MDR2,  NNN, C_D2S_NN,        "OR"},		// OR r2, r1 -> 0000 101w: 11 r2 r2
	{ 0x0000FE, 0x00000A, 1, WW,  MDR1, MM2,   NNN, C_D2S_NN,        "OR"},		// OR r1, MM -> 0000 101w: mod reg r/m
	{ 0x0000FE, 0x000008, 1, WW,  MDR1R,MM1,   NNN, C_NNN,           "OR"},		// OR MM, r1 -> 0000 100w: mod reg r/m
	{ 0x00F8FC, 0x00C880, 1, WS,  MDR2R,IMM,   NNN, C_D2S_NN,        "OR"},		// OR r1, IM -> 1000 00sw: 11 001 r1: IM
	{ 0x0000FE, 0x00000C, 1, WW,  ACC,  IMMC,  NNN, C_D2S_NN,        "OR"},		// OR AC, IM -> 0000 110w: IM
	{ 0x0038FC, 0x000880, 1, WS,  MM1,  IMMS,  NNN, C_NNN,           "OR"},		// OR MM, IM -> 1000 00sw: mod 001 r/m: IM

	{ 0x0000FE, 0x0000E6, 1, WW,  ACC,  IMM8C, NNN, C_NNN,           "OUT"},		// OUT fixed port -> 1110 011w: PORT NR
	{ 0x0000FE, 0x0000EE, 1, WW,  ACC,  REG_DX,NNN, C_NNN,           "OUT"},		// OUT variable port -> 1110 111w
	{ 0x0000FE, 0x00006E, 1, WW|NA,NNN, NNN,   NNN, C_S_EDX,         "OUTS*"},		// OUTS to DX -> 0110 111w

	{ 0x00F8FF, 0x00C08F, 1, 0,   MDR2R,NNN,   NNN, C_DS_ESP,        "POP"},		// POP r1 -> 1000 1111: 11 000 reg
	{ 0x0000F8, 0x000058, 1, 0,   MDR2_A,NNN,  NNN, C_DS_ESP,        "POP"},		// POP r1 -> 0101 1 reg
	{ 0x0038FF, 0x00008F, 1, 0,   MM1,  NNN,   NNN, C_DS_ESP,        "POP"},		// POP MM -> 1000 1111: mod 000 r/m
	{ 0x00C7FF, 0x00810F, 1, 0,   SREG3,NNN,   NNN, C_DS_ESP,        "POP"},		// POP FS/GS -> 0000 1111: 10 sreg3 001

    { 0x0000FF, 0x000061, 1, 0,   NNN,  NNN,   NNN, C_D_ALL,         "POPAD"},		// POPAD -> 0110 0001
	{ 0x0000FF, 0x00009D, 1, 0,   NNN,  NNN,   NNN, C_NNN,           "POPFD"},		// POPFD -> 1001 1101

	{ 0x00F8FF, 0x00F0FF, 1, 0,   MDR2R,NNN,   NNN, C_DS_ESP_N,      "PUSH"},		// PUSH r1 -> 1111 1111: 11 110 r1
	{ 0x0000F8, 0x000050, 1, 0,   MDR2_A,NNN,  NNN, C_DS_ESP_N,      "PUSH"},		// PUSH r1 -> 0101 0 reg
	{ 0x0038FF, 0x0030FF, 1, 0,   MM1,  NNN,   NNN, C_DS_ESP,        "PUSH"},		// PUSH MM -> 1111 1111: mod 110 r/m
	{ 0x0000FD, 0x000068, 1, SS,  IMMC, NNN,   NNN, C_DS_ESP,        "PUSH"},		// PUSH IM -> 0110 10s0: IM
	{ 0x0000E7, 0x000006, 1, 0,   SREG2, NNN,  NNN, C_DS_ESP,        "PUSH"},		// PUSH CS/DS/ES/SS -> 000 sreg2 110
	{ 0x00C7FF, 0x00800F, 1, 0,   SREG3, NNN,  NNN, C_DS_ESP,        "PUSH"},		// PUSH FS/GS -> 0000 1111: 10 sreg3 000

	{ 0x0000FF, 0x000060, 1, 0,   NNN, NNN,    NNN, C_S_ALL,         "PUSHAD"},		// PUSHAD -> 0110 0000
	{ 0x0000FF, 0x00009C, 1, 0,   NNN, NNN,    NNN, C_DS_ESP,        "PUSHFD"},		// PUSHFD -> 1001 1100


	{ 0x00F8FE, 0x00D0D0, 1, WW,  MDR2R, IMM1, NNN, C_D2S_NN,        "RCL"},		// RCL r1,1 -> 1101 000w: 11 010 r1
	{ 0x0038FE, 0x0010D0, 1, WW,  MM1, IMM1,   NNN, C_NNN,           "RCL"},		// RCL MM, 1 -> 1101 000w: mod 010 r/m
	{ 0x00F8FE, 0x00D0D2, 1, WW,  MDR2R, REG_CL, NNN, C_D2S_NN,      "RCL"},		// RCL r1,cl -> 1101 001w: 11 010 reg
	{ 0x0038FE, 0x0010D2, 1, WW,  MM1, REG_CL, NNN, C_NNN,           "RCL"},		// RCL MM,cl -> 1101 001w: mod 010 r/m
	{ 0x00F8FE, 0x00D0C0, 1, WW,  MDR2R, IMM8, NNN, C_D2S_NN,        "RCL"},		// RCL r1,IM -> 1100 000w: 11 010 reg: NNN
	{ 0x0038FE, 0x0010C0, 1, WW,  MM1, IMM8S,  NNN, C_NNN,           "RCL"},		// RCL MM,IM -> 1100 000w: mod 010 r/m: NNN

	{ 0x00F8FE, 0x00D8D0, 1, WW,  MDR2R, IMM1, NNN, C_D2S_NN,        "RCR"},		// RCR r1,1 -> 1101 000w: 11 011 r1
	{ 0x0038FE, 0x0018D0, 1, WW,  MM1, IMM1,   NNN, C_NNN,           "RCR"},		// RCR MM,1 -> 1101 000w: mod 011 r/m
	{ 0x00F8FE, 0x00D8D2, 1, WW,  MDR2R, REG_CL, NNN, C_D2S_NN,      "RCR"},		// RCR r1,cl -> 1101 001w: 11 011 r1
	{ 0x0038FE, 0x0018D2, 1, WW,  MM1, REG_CL, NNN, C_NNN,           "RCR"},		// RCR MM,cl -> 1101 001w: mod 011 r/m
	{ 0x00F8FE, 0x00D8C0, 1, WW,  MDR2R, IMM8, NNN, C_D2S_NN,        "RCR"},		// RCR r1,IM -> 1100 000w: 11 011 reg: NNN
	{ 0x0038FE, 0x0018C0, 1, WW,  MM1, IMM8S,  NNN, C_NNN,           "RCR"},		// RCR MM,IM -> 1100 000w: mod 011 r/m: NNN


	{ 0x0000FF, 0x0000C3, 1, 0,   NNN, NNN,    NNN, C_DS_ESP,        "RET"},		// RET (same seg)-> 1100 1011
	{ 0x0000FF, 0x0000C2, 1, 0,   IMM16C,NNN,  NNN, C_DS_ESP,        "RET"},		// RET ARG (same seg) -> 1100 0010: 16-bit DISP
	{ 0x0000FF, 0x0000CB, 1, 0,   NNN, NNN,    NNN, C_DS_ESP,        "RET FAR"},		// RET (other seg) -> 1100 1011
	{ 0x0000FF, 0x0000CA, 1, 0,   IMM16C,NNN,  NNN, C_DS_ESP,        "RET FAR"},		// RET ARG (other seg) -> 1100 1010: 16-bit DISP


	{ 0x00F8FE, 0x00C0D0, 1, WW,  MDR2R, IMM1, NNN, C_D2S_NN,        "ROL"},		// ROL r1,1 -> 1101 000w: 11 000 r1
	{ 0x0038FE, 0x0000D0, 1, WW,  MM1,   IMM1, NNN, C_NNN,           "ROL"},		// ROL MM,1 -> 1101 000w: mod 000 r/m
	{ 0x00F8FE, 0x00C0D2, 1, WW,  MDR2R, REG_CL, NNN, C_D2S_NN,      "ROL"},		// ROL r1,cl -> 1101 001w: 11 000 r1
	{ 0x0038FE, 0x0000D2, 1, WW,  MM1,   REG_CL, NNN, C_NNN,         "ROL"},		// ROL MM,cl -> 1101 001w: mod 000 r/m
	{ 0x00F8FE, 0x00C0C0, 1, WW,  MDR2R, IMM8, NNN, C_D2S_NN,        "ROL"},		// ROL r1,IM -> 1100 000w: 11 000 r1: NNN
	{ 0x0038FE, 0x0000C0, 1, WW,  MM1,   IMM8S,NNN, C_NNN,           "ROL"},		// ROL MM,IM -> 11000 000w: mod 000 r/m: NNN

	{ 0x00F8FE, 0x00C8D0, 1, WW,  MDR2R, IMM1, NNN, C_D2S_NN,        "ROR"},		// ROR r1,1 -> 1101 000w: 11 001 r1
	{ 0x0038FE, 0x0008D0, 1, WW,  MM1,   IMM1, NNN, C_NNN,           "ROR"},		// ROR MM,1 -> 1101 000W: mod 001 r/m
	{ 0x00F8FE, 0x00C8D2, 1, WW,  MDR2R, REG_CL, NNN, C_D2S_NN,      "ROR"},		// ROR r1,cl -> 1101 001w: 11 001 r1
	{ 0x0038FE, 0x0008D2, 1, WW,  MM1,   REG_CL, NNN, C_NNN,         "ROR"},		// ROR MM,cl -> 1101 001w: mod 001 r/m
	{ 0x00F8FE, 0x00C8C0, 1, WW,  MDR2R, IMM8, NNN, C_D2S_NN,        "ROR"},		// ROR r1,IM -> 1100 000w: 11 001 r1: NNN
	{ 0x0038FE, 0x0008C0, 1, WW,  MM1,   IMM8S,NNN, C_NNN,           "ROR"},		// ROR MM,IM -> 1100 000w: mod 001 r/m: NNN

	{ 0x00F8FE, 0x00F8D0, 1, WW,  MDR2R, IMM1, NNN, C_D2S_NN,        "SAR"},		// SAR r1,1 -> 1101 000w: 11 111 r1
	{ 0x0038FE, 0x0038D0, 1, WW,  MM1,   IMM1, NNN, C_NNN,           "SAR"},		// SAR MM,1 -> 1101 000w: mod 111 r/m
	{ 0x00F8FE, 0x00F8D2, 1, WW,  MDR2R, REG_CL, NNN, C_D2S_NN,      "SAR"},		// SAR r1,cl -> 1101 001w: 11 111 r1
	{ 0x0038FE, 0x0038D2, 1, WW,  MM1,   REG_CL, NNN, C_NNN,         "SAR"},		// SAR MM,cl -> 1101 001w: mod 111 r/m
	{ 0x00F8FE, 0x00F8C0, 1, WW,  MDR2R, IMM8, NNN, C_D2S_NN,        "SAR"},		// SAR r1,IM -> 1100 000w: 11 111 reg: NNN
	{ 0x0038FE, 0x0038C0, 1, WW,  MM1,   IMM8S,NNN, C_NNN,           "SAR"},		// SAR MM,IM -> 1100 000w: mod 111 r/m: NNN

	{ 0x00C0FE, 0x00C018, 1, WW,  MDR1R, MDR2R,NNN, C_D2S_NN,        "SBB"},		// SBB r1,r2 -> 0001 100w: 11 r1 r2
	{ 0x00C0FE, 0x00C01A, 1, WW,  MDR1,  MDR2, NNN, C_D2S_NN,        "SBB"},		// SBB r2,r1 -> 0001 101w: 11 r2 r2
	{ 0x0000FE, 0x00001A, 1, WW,  MDR1,  MM2,  NNN, C_D2S_NN,        "SBB"},		// SBB r1,MM -> 0001 101w: mod reg r/m
	{ 0x0000FE, 0x000018, 1, WW,  MDR1R, MM1,  NNN, C_NNN,           "SBB"},		// SBB MM,r1 -> 0001 100w: mod reg r/m
	{ 0x00F8FC, 0x00D880, 1, WS,  MDR2R, IMM,  NNN, C_D2S_NN,        "SBB"},		// SBB r1,IM -> 100000sw: 11 011 reg: NNN
	{ 0x0000FE, 0x00001C, 1, WW,  ACC,   IMMC, NNN, C_D2S_NN,        "SBB"},		// SBB AC,IM -> 0001 110w: NNN
	{ 0x0038FC, 0x001880, 1, WS,  MM1,   IMMS, NNN, C_NNN,           "SBB"},		// SBB MM,IM -> 1000 00sw: mod 011 r/m: NNN

	{ 0x0000FE, 0x0000AE, 1, WW|NA,NNN,  NNN, NNN,  C_S_EDIESIEAX,   "SCAS*"},		// SCASB -> 1010 111w
	{ 0xF8F0FF, 0xC0900F, 2, 0,   JTTTNS,MDR2R_8, NNN, C_NNN,        "SETcc"},		// SETcc r1 -> 0000 1111: 1001 NNN: 11 000 r1
	{ 0x38F0FF, 0x00900F, 2, 0,   JTTTNS,MM2R_8,NNN, C_NNN,          "SETcc"},		// SETcc MM -> 0000 1111: 1001 NNN: mod 000 r/m

	{ 0x00F8FE, 0x00E0D0, 1, WW,  MDR2R, IMM1, NNN, C_D2S_NN,        "SHL"},		// SHL r1,1 -> 1101 000w: 11 100 r1
	{ 0x0038FE, 0x0020D0, 1, WW,  MM1,   IMM1, NNN, C_NNN,           "SHL"},		// SHL MM,1 -> 1101 000w: mod 1000 r/m
	{ 0x00F8FE, 0x00E0D2, 1, WW,  MDR2R, REG_CL, NNN, C_D2S_NN,      "SHL"},		// SHL r1,cl -> 1101 001w: 11 100 r1
	{ 0x0038FE, 0x0020D2, 1, WW,  MM1,   REG_CL, NNN, C_NNN,         "SHL"},		// SHL MM,cl -> 1101 001w: mod 100 r/m
	{ 0x00F8FE, 0x00E0C0, 1, WW,  MDR2R, IMM8, NNN, C_D2S_NN,        "SHL"},		// SHL r1,IM -> 1100 000w: 11 100 reg: NNN
	{ 0x0038FE, 0x0020C0, 1, WW,  MM1,   IMM8S,NNN, C_NNN,           "SHL"},		// SHL MM,IM -> 1100 000w: mod 100 r/m: NNN

	{ 0xC0FFFF, 0xC0A40F, 2, 0,   MDR1R, MDR2R, IMMI8,C_D2S_NN,      "SHLD"},		// SHLD r1,IM ->0000 1111: 1010 0100: 11 r2 r1: NNN
	{ 0x00FFFF, 0x00A40F, 2, 0,   MM1,   MDR1R, IMMI8,C_NNN,         "SHLD"},		// SHLD MM,IM ->0000 1111: 1010 0100:mod reg r/m:IM8
	{ 0xC0FFFF, 0xC0A50F, 2, 0,   MDR1R, MDR2R, REG_CL_I, C_S_CL_N,  "SHLD"},		// SHLD r1,cl ->0000 1111: 1010 0101: 11 r2 r2
	{ 0x00FFFF, 0x00A50F, 2, 0,   MM1,   MDR1R, REG_CL_I, C_S_CL,    "SHLD"},		// SHLD MM,cl ->0000 1111: 1010 0101: mod reg r/m

	
	{ 0x00F8FE, 0x00E8D0, 1, WW,  MDR2R, IMM1, NNN, C_D2S_NN,        "SHR"},		// SHR r1,1 -> 1101 000w: 11 101 reg
	{ 0x0038FE, 0x0028D0, 1, WW,  MM1,   IMM1, NNN, C_NNN,           "SHR"},		// SHR MM,1 -> 1101 000w: mod 101 r/m
	{ 0x00F8FE, 0x00E8D2, 1, WW,  MDR2R, REG_CL, NNN, C_D2S_NN,      "SHR"},		// SHR r1,cl -> 1101 001w: 11 101 reg
	{ 0x0038FE, 0x0028D2, 1, WW,  MM1,   REG_CL, NNN, C_NNN,         "SHR"},		// SHR MM,cl -> 1101 001w: mod 101 r/m
	{ 0x00F8FE, 0x00E8C0, 1, WW,  MDR2R, IMM8, NNN, C_D2S_NN,        "SHR"},		// SHR r1,IM -> 1100 000w: 11 101 XXX: NNN
	{ 0x0038FE, 0x0028C0, 1, WW,  MM1,   IMM8S,NNN, C_NNN,           "SHR"},		// SHR MM,IM -> 1100 000w: mod 101 r/m: NNN

	{ 0xC0FFFF, 0xC0AC0F, 2, 0,   MDR1R, MDR2R, IMMI8, C_D2S_NN,     "SHRD"},		// SHRD r1,IM->0000 1111: 1010 1100: 11 r2 r1: NNN
	{ 0x00FFFF, 0x00AC0F, 2, 0,   MM1,   MDR1R, IMMI8, C_NNN,        "SHRD"},		// SHRD MM,IM->0000 1111: 1010 1100:mod reg r/m:NNN
	{ 0xC0FFFF, 0xC0AD0F, 2, 0,   MDR1R, MDR2R, REG_CL_I, C_S_CL_N,  "SHRD"},		// SHRD r1,cl->00001111: 1010 1101: 11 r2 r1
	{ 0x00FFFF, 0x00AD0F, 2, 0,   MM1,   MDR1R, REG_CL_I, C_S_CL,    "SHRD"},		// SHRD MM,cl->00001111:1010 1101: mod reg r/m

	{ 0x38FFFF, 0x08010F, 2, 0,   MM2_EF,NNN,   NNN, C_NNN,         "SIDT"},		// SIDT -> 0000 1111: 0000 0001: mod^a 001 r/m
	{ 0xF8FFFF, 0xC0000F, 2, 0,   MDR2_16,NNN,  NNN, C_NNN,         "SLDT"},		// SLDT to r1 -> 0000 1111: 0000 0000: 11 000 r1
	{ 0x38FFFF, 0x00000F, 2, 0,   MM1_16,NNN,   NNN, C_NNN,         "SLDT"},		// SLDT to MM -> 0000 1111: 0000 0000: mod 000 r/m

	{ 0xF8FFFF, 0xE0010F, 2, 0,   MDR2R_16,NNN, NNN, C_NNN,         "SMSW"},		// SMSW to r1 -> 0000 1111: 0000 0001: 11 100 r1
	{ 0x38FFFF, 0x20010F, 2, 0,   MM1_16,NNN,   NNN, C_NNN,         "SMSW"},		// SMSW to MM -> 0000 1111: 0000 0001: mod 100 r/m
	{ 0x0000FF, 0x0000F9, 1, 0,   NNN,   NNN,   NNN, C_NNN,         "STC"},		// STC -> 1111 1001
	{ 0x0000FF, 0x0000FD, 1, 0,   NNN,   NNN,   NNN, C_NNN,         "STD"},		// STD -> 1111 1101
	{ 0x0000FF, 0x0000FB, 1, 0,   NNN,   NNN,   NNN, C_NNN,         "STI"},		// STI -> 1111 1011
	{ 0x0000FE, 0x0000AA, 1, WW|NA,NNN,  NNN,   NNN, C_S_EDIESIEAX, "STOS*"},		// STOSB -> 1010 101w
	{ 0xF8FFFF, 0xC8000F, 2, 0,   MDR2R_16, NNN,NNN, C_D2SN,        "STR"},		// STR to r1 -> 0000 1111: 0000 0000: 11 001 reg
	{ 0x38FFFF, 0x08000F, 2, 0,   MM1_16,NNN,   NNN, C_NNN,         "STR"},		// STR to MM -> 0000 1111: 0000 0000: mod 001 r/m

	{ 0x00C0FE, 0x00C028, 1, WW,  MDR1R,MDR2R, NNN, C_D2S_NN,       "SUB"},		// SUB r1,r2 -> 0010 100w: 11 r1 r2
	{ 0x00C0FE, 0x00C02A, 1, WW,  MDR1, MDR2,  NNN, C_D2S_NN,       "SUB"},		// SUB r2,r1 -> 0010 101w: 11 r1 r2
	{ 0x0000FE, 0x00002A, 1, WW,  MDR1, MM2,   NNN, C_D2S_NN,       "SUB"},		// SUB MM,r1 -> 0010 101w: mod reg r/m
	{ 0x0000FE, 0x000028, 1, WW,  MDR1R,MM1,   NNN, C_NNN,          "SUB"},		// SUB r1,MM -> 0010 100w: mod reg r/m
	{ 0x00F8FC, 0x00E880, 1, WS,  MDR2R,IMM,   NNN, C_D2S_NN,       "SUB"},		// SUB r1,IM -> 1000 00sw: 11 101 r1: NNN
	{ 0x0000FE, 0x00002C, 1, WW,  ACC,  IMMC,  NNN, C_D2S_NN,       "SUB"},		// SUB AC,IM -> 0010 110w: NNN
	{ 0x0038FC, 0x002880, 1, WS,  MM1,  IMMS,  NNN, C_NNN,          "SUB"},		// SUB MM,IM -> 1000 00sw: mod 101 r/m: NNN


	{ 0x00C0FE, 0x00C084, 1, WW,  MDR1, MDR2,  NNN, C_D2SN,         "TEST"},		// TEST r1,r2 -> 1000 010w: 11 r1 r2
	{ 0x0000FE, 0x000084, 1, WW,  MM1,  MDR1R, NNN, C_D2SN,         "TEST"},		// TEST MM,r1 -> 1000 010w: mod reg r/m
	{ 0x00F8FE, 0x00C0F6, 1, WW,  MDR2R,IMM,   NNN, C_D2SN,         "TEST"},		// TEST r1,IM -> 1111 011w: 11 000 r1: NNN
	{ 0x0000FE, 0x0000A8, 1, WW,  ACC,  IMMC,  NNN, C_D2SN,         "TEST"},		// TEST AC,IM -> 1010 100w: NNN
	{ 0x0038FE, 0x0000F6, 1, WW,  MM1,  IMMS,  NNN, C_D2SN,         "TEST"},		// TEST MM,IM -> 1111 011w: mod 000 r/m: NNN

	{ 0x00FFF0, 0x000B00, 2, 0,   NNN,  NNN,   NNN, C_NNN,          "UD2"},		// UD2 -> 0000 FFFF: 0000 1011
	{ 0xF8FFFF, 0xE0000F, 2, 0,   MDR2R_16,NNN,NNN, C_NNN,          "VERR"},		// VERR r1 -> 0000 1111: 0000 0000: 11 100 r1
	{ 0x38FFFF, 0x20000F, 2, 0,   MM1_16,NNN,  NNN, C_NNN,          "VERR"},		// VERR MM -> 0000 1111: 0000 0000: mod 100 r/m
	{ 0xF8FFFF, 0xE8000F, 2, 0,   MDR2R_16,NNN,NNN, C_NNN,          "VERW"},		// VERW r1 -> 0000 1111: 0000 0000: 11 101 reg
	{ 0x38FFFF, 0x28000F, 2, 0,   MM1_16,NNN,  NNN, C_NNN,          "VERW"},		// VERW MM -> 0000 1111: 0000 0000: mod 101 r/m


	{ 0x0000FF, 0x00009B, 1, 0,   NNN,   NNN,  NNN, C_NNN,          "WAIT"},		// WAIT -> 1001 1011
	{ 0x00FFFF, 0x00090F, 2, 0,   NNN,   NNN,  NNN, C_NNN,          "WBINVD"},		// WBINVD -> 0000 1111: 0000 1001
	{ 0x00FFFF, 0x00300F, 1, 0,   NNN,   NNN,  NNN, C_NNN,          "WRMSR"},		// WRMSR -> 0000 1111: 0011 0000

	{ 0xC0FEFF, 0xC0C00F, 2, WW,  MDR1R,MDR2R, NNN, C_D2S_NN,       "XADD"},		// XADD r1,r2 -> 0000 1111: 1100 000w: 11 r2 r2
	{ 0x00FEFF, 0x00C00F, 2, WW,  MM1, MDR1R,  NNN, C_NNN,          "XADD"},		// XADD MM,r1 -> 0000 1111: 1100 000w: mod reg r/m
	{ 0x00C0FE, 0x00C086, 1, WW,  MDR1,MDR2,   NNN, C_NNN,          "XCHG"},		// XCHG r1,r2 -> 1000 011w: 11 r2 r2
	{ 0x0000F8, 0x000090, 1, 0,   ACC, MDR2_AA, NNN, C_NNN,         "XCHG"},		// XCHG AC,r1 -> 1001 0 reg
	{ 0x0000FE, 0x000086, 1, WW,  MM1, MDR1R,  NNN, C_NNN,          "XCHG"},		// XCHG MM,r1 -> 1000 011w: mod reg r/m
	{ 0x0000FF, 0x0000D7, 1, 0,   NNN, NNN,    NNN, C_NNN,          "XLAT"},		// XLAT -> 1101 0111

	{ 0x00C0FE, 0x00C030, 1, WW,  MDR1R,MDR2R, NNN, C_D2S_NN,       "XOR"},		// XOR r1,r2 -> 0011 000w: 11 r1 r2
	{ 0x00C0FE, 0x00C032, 1, WW,  MDR1, MDR2,  NNN, C_D2S_NN,       "XOR"},		// XOR r2,r1 -> 0011 001w: 11 r2 r2
	{ 0x0000FE, 0x000032, 1, WW,  MDR1, MM2,   NNN, C_D2S_NN,       "XOR"},		// XOR MM,r1 -> 0011 001w: mod reg r/m
	{ 0x0000FE, 0x000030, 1, WW,  MDR1R,MM1,   NNN, C_NNN,          "XOR"},		// XOR r1,MM -> 0011 000w: mod reg r/m
	{ 0x00F8FC, 0x00F080, 1, WS,  MDR2R,IMM,   NNN, C_D2S_NN,       "XOR"},		// XOR r1,IM -> 1000 00sw: 11 110 r1: NNN
	{ 0x0000FE, 0x000034, 1, WW,  ACC,  IMMC,  NNN, C_D2S_NN,       "XOR"},		// XOR AC,IM -> 0011 010w: NNN
	{ 0x0038FC, 0x003080, 1, WS,  MM1,  IMMS,  NNN, C_NNN,          "XOR"},		// XOR MM,IM -> 1000 00sw: mod 110 r/m: IM
	{ 0x38FFFF, 0x08C70F, 2, 0,   MM1,  MDR1R, NNN, C_NNN,          "CMPXCHG8B"},		// CMPXCHG8B MM,r1 -> 0000 1111: 1100 0111: mod 0001 r/m



	{ 0x0000E7, 0x000007, 1, 0,   SREG2,NNN,   NNN, C_DS_ESP,       "POP"},		// POP DS/ES/SS -> 000 sreg2 111
	{ 0x0000FF, 0x0000D5, 1, 0,   IMM8CN,NNN,  NNN, C_D_EAX,        "AAD"},		// AAD -> 1101 0101: IMM8
	{ 0x0000FF, 0x0000D4, 1, 0,   IMM8CN,NNN,  NNN, C_D_EAX,        "AAM"},		// AAM -> 1101 0100: 0000 1010
	

	{ 0x000000, 0x000000, 0, 00, 000, 000, 000, 000,""},

};


int		_disasm(unsigned char *instr, _dis_data *dis_data);
char*	REGfromBIT(unsigned long bits);
void	dump_table(void);


#endif
