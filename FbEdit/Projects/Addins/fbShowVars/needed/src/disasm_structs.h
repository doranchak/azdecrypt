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


#ifndef __DISASM_S_H
#define __DISASM_S_H

unsigned long t_regs_n[3][8] = {
	R_AL,  R_CL,  R_DL,  R_BL,  R_AH,  R_CH,  R_DH,  R_BH,
	R_AX,  R_CX,  R_DX,  R_BX,  R_SP,  R_BP,  R_SI,  R_DI,
	R_EAX, R_ECX, R_EDX, R_EBX, R_ESP, R_EBP, R_ESI, R_EDI
};



#define T_REGS16_M_N_MAX 7
unsigned long t_regs16m_n[] = {
	R_BX | R_SI, R_BX | R_DI, R_BP | R_SI, R_BP | R_DI, R_SI, R_DI, R_BP, R_BX
};

char *t_regs[3][8] = {
	"AL", "CL", "DL", "BL", "AH", "CH", "DH", "BH",
	"AX", "CX", "DX", "BX", "SP", "BP", "SI", "DI",
	"EAX", "ECX", "EDX", "EBX", "ESP", "EBP", "ESI", "EDI"
};


char *t_regs_dr[] = {
	"DR0", "DR1", "DR2", "DR3", "DR??", "DR??","DR6","DR7"
};

char *t_regs_cr[] = {
	"CR0","CR??","CR2","CR3","CR4","CR??","CR??","CR??"
};


char *t_segs[] = {
	"ES", "CS", "SS", "DS", "FS", "GS","??","??"
};

char *t_sizes[] = {
	"BYTE PTR", "WORD PTR", "DWORD PTR", "FWORD PTR", "QWORD PTR"
};

char *t_tttns[] = {
	"JO", "JNO", "JB", "JNB", "JE", "JNE", "JBE", "JNBE", "JS","JNS", "JP", "JNP", "JL", "JNL", "JLE", "JNLE"
};

char *t_tttns_s[] = {
	"SETO", "SETNO", "SETB", "SETNB", "SETE", "SETNE", "SETBE", "SETNBE", "SETS","SETNS", "SETP", "SETNP", "SETL", "SETNL", "SETLE", "SETNLE"
};


char regs[255];

DWORD s_masks[] = {
	0x00008000,0x00000080,0x00008000,0x00000000,0x80000000
};


DWORD n_masks[] = {
	0x0000FF00 /* AH, BH, .. */, 0x000000FF /* AL, BL, ... */, 0x0000FFFF /* AX, BX, ... */,
	0x00000000, 0xFFFFFFFF
};



#define		SEG_ES 0
#define		SEG_CS 1
#define		SEG_SS 2
#define		SEG_DS 3
#define		SEG_FS 4
#define		SEG_GS 5



#define RR_AL 0
#define RR_CL 1
#define RR_DL 2
#define RR_BL 3
#define RR_AH 4
#define RR_CH 5
#define RR_DH 6
#define RR_BH 7
#define RR_AX 0
#define RR_CX 1
#define RR_DX 2
#define RR_BX 3
#define RR_SP 4
#define RR_BP 5
#define RR_SI 6
#define RR_DI 7
#define RR_EAX 0
#define RR_ECX 1
#define RR_EDX 2
#define RR_EBX 3
#define RR_ESP 4
#define RR_EBP 5
#define RR_ESI 6
#define RR_EDI 7




#define q(x) strcat(regs,x);


#define show_mem_info  _snprintf(debug_buff,512,"Segment is: %s\n",t_segs[ddm->seg]); \
					  debug; \
					  _snprintf(debug_buff,512,"Mem is: %d (0-DST) Mem registers: %s\n",ddm->mem_act,REGfromBIT(ddm->mem_regs)); \
	                  debug; \
					  _snprintf(debug_buff,512,"Mem imm: %x (size = %d) - Mul: %d\n",ddm->mem_imm,ddm->mem_imm_size,ddm->sib_mul); \
					  debug; 



#define show_imm_data(x,y) _snprintf(debug_buff,512,"Imm data, size = %d * data = %x\n",x,y); \
	                       OutputDebugString(debug_buff);

#define show_src_regs(x) OutputDebugString("-> Source:"); \
	                        show_regs(x);
#define show_dst_regs(x) OutputDebugString("-> Dest:"); \
	                     show_regs(x);

#define show_regs(x) OutputDebugString("RegsFROMbits are: "); \
                     OutputDebugString(REGfromBIT(x));   \
					 OutputDebugString("\n");

char *REGfromBIT(unsigned long bits)
{

	memset((void*)&regs,0,255);

	// EAX/AX/AH/AL support
	if ((bits & R_EAX) == R_EAX) 
	{
		q("EAX+"); 
	}
    else if ((bits & R_AX) == R_AX)
	{
		q("AX+");
	}
	else {
		if ((bits & R_AL) == R_AL)
			q("AL+");
		if ((bits & R_AH) == R_AH)
			q("AH+");
	}

	// ECX/CX/CH/CL support
	if ((bits & R_ECX) == R_ECX)
	{
		q("ECX+");
	}
	else if ((bits & R_CX) == R_CX)
	{
		q("CX+");
	}
	else {
		if ((bits & R_CL) == R_CL)
			q("CL+");
		if ((bits & R_CH) == R_CH)
			q("CH+");
	}

	// EBX/BX/BH/BL support
	if ((bits & R_EBX) == R_EBX)
	{
		q("EBX+");
	}
	else if ((bits & R_BX) == R_BX)
	{
		q("BX+");
	}
	else {
		if ((bits & R_BL) == R_BL)
			q("BL+");
		if ((bits & R_BH) == R_BH)
			q("BH+");
	}
	// EDX/DX/DH/DL support
	if ((bits & R_EDX) == R_EDX)
	{
		q("EDX+");
	}
	else if ((bits & R_DX) == R_DX)
	{
		q("DX+");
	}
	else {
		if ((bits & R_DL) == R_DL)
			q("DL+");
		if ((bits & R_DH) == R_DH)
			q("DH+");
	}

	// EDI/DI
	if ((bits & R_EDI) == R_EDI)
	{
		q("EDI+");
	}
	else if ((bits & R_DI) == R_DI)
	{
		q("DI+");
	}
	// ESP/SP
	if ((bits & R_ESP) == R_ESP)
	{
		q("ESP+");
	}
	else if ((bits & R_SP) == R_SP)
	{
		q("SP+");
	}
	// EBP/BP
	if ((bits & R_EBP) == R_EBP)
	{
		q("EBP+");
	}
	else if ((bits & R_BP) == R_BP)
	{
		q("BP+");
	}

	// ESI/SI
	if ((bits & R_ESI) == R_ESI)
	{
		q("ESI+");
	}
	else if ((bits & R_SI) == R_SI)
	{
		q("SI+");
	}


return regs;
}



#endif
