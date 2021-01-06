
' Comment the following line when compiling the library. It will save some 1K on the executables size.
#Define DEFDLL

#Include Once "windows.bi"
#Include Once "win\ole2.bi"
#Include Once "win\olectl.bi"

#Include "..\FBEPictView.bi"

Type PICTURE
	hBmp				As HBITMAP
	dwt				As Integer
	dht				As Integer
	pwt				As Integer
	pht				As Integer
End Type

Type FBEPICTVIEW
	hParent			As HWND
	hPictView		As HWND
	hinst				As HINSTANCE
	pict				As PICTURE
End Type

#Define HIMETRIC_INCH		2540

Type OLE_XSIZE_HIMETRIC As Integer
Type OLE_YSIZE_HIMETRIC As Integer
Type OLE_XPOS_HIMETRIC As Integer
Type OLE_YPOS_HIMETRIC As Integer

Type MyIPicture
	QueryInterface as function(byval as Any ptr, byval as IID ptr, byval as PVOID ptr) as HRESULT
	AddRef as function(byval as Any ptr) as ULONG
	Release as function(byval as Any ptr) as ULONG
	get_Handle as function(byval as Any ptr, byval as OLE_HANDLE ptr) as HRESULT
	get_hPal as function(byval as Any ptr, byval as OLE_HANDLE ptr) as HRESULT
	get_Type as function(byval as Any ptr, byval as short ptr) as HRESULT
	get_Width as function(byval as Any ptr, byval as OLE_XSIZE_HIMETRIC ptr) as HRESULT
	get_Height as function(byval as Any ptr, byval as OLE_YSIZE_HIMETRIC ptr) as HRESULT
	Render as function(byval as Any ptr, byval as HDC, byval as integer, byval as integer, byval as integer, byval as integer, byval as OLE_XPOS_HIMETRIC, byval as OLE_YPOS_HIMETRIC, byval as OLE_XSIZE_HIMETRIC, byval as OLE_YSIZE_HIMETRIC, byval as RECT ptr) as HRESULT
	set_hPal as function(byval as Any ptr, byval as OLE_HANDLE) as HRESULT
	get_CurDC as function(byval as Any ptr, byval as HDC ptr) as HRESULT
	SelectPicture as function(byval as Any ptr, byval as HDC, byval as HDC ptr, byval as OLE_HANDLE ptr) as HRESULT
	get_KeepOriginalFormat as function(byval as Any ptr, byval as BOOL ptr) as HRESULT
	put_KeepOriginalFormat as function(byval as Any ptr, byval as BOOL) as HRESULT
	PictureChanged as function(byval as Any ptr) as HRESULT
	SaveAsFile as function(byval as Any ptr, byval as Any ptr, byval as BOOL, byval as LONG ptr) as HRESULT
	get_Attributes as function(byval as Any ptr, byval as PDWORD) as HRESULT
end type

Dim Shared pIPicture As Integer ptr
Dim Shared IPicture As MyIPicture ptr
Dim Shared IID_IPicture As GUID=(&H07BF80980,&H0BF32,&H0101A,{&H08B,&H0BB,&H000,&H0AA,&H000,&H030,&H00C,&H0AB})

