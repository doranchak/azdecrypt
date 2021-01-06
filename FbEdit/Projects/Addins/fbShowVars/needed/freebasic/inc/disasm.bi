''
''
'' disasm -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#Ifndef __disasm_bi__
#Define __disasm_bi__

#Inclib "disasm"

Type _dis_data
	As Integer		_len
	As UByte			_prefix( 0 To 2 )
	As UByte			_seg
	As UByte			_w_bit
	As UByte			_s_bit
	As UByte			_opcode
	As UByte			_opcode2
	As UByte			_modrm
	As UByte			_mem_act
	As UInteger		_mem_regs
	As UByte			_use_sib
	As UByte			_sib
	As UByte			_sib_mul
	As UInteger		_sib_mul_reg
	As UInteger		_mem_imm
	As UInteger		_mem_imm_size
	As UByte			_mem_super_size
	As UInteger		_src_regs
	As UInteger		_dst_regs
	As UInteger		_i_src_regs
	As UInteger		_i_dst_regs
	As UInteger		_flags
	As UByte			_spec_regs_on
	As UByte			_spec_regs
	As UByte			_spec_flag
	As UShort		_selector
	As UByte			_default_addr
	As UByte			_default_data
	As UInteger		_imm_data
	As UByte			_imm_size
	As UByte			_imm_signextend
	As UInteger		_reserved
	As UByte			_reserved_size
	As ZString * 50 _instr_out
	As ZString * 24 _instr_dump
	As ZString * 20 _prefix_t
End Type

Declare Function _disasm StdCall Alias "_disasm" (ByVal _InStr As UByte ptr, ByVal dis_data As _dis_data ptr) As Integer

#EndIf
