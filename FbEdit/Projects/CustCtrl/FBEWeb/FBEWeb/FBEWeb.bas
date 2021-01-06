
' Comment the following line when compiling the library. It will save some 1K on the executables size.
#Define DEFDLL

#Include Once "windows.bi"
#Include "..\FBEWeb.bi"

Type FBEWEB
	hParent			As HWND
	hWeb				As HWND
	pIWebBrowser	As Integer
End Type

Type IID
    Data1 			As uinteger
    Data2 			As ushort 
    Data3 			As ushort 
    Data4(0 To 7)	As ubyte
End Type

Type IUnknown
	QueryInterface As Function(ByVal pif As Integer,ByVal iid As IID ptr,ByVal pInterface As Any ptr) As Integer
	AddRef As Function(ByVal pif As Integer) As Integer
	Release As Function(ByVal pif As Integer) As Integer
End Type

Type IWebBrowser
	QueryInterface As Function(ByVal pif As Integer,ByVal iid As IID ptr,ByVal pInterface As Any ptr) As Integer
	AddRef As Function(ByVal pif As Integer) As Integer
	Release As Function(ByVal pif As Integer) As Integer
	GetTypeInfoCount As Function(ByVal pif As Integer,pctinfo As DWORD) As Integer
	GetTypeInfo As Function(ByVal pif As Integer,ByVal iTInfo As DWORD,ByVal lcid As DWORD,ByVal ppTInfo As DWORD) As Integer
	GetIDsOfNames As Function(ByVal pif As Integer,ByVal riid As DWORD,ByVal rgszNames As DWORD,ByVal cNames As DWORD,ByVal lcid As DWORD,ByVal rgDispId As DWORD) As Integer
	Invoke As Function(ByVal pif As Integer,ByVal dispIdMember As DWORD,ByVal riid As DWORD,ByVal lcid As DWORD,ByVal wFlags As DWORD,ByVal pDispParams As DWORD,ByVal pVarResult As DWORD,ByVal pExcepInfo As DWORD,ByVal puArgErr As DWORD) As Integer
	GoBack As Function(ByVal pif As Integer) As Integer
	GoForward As Function(ByVal pif As Integer) As Integer
	GoHome As Function(ByVal pif As Integer) As Integer
	GoSearch As Function(ByVal pif As Integer) As Integer
	Navigate As Function(ByVal pif As Integer,ByVal bstrURL As WString ptr,ByVal Flags As Any ptr,ByVal TargetFrameName As Any ptr,ByVal PostData As Any ptr,ByVal Headers As Any ptr) As Integer
End Type

Dim Shared hInstance As HINSTANCE
Dim Shared hLib As HMODULE
Dim Shared AtlAxWinInit As Function As Boolean
Dim Shared AtlAxGetControl As Function (ByVal hWin As HWND,ByVal pp As Integer ptr) As Integer

Dim Shared IID_IWebBrowser As IID=(&H0EAB22AC1,&H030C1,&H011CF,{&H0A7,&H0EB,&H000,&H000,&H0C0,&H05B,&H0AE,&H00B})

Dim Shared pIUnknown As Integer
Dim Shared IUnknown As IUnknown ptr
Dim Shared pIWebBrowser As Integer
Dim Shared IWebBrowser As IWebBrowser ptr

Function WndProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As LRESULT
	Dim lpFBEWEB As FBEWEB ptr
	Dim rect As RECT
	Dim wUrl As WString*260

	Select Case uMsg
		Case WM_CREATE
			If hLib Then
				lpFBEWEB=GlobalAlloc(GMEM_FIXED Or GMEM_ZEROINIT,SizeOf(FBEWEB))
				SetWindowLong(hWin,0,Cast(Integer,lpFBEWEB))
				lpFBEWEB->hParent=GetParent(hWin)
				GetWindowText(hWin,Cast(ZString ptr,@wUrl),260)
				If wUrl="" Then
					wUrl="http://"
				EndIf
				lpFBEWEB->hWeb=CreateWindowEx(0,"AtlAxWin",Cast(ZString ptr,@wUrl),WS_CHILD Or WS_VISIBLE Or WS_VSCROLL Or WS_HSCROLL,0,0,100,100,hWin,0,hInstance,0)
				' Get the IUnknown interface
				AtlAxGetControl(lpFBEWEB->hWeb,@pIUnknown)
				IUnknown=Cast(IUnknown ptr,Peek(DWORD,pIUnknown))
				' Get the IWebBrowser interface
				IUnknown->QueryInterface(pIUnknown,@IID_IWebBrowser,@pIWebBrowser)
				lpFBEWEB->pIWebBrowser=pIWebBrowser
				IWebBrowser=Cast(IWebBrowser ptr,Peek(DWORD,pIWebBrowser))
				IUnknown->Release(pIUnknown)
			EndIf
			'
		Case WM_SIZE
			If hLib Then
				lpFBEWEB=Cast(FBEWEB ptr,GetWindowLong(hWin,0))
				GetClientRect(hWin,@rect)
				MoveWindow(lpFBEWEB->hWeb,0,0,rect.right,rect.bottom,TRUE)
			EndIf
			'
		Case WM_DESTROY
			If hLib Then
				lpFBEWEB=Cast(FBEWEB ptr,GetWindowLong(hWin,0))
				pIWebBrowser=lpFBEWEB->pIWebBrowser
				IWebBrowser=Cast(IWebBrowser ptr,Peek(DWORD,pIWebBrowser))
				IWebBrowser->Release(pIWebBrowser)
				DestroyWindow(lpFBEWEB->hWeb)
				GlobalFree(lpFBEWEB)
			EndIf
			'
		Case WBM_NAVIGATE
			If hLib Then
				lpFBEWEB=Cast(FBEWEB ptr,GetWindowLong(hWin,0))
				pIWebBrowser=lpFBEWEB->pIWebBrowser
				IWebBrowser=Cast(IWebBrowser ptr,Peek(DWORD,pIWebBrowser))
				MultiByteToWideChar(CP_ACP,0,Cast(ZString ptr,lParam),-1,Cast(wString ptr,@wUrl),260)
				IWebBrowser->Navigate(pIWebBrowser,@wUrl,NULL,NULL,NULL,NULL)
			EndIf
			'
		Case WBM_GOBACK
			If hLib Then
				lpFBEWEB=Cast(FBEWEB ptr,GetWindowLong(hWin,0))
				pIWebBrowser=lpFBEWEB->pIWebBrowser
				IWebBrowser=Cast(IWebBrowser ptr,Peek(DWORD,pIWebBrowser))
				IWebBrowser->GoBack(pIWebBrowser)
			EndIf
			'
		Case WBM_GOFORWARD
			If hLib Then
				lpFBEWEB=Cast(FBEWEB ptr,GetWindowLong(hWin,0))
				pIWebBrowser=lpFBEWEB->pIWebBrowser
				IWebBrowser=Cast(IWebBrowser ptr,Peek(DWORD,pIWebBrowser))
				IWebBrowser->GoForward(pIWebBrowser)
			EndIf
			'
	End Select
	Return DefWindowProc(hWin,uMsg,wParam,lParam)

