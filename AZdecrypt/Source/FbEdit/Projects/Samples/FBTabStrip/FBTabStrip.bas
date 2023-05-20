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
