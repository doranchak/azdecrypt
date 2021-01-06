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



#include <stdio.h>
#include <windows.h>		// strncpy and others....


#include "disasm.h"
#include "disasm_structs.h"



#define	DEBUG_IT	0
#define	debug OutputDebugString(debug_buff);

#if DEBUG_IT == 1
char	debug_buff[1024];
#endif


static _dis_data *ddm;


#define q(x) strcat(regs,x);




char *REG2STR(int reg)
{
	int i, ii;

	for (i = 0; i != 3; i++)
	{
		for (ii = 0; ii != 8; ii++)
		{
			if (t_regs_n[i][ii] == reg)
			{
#if DEBUG_IT == 1
	_snprintf(debug_buff,sizeof(debug_buff),"Reg is: %s\n",t_regs[i][ii]);
	debug;
#endif
			return t_regs[i][ii];
			}
		}		
	}

	return 0;
}

int set_segment(unsigned char prefix[3])
{

	for (int i =0; i != 3; i++)
	{
		if (prefix[i] == 0)
			break;

		switch(prefix[i])
		{

		case 0x2E:				// CS
			return SEG_CS;	
		case 0x36:				// SS
			return SEG_SS;
		case 0x3E:				// DS
			return SEG_DS;
		case 0x26:				// ES
			return SEG_ES;
		case 0x64:				// FS
			return SEG_FS;
		case 0x65:				// GS
			return SEG_GS;

		}
	}

	return SEG_DS;	// default
}

unsigned long decodeREG(int reg, int d_size)
{
	int i = 0;
	
	if (d_size == 4)
		i = 2;
	else if (d_size == 2)
		i = 1;

	return t_regs_n[i][reg];

}



