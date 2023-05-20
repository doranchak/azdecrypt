/'
	Dialog Example, by fsw

	compile with:	fbc -s gui dialog.rc dialog.bas

'/

#Include Once "windows.bi"
#Include "win/commctrl.bi"

#Include "ProgressBar.bi"

Declare Function DlgProc(ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	InitCommonControls
	DialogBoxParam(GetModuleHandle(NULL), Cast(ZString Ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	End

'''
''' Program end
'''
Function DlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event, x, y, nPos
	Dim hBtn As HWND
	Dim rect As RECT

	Select Case uMsg
		Case WM_INITDIALOG
			'
		Case WM_CLOSE
			EndDialog(hWin, 0)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case id
				Case IDC_BTN1
					EndDialog(hWin, 0)
					'
			End Select
		Case WM_SIZE
			GetClientRect(hWin,@rect)
			hBtn=GetDlgItem(hWin,IDC_BTN1)
			x=rect.right-100
			y=rect.bottom-35
			MoveWindow(hBtn,x,y,97,31,TRUE)
			'
		Case WM_HSCROLL
			' Get trackbar position
			nPos=SendDlgItemMessage(hWin,IDC_TRB1,TBM_GETPOS,0,0)
			' Set progressbar value
			SendDlgItemMessage(hWin,IDC_PGB1,PBM_SETPOS,nPos,0)
			' Show value in text box
			SetDlgItemInt(hWin,IDC_EDT1,nPos,FALSE)
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
