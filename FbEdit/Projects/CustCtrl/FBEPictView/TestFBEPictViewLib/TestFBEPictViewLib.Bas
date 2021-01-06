/'
	Dialog Example, by fsw

	compile with:	fbc -s gui dialog.rc dialog.bas

'/

'option explicit

#include once "windows.bi"

#include "TestFBEPictViewLib.bi"
#Include "..\FBEPictView.bi"
#inclib "FBEPictView"

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
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
	CreateClass(hInstance,FALSE)
	DialogBoxParam(hInstance, Cast(zstring ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	end

'''
''' Program end
'''
function DlgProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim as long id, event, x, y
	dim hBtn as HWND
	dim rect as RECT

	select case uMsg
		case WM_INITDIALOG
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
			hBtn=GetDlgItem(hWin,IDC_BTN1)
			x=rect.right-100
			y=rect.bottom-35
			MoveWindow(hBtn,x,y,97,31,TRUE)
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
