/'
	Dialog Example, by fsw

	compile with:	fbc -s gui dialog.rc dialog.bas

'/

'option explicit

#include once "windows.bi"

#include "TestFBEPictViewDll.bi"
#Include "..\FBEPictView.bi"
declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

'''
''' Program start
'''

	GetModuleFileName(hInstance,@buff,260)
	i=lstrlen(@buff)
	While Mid(buff,i,1)<>"\"
		i-=1
	Wend
	buff=Left(buff,i-1)
	SetCurrentDirectory(@buff)
	i=0
	szPicture(0) = "Img\ToolBox.bmp"
	szPicture(1) = "Img\blue hills.jpg"
	szPicture(2) = "Img\site_logo.gif"
	szPicture(3) = "Img\icon.ico"
	hLib=LoadLibrary("FBEPictView.dll")
	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	DialogBoxParam(hInstance, Cast(zstring ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''
	FreeLibrary(hLib)

	ExitProcess(0)
	end

'''
''' Program end
'''
function DlgProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim as long id, event
	dim rect as RECT

	select case uMsg
		case WM_INITDIALOG
			' Load picture from resource
			SendDlgItemMessage(hWin,IDC_PVW1,PVM_LOADRESOURCE,Cast(WPARAM,hInstance),100)
			'
		case WM_CLOSE
			EndDialog(hWin, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			select case id
				case IDC_BTN1
					' Load picture from file
					SendDlgItemMessage(hWin,IDC_PVW1,PVM_LOADFILE,0,Cast(LPARAM,@szPicture(i)))
					i=(i+1) And 3
					'
			end select
		case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(GetDlgItem(hWin,IDC_PVW1),0,0,rect.right,rect.bottom-40,TRUE)
			MoveWindow(GetDlgItem(hWin,IDC_BTN1),rect.right-100,rect.bottom-35,97,31,TRUE)
			'
		Case WM_NOTIFY
			If wParam=1002 Then
				MessageBox(hWin,"Click","FBEPictView",MB_OK)
			EndIf
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
