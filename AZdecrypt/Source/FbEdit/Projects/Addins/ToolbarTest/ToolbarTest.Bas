/'
	Dialog Example, by fsw

	compile with:	fbc -s gui dialog.rc dialog.bas

'/

'option explicit

#include once "windows.bi"
#include once "win/commctrl.bi"

#include "ToolbarTest.bi"

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	InitCommonControls
	DialogBoxParam(hInstance, Cast(zstring ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	end

'''
''' Program end
'''

sub DoToolbar(byval hTbr as HWND,byval hInst as HINSTANCE)
	dim tbab as TBADDBITMAP
	dim tbrbtn5 as TBBUTTON=(5,IDC_TBB4,TBSTATE_ENABLED,TBSTYLE_BUTTON or TBSTYLE_CHECK or TBSTYLE_GROUP,{0,0},0)
	dim tbrbtn4 as TBBUTTON=(2,IDC_TBB3,TBSTATE_ENABLED,TBSTYLE_BUTTON or TBSTYLE_CHECK or TBSTYLE_GROUP,{0,0},0)
	dim tbrbtn3 as TBBUTTON=(0,0,TBSTATE_ENABLED,TBSTYLE_SEP,{0,0},0)
	dim tbrbtn2 as TBBUTTON=(1,IDC_TBB2,TBSTATE_ENABLED,TBSTYLE_BUTTON,{0,0},0)
	dim tbrbtn1 as TBBUTTON=(0,IDC_TBB1,TBSTATE_ENABLED,TBSTYLE_BUTTON,{0,0},0)

	'Set toolbar struct size
	SendMessage(hTbr,TB_BUTTONSTRUCTSIZE,SizeOf(TBBUTTON),0)
	'Set toolbar bitmap
	tbab.hInst=hInst
	tbab.nID=IDB_TOOLBAR
	SendMessage(hTbr,TB_ADDBITMAP,29,Cast(LPARAM,@tbab))
	'Set toolbar buttons
	SendMessage(hTbr,TB_ADDBUTTONS,5,Cast(LPARAM,@tbrbtn1))

end sub

function DlgProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim as long id, event, x, y
	dim hBtn as HWND
	dim rect as RECT

	select case uMsg
		case WM_INITDIALOG
			hBtn=GetDlgItem(hWin,1002)
			DoToolbar(hBtn,hInstance)
			'
		case WM_CLOSE
			EndDialog(hWin, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			select case id
				case IDC_BTN1
					EndDialog(hWin, 0)
					'
				case IDC_TBB1
					MessageBox(hWin,"IDC_TBB1",Str(loword(wParam)),MB_OK)
					'
				case IDC_TBB2
					MessageBox(hWin,"IDC_TBB2",Str(loword(wParam)),MB_OK)
					'
				case IDC_TBB3
					MessageBox(hWin,"IDC_TBB3",Str(loword(wParam)),MB_OK)
					'
				case IDC_TBB4
					MessageBox(hWin,"IDC_TBB4",Str(loword(wParam)),MB_OK)
					'
			end select
		case WM_SIZE
			GetClientRect(hWin,@rect)
			hBtn=GetDlgItem(hWin,IDC_BTN1)
			x=rect.right-100
			y=rect.bottom-35
			MoveWindow(hBtn,x,y,97,31,TRUE)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
