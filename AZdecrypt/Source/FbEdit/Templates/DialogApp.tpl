DialogApp
Windows GUI with a dialog as main window
[*BEGINPRO*]
[*BEGINDEF*]
[Project]
Version=2
Api=fb (FreeBASIC),win (Windows)
Description=Dialog application.
[Make]
Recompile=0
Module=Module Build,fbc -c
Current=1
1=Windows GUI,fbc -s gui
2=Windows GUI (Debug),fbc -s gui -g
[*ENDDEF*]
[*BEGINTXT*]
[*PRONAME*].Bas
/'
	Dialog Example, by fsw

	compile with:	fbc -s gui dialog.rc dialog.bas

'/

#Include Once "windows.bi"

#Include "[*PRONAME*].bi"

Declare Function DlgProc(ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	DialogBoxParam(hInstance, Cast(ZString Ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	End

'''
''' Program end
'''
Function DlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event, x, y
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
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].Bi
#define IDD_DLG1 1000 
#define IDC_BTN1 1001

Dim Shared hInstance As HMODULE
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].Rc
#define IDD_DLG1 1000
#define IDC_BTN1 1001
IDD_DLG1 DIALOGEX 6,5,194,107
CAPTION "IDD_DLG"
FONT 8,"MS Sans Serif",400,0
STYLE 0x10CE0800
BEGIN
  CONTROL "Click me",IDC_BTN1,"Button",0x50010000,126,83,64,19
END
[*ENDTXT*]
[*ENDPRO*]