void show_the_function(char *name)
{
	char *p;
	char dest[255]; 
	char src[255]; 
	char mem[255];
	char imm[13];
	char mul[13];
	char s_reg[13];
	char prze[2];
//	char sel[8];
	ulong b;

	int d_size, d_size2;

	memset((void*)&imm,0,sizeof(imm));
	memset((void*)&mul,0,sizeof(mul));
//	memset((void*)&sel,0,sizeof(sel));

	prze[0] = ','; prze[1] = 0;


	// if SIB is on we must do some adjustments for the mem_regs
	// in short words, delete the register to which multiper is 
	// assigned (temp)


	b = ddm->mem_regs;

	if (ddm->sib_mul != 0)
		b ^= ddm->sib_mul_reg;

	p = REGfromBIT(ddm->sib_mul_reg);
	memcpy((void*)&s_reg, (void*)p, sizeof(s_reg));

	if (strlen(s_reg)>2)
		s_reg[strlen(s_reg)-1] = 0;

	if (ddm->mem_imm_size != 0)
		_snprintf(imm,sizeof(imm),"0x%x",ddm->mem_imm);

	if (ddm->sib_mul != 0)
		_snprintf(mul,sizeof(mul),"%s*%d+",s_reg,ddm->sib_mul);

//	if (ddm->selector != 0)
//		_snprintf(sel,sizeof(sel),"%x",ddm->selector);


	d_size = ddm->default_data;

	// exception
	if (ddm->mem_super_size != 0)
		d_size = ddm->mem_super_size;


	if ((d_size == 1) || (d_size == 2))
		d_size2 = d_size - 1;
	else
		d_size2 = d_size - 2;

	p = REGfromBIT(ddm->dst_regs);
	memcpy((void*)&dest, (void*)p, sizeof(dest));
	p = REGfromBIT(ddm->src_regs);
	memcpy((void*)&src, (void*)p, sizeof(src));
	p = REGfromBIT(b);
	memcpy((void*)&mem, (void*)p, sizeof(src));


	// take care of giant imuls
	if ((dest[0] != 0) && (src[0] != 0))
	{ 
		if ((ddm->imm_size != 0) && (ddm->reserved == 0))
		{
			src[strlen(src)-1]=',';
			_snprintf(src,sizeof(src),"%s0x%x",src,ddm->imm_data);
		}
	}


	if (dest[0] == 0)
	{
		// possible memory (SIBs etc in dest)
		// make sure it is a valid action
		if ((ddm->mem_act == 0) && ((ddm->mem_regs != 0) || (ddm->mem_imm_size != 0)))
			_snprintf(dest,sizeof(dest),"%s %s:[%s%s%s]",t_sizes[d_size2],t_segs[ddm->seg],mem,mul,imm);
	}

	if (src[0] == 0)
	{
		// ignorance is a bless - not this time
		if ((ddm->mem_act == 1) && ((ddm->mem_regs != 0) || (ddm->mem_imm_size != 0)))
			_snprintf(src,sizeof(src),"%s %s:[%s%s%s]",t_sizes[d_size2],t_segs[ddm->seg],mem,mul,imm);
	}

	// still no data ? try IMMs 
	// ups IMMs are only sources (well, assume this for now :))
	if ((src[0] == 0) && (dest[0] != 0) && (ddm->imm_size != 0))
		_snprintf(src,sizeof(src),"0x%x",ddm->imm_data);

	if (ddm->reserved_size != 0)
	{
		src[strlen(src)]=',';
		if (src[strlen(src)-2] == '+')
		{
			src[strlen(src)-2] = ',';
			src[strlen(src)-1] = 0;
		}

		_snprintf(src,sizeof(src),"%s0x%x",src,ddm->reserved);
	}

	


	// if this is call/jump stuff

	if ((src[0] == 0) && (dest[0] == 0))
	{
		prze[0] = 0;
		if (ddm->spec_flag == F_CALL)
		{
			// now pastly decoded IMM is an operand
			if (ddm->selector == 0)
				_snprintf(dest,sizeof(dest),"$+0x%x",ddm->imm_data);
			else
				_snprintf(dest,sizeof(dest),"%x:0x%x",ddm->selector,ddm->imm_data);
		}

		// this is paranentaly sponsored by Intel and the enter instruction
		if (ddm->spec_flag == F_ENTER)
		{
			_snprintf(dest,sizeof(dest),"0x%x,0x%x",ddm->selector,ddm->imm_data);
		}
	}


	// sete exception
	if (ddm->spec_flag == F_SETXX)
		strcpy(name,t_tttns_s[ddm->reserved]);

	
    // CR/DR - decodings 
	if ((src[0] == 0) || (dest[0] == 0))
	{
		// CR registers detected
		if (ddm->spec_regs_on == USE_CRS)
		{
			if (src[0] == 0)
				strcpy(src,t_regs_cr[ddm->spec_regs]);
			else
				strcpy(dest,t_regs_cr[ddm->spec_regs]);
		}
		else if (ddm->spec_regs_on == USE_DRS)
		{
			if (src[0] == 0)
				strcpy(src,t_regs_dr[ddm->spec_regs]);
			else
				strcpy(dest,t_regs_dr[ddm->spec_regs]);
		}
		else if (ddm->spec_regs_on == USE_SREG)
		{
			if (src[0] == 0)
				strcpy(src,t_segs[ddm->spec_regs]);
			else
				strcpy(dest,t_segs[ddm->spec_regs]);
		}



		if (ddm->spec_regs_on == 0)
			prze[0] = 0;
	}



	if ((src[0] == 0) && (dest[0] == 0))
	{
		// maybe it is INT XX ?
		if (ddm->imm_size != 0)
			_snprintf(dest,sizeof(dest),"0x%x",ddm->imm_data);
	}




	// repair the broken strings
	int s = strlen(dest) - 1;
	if (dest[s] == '+')
		dest[s] = 0;
	else if (dest[s-1] == '+')
	{
		dest[s-1] = dest[s];
		dest[s] = 0;
	}
	s = strlen(src) - 1;
	if (src[s] == '+')
		src[s] = 0;
	else if (src[s-1] == '+')
	{
		src[s-1] = src[s];
		src[s] = 0;
	}


			// append cl to the src
	if (ddm->spec_flag == F_SHL3)
		_snprintf(src,sizeof(src),"%s,CL",src);
	

//	memset((void*)&debug_buff, 0, sizeof(debug_buff));
//	_snprintf(debug_buff,sizeof(debug_buff),"Command (len = %d): %s %s%s%s\n",ddm->len,name,dest,prze,src);
//	debug;

	_snprintf(ddm->instr_out,50,"%s%s %s%s%s",ddm->prefix_t,name,dest,prze,src);

}


unsigned long decodeIMM(char *i, int d_size)
{
	unsigned long a = 0;
	memcpy((void*)&a, (void*)i, d_size);
	return a;
}


