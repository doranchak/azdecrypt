''
'' RAGrid demo
'' -----------
'' To be able to run this demo you must copy RAGrid.dll to the project folder or to C:\Windows\System
''
''


#Include Once "windows.bi"

#Include "GridDemo.bi"
#Include "..\..\..\Inc\RAGrid.bi"

Declare Function DlgProc(ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
#Define Cell(x,y) (y Shl 16)+x
'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hLib=LoadLibrary(StrPtr("RAGrid.dll"))
	If hLib Then
		DialogBoxParam(GetModuleHandle(NULL), Cast(ZString ptr,IDD_DLG1), NULL, @DlgProc, NULL)
		FreeLibrary(hLib)
	EndIf
	''
	'' Program has ended
	''
	ExitProcess(0)
	End

'''
''' Program end
'''
Function DlgProc(ByVal hDlg As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event, x, y
	Dim hBtn As HWND
	Dim rect As RECT
	Dim col As COLUMN
	Dim lpGRIDNOTIFY As GRIDNOTIFY ptr
	Dim tmp As ZString*512
	Dim ival As Integer

	Select Case uMsg
		Case WM_INITDIALOG
			hGrd=GetDlgItem(hDlg,IDC_GRD1)
			SendMessage(hGrd,GM_SETBACKCOLOR,&HC0FFFF,0)
			SendMessage(hGrd,GM_SETGRIDCOLOR,&H808080,0)
			SendMessage(hGrd,GM_SETTEXTCOLOR,&H800000,0)
			' Add Name column
			col.colwt=150
			col.lpszhdrtext=StrPtr("Name")
			col.halign=GA_ALIGN_LEFT
			col.calign=GA_ALIGN_LEFT
			col.ctype=TYPE_EDITTEXT
			col.ctextmax=31
			col.lpszformat=0
			col.himl=0
			col.hdrflag=0
			SendMessage(hGrd,GM_ADDCOL,0,Cast(LPARAM,@col))
			' Add Address column
			col.colwt=150
			col.lpszhdrtext=StrPtr("Address")
			col.halign=GA_ALIGN_LEFT
			col.calign=GA_ALIGN_LEFT
			col.ctype=TYPE_EDITTEXT
			col.ctextmax=31
			col.lpszformat=0
			col.himl=0
			col.hdrflag=0
			SendMessage(hGrd,GM_ADDCOL,0,Cast(LPARAM,@col))
			' Add Points column
			col.colwt=50
			col.lpszhdrtext=StrPtr("Points")
			col.halign=GA_ALIGN_RIGHT
			col.calign=GA_ALIGN_RIGHT
			col.ctype=TYPE_EDITLONG
			col.ctextmax=4
			col.lpszformat=0
			col.himl=0
			col.hdrflag=0
			SendMessage(hGrd,GM_ADDCOL,0,Cast(LPARAM,@col))
			' Button column
			col.colwt=60
			col.lpszhdrtext=StrPtr("Button")
			col.halign=GA_ALIGN_LEFT
			col.calign=GA_ALIGN_LEFT
			col.ctype=TYPE_BUTTON
			col.ctextmax=MAX_PATH
			col.lpszformat=0
			col.himl=0
			SendMessage(hGrd,GM_ADDCOL,0,Cast(LPARAM,@col))
			' Add some rowdata
			SendMessage(hGrd,GM_ADDROW,0,Cast(LPARAM,@rdta1))
			SendMessage(hGrd,GM_ADDROW,0,Cast(LPARAM,@rdta2))
			SendMessage(hGrd,GM_ADDROW,0,Cast(LPARAM,@rdta3))
			SendMessage(hGrd,GM_ADDROW,0,Cast(LPARAM,@rdta4))
			'
		Case WM_CLOSE
			EndDialog(hDlg, 0)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case id
				Case IDC_BTN1
					EndDialog(hDlg, 0)
					'
				Case IDC_BTN2
					x=SendMessage(hGrd,GM_GETCURCOL,0,0)
					y=SendMessage(hGrd,GM_GETCURROW,0,0)
					If x=2 Then
						' Integer cell
						SendMessage(hGrd,GM_GETCELLDATA,Cell(x,y),Cast(LPARAM,@ival))
						MessageBox(hDlg,Str(ival),"RAGrid Demo",MB_OK)
					Else
						' String cell
						SendMessage(hGrd,GM_GETCELLDATA,Cell(x,y),Cast(LPARAM,@tmp))
						MessageBox(hDlg,@tmp,"RAGrid Demo",MB_OK)
					EndIf
					'
			End Select
		Case WM_SIZE
			GetClientRect(hDlg,@rect)
			hBtn=GetDlgItem(hDlg,IDC_BTN1)
			MoveWindow(hBtn,rect.right-100,rect.bottom-35,97,31,TRUE)
			hBtn=GetDlgItem(hDlg,IDC_BTN2)
			MoveWindow(hBtn,3,rect.bottom-35,97,31,TRUE)
			MoveWindow(hGrd,0,0,rect.right,rect.bottom-40,TRUE)
			'
		Case WM_NOTIFY
			lpGRIDNOTIFY=Cast(GRIDNOTIFY ptr,lParam)
			If lpGRIDNOTIFY->nmhdr.hwndFrom=hGrd Then
				If lpGRIDNOTIFY->nmhdr.code=GN_BUTTONCLICK Then
					MessageBox(hDlg,"Button clicked","RAGrid Demo",MB_OK)
				EndIf
			EndIf
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