type MyIStream
	QueryInterface as function (byval as Any ptr, byval as IID ptr, byval as PVOID ptr) as HRESULT
	AddRef as function (byval as Any ptr) as ULONG
	Release as function (byval as Any ptr) as ULONG
	Read as function (byval as Any ptr, byval as any ptr, byval as ULONG, byval as ULONG ptr) as HRESULT
	Write as function (byval as Any ptr, byval as any ptr, byval as ULONG, byval as ULONG ptr) as HRESULT
	Seek as function (byval as Any ptr, byval as LARGE_INTEGER, byval as DWORD, byval as ULARGE_INTEGER ptr) as HRESULT
	SetSize as function (byval as Any ptr, byval as ULARGE_INTEGER) as HRESULT
	CopyTo as function (byval as Any ptr, byval as IStream ptr, byval as ULARGE_INTEGER, byval as ULARGE_INTEGER ptr, byval as ULARGE_INTEGER ptr) as HRESULT
	Commit as function (byval as Any ptr, byval as DWORD) as HRESULT
	Revert as function (byval as Any ptr) as HRESULT
	LockRegion as function (byval as Any ptr, byval as ULARGE_INTEGER, byval as ULARGE_INTEGER, byval as DWORD) as HRESULT
	UnlockRegion as function (byval as Any ptr, byval as ULARGE_INTEGER, byval as ULARGE_INTEGER, byval as DWORD) as HRESULT
	Stat as function (byval as Any ptr, byval as STATSTG ptr, byval as DWORD) as HRESULT
	Clone as function (byval as Any ptr, byval as LPSTREAM ptr) as HRESULT
end type

Dim Shared pIStream As Any ptr
Dim Shared IStream As MyIStream ptr

Dim Shared hInstance As HINSTANCE

Function BitmapFromPicture(ByVal wt As Integer,ByVal ht As Integer) As HBITMAP
	Dim tempDC As HDC
	Dim tempBitmap As HBITMAP
	Dim OldBitmap As HBITMAP
	Dim compDC As HDC
   Dim hmWidth As Integer
   Dim hmHeight As Integer

	' get a DC to work with
	compDC=GetDC(NULL)
	tempDC=CreateCompatibleDC(compDC)
	' Get width and height
	IPicture->get_Width(pIPicture,@hmWidth)
	IPicture->get_Height(pIPicture,@hmHeight)
	' Create bitmap
	tempBitmap=CreateCompatibleBitmap(compDC,wt,ht)
	OldBitmap=SelectObject(tempDC,tempBitmap)
	' Draw picture
	IPicture->Render(pIPicture,tempDC,0,0,wt,ht,0,hmHeight,hmWidth,-hmHeight,NULL)
	SelectObject(tempDC,OldBitmap)
	DeleteDC(tempDC)
	ReleaseDC(NULL,compDC)
	Return tempBitmap

End Function

Sub GetPictureFromFile(ByVal lpszFile As ZString ptr)
	Dim hFile As HANDLE
	Dim dwFileSize As Integer
	Dim hGlobal As HGLOBAL
	Dim pvData As HGLOBAL
	Dim dwBytesRead As Integer
	Dim bRead As Boolean

	pIStream=0
	pIPicture=0
	hFile=CreateFile(lpszFile,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,0,NULL)
	If hFile<>INVALID_HANDLE_VALUE Then
		dwFileSize=GetFileSize(hFile,NULL)
		hGlobal=GlobalAlloc(GMEM_MOVEABLE,dwFileSize)
		pvData=GlobalLock(hGlobal)
		bRead=ReadFile(hFile,pvData,dwFileSize,@dwBytesRead,NULL)
		GlobalUnlock(hGlobal)
		CloseHandle(hFile)
		' create IStream* from global memory
		CreateStreamOnHGlobal(hGlobal,TRUE,@pIStream)
		If pIStream Then
			IStream=Cast(MyIStream ptr,Peek(DWORD,pIStream))
			OleLoadPicture(pIStream,dwFileSize,FALSE,@IID_IPicture,@pIPicture)
			If pIPicture Then
				IPicture=Cast(MyIPicture ptr,Peek(DWORD,pIPicture))
			EndIf
			IStream->Release(pIStream)
		EndIf
		GlobalFree(hGlobal)
	EndIf

End Sub