unsigned long decodeSIB(char *i, int d_size, int mod)
{
	int sib = i[0];
	int sib_ss = (sib >> 6) & 0x03;
	int sib_index = (sib >> 3) & 0x07;
	int base = sib & 0x07;

	ddm->sib = sib;
	ddm->use_sib = 1;

	if (sib_ss == 0x01)
		ddm->sib_mul = 2;
	else if (sib_ss == 0x02)
		ddm->sib_mul = 4;
	else if (sib_ss == 0x03)
		ddm->sib_mul = 8;

	ddm->sib_mul_reg = decodeREG(sib_index,d_size);

	if (sib_index == 0x4) /* none */
		ddm->sib_mul_reg = 0;

	// is there is a ESP request, segment is changed to SS
	if (base == 4)
		ddm->seg = SEG_SS;


	// some global exception if index = 4, there is no scaled index
	// only base
	if ((sib_index == 0x4) && (base != 5))
		return decodeREG(base,d_size);

	if (base != 5)
		return (decodeREG(base,d_size) | decodeREG(sib_index,d_size));

	
	if (base == 5) 
	{
		// base = 5 / mod = 0 -> [sc.in] + disp32
		// like: 00401003   . 110C2D 1122110>ADC DWORD PTR DS:[EBP+4112211],ECX

		if (mod == 0)
		{
			ddm->mem_imm_size = 4;						// 32 bit data
			ddm->mem_imm = decodeIMM(i+1,4);			// decode 32 bit disp
			return decodeREG(sib_index,d_size);
		}

		// [sc.in] + disp8/32 + EBP
		else
		{
			return (decodeREG(sib_index,d_size) | decodeREG(RR_EBP,4));

		}

	}

	

	return 0;
}

unsigned long decodeMEM(char *i, int d_size, int d_addr_s)
{
	int n = 0;

	n = (i[0] & 0xC7);

	// firstly take care of 16bit addressing forms
	if (d_addr_s == 2)
	{				
							    // like: adc     ds:6766h, al
		if (n == 0x06)			// Effective Address: disp16
		{
			ddm->mem_imm_size = 2;						// 16 bit data
			ddm->mem_imm = decodeIMM(i+1,2);			// decode 16 bit disp
			return 0;
		}

		// from [BX+SI] to [BX]
		// like: 00401000 > $ 67:1300        ADC EAX,DWORD PTR DS:[BX+SI]
		else if ((n >= 0) && (n <= 7))
		{
			if ((n == 2) || (n == 3))					// BP requests requires SS
				ddm->seg = SEG_SS;
			return t_regs16m_n[(n & 0x7)];
		}

		// from [BX+SI]+disp8 to [BX]+disp8
		else if ((n >= 0x40) && (n <= 0x47))
		{
			ddm->mem_imm_size = 1;						// 8 bit data
			ddm->mem_imm = decodeIMM(i+1,1);

			if ((n == 0x42) || (n == 0x43) || (n == 0x46))
				ddm->seg = SEG_SS;

			return t_regs16m_n[(n & 0x7)];
		}

		// from [BX+SI]+disp16 to [BX]+disp16	
		else if ((n >= 0x80) && (n <= 0x87))
		{
			ddm->mem_imm_size = 2;							// 16 bit data
			ddm->mem_imm = decodeIMM(i+1,2);

			if ((n == 0x82) || (n == 0x83) || (n == 0x86))
				ddm->seg = SEG_SS;

			return t_regs16m_n[(n & 0x7)];
		}
	}

	// now take care of 32 bit addressing forms
	else {

		// disp32
		if (n == 0x5)
		{
			ddm->mem_imm_size = 4;						// 32 bit data
			ddm->mem_imm = decodeIMM(i+1,4);			// decode 32 bit disp
			return 0;
		}

		// from [EAX] to [EDI] (except of SIB block and disp32)
		// example: 00401000 > $ 1302           ADC EAX,DWORD PTR DS:[EDX]

		else if ((n >= 0) && (n != 0x04) && (n <= 7))
		{
			return decodeREG((n & 0x7),4);		//hardcore 32 bits!!!
		}

		// from [EAX]+disp8 to [EDI]+disp8, except of SIB block
		else if ((n >= 0x40) && (n <= 0x47) && (n != 0x44))
		{
			ddm->mem_imm_size = 1;					// 8 bit
			ddm->mem_imm = decodeIMM(i+1,1);
			return decodeREG((n & 0x7),4);
		}

		// from [EAX]+disp32 to [EDI]+disp32, except SIB block
		else if ((n >= 0x80) && (n <= 0x87) && (n != 0x84))
		{
			ddm->mem_imm_size = 4;						// 32 bit data
			ddm->mem_imm = decodeIMM(i+1,4);			// decode 32 bit disp
			return decodeREG((n & 0x7),4);
		}

		// now SIB meine freunds
		else if (n == 4)
		{	
			return decodeSIB((i+1),4,((n >> 6) & 0x3));
		}

		// SIB + disp8
		else if (n == 0x44)
		{	
			ddm->mem_imm_size = 1;					// 8 bit
			ddm->mem_imm = decodeIMM(i+2,1);
			return decodeSIB((i+1),4,((n >> 6) & 0x3));
		}

		// SIB + dis32
		else if (n == 0x84) 
		{
			ddm->mem_imm_size = 4;					// 32 bit
			ddm->mem_imm = decodeIMM(i+2,4);
			return decodeSIB((i+1),4,((n >> 6) & 0x3));
		}
	}

	return 0;

}



