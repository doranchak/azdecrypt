/'
	Dialog Example, by fsw

	compile with:	fbc -s gui dialog.rc dialog.bas

'/

'option explicit

#Include Once "windows.bi"
#Include Once "win/commdlg.bi"

#Include "OpenFile.bi"

Declare Function DlgProc(ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	DialogBoxParam(hInstance,Cast(ZString ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	End

'''
''' Program end
'''

Function OpenFontFile(ByVal hWin As HWND) As String
	Dim ofn As OPENFILENAME
	Dim buff As ZString*260

	ofn.lStructSize=SizeOf(OPENFILENAME)
	ofn.hwndOwner=hWin
	ofn.hInstance=hInstance
	ofn.lpstrInitialDir=StrPtr("C:\")
	buff=String(260,0)
	ofn.lpstrFile=@buff
	ofn.nMaxFile=260
	ofn.lpstrFilter=StrPtr(szFilter)
	ofn.lpstrTitle=StrPtr("Add New Font")
	ofn.Flags=OFN_PATHMUSTEXIST Or OFN_HIDEREADONLY Or OFN_EXPLORER
	If GetOpenFileName(@ofn) Then
		Return buff
	EndIf

End Function

Function DlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As integer
	Dim As long id, Event, x, y
	Dim hBtn As HWND
	Dim rect As RECT
	Dim buff As ZString*260

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
					buff=OpenFontFile(hWin)
					SetDlgItemText(hWin,IDC_EDT1,@buff)
					'
			End Select
		Case WM_SIZE
			GetClientRect(hWin,@rect)
			hBtn=GetDlgItem(hWin,IDC_BTN1)
			x=rect.right-100
			y=rect.bottom-35
			MoveWindow(hBtn,x,y,97,31,TRUE)
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
