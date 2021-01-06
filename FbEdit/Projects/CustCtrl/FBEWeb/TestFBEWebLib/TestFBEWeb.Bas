/'
	Dialog Example, by fsw

	compile with:	fbc -s gui -p ".." TestFBEWeb.rc TestFBEWeb.bas

'/

#Include Once "windows.bi"

#Include "..\FBEWeb.bi"
#Include "TestFBEWeb.bi"
#inclib "FBEWeb"

Declare Function DlgProc(ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	CreateClass(GetModuleHandle(NULL),FALSE)
	DialogBoxParam(GetModuleHandle(NULL), Cast(zstring ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	End

'''
''' Program end
'''
Function DlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As integer
	Dim As long id, Event
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
				Case IDM_FILE_URL1
					SendDlgItemMessage(hWin,IDC_WEB1,WBM_NAVIGATE,0,Cast(LPARAM,StrPtr("http://www.radasm.com/fbedit/")))
					'
				Case IDM_FILE_URL2
					SendDlgItemMessage(hWin,IDC_WEB1,WBM_NAVIGATE,0,Cast(LPARAM,StrPtr("http://www.radasm.com/")))
					'
				Case IDM_FILE_BACK
					SendDlgItemMessage(hWin,IDC_WEB1,WBM_GOBACK,0,0)
					'
				Case IDM_FILE_FORWARD
					SendDlgItemMessage(hWin,IDC_WEB1,WBM_GOFORWARD,0,0)
					'
				Case IDM_FILE_EXIT
					EndDialog(hWin, 0)
					'
			End Select
			'
		Case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(GetDlgItem(hWin,IDC_WEB1),0,0,rect.right,rect.bottom,TRUE)
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