Sub GetPictureFromResource(ByVal hInst As HINSTANCE,ByVal ResNumber As Integer)
	Dim dwFileSize As Integer
	Dim hResource As HRSRC
	Dim pvImage As HGLOBAL
	Dim hGlobal As HGLOBAL
	Dim pvData As HGLOBAL

	pIStream=0
	pIPicture=0
	' get a resource handle (address) and resource length from the executable
	hResource=FindResource(hInst,Cast(ZString ptr,ResNumber),StrPtr("IMAGE"))
	If hResource Then
		dwFileSize=SizeofResource(hInst,hResource)
		pvImage=LockResource(LoadResource(hInst,hResource))
		hGlobal=GlobalAlloc(GMEM_MOVEABLE,dwFileSize)
		pvData=GlobalLock(hGlobal)
		RtlMoveMemory(pvData,pvImage,dwFileSize)
		GlobalUnlock(hGlobal)
		' create IStream* from global memory
		CreateStreamOnHGlobal(hGlobal,TRUE,@pIStream)
		If pIStream Then
			IStream=Cast(MyIStream ptr,Peek(DWORD,pIStream))
			OleLoadPicture(pIStream,dwFileSize,FALSE,@IID_IPicture,@pIPicture)
			If pIPicture Then
				IPicture=Cast(MyIPicture ptr,Peek(DWORD,pIPicture))
			EndIf
			IStream->Release(pIStream)
		EndIf
		GlobalFree(hGlobal)
	EndIf

End Sub

Function GetSize(ByVal hWin As HWND) As Boolean
   Dim hmWidth As Integer
   Dim hmHeight As Integer
	Dim lpFBEPICTVIEW As FBEPICTVIEW ptr
	Dim compDC As HDC
	Dim buff As ZString*260

	lpFBEPICTVIEW=Cast(FBEPICTVIEW ptr,GetWindowLong(hWin,0))
	lpFBEPICTVIEW->pict.pwt=0
	lpFBEPICTVIEW->pict.pht=0
	If GetWindowText(hWin,@buff,260) Then
		If Left(buff,1)="#" Then
			GetPictureFromResource(lpFBEPICTVIEW->hinst,Val(Mid(buff,2)))
		Else
			GetPictureFromFile(@buff)
		EndIf
		If pIPicture Then
			' Get width and height
			IPicture->get_Width(pIPicture,@hmWidth)
			IPicture->get_Height(pIPicture,@hmHeight)
			' convert himetric to pixels
			compDC=GetDC(NULL)
			lpFBEPICTVIEW->pict.pwt=MulDiv(hmWidth,GetDeviceCaps(compDC,LOGPIXELSX),HIMETRIC_INCH)
			lpFBEPICTVIEW->pict.pht=MulDiv(hmHeight,GetDeviceCaps(compDC,LOGPIXELSY),HIMETRIC_INCH)
			ReleaseDC(NULL,compDC)
			IPicture->Release(pIPicture)
			pIPicture=0
			Return TRUE
		EndIf
	EndIf
	Return FALSE

End Function

