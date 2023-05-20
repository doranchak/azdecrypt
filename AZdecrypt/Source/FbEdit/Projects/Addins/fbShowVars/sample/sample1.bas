
#Define DEBUGGING		'' only comment this line for remove "debug" from executable!!! (check filesize)
#Include Once "showvars.bi"

#Define ALLTABS CLR_0 Or CLR_1 Or CLR_2 Or CLR_3 Or CLR_4 Or CLR_5 Or CLR_6

DebugClear( ALLTABS )

DebugVar( "t1", 1234 )
Print "add integer to debug"
DebugVar( "t1", 1234.5678 )
Print "add float to debug"
DebugVar( "t1", "1234" )
Print "add string to debug"
DebugLog( 1234 )
Print "add integer to log"
DebugLog( 1234.5678 )
Print "add floats to log"
DebugLog( "1234" )
Print "add string to log"
DebugMem( "debug info", @di, 32 )
Print "add mem to debug
Mark1()
Print "disassembler this"
Mark2()
DebugAsm( "t1" )

DebugState( TRUE )

For i As Integer = 0 To 6
	Print "Select tab(";i;" )"
	DebugSelect( i )
	Sleep 1000
	Print "Hide window"
	DebugHide( )
	Sleep 1000
	Print "Show window"
	DebugShow( )
	Sleep 1000
	Print"===================="
Next

Print "bye"
Sleep 1000