End Function

' This sub registers a windowclass for the custom control 
Function CreateClass(ByVal hModule As HMODULE,ByVal fGlobal As Boolean) As Integer
	Dim wc As WNDCLASSEX

	hInstance=hModule
	hLib=LoadLibrary("atl.dll")
	If hLib Then
		AtlAxWinInit=Cast(Any ptr,GetProcAddress(hLib,"AtlAxWinInit"))
		If AtlAxWinInit() Then
			AtlAxGetControl=Cast(Any ptr,GetProcAddress(hLib,"AtlAxGetControl"))
		EndIf
	EndIf
	' Create a windowclass for the custom control
	wc.cbSize=SizeOf(WNDCLASSEX)
	If fGlobal Then
		wc.style=CS_HREDRAW Or CS_VREDRAW Or CS_GLOBALCLASS Or CS_PARENTDC Or CS_DBLCLKS
	Else
		wc.style=CS_HREDRAW Or CS_VREDRAW Or CS_PARENTDC Or CS_DBLCLKS
	EndIf
	wc.lpfnWndProc=@WndProc
	wc.cbClsExtra=0
	' Holds the FBEWEB ptr
	wc.cbWndExtra=4
	wc.hInstance=hInstance
	wc.hbrBackground=NULL
	wc.lpszMenuName=NULL
	wc.lpszClassName=StrPtr(szClassName)
	wc.hIcon=NULL
	wc.hIconSm=NULL
	wc.hCursor=LoadCursor(NULL,IDC_ARROW)
	Return RegisterClassEx(@wc)

End Function

#Ifdef DEFDLL

Type CCDEFEX Field=1
	ID					As integer					'Controls uniqe ID. ID's below 1000 are reserved.
	lptooltip		As zstring ptr				'Pointer to FbEdit toolbox tooltip text
	hbmp				As HBITMAP					'Handle of FbEdit toolbox bitmap
	lpcaption		As zstring ptr				'Pointer to default caption text
	lpname			As zstring ptr				'Pointer to default idname text
	lpclass			As zstring ptr				'Pointer to class text
	style				As integer					'Default style
	exstyle			As integer					'Default ex-style
	flist1			As integer					'Property listbox bitflag1
	flist2			As integer					'Property listbox bitflag2
	flist3			As integer					'Property listbox bitflag3
	flist4			As integer					'Property listbox bitflag4
	lpszproperty	As zstring ptr				'Pointer to properties text
	lpproprty		As Any ptr					'Pointer to properties descriptor
End Type

' Default styles
#Define DEFSTYLE						WS_CHILD Or WS_VISIBLE
#Define DEFEXSTYLE					&H200
#Define IDB_BMP						100

#Define EXSTYLE_NONE					0

' Controls tooltip
Const szToolTip="Custom Web Browser Control"
' Controls default caption
Const szCap="http://"
' Controls default name
Const szName="IDC_WEB"

Const szProperty=""

' FbEdit uses this data when designing the control on a dialog. For a description of flist1 to flist4 bit values, see CustCtrl.txt file.
Dim Shared ccdefex As CCDEFEX=(903,@szToolTip,0,@szCap,@szName,@szClassName,DEFSTYLE,DEFEXSTYLE,&B11111111000011000000000000000000,&B00010000000000011000000000000000,&B00001000000000000000000000000000,&B00000000000000000000000000000000,@szProperty,NULL)

' Windows calls this function when the dll is loaded.
Function DllMain Alias "DllMain" (ByVal hModule As HMODULE,ByVal reason As Integer,ByVal lpReserved As LPVOID) As BOOL

   Select Case reason
	   Case DLL_PROCESS_ATTACH
	   	CreateClass(hModule,TRUE)
			'
		Case DLL_PROCESS_DETACH
			If hLib Then
				FreeLibrary(hLib)
				hLib=0
			EndIf
			'
	End Select 
	Return TRUE 

End Function 

' FbEdit calls this function to get the controls definitions.
Function GetDefEx Cdecl Alias "GetDefEx" (ByVal nInx As Integer) As CCDEFEX ptr Export

	If nInx=0 Then
		' Get the toolbox bitmap
		ccdefex.hbmp=LoadBitmap(hInstance,Cast(zstring ptr,IDB_BMP))
		' Return pointer to inited struct
		Return @ccdefex
	Else
		Return 0
	EndIf

End Function
#EndIf
