
''
'' lib
'' compile with fbc -lib
''

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

Dim Shared As UInteger __spos, __epos
Dim Shared As HWND fbedit
Dim Shared As MYDEBUGINF di
Dim Shared As MYDEBUGMEM dm
Dim Shared As COPYDATASTRUCT cds_di
Dim Shared As COPYDATASTRUCT cds_dm

cds_di.cbData = SizeOf ( di )
cds_di.lpData = @di
cds_dm.cbData = SizeOf ( dm )
cds_dm.lpData = @dm
fbedit = FindWindow( "MAINFBEDIT", 0 )

Sub _DebugVar( ByRef Var_label As String, ByVal Var_value As Integer, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	di._Line = dLine
	di._Func = dFunc
	di._Path = dPath
	di._File = dFile
	di.dLabel = Var_label
	di.dInteger = Var_value
	cds_di.dwData = DBG_VAR
	SendMessage( windbg, WM_COPYDATA, TYP_INTEGER, Cast( LPARAM, @cds_di ) )
End Sub

Sub _DebugVar( ByRef Var_label As String, ByVal Var_value As Double, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	di._Line = dLine
	di._Func = dFunc
	di._Path = dPath
	di._File = dFile
	di.dLabel = Var_label
	di.dFloat = Var_value
	cds_di.dwData = DBG_VAR
	SendMessage( windbg, WM_COPYDATA, TYP_DOUBLE, Cast( LPARAM, @cds_di ) )
End Sub

Sub _DebugVar( ByRef Var_label As String, ByRef Var_value As String, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	di._Line = dLine
	di._Func = dFunc
	di._Path = dPath
	di._File = dFile
	di.dLabel = Var_label
	di.dString = Var_value
	cds_di.dwData = DBG_VAR
	SendMessage( windbg, WM_COPYDATA, TYP_STRING, Cast( LPARAM, @cds_di ) )
End Sub

Sub _DebugLog( ByVal Var_value As Integer, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	di._Line = dLine
	di._Func = dFunc
	di._Path = dPath
	di._File = dFile
	di.dInteger = Var_value
	cds_di.dwData = DBG_LOG
	SendMessage( windbg, WM_COPYDATA, TYP_INTEGER, Cast( LPARAM, @cds_di ) )
End Sub

Sub _DebugLog( ByVal Var_value As Double, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	di._Line = dLine
	di._Func = dFunc
	di._Path = dPath
	di._File = dFile
	di.dFloat = Var_value
	cds_di.dwData = DBG_LOG
	SendMessage( windbg, WM_COPYDATA, TYP_DOUBLE, Cast( LPARAM, @cds_di ) )
End Sub

Sub _DebugLog( ByRef Var_value As String, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	di._Line = dLine
	di._Func = dFunc
	di._Path = dPath
	di._File = dFile
	di.dString = Var_value
	cds_di.dwData = DBG_LOG
	SendMessage( windbg, WM_COPYDATA, TYP_STRING, Cast( LPARAM, @cds_di ) )
End Sub

Sub _DebugMem( ByRef Var_label As String, ByVal Address As Any ptr, ByVal nLines As Integer, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	dm._Line = dLine
	dm._Func = dFunc
	dm._Path = dPath
	dm._File = dFile
	dm.dLabel = "[" + Str( nLines ) + "] " + Var_label
	dm.dAddress = Address
	CopyMemory( @dm.iData( 0 ), Address, IIf( nLines > 512, 512, nLines ) * 16 )
	cds_dm.dwData = DBG_MEM
	SendMessage( windbg, WM_COPYDATA, nLines, Cast( LPARAM, @cds_dm ) )
End Sub

Sub _DebugAsm( ByRef Var_label As String, ByVal Address1 As Any ptr, ByVal Address2 As Any ptr, ByVal dLine As Integer, ByRef dFunc As String, ByRef dPath As String, ByRef dFile As String )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	If Address1 = 0 Or Address2 = 0 Or Address1 > Address2 Then Exit Sub
	dm._Line = dLine
	dm._Func = dFunc
	dm._Path = dPath
	dm._File = dFile
	dm.dLabel = "[" + Str( Address2 - Address1 ) + "] " + Var_label
	dm.dAddress = Address1
	CopyMemory( @dm.iData( 0 ), Address1, IIf( Address2 - Address1 > 8192, 8192, Address2 - Address1 ) )
	cds_dm.dwData = DBG_DIS
	SendMessage( windbg, WM_COPYDATA, Address2 - Address1, Cast( LPARAM, @cds_dm ) )
End Sub

Sub DebugSelect( ByVal Var_value As Integer )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	SendMessage( windbg, DBG_SELECT, Var_value+1300, 0 )
End Sub

Sub DebugClear( ByVal Var_value As Integer )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	SendMessage( windbg, DBG_CLEAR, Var_value, 0 )
End Sub

Sub DebugState( ByVal Var_value As Integer )
	Dim As HWND windbg
	windbg = FindWindow( 0, "ShowVars" )
	If windbg = 0 Then windbg = FindWindowEx( fbedit, 0, 0, "ShowVars" )
	SendMessage( windbg, DBG_STATE, Var_value, 0 )
End Sub
