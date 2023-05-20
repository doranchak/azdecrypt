/'
	Dialog Example, by fsw

	compile with:	fbc -s gui dialog.rc dialog.bas

'/

#include once "windows.bi"
#Include "win\ole2.bi"
#Include "win\olectl.bi"

#Include "PictCtrl.bi"

Declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	szPicture(0) = "Img\ToolBox.bmp"
	szPicture(1) = "Img\blue hills.jpg"
	szPicture(2) = "Img\site_logo.gif"
	DialogBoxParam(GetModuleHandle(NULL), Cast(zstring ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	end

'''
''' Program end
'''
Function BitmapFromPicture() As HBITMAP
	Dim tempDC As HDC
	Dim tempBitmap As HBITMAP
	Dim OldBitmap As HBITMAP
	Dim dwWidth As Integer
	Dim dwHeight As Integer
	Dim compDC As HDC
   Dim hmWidth As Integer
   Dim hmHeight As Integer
   Dim neghmHeight As Integer

	' get a DC to work with
	compDC=GetDC(NULL)
	tempDC=CreateCompatibleDC(compDC)
	' Get width and height
	IPicture->get_Width(pIPicture,@hmWidth)
	IPicture->get_Height(pIPicture,@hmHeight)
	' convert himetric to pixels
	dwWidth=MulDiv(hmWidth,GetDeviceCaps(compDC,LOGPIXELSX),HIMETRIC_INCH)
	dwHeight=MulDiv(hmHeight,GetDeviceCaps(compDC,LOGPIXELSY),HIMETRIC_INCH)
	neghmHeight=-hmHeight

	tempBitmap=CreateCompatibleBitmap(compDC,dwWidth,dwHeight)
	OldBitmap=SelectObject(tempDC,tempBitmap)

	' ok, now we have our bitmap mounted onto our temporary DC, let's blit to it
	' (IPicture)pPicture::Render(hdc, x, y, cx, cy,                            \
	'                            xpos_himetric, ypos_himetric,                 \
	'                            xsize_himetric, ysize_himetric, *rectBounds)
	IPicture->Render(pIPicture,tempDC,0,0,dwWidth,dwHeight,0,hmHeight,hmWidth,neghmHeight,NULL)

	SelectObject(tempDC,OldBitmap)
	DeleteDC(tempDC)
	ReleaseDC(NULL,compDC)
	Return tempBitmap

End Function

Function LoadPict(ByVal szPict As String) As HBITMAP
	Dim hFile As HANDLE
	Dim dwFileSize As Integer
	Dim hGlobal As HGLOBAL
	Dim pvData As HGLOBAL
	Dim dwBytesRead As Integer
	Dim bRead As Boolean
	Dim hr As HRESULT

	If hBmp Then
		DeleteObject(hBmp)
		hBmp=0
	EndIf
	hFile=CreateFile(szPict,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,0,NULL)
	If hFile<>INVALID_HANDLE_VALUE Then
		dwFileSize=GetFileSize(hFile,NULL)
		hGlobal=GlobalAlloc(GMEM_MOVEABLE,dwFileSize)
		pvData=GlobalLock(hGlobal)
		bRead=ReadFile(hFile,pvData,dwFileSize,@dwBytesRead,NULL)
		GlobalUnlock(hGlobal)
		CloseHandle(hFile)
		' create IStream* from global memory
		hr=CreateStreamOnHGlobal(hGlobal,TRUE,@pIStream)
		If pIStream Then
			IStream=Cast(MyIStream ptr,Peek(DWORD,pIStream))
			hr=OleLoadPicture(pIStream,dwFileSize,FALSE,@IID_IPicture,@pIPicture)
			If pIPicture Then
				IPicture=Cast(MyIPicture ptr,Peek(DWORD,pIPicture))
				hBmp=BitmapFromPicture
				IPicture->Release(pIPicture)
			EndIf
			IStream->Release(pIStream)
		EndIf
		GlobalFree(hGlobal)
		Return hBmp
	EndIf
	Return NULL

End Function

Function DlgProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim as long id, event
	dim rect as RECT

	select case uMsg
		case WM_INITDIALOG
			'
		case WM_CLOSE
			If hBmp Then
				DeleteObject(hBmp)
			EndIf
			EndDialog(hWin, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			select case id
				case IDC_BTN1
					hBmp=LoadPict(szPicture(i))
					SendDlgItemMessage(hWin,IDC_BTN2,BM_SETIMAGE,IMAGE_BITMAP,Cast(LPARAM,hBmp))
					i=(i+1) And 3
					'
			end select
		case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(GetDlgItem(hWin,IDC_BTN2),0,0,rect.right,rect.bottom-40,TRUE)
			MoveWindow(GetDlgItem(hWin,IDC_BTN1),rect.right-100,rect.bottom-35,97,31,TRUE)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