Function LoadPict(ByVal hWin As HWND) As Boolean
   Dim hmWidth As Integer
   Dim hmHeight As Integer
	Dim lpFBEPICTVIEW As FBEPICTVIEW ptr
	Dim compDC As HDC
	Dim rect As RECT
	Dim rect1 As RECT
	Dim st As Integer
	Dim buff As ZString*260

	lpFBEPICTVIEW=Cast(FBEPICTVIEW ptr,GetWindowLong(hWin,0))
	lpFBEPICTVIEW->pict.pwt=0
	lpFBEPICTVIEW->pict.pht=0
	If GetWindowText(hWin,@buff,260) Then
		If Left(buff,1)="#" Then
			GetPictureFromResource(lpFBEPICTVIEW->hinst,Val(Mid(buff,2)))
		Else
			GetPictureFromFile(@buff)
		EndIf
		If pIPicture Then
			' Get width and height
			IPicture->get_Width(pIPicture,@hmWidth)
			IPicture->get_Height(pIPicture,@hmHeight)
			' convert himetric to pixels
			compDC=GetDC(NULL)
			lpFBEPICTVIEW->pict.pwt=MulDiv(hmWidth,GetDeviceCaps(compDC,LOGPIXELSX),HIMETRIC_INCH)
			lpFBEPICTVIEW->pict.pht=MulDiv(hmHeight,GetDeviceCaps(compDC,LOGPIXELSY),HIMETRIC_INCH)
			ReleaseDC(NULL,compDC)
			GetClientRect(hWin,@rect)
			st=GetWindowLong(hWin,GWL_STYLE) And 7
			Select Case st
				Case 2
					' Stretch
					lpFBEPICTVIEW->pict.dwt=rect.right
					lpFBEPICTVIEW->pict.dht=rect.bottom
					'
				Case 3
					' Stretch keep aspect
					rect1.right=lpFBEPICTVIEW->pict.pwt
					rect1.bottom=lpFBEPICTVIEW->pict.pht
					if rect.bottom/rect1.bottom>rect.right/rect1.right then
						lpFBEPICTVIEW->pict.dwt=rect1.right*(rect.right/rect1.right)
						lpFBEPICTVIEW->pict.dht=rect1.bottom*(rect.right/rect1.right)
					else
						lpFBEPICTVIEW->pict.dwt=rect1.right*(rect.bottom/rect1.bottom)
						lpFBEPICTVIEW->pict.dht=rect1.bottom*(rect.bottom/rect1.bottom)
					endif
					'
				Case Else
					' None, Center image or Size control
					lpFBEPICTVIEW->pict.dwt=lpFBEPICTVIEW->pict.pwt
					lpFBEPICTVIEW->pict.dht=lpFBEPICTVIEW->pict.pht
					'
			End Select
			lpFBEPICTVIEW->pict.hBmp=BitmapFromPicture(lpFBEPICTVIEW->pict.dwt,lpFBEPICTVIEW->pict.dht)
			IPicture->Release(pIPicture)
			pIPicture=0
			Return TRUE
		EndIf
	EndIf
	Return FALSE

End Function