void rotate_name(const g_ddata *tc, char *name)
{
			// MOVS*
		if (tc->name[4] == '*')
		{
			if (ddm->default_data == 4)							// give MOVSD
				name[4] = 'D';
			else if (ddm->default_data == 2)
				name[4] = 'W';									// give MOVSW
			else if (ddm->default_data == 1)			
				name[4] = 'B';									// give MOVSB
		}

		// CWDE/CBW
		else if (tc->name[3] == '*')
		{
			if (ddm->default_data == 2)
				name[3] = 0;									// give CBW
			else
			{
				name[1] = 'W'; name[2] = 'D'; name[3] = 'E';	// give CWDE
			}
		}

		// CWD/CDQ
		else if (tc->name[2] == '*')
		{
			if (ddm->default_data == 4)							// give CDQ
				name[2] = 'Q';
			else
			{
				name[1] = 'W'; name[2] = 'D';					// give CWD
			}
		}


		// jump names are based on tttn fields
		if (strcmp(name,"JCC") == 0)
			strcpy(name,t_tttns[ddm->reserved]);


}


int	_disasm(unsigned char *instr, _dis_data *dis_data)
{


	int l, p, adj;
	unsigned char *i = instr;
	unsigned char s;
	DWORD data;
	char *bytes;
	const g_ddata *tc;
	char l_args[3];
	char name[255];
	int s_md = 0;

	ddm = (_dis_data*)malloc(sizeof(_dis_data));

	if (ddm == NULL)
		return -1;

	memset((void*)ddm, 0, sizeof(_dis_data));
	memset((void*)dis_data, 0, sizeof(_dis_data));

	ddm->default_addr = 4;        // default 32 bit mode
	ddm->default_data = 4;        // default 32 bit mode

	
	for (l = p = 0; l < MAX_PREFIXES; l++)
	{
		s = *i++;
		
		if (s == 0xF0)	/* lock prefix */
		{
			strcat(ddm->prefix_t,"LOCK ");
			ddm->prefix[p] = s;
			p++;
			continue;
		}


		
		if ((s == 0xF2) || (s == 0xF3)) /* repne-repnz and rep*/
		{
			if (s == 0xF2)			// repne
				strcat(ddm->prefix_t,"REPNE ");

			else					// rep
				strcat(ddm->prefix_t,"REP ");


			ddm->prefix[p] = s;
			p++;
			continue;
		}


		if ((s == 0x26) || (s == 0x2E) || (s == 0x36) || \
			(s == 0x3E) || (s == 0x64) || (s == 0x65) || \
			(s == 0x2E) || (s == 0x3E))
		{

#if DEBUG_IT == 1
	OutputDebugString("Prefixes found\n");
#endif
			ddm->prefix[p] = s;
			p++;
			continue;

		}

		if (s == 0x66)	/* operand-size ovveride prefix */
		{

#if DEBUG_IT == 1
	OutputDebugString("Operand-size Prefix found\n");
#endif
			ddm->prefix[p] = 0x66;
			ddm->default_data = ((ddm->default_data) / 2);
			p++;
			continue;
		}

		if (s == 0x67) /* address-size override prefix */
		{

#if DEBUG_IT == 1
	OutputDebugString("Address-size Prefix found\n");
#endif
			ddm->prefix[p] = 0x67;
			ddm->default_addr = ((ddm->default_addr) / 2);
			p++;
			continue;
		}

		if ((p == 0) || (ddm->prefix[l] == 0))
			break;

	}

	ddm->seg = set_segment(ddm->prefix);		// set the active segment

	s = *(instr + p);

	data = *(DWORD*)(instr + p);	
	ddm->opcode = *(BYTE*)(instr + p);


	for (tc = i_data; tc->len != 0; tc++)
	{				
		if (((DWORD)(data & tc->mask) == (DWORD)tc->code))
			break;


	}

	if (tc->len == 0)						// command not found
	{
		free(ddm);
		return 0;
	}


#if DEBUG_IT == 1
	OutputDebugString("Found name: ");
	OutputDebugString(tc->name);
	OutputDebugString("\n");
#endif


    adj = 0;
    // adjust the command if the size is equal to 2
	if (tc->len == 2)
	{
		adj++;
		data = *(DWORD*)(instr + p + adj);
		ddm->opcode2 = *(BYTE*)(instr + p + adj);
	}

	bytes = (char*)(instr + p + adj);
	
	// now take care of w/w3/s bits
	if (((tc->bits & WW ) == WW || (tc->bits & WS) == WS))
	{
		ddm->w_bit = (data & WW);
		if (ddm->w_bit == 0)
			ddm->default_data = 1;			// switch from 32 bit to 8 bit mode (w = 0)		
	}
	else if (tc->bits == W3)
	{
		ddm->w_bit = (data & W3) >> 3;
		if (ddm->w_bit == 0)
			ddm->default_data = 1;			// switch to 32 bit to 8 bit mode (w = 0)
	}

	if (((tc->bits & SS ) == SS || (tc->bits & WS) == WS))
	{
		ddm->s_bit = (data & SS) >> 1;
	}


#if DEBUG_IT == 1
	_snprintf(debug_buff,sizeof(debug_buff),"Current size mode is: %x\n",ddm->default_data);
	debug;
	_snprintf(debug_buff,sizeof(debug_buff),"W_bit = %x | S_bit = %x\n",ddm->w_bit,ddm->s_bit);
	debug;
#endif


	l_args[0] = tc->arg1;
	l_args[1] = tc->arg2;
	l_args[2] = tc->arg3;

	ddm->len = tc->len + p;			// size init

//	ddm->src_regs |= R_EBX | R_ECX | R_SP | R_SI | R_BP;
//	OutputDebugString(REGfromBIT(ddm->src_regs));
//	OutputDebugString("\n");


	// too late to differ, i'm very insane

	for (int ii = 0; ii != 3; ii++)
	{

		if (l_args[ii] == NNN)
			continue;
		
		
		switch(l_args[ii])
		{

			// SEGMENT FIELDS (possible SEGMENT as dest/source)
		case SREG3:
			ddm->spec_regs_on = USE_SREG;
			ddm->spec_regs = ((bytes[1] >> 3) & 0x07); // SREG3 field
			s_md = 1;
			break;

		case SREG2:
			ddm->spec_regs_on = USE_SREG;
			ddm->spec_regs = ((bytes[0] >> 3) & 0x03); // SREG2 field
			break;

			// CR register
		case CRX:
			ddm->spec_regs_on = USE_CRS;
			ddm->modrm = bytes[1];
			ddm->spec_regs = ((bytes[1] >> 3) & 0x07);	// no need to decode EEE field
			break;

			// DR register
		case DRX:
			ddm->spec_regs_on = USE_DRS;
			ddm->modrm = bytes[1];
			ddm->spec_regs = ((bytes[1] >> 3) & 0x07);	// no need to decode EEE field
			break;


			// REG2 field
			// situation: this is source (alternate encoding - XCHG)
		case MDR2_AA:
			ddm->src_regs |= decodeREG((bytes[0] & 0x07),ddm->default_data);
			break;



			// REG2 field
			// situation: this is destination (alternate encoding - dec/inc/...)
		case MDR2_A:
			ddm->dst_regs |= decodeREG((bytes[0] & 0x07),ddm->default_data);
			break;

			// REG1 field
			// situation: this is destination (fuck the direction bits :))
		case MDR1:
			ddm->dst_regs |= decodeREG(((bytes[1] >> 3) & 0x07),ddm->default_data);
			s_md = 1; // for size
			break;

			// REG2 field
			// situation: this is source
		case MDR2:
			ddm->src_regs |= decodeREG((bytes[1] & 0x07),ddm->default_data);
			s_md = 1;
			break;

			// REG1 field
			// situation now REG1 is source (d=0)
		case MDR1R:
			ddm->src_regs |= decodeREG(((bytes[1] >> 3) & 0x07),ddm->default_data);
			s_md = 1;
			break;

			// REG2 field
			// situation: now REG2 is dest (d=0)
		case MDR2R:
			ddm->dst_regs |= decodeREG((bytes[1] & 0x07),ddm->default_data);
			s_md = 1;
			break;

			// REG1 field
			// situation 16 bit register as source
		case MDR1R_16:
			ddm->src_regs |= decodeREG(((bytes[1] >> 3) & 0x07),2);   // hardcored 16 bit
			s_md = 1;
			break;

			// REG1 field
			// situation 16 bit reg as dest
		case MDR1_16:
			ddm->dst_regs |= decodeREG(((bytes[1] >> 3) & 0x07),2);   // hardcored 16 bit
			s_md = 1;
			break;


			// REG2 field
			//situation 16 bit reg as source
		case MDR2_16:
			ddm->src_regs |= decodeREG((bytes[1] & 0x07),2);		  // hardcored 16 bit
			s_md = 1;
			break;


			// REG2 field
			// situation 16 bit register as dest
		case MDR2R_16:
			ddm->dst_regs |= decodeREG((bytes[1] & 0x07),2);		  // hardcored 16 bit
			s_md = 1;
			break;


		case MDR2_8:
			ddm->src_regs |= decodeREG((bytes[1] & 0x07),1);		  // hardcored 8 bit
			s_md = 1;
			break;



		case MDR2R_8:
			ddm->dst_regs |= decodeREG((bytes[1] & 0x07),1);		  // hardcored 8 bit
			s_md = 1;
			break;


			// SELECTOR DECODING (2 BYTES)
		case IMM_SEL:
			ddm->selector = decodeIMM(bytes + 1 + 4,2); // selector after offset
			ddm->len += 2;	// update the len !!!			
			break;

			// ENTER "SELECTOR" decoding (2 BYTES)
		case IMM_SEL_E:
			ddm->spec_flag = F_ENTER;					 // set flag to ENTER command
			ddm->selector = decodeIMM(bytes + 1,2);  // directly after op
			ddm->len += 2;
			break;


			// 8 Bit immediate directly after op
		case IMM8C:
			ddm->spec_flag = F_CALL;

		case IMM8CN:
			ddm->imm_size = 1;
			ddm->imm_data = decodeIMM(bytes + 1,ddm->imm_size);
			break;


			// Immediate: value = 1
		case IMM1:
			ddm->imm_size = 1;
			ddm->imm_data = 1;
			ddm->len--;				// fixed - needed decreasion
			break;

			// CL
		case REG_CL_I:
			ddm->spec_flag = F_SHL3;
			ddm->spec_regs = decodeREG(RR_ECX, 1);
			break;



			// CL
		case REG_CL:
			ddm->src_regs |= decodeREG(RR_ECX, 1);
			break;

			// DX
		case REG_DX:
			ddm->src_regs |= decodeREG(RR_EDX, 2);
			break;


			// Jumps decoding
			//TTTN field in opcode
		case JTTTN:
			ddm->reserved = (decodeIMM(bytes,1)) & 0x0F;	// reserved = tttn field now
			break;

		case JTTTNS:
			ddm->spec_flag = F_SETXX;
			ddm->reserved = (decodeIMM(bytes,1)) & 0x0F;	// reserved = tttn field now
			break;

	

			// 8 bit Immediate after selector (ENTER)
		case IMM8E:
			ddm->imm_size = 1;
			ddm->imm_data = decodeIMM(bytes + 1 + 2,ddm->imm_size);
			break;

			// Immediate data directly after op.
		case IMMC:
			ddm->imm_size = (ddm->s_bit == 0? ddm->default_data : 1);
			ddm->imm_data = decodeIMM(bytes + 1,ddm->imm_size);
			break;


			// Immediate data decoding (special member)
			// Possible after SIB lock (adjust needed)
		case IMMI:
			ddm->reserved_size = (ddm->s_bit == 0? ddm->default_data : 1);
			ddm->reserved = decodeIMM(bytes + 1 + 1 + ddm->mem_imm_size + ddm->use_sib,ddm->reserved_size);
			break;

		case IMMI8:
			ddm->reserved_size = 1;
			ddm->reserved = decodeIMM(bytes + 1 + 1 + ddm->mem_imm_size + ddm->use_sib,ddm->reserved_size);
			break;



			// Immediate data decoding
			// Possible after SIB lock (adjust needed)
		case IMMS:
			ddm->imm_size = (ddm->s_bit == 0? ddm->default_data : 1);
			ddm->imm_data = decodeIMM(bytes + 1 + 1 + ddm->mem_imm_size + ddm->use_sib,ddm->imm_size);
			break;


			// Immediate 8 bit
			// Possible after SIB block (adjust needed)
		case IMM8S:
			ddm->imm_size = 1;
			ddm->imm_data = decodeIMM(bytes + 1 + 1 + ddm->mem_imm_size + ddm->use_sib,ddm->imm_size);
			break;


			// Immediate 32 bit for call
		case IMM32C:
			ddm->spec_flag = F_CALL;		// call flag on

		case IMM32:
			ddm->imm_size = 4;		// upcoming 32 bit imm
			ddm->imm_data = decodeIMM(bytes + 1,ddm->imm_size);
			break;


			// Immediate 8 bit
		case IMM8:
			ddm->imm_size = 1;
			ddm->imm_data = decodeIMM(bytes + 2,ddm->imm_size);
			break;

			// Immediate 16 bit
		case IMM16:
			ddm->imm_size = 2;
			ddm->imm_data = decodeIMM(bytes + 2,ddm->imm_size);
			break;

			// Immediate 16 bit (direct after op)
		case IMM16C:
			ddm->imm_size = 2;
			ddm->imm_data = decodeIMM(bytes + 1,ddm->imm_size);
			break;
			


			// Memory as dest (FULL DISP) 
		case MM1_FD:
			ddm->mem_act = 0;
			ddm->mem_imm_size = 4;
			ddm->mem_imm = decodeIMM(bytes + 1,ddm->mem_imm_size);
			break;

			// Memory as src (FULL DISP) 
		case MM2_FD:
			ddm->mem_act = 1;
			ddm->mem_imm_size = 4;
			ddm->mem_imm = decodeIMM(bytes + 1,ddm->mem_imm_size);
			break;



			// Immediate data decoding
			// IMM directly after mod reg fields
		case IMM:
			ddm->imm_size = (ddm->s_bit == 0? ddm->default_data : 1);
			ddm->imm_data = decodeIMM(bytes + 2,ddm->imm_size);
			break;


			//Accumulator reg (EAX/AX/AL)
			//Always as src reg
		case ACCR:
			ddm->src_regs |= decodeREG(RR_EAX, ddm->default_data);
			break;


			// Accumulator register (EAX/AX/AL)
			// a destination register (RR_EAX)
		case ACC:
			ddm->dst_regs |= decodeREG(RR_EAX, ddm->default_data);
			break;


			// Memory
			// situation: this is dest
		case MM1:
			ddm->mem_act = 0;			// act like dest
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			s_md = 1;
			break;

			// Memory
			// situation: this is source
		case MM2:
			ddm->mem_act = 1;			// act like source
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			s_md = 1;
			break;

		case MM_8:
			ddm->mem_act = 1;
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			ddm->mem_super_size = 1;		// hardcore 8 bits
			s_md = 1;
			break;

		case MM_16:
			ddm->mem_act = 1;
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			ddm->mem_super_size = 2;		// hardcore 8 bits
			s_md = 1;
			break;


		case MM2R_8:
			ddm->mem_act = 0;
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			ddm->mem_super_size = 1;		// hardcore 8 bits
			s_md = 1;
			break;


			// Memory 
			// situation: 16 bit dest
		case MM1_16:
			ddm->mem_act = 0;
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			ddm->mem_super_size = 2;		// hardcore 16 bits
			s_md = 1;
			break;

			// Memory source exteneded (calls)
			// Situation: src exteneded
		case MM2CE:
			ddm->mem_act = 1;
			ddm->spec_flag = F_CALL;		// call flag on
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			ddm->mem_super_size = 5;	// switch to fword
			s_md = 1;
			break;


			// Memory
			// Situation: src extended
		case MM2_EF:
			ddm->mem_act = 1;
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			if (ddm->default_data == 4)
				ddm->mem_super_size = 5;
			else if (ddm->default_data == 2)
				ddm->mem_super_size = 4;
			break;

			// Memory
			// Situation: src extended (depends on first param)
		case MM2_E:
			ddm->mem_act = 1;
			ddm->mem_regs |= decodeMEM(bytes + 1, ddm->default_data, ddm->default_addr);
			if (ddm->default_data == 2)
				ddm->mem_super_size = 4;
			else if (ddm->default_data == 4)
				ddm->mem_super_size = 6;
			s_md = 1;
			break;
		}
	}


	// setup modrm, well where there sreg3 (etc.) fields available i made modrms from
	// them also, well it makes no diff for me
	if (s_md >= 1)
		ddm->modrm = bytes[1];


	// if the name depends on size, give the proper one
	strncpy((char*)&name, tc->name, 255);
	if ((tc->bits & NA) == NA)
		rotate_name(tc, name);


#if DEBUG_IT == 1
	_snprintf(debug_buff,sizeof(debug_buff),"Name is: %s - Code: %x\n",name,tc->code);
	debug;
#endif

	// calclate the size
	ddm->len += (s_md + ddm->imm_size + ddm->use_sib + ddm->mem_imm_size + ddm->reserved_size);





	// ------------------------------------------
	// sign extend datas urm!
	// ------------------------------------------

	if ((tc->arg3 == 0) && ((tc->arg2 == IMM) || (tc->arg2 == IMMC) || (tc->arg2 == IMMS)) && \
		((tc->arg1 == MDR2R) || (tc->arg1 == ACC) || (tc->arg1 == MM1)) || \
		((tc->arg1 == IMM8C) && (tc->arg2 == 0)) || \
		((tc->arg1 == JTTTN) && (tc->arg2 == IMM8C))) /* JCC */
	{
		if ((ddm->default_data != ddm->imm_size) && (ddm->imm_size == 1))
		{
			if ((ddm->imm_data & s_masks[1]) != 0)		// sign found
				ddm->imm_data = (~n_masks[1] | ddm->imm_data) & n_masks[ddm->default_data];
			//ddm->imm_size = ddm->default_data;		// rotate the size
			ddm->imm_signextend = 1;
		}

	}
		


	show_the_function(name);
	

	// make a view
	ddm->i_dst_regs = ddm->dst_regs;
	ddm->i_src_regs = ddm->src_regs;

	// now do some final actions, in future versions this should be replaced by some bits
	// operations (this will require (prolly) to add 2 fields for the g_ddata table for
	// each entry) - currently it is case ...

	ddm->flags = tc->s_flag;

	switch(tc->s_flag)
	{

		// Here i don't care about reg modes (16/32/8)
		// in cmpxchg instruction there are possiblities when
		// there will be no destination register so there
		// are few exceptions, and following calculations
		// may not be 100% correct.

		// Dest: EAX | EDX , Source |= EAX
		case C_DS_EAXEDX_EAX:
			ddm->dst_regs = R_EAX | R_EDX;
			ddm->src_regs |= R_EAX;
			break;


		// Dest regs are source regs
		case C_D2S:
			ddm->src_regs = ddm->dst_regs;
			break;


		// Dest 2 Source, Dest = EAX
		case C_D2S_DEAX:
			ddm->src_regs |= ddm->dst_regs;
			ddm->dst_regs |= R_EAX;
			break;

		// Src regs are dest regs
		case C_S2D:
			ddm->dst_regs = ddm->src_regs;
			break;

		//Destination: EAX | ECX | EDX | EBX 
		case C_D_4R:
			ddm->dst_regs = R_EAX | R_ECX | R_EDX | R_EBX;
			break;

		case C_S_EDX:
			ddm->src_regs |= R_EDX;
			break;

		case C_D_ESP:
			ddm->dst_regs |= R_ESP;
			break;

		case C_DS_EDX_EAX:
			ddm->dst_regs |= R_EDX;
			ddm->src_regs |= R_EAX;
			break;

		case C_D_EAX:
			ddm->dst_regs |= R_EAX;
			break;

		case C_DS_EAX:
			ddm->dst_regs |= R_EAX;
			ddm->src_regs |= R_EAX;
			break;

		case C_D2SN:
			ddm->src_regs |= ddm->dst_regs;
			ddm->dst_regs = 0;
			break;

		case C_S_EDIESI:
			ddm->src_regs |= R_EDI | R_ESI;
			break;

		case C_D_EBPESP:
			ddm->dst_regs |= R_ESP | R_EBP;
			break;

		case C_DS_EAX_ESI:
			ddm->dst_regs |= R_EAX;
			ddm->src_regs |= R_ESI;
			break;

		case C_DS_ECX:
			ddm->dst_regs |= R_ECX;
			ddm->src_regs |= R_ECX;
			break;

		case C_DS_EDI_ESI:
			ddm->dst_regs |= R_EDI;
			ddm->src_regs |= R_ESI;
			break;

		case C_DS_ESP:
			ddm->dst_regs |= R_ESP;
			ddm->src_regs |= R_ESP;
			break;

		case C_D_ALL:
			ddm->dst_regs = R_ALL32;
			if (ddm->default_data == 2)
				ddm->dst_regs = R_ALL16;
			break;

		case C_S_ALL:
			ddm->src_regs = R_ALL32;
			if (ddm->default_data == 2)
				ddm->src_regs = R_ALL16;
			break;

		case C_S_EDIESIEAX:
			ddm->src_regs |= R_EDI | R_ESI | R_EAX;
			break;

			// Src: CL
		case C_S_CL:
			ddm->src_regs |= R_CL;
			break;

		case C_S_CL_N:
			ddm->src_regs |= R_CL | ddm->dst_regs;
			break;


			// Dest: EAX / EDX
		case C_D_EAX_EDX:
			ddm->dst_regs |= R_EAX | R_EDX;
			break;

			// Dest: EAX / EDX
			// Src: ECX
		case C_DS_EAXEDX_ECX:
			ddm->src_regs |= R_ECX;
			ddm->dst_regs |= R_EAX | R_EDX;
			break;


			// Src |= Dest
			// Dest - unchanged
		case C_D2S_NN:
			ddm->src_regs |= ddm->dst_regs;
			break;



		case C_DS_ESP_N:
			ddm->src_regs |= ddm->dst_regs |= R_ESP;
			ddm->dst_regs = R_ESP;
			break;
				
			



	default:
			break;
	}


	// Extra "case"
	// Here if the memory request will be found we will adjust
	// the registers for the source
	if (ddm->mem_regs != 0)
		ddm->src_regs |= ddm->mem_regs;

	
	// you thought it is the end? :)
#if DEBUG_IT == 1
	show_dst_regs(ddm->dst_regs);
	show_src_regs(ddm->src_regs);
	show_imm_data(ddm->imm_size, ddm->imm_data);
	show_mem_info;
#endif

			
	memcpy((void*)dis_data,(void*)ddm,sizeof(_dis_data));

	for (int lli = 0; lli != ddm->len; lli++)
		_snprintf(dis_data->instr_dump,sizeof(dis_data->instr_dump),"%s %.02x",dis_data->instr_dump,*(BYTE*)(instr + lli));

	free(ddm);
	return dis_data->len;
}

