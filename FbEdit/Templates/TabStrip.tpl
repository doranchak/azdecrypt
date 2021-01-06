FBTabStrip
Tab strip with 2 tabs
[*BEGINPRO*]
[*BEGINDEF*]
[Project]
Version=2
Description=TabStrip
Api=fb (FreeBASIC),win (Windows)
[Make]
Current=1
1=Windows GUI,fbc -s gui -w 1
Recompile=0
Module=Module Build,fbc -c
[*ENDDEF*]
[*BEGINTXT*]
[*PRONAME*].bas
''
'' Dialog Example, by fsw
''
'' compile with:	fbc -s gui FBTabStrip.rc FBTabStrip.bas
''
''

#include once "windows.bi"
#include once "win/commctrl.bi"

#define IDD_DLG0 1000
#define IDC_TAB1 1001
#define IDC_BTN1 1002

#define IDD_TAB1 1100
#define IDD_TAB2 1200

declare function DlgProc(byval hWnd as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer

dim SHARED hInstance as HINSTANCE

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	InitCommonControls
	DialogBoxParam(hInstance,Cast(zstring ptr,IDD_DLG0),NULL,@DlgProc,NULL)
	''
	'' Program has ended
	''
	ExitProcess(0)
	end

'''
''' Program end
'''

function Tab1Proc(byval hDlg as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool

	return FALSE

end function

function Tab2Proc(byval hDlg as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool

	return FALSE

end function


function DlgProc(byval hDlg as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool
	dim as long id, event
	dim ts as TCITEM
	dim lpNMHDR as NMHDR PTR
	dim hTab as HWND

	select case uMsg
		case WM_INITDIALOG
			' Get handle of tabstrip
			hTab=GetDlgItem(hDlg,IDC_TAB1)
			ts.mask=TCIF_TEXT or TCIF_PARAM
			ts.pszText=StrPtr("Tab1")
			' Create Tab1 child dialog
			ts.lParam=CreateDialogParam(hInstance,Cast(zstring ptr,IDD_TAB1),hTab,@Tab1Proc,0)
			SendMessage(hTab,TCM_INSERTITEM,0,Cast(LPARAM,@ts))
			ts.pszText=StrPtr("Tab2")
			' Create Tab2 child dialog
			ts.lParam=CreateDialogParam(hInstance,Cast(zstring ptr,IDD_TAB2),hTab,@Tab2Proc,0)
			SendMessage(hTab,TCM_INSERTITEM,1,Cast(LPARAM,@ts))
			'
		case WM_NOTIFY
			lpNMHDR=Cast(NMHDR ptr,lParam)
			if lpNMHDR->code=TCN_SELCHANGING then
				' Hide the currently selected dialog
				id=SendMessage(lpNMHDR->hwndFrom,TCM_GETCURSEL,0,0)
				ts.mask=TCIF_PARAM
				SendMessage(lpNMHDR->hwndFrom,TCM_GETITEM,id,Cast(LPARAM,@ts))
				ShowWindow(Cast(HWND,ts.lParam),SW_HIDE)
			elseif lpNMHDR->code=TCN_SELCHANGE then
				' Show the currently selected dialog
				id=SendMessage(lpNMHDR->hwndFrom,TCM_GETCURSEL,0,0)
				ts.mask=TCIF_PARAM
				SendMessage(lpNMHDR->hwndFrom,TCM_GETITEM,id,Cast(LPARAM,@ts))
				ShowWindow(Cast(HWND,ts.lParam),SW_SHOW)
			endif
			'
		case WM_CLOSE
			EndDialog(hDlg, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			select case id
				case IDC_BTN1
					EndDialog(hDlg, 0)
					'
			end select
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].rc
#define IDD_DLG0 1000
#define IDC_BTN1 1002
#define IDC_TAB1 1001
IDD_DLG0 DIALOGEX 6,6,248,188
CAPTION "Tabstrip"
FONT 8,"MS Sans Serif",400,0
STYLE 0x10C80880
EXSTYLE 0x00000001
BEGIN
  CONTROL "Exit",IDC_BTN1,"Button",0x50010000,176,166,64,17,0x00000000
  CONTROL "",IDC_TAB1,"SysTabControl32",0x50018000,2,3,244,157,0x00000000
END
#define IDD_TAB1 1100
#define CHK_1 1101
#define EDT_1 1102
IDD_TAB1 DIALOGEX 6,15,200,123
FONT 8,"MS Sans Serif",400,0
STYLE 0x50000000
EXSTYLE 0x00000000
BEGIN
  CONTROL "CheckBox",CHK_1,"Button",0x50010003,14,38,172,9,0x00000000
  CONTROL "",EDT_1,"Edit",0x50010000,14,49,172,13,0x00000200
END
#define IDD_TAB2 1200
#define CHK_2 1201
#define CHK_3 1202
#define EDT_2 1001
#define EDT_3 1002
#define EDT_4 1003
IDD_TAB2 DIALOGEX 6,15,200,123
FONT 8,"MS Sans Serif",400,0
STYLE 0x40000000
EXSTYLE 0x00000000
BEGIN
  CONTROL "CheckBox",CHK_2,"Button",0x50010003,8,24,170,13,0x00000000
  CONTROL "CheckBox",CHK_3,"Button",0x50010003,8,38,170,15,0x00000000
  CONTROL "",EDT_2,"Edit",0x50010000,8,55,174,13,0x00000200
  CONTROL "",EDT_3,"Edit",0x50010000,8,73,174,13,0x00000200
  CONTROL "",EDT_4,"Edit",0x50010000,8,92,174,13,0x00000200
END
[*ENDTXT*]
[*ENDPRO*]