Function WndProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As LRESULT
	Dim lpFBEPICTVIEW As FBEPICTVIEW ptr
	Dim rect As RECT
	Dim rect1 As RECT
	Dim ps As PAINTSTRUCT
	Dim mDC As HDC
	Dim hBmp As HBITMAP
	Dim As Integer x,y,st
	Dim buff As ZString*32
	Dim nmpvc As NMPVCLICK

	Select Case uMsg
		Case WM_CREATE
			lpFBEPICTVIEW=GlobalAlloc(GMEM_FIXED Or GMEM_ZEROINIT,SizeOf(FBEPICTVIEW))
			SetWindowLong(hWin,0,Cast(Integer,lpFBEPICTVIEW))
			lpFBEPICTVIEW->hParent=GetParent(hWin)
			lpFBEPICTVIEW->hPictView=hWin
			'
		Case WM_PAINT
			lpFBEPICTVIEW=Cast(FBEPICTVIEW ptr,GetWindowLong(hWin,0))
			If lpFBEPICTVIEW->pict.hBmp=0 Then
				LoadPict(hWin)
			EndIf
			BeginPaint(hWin,@ps)
			FillRect(ps.hdc,@ps.rcPaint,GetStockObject(LTGRAY_BRUSH))
			If lpFBEPICTVIEW->pict.hBmp Then
				GetClientRect(hWin,@rect)
				mDC=CreateCompatibleDC(ps.hdc)
				hBmp=SelectObject(mDC,lpFBEPICTVIEW->pict.hBmp)
				st=GetWindowLong(hWin,GWL_STYLE) And 7
				Select Case st
					Case 1
						' Center image
						x=(rect.right-lpFBEPICTVIEW->pict.pwt)/2
						y=(rect.bottom-lpFBEPICTVIEW->pict.pht)/2
						BitBlt(ps.hdc,x,y,lpFBEPICTVIEW->pict.pwt,lpFBEPICTVIEW->pict.pht,mDC,0,0,SRCCOPY)
						'
					Case 2
						' Stretch
						BitBlt(ps.hdc,0,0,rect.right,rect.bottom,mDC,0,0,SRCCOPY)
						'
					Case 3
						' Stretch keep aspect
						rect1.right=lpFBEPICTVIEW->pict.pwt
						rect1.bottom=lpFBEPICTVIEW->pict.pht
						if rect.bottom/rect1.bottom>rect.right/rect1.right then
							rect1.bottom=rect1.bottom*(rect.right/rect1.right)
							rect1.right=rect1.right*(rect.right/rect1.right)
						else
							rect1.right=rect1.right*(rect.bottom/rect1.bottom)
							rect1.bottom=rect1.bottom*(rect.bottom/rect1.bottom)
						endif
						rect1.left=(rect.right-rect1.right)/2
						rect1.top=(rect.bottom-rect1.bottom)/2
						BitBlt(ps.hdc,rect1.left,rect1.top,rect1.right,rect1.bottom,mdc,0,0,SRCCOPY)
						'
					Case Else
						' None or Size control
						BitBlt(ps.hdc,0,0,lpFBEPICTVIEW->pict.pwt,lpFBEPICTVIEW->pict.pht,mDC,0,0,SRCCOPY)
						'
				End Select
				SelectObject(mDC,hBmp)
				DeleteDC(mDC)
			EndIf
			EndPaint(hWin,@ps)
			'
		Case WM_SIZE
			lpFBEPICTVIEW=Cast(FBEPICTVIEW ptr,GetWindowLong(hWin,0))
			If lpFBEPICTVIEW->pict.hBmp Then
				DeleteObject(lpFBEPICTVIEW->pict.hBmp)
				lpFBEPICTVIEW->pict.hBmp=0
			EndIf
			'
		Case WM_DESTROY
			lpFBEPICTVIEW=Cast(FBEPICTVIEW ptr,GetWindowLong(hWin,0))
			If lpFBEPICTVIEW->pict.hBmp Then
				DeleteObject(lpFBEPICTVIEW->pict.hBmp)
				lpFBEPICTVIEW->pict.hBmp=0
			EndIf
			GlobalFree(lpFBEPICTVIEW)
			'
		Case WM_SETTEXT
			DefWindowProc(hWin,uMsg,wParam,lParam)
			lpFBEPICTVIEW=Cast(FBEPICTVIEW ptr,GetWindowLong(hWin,0))
			If lpFBEPICTVIEW->pict.hBmp Then
				DeleteObject(lpFBEPICTVIEW->pict.hBmp)
				lpFBEPICTVIEW->pict.hBmp=0
			EndIf
			If (GetWindowLong(hWin,GWL_STYLE) And 7)=4 Then
				' Get picture size
				GetSize(hWin)
				' Get window boarder size
				GetClientRect(hWin,@rect)
				GetWindowRect(hWin,@rect1)
				x=rect1.right-rect1.left-rect.right
				y=rect1.bottom-rect1.top-rect.bottom
				SetWindowPos(hWin,0,0,0,lpFBEPICTVIEW->pict.pwt+x,lpFBEPICTVIEW->pict.pht+y,SWP_NOMOVE Or SWP_NOZORDER)
			EndIf
			InvalidateRect(hWin,NULL,TRUE)
			Return 0
			'
		Case WM_LBUTTONDOWN
			SetCapture(hWin)
			'
		Case WM_LBUTTONUP
			If GetCapture=hWin Then
				ReleaseCapture
				nmpvc.pt.x=LoWord(lParam)
				nmpvc.pt.y=HiWord(lParam)
				GetClientRect(hWin,@rect)
				If nmpvc.pt.x<rect.right And nmpvc.pt.y<rect.bottom Then
					nmpvc.nmhdr.hwndFrom=hWin
					nmpvc.nmhdr.idFrom=GetWindowLong(hWin,GWL_ID)
					nmpvc.nmhdr.code=PVN_CLICK
					SendMessage(GetParent(hWin),WM_NOTIFY,nmpvc.nmhdr.idFrom,@nmpvc)
				EndIf
			EndIf
			'
		Case PVM_LOADFILE
			SetWindowText(hWin,Cast(ZString ptr,lParam))
			'
		Case PVM_LOADRESOURCE
			lpFBEPICTVIEW=Cast(FBEPICTVIEW ptr,GetWindowLong(hWin,0))
			lpFBEPICTVIEW->hinst=Cast(HINSTANCE,wParam)
			buff="#" & Str(lParam)
			SetWindowText(hWin,@buff)
			'
	End Select
	Return DefWindowProc(hWin,uMsg,wParam,lParam)

