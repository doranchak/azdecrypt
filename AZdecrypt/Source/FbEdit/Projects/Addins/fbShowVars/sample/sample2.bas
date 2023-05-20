
#Define DEBUGGING		'' only comment this line for remove "debug" from executable!!! (check filesize)
#Include Once "windows.bi"
#Include Once "showvars.bi"

Declare Function WinMain ( ByVal hInstance As HINSTANCE, ByVal hPrevInstance As HINSTANCE, ByRef szCmdLine As String, ByVal iCmdShow As Integer ) As Integer
Declare Function WndProc ( ByVal hWnd As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As LRESULT

Function WndProc ( 	ByVal hWnd As HWND, _
							ByVal wMsg As UINT, _
							ByVal wParam As WPARAM, _
							ByVal lParam As LPARAM ) As LRESULT

	Dim As RECT rct
	Dim As PAINTSTRUCT pnt
	Dim As HDC hDC
	Dim As Integer wmId, wmEvent

	Function = 0

	Select Case wMsg
		Case WM_CREATE
'			Exit Function
		Case WM_COMMAND
			wmId    = LoWord( wParam )
			wmEvent = HiWord( wParam )
			Select Case wmId
				Case IDOK
'					Exit Function
				Case IDCANCEL
'					Exit Function
			End Select
		Case WM_SIZE
'			Exit Function
		Case WM_PAINT
'			Exit Function
		Case WM_DESTROY
			PostQuitMessage( 0 )
			Exit Function
	End Select

	Function = DefWindowProc( hWnd, wMsg, wParam, lParam )

End Function

Function WinMain (	ByVal hInstance As HINSTANCE, _
							ByVal hPrevInstance As HINSTANCE, _
							ByRef szCmdLine As String, _
							ByVal iCmdShow As Integer ) As Integer

	Dim As MSG wMsg
	Dim As WNDCLASS wcls
	Dim As String appName
	Dim As HWND hWnd

	Function = 0

	''
	'' Setup window class
	''
	appName = "Test"

	wcls.style         = CS_HREDRAW Or CS_VREDRAW
	wcls.lpfnWndProc   = @WndProc
	wcls.cbClsExtra    = 0
	wcls.cbWndExtra    = 0
	wcls.hInstance     = hInstance
	wcls.hIcon         = LoadIcon( NULL, IDI_APPLICATION )
	wcls.hCursor       = LoadCursor( NULL, IDC_ARROW )
	wcls.hbrBackground = Cast(HBRUSH,1)
	wcls.lpszMenuName  = NULL
	wcls.lpszClassName = StrPtr(appName)

	''
	'' Register the window class
	''
	If ( RegisterClass( @wcls ) = FALSE ) Then
		MessageBox( NULL, "Failed to register the window class", appName, MB_ICONERROR )
		Exit Function
	End If

	''
	'' Create the window and show it
	''
	Mark1()
	hWnd = CreateWindowEx (	0, _
									appName, _
									"Test", _
									WS_OVERLAPPEDWINDOW, _
									686, 140, 300, 220, _
									NULL, _
									NULL, _
									hInstance, _
									NULL )

	ShowWindow( hWnd, iCmdShow )
	UpdateWindow( hWnd )
	Mark2()

	DebugVar( "string1", String ( 77, "0" ) + "1" )
	DebugVar( "string2", appName )
	DebugVar( "num1", &h7fffffff )
	DebugVar( "num2", &h80000000 )
	DebugVar( "num3", -2147483647 )
	DebugVar( "num4", -1 )
	DebugVar( "num5", &h26414243 )
	DebugVar( "floats", Sin ( 135 ) )
	DebugMem( "appName", StrPtr ( appName ), 1 )
	DebugMem( "winmain", @WinMain, 6 )
	DebugAsm( "createwindow" )

	DebugShow( )
	DebugSelect( TAB_1 )

	''
	'' Process windows messages
	''
	While( GetMessage( @wMsg, NULL, 0, 0 ) )
		DebugVar( "Msg.hwnd", Cast ( Integer, wMsg.hwnd ) )
		DebugVar( "Msg.message", wMsg.message )
		DebugVar( "Msg.wparam", wMsg.wparam )
		DebugVar( "Msg.lparam", wMsg.lparam )
		DebugVar( "Msg.time", wMsg.time )
		DebugVar( "Msg.pt.x", Cast ( Integer, wMsg.pt.x ) )
		DebugVar( "Msg.pt.y", Cast ( Integer, wMsg.pt.y ) )
		TranslateMessage( @wMsg )
		DispatchMessage( @wMsg )
	Wend

	''
	'' Program has ended
	''
	Function = wMsg.wParam

End Function

#Define ALLTABS CLR_0 Or CLR_1 Or CLR_2 Or CLR_3 Or CLR_4 Or CLR_5 Or CLR_6

DebugClear( ALLTABS )

DebugLog( "Start Program" )

WinMain( GetModuleHandle( 0 ), NULL, Command, SW_NORMAL )

DebugLog( "End Program" )
