
' DATA STAB
Type udtstab
	stabs			As Integer
	code			As UShort
	nline			As UShort
	ad				As Integer
End Type

Type tproc
	nm				As String   'name
	db				As UInteger 'lower address
	fn				As UInteger 'upper address
	sr				As Byte     'source index
	ad				As UInteger 'address
	vr				As UInteger 'lower index variable upper (next proc) -1
	rv				As Integer  'return value type
	nu				As UShort	'Line number
End Type

Type tprocr
	sk				As UInteger
	idx			As UInteger
	'lst 			As uinteger 'future array in LIST
End Type

Enum
	TYUDT
	TYRDM
	TYDIM
End Enum

Enum 'type of running
	RTRUN
	RTSTEP
	RTAUTO
End Enum

Type tnlu
	nb				As UInteger
	lb				As UInteger
	ub				As UInteger
End Type

Type taudt
	dm				As Integer
	nlu(5)		As tnlu
End Type

Type tcudt
	nm				As String	'name of components
	typ			As UShort	'type
	ofs			As UInteger	'offset
	arr			As UInteger 'Index array def
	pt				As UByte
End Type

Type tudt
	nm				As String  'name of udt
	typ			As UShort
	sr				As Byte     'source index
	lb				As Integer 'lower limit for components
	ub				As Integer 'upper
	lg				As Integer 'lenght 
End Type

Type tarr 'five dimensions max
	dat			As Any Ptr
	pot			As Any Ptr
	siz			As UInteger 'nb bytes non used
	dmn			As UInteger
	nlu(5)		As tnlu
End Type

Type tvar
	nm				As String	'name
	typ			As UShort	'type
	sr				As Byte     'source index
	adr			As Integer	'address or offset 
	mem			As UByte		'scope 
	arr			As tarr Ptr	'pointer to array def
	pt				As UByte		'pointer
	pn				As Short		'to keep track of vars with same name
End Type

Type tline
	ad				As UInteger	'Address
	nu				As Integer	'Line number
	sv				As Short 	'Source byte
	pr				As UShort	'Proc
End Type

Type tsource
	file			As String	'Filename
	pInx			As Integer	'Project index
End Type

Type tthread
	thread		As HANDLE
	threadret	As HANDLE
	threadid		As UInteger
	threadres	As UInteger
End Type

Dim Shared pinfo As PROCESS_INFORMATION
Dim Shared dbghand As HANDLE
Dim Shared ct As CONTEXT

' Stabs
Dim Shared secnb As UShort
Dim Shared pe As UInteger
Dim Shared secnm As String*8
Dim Shared basestab As UInteger
Dim Shared basestabs As UInteger
Dim Shared recupstab As udtstab
Dim Shared recup As ZString*8192

' Proc
Const PROCMAX=500
Dim Shared proc(PROCMAX) As tproc
Dim Shared procnb As Integer
Dim Shared procfg As Byte
Dim Shared As UInteger procsv,procad ,procin,procsk,proccurad

'Running proc
Const PROCRMAX=50000
Dim Shared procr(PROCRMAX) As tprocr 'list of running proc
Dim Shared procrnb as Integer
Dim Shared procrsk As UInteger

'sources ===========================================
Dim Shared source(SOURCEMAX) As tsource
Dim Shared sourceix As Integer
Dim Shared sourcenb As Integer

' UDT's
Const TYPEMAX=1500
Dim Shared udt(TYPEMAX) As tudt
Dim Shared udtnb As Integer
udt(0).nm="Proc"
udt(0).typ=0
udt(0).lg=0
udt(1).nm="Integer"
udt(1).typ=1
udt(1).lg=4
udt(2).nm="Byte"
udt(2).typ=2
udt(2).lg=1
udt(3).nm="UByte"
udt(3).typ=3
udt(3).lg=1
udt(4).nm="ZString"
udt(4).typ=4
udt(4).lg=0
udt(5).nm="Short"
udt(5).typ=5
udt(5).lg=2
udt(6).nm="UShort"
udt(6).typ=6
udt(6).lg=2
udt(7).nm="Void"
udt(7).typ=7
udt(7).lg=0
udt(8).nm="UInteger"
udt(8).typ=8
udt(8).lg=4
udt(9).nm="Longint"
udt(9).typ=9
udt(9).lg=8
udt(10).nm="ULongint"
udt(10).typ=10
udt(10).lg=8
udt(11).nm="Single"
udt(11).typ=11
udt(11).lg=4
udt(12).nm="Double"
udt(12).typ=12
udt(12).lg=8
udt(13).nm="String"
udt(13).typ=13
udt(13).lg=0
udt(14).nm="FString"
udt(14).typ=14
udt(14).lg=0
udt(15).nm="PChar"
udt(15).typ=15
udt(15).lg=0

Const CTYPEMAX=10000
Dim Shared cudt(CTYPEMAX) As tcudt
Dim Shared cudtnb As Integer

Const ATYPEMAX=1000
Dim Shared audt(ATYPEMAX) As taudt
Dim Shared audtnb As Integer

' Variables
Const VARMAX=5000
Dim Shared vrb(VARMAX) As tvar
Dim Shared vrbnb As UInteger  'nb of variables

' Arrays
Const ARRMAX=1000
Dim Shared arr(ARRMAX) As tarr
Dim Shared arrnb As UShort

' Lines
Const LINEMAX=250000
Dim Shared rline(LINEMAX) As tline
Dim Shared linenb As UInteger
Dim Shared linesav As UInteger

' Threads
Const THREADMAX=50
Dim Shared thread(THREADMAX) As tthread
Dim Shared threadnb As UInteger
Dim Shared threadcontext As HANDLE
Dim Shared threadidx As Integer

' Stabs
Dim Shared stabnb As Integer
Const STABMAX=10000
Dim Shared stab(STABMAX) As String

Dim Shared breakvalue As Integer =&hCC
Dim Shared linead As UInteger