End Function

' This sub registers a windowclass for the custom control 
Function CreateClass(ByVal hModule As HMODULE,ByVal fGlobal As Boolean) As Integer
	Dim wc As WNDCLASSEX

	hInstance=hModule
	' Create a windowclass for the custom control
	wc.cbSize=SizeOf(WNDCLASSEX)
	If fGlobal Then
		wc.style=CS_HREDRAW Or CS_VREDRAW Or CS_GLOBALCLASS Or CS_DBLCLKS
	Else
		wc.style=CS_HREDRAW Or CS_VREDRAW Or CS_DBLCLKS
	EndIf
	wc.lpfnWndProc=@WndProc
	wc.cbClsExtra=0
	' Holds the FBEPICTVIEW ptr
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
Const szToolTip="Custom Picture Viewer Control"
' Controls default caption
Const szCap=""
' Controls default name
Const szName="IDC_PVW"

' Propery types
#define PROP_STYLETRUEFALSE		1
#define PROP_EXSTYLETRUEFALSE		2
#define PROP_STYLEMULTI				3

type PROPERTYSIZEMODE Field=1
	txt as ZString*48					' The lenght must match the actual string
	and_style1 as integer
	or_style1 as integer
	and_exstyle1 as integer
	or_exstyle1 as integer
	and_style2 as integer
	or_style2 as integer
	and_exstyle2 as integer
	or_exstyle2 as integer
	and_style3 as integer
	or_style3 as integer
	and_exstyle3 as integer
	or_exstyle3 as integer
	and_style4 as integer
	or_style4 as integer
	and_exstyle4 as integer
	or_exstyle4 as integer
	and_style5 As integer
	or_style5 As integer
	and_exstyle5 As integer
	or_exstyle5 As integer
End type

' Description of the property
Type PROPERTIES field=1
	type1 as integer
	property1 as PROPERTYSIZEMODE ptr
end type

' Property descriptions
Dim Shared PropertySizeMode as PROPERTYSIZEMODE=("None,CenterImage,Stretch,KeepAspect,SizeControl",-1 xor &H0007,STYLE_SIZENONE,-1,EXSTYLE_NONE,-1 xor &H0007,STYLE_SIZECENTERIMAGE,-1,EXSTYLE_NONE,-1 xor &H0007,STYLE_SIZESTRETCH,-1,EXSTYLE_NONE,-1 xor &H0007,STYLE_SIZEKEEPASPECT,-1,EXSTYLE_NONE,-1 xor &H0007,STYLE_SIZESIZECONTROL,-1,EXSTYLE_NONE)
' Properties descriptor
Dim Shared Properties As PROPERTIES=(PROP_STYLEMULTI,@PropertySizeMode)

Const szProperty="SizeMode"

' FbEdit uses this data when designing the control on a dialog. For a description of flist1 to flist4 bit values, see CustCtrl.txt file.
Dim Shared ccdefex As CCDEFEX=(904,@szToolTip,0,@szCap,@szName,@szClassName,DEFSTYLE,DEFEXSTYLE,&B11111111000011000000000000000000,&B00010000000000011000000000000000,&B00001000000000000000000000000000,&B00000000000000000000000000000000,@szProperty,@Properties)

' Windows calls this function when the dll is loaded.
Function DllMain Alias "DllMain" (ByVal hModule As HMODULE,ByVal reason As Integer,ByVal lpReserved As LPVOID) As BOOL

   Select Case reason
	   Case DLL_PROCESS_ATTACH
	   	CreateClass(hModule,TRUE)
			'
		Case DLL_PROCESS_DETACH
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
