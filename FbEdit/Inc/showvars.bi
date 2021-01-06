
'' version 0.5

#Ifndef __showvars_bi__
#Define __showvars_bi__

#Ifdef DEBUGGING

#Inclib "ShowVars"

#Include Once "windows.bi"

'( tab ) for select: +1300
Const TAB_0				= 0				'output
Const TAB_1				= 1				'var
Const TAB_2				= 2				'float
Const TAB_3				= 3				'string
Const TAB_4				= 4				'memory
Const TAB_5				= 5				'disassembler
Const TAB_6				= 6				'log

'( typ )
Const TYP_INTEGER		= 0
Const TYP_DOUBLE		= 1
Const TYP_STRING		= 2

'( clear )
Const CLR_0				= &h1				'output
Const CLR_1				= &h2				'var
Const CLR_2				= &h4				'float
Const CLR_3				= &h8				'string
Const CLR_4				= &h10			'memory
Const CLR_5				= &h20			'disassembler
Const CLR_6				= &h40			'log

'( messages )
Const DBG_VAR			= WM_USER+1000	'add/update ( typ ).	wParam=( typ ), 	lParam=pointer MYDEBUGINF struct
Const DBG_LOG			= WM_USER+1001	'add logs ( typ ).	wParam=( typ ), 	lParam=pointer MYDEBUGINF struct
Const DBG_MEM			= WM_USER+1002	'add/update memory.	wParam=nlines, 	lParam=pointer MYDEBUGMEM struct
Const DBG_DIS			= WM_USER+1003	'add disassembler.	wParam=lenght,		lParam=pointer MYDEBUGMEM struct

Const DBG_SELECT		= WM_USER+1004	'Select tab ( tab ).	wParam=( tab ), 	lParam=0
Const DBG_CLEAR		= WM_USER+1005	'Clear tab ( tab ).	wParam=( clear ),	lParam=0
Const DBG_STATE		= WM_USER+1006	'show/hide window.	wParam=TRUE/FALSE,lParam=0

Type MYDEBUGINF
	_Line		As Integer
	_Func		As ZString * 32
	_Path		As ZString * 260
	_File		As ZString * 260
	dLabel	As ZString * 32
	dString	As ZString * 128
	dInteger	As Integer
	dFloat	As Double
	iUpd		As Integer
End Type

Type MYDEBUGMEM
	_Line				As Integer
	_Func				As ZString * 32
	_Path				As ZString * 260
	_File				As ZString * 260
	dLabel			As ZString * 32
	dAddress			As Any ptr
	iUpd				As Integer
	iData ( 8192 )	As UByte				'max 512 lines ( 8kb )
End Type

Declare Sub _DebugVar OverLoad ( ByRef Var_label As String, ByVal Var_value As Integer, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
Declare Sub _DebugVar OverLoad ( ByRef Var_label As String, ByVal Var_value As Double, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
Declare Sub _DebugVar OverLoad ( ByRef Var_label As String, ByRef Var_value As String, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
Declare Sub _DebugLog OverLoad ( ByVal Var_value As Integer, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
Declare Sub _DebugLog OverLoad ( ByVal Var_value As Double, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
Declare Sub _DebugLog OverLoad ( ByRef Var_value As String, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
Declare Sub _DebugMem( ByRef Var_label As String, ByVal Address As Any ptr, ByVal nLines As Integer, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
Declare Sub _DebugAsm( ByRef Var_label As String, ByVal Address1 As Any ptr, ByVal Address2 As Any ptr, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
Declare Sub DebugClear( ByVal Var_value As Integer )
Declare Sub DebugState( ByVal Var_value As Integer )
Declare Sub DebugSelect( ByVal Var_value As Integer )

Dim Shared As UInteger __spos, __epos
Dim Shared As HWND fbedit
Dim Shared As MYDEBUGINF di
Dim Shared As MYDEBUGMEM dm
Dim Shared As COPYDATASTRUCT cds_di
Dim Shared As COPYDATASTRUCT cds_dm

#Macro _Mark1( _func, _line )
Asm
.##_func##_line:
	lea eax, [ .##_func##_line + 11 ]
	mov Dword ptr [ __spos ], eax
End Asm
#EndMacro

#Define Mark1( ) _Mark1( __Function_Nq__, __LINE__ )

#Macro _Mark2( _func, _line )
Asm
.##_func##_line:
	lea eax, [ .##_func##_line ]
	mov Dword ptr [ __ePos ], eax
End Asm
#EndMacro

#Define Mark2( ) _Mark2( __Function_Nq__, __LINE__ )

#Define DebugVar( a, b ) _DebugVar( a, b, __LINE__, __FUNCTION__, __PATH__, __FILE__ )
#Define DebugLog( a ) _DebugLog( a, __LINE__, __FUNCTION__, __PATH__, __FILE__ )
#Define DebugMem( a, b, c ) _DebugMem( a, b, c, __LINE__, __FUNCTION__, __PATH__, __FILE__ )
#Define DebugAsm( a ) _DebugAsm( a, Cast( Any ptr, __spos ), Cast( Any ptr, __epos ), __LINE__, __FUNCTION__, __PATH__, __FILE__ )
#Define DebugShow( ) DebugState( TRUE )
#Define DebugHide( ) DebugState( FALSE )

#Else

#Define DebugVar( a, b )
#Define DebugLog( a )
#Define DebugMem( a, b, c )
#Define DebugAsm( a )
#Define DebugSelect( a )
#Define DebugClear( a )
#Define DebugState( a )
#Define DebugShow( )
#Define DebugHide( )
#Define Mark1( )
#Define Mark2( )

#EndIf

#EndIf
