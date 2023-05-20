
Type FUNC
	nID		As Integer
	szText	As ZString*16
End Type

Type RES
	ntyp		As Integer
	dval		As Double
	sval		As String
End Type

Declare Function EvalFunc(ByRef px As Integer,ByVal pf As Integer,ByRef pres As RES,ByVal bset As Integer) As Integer

#Define IFUN		1		' Immediate
#Define MFUN		2		' +, -, *, /, ^
#Define NFUN		3		' Asc
#Define SFUN		4		' Str
#Define VFUN		5		' Variable
#Define UFUN		6		' UDT Item

#Define INUM		1		' Number
#Define ISTR		2		' String
#Define IERR		3		' Error

#Define FLPA		1		' (
#Define FRPA		2		' )
#Define FEQV		3		' Eqv
#Define FIMP		4		' Imp
#Define FXOR		5		' Xor
#Define FLOR		6		' Or
#Define FAND		7		' And
#Define FNOT		8		' Not
#Define FEQ			9		' =
#Define FNEQ		10		' <>
#Define FLE			11		' <
#Define FGT			12		' >
#Define FLEEQ		13		' <=
#Define FGTEQ		14		' >=
#Define FADD		15		' +
#Define FSUB		16		' -
#Define FSHL		17		' Shl
#Define FSHR		18		' Shr
#Define FMOD		19		' Mod
#Define FIDIV		20		' \
#Define FMUL		21		' *
#Define FDIV		22		' /
#Define FNEG		23		' -
#Define FEXP		24		' ^
#Define FSADD		25		' &
#Define FCOMMA		26		' ,

#Define NASC		32		' Asc
#Define NLEN		33		' Len
#Define NINSTR		34		' InStr
#Define NINSTRREV	35		' InStrRev

#Define SSTR		128	' Str
#Define SCHR		129	' Chr
#Define SLEFT		130	' Left
#Define SRIGHT		131	' Right
#Define SMID		132	' Mid
#Define SSPACE		133	' Space
#Define SSTRING	134	' String

Dim Shared fn(255) As FUNC={(FLPA,"("),(FRPA,")"),(FEQV,"eqv"),(FIMP,"imp"),(FXOR,"xor"),(FLOR,"or"),(FAND,"and"),(FNOT,"not"),(FEQ,"="),(FNEQ,"<>"),(FLE,"<"),(FGT,">"),(FLEEQ,"<="),(FGTEQ,">="),(FADD,"+"),(FSUB,"-"),(FSHL,"shl"),(FSHR,"shr"),(FMOD,"mod"),(FIDIV,"\"),(FMUL,"*"),(FDIV,"/"),(FEXP,"^"),(FSADD,"&"),(FCOMMA,","),_
									 (NASC,"asc"),(NLEN,"len"),(NINSTR,"instr"),(NINSTRREV,"instrrev"),_
									 (SSTR,"str"),(SCHR,"chr"),(SLEFT,"left"),(SRIGHT,"right"),(SMID,"mid"),(SSPACE,"space"),(SSTRING,"string")}

Dim Shared szCompiled As ZString*2048
Dim Shared nErr As Integer
