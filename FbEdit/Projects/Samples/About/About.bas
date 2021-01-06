#Include once "windows.bi"
#include once "win/shellapi.bi"

#Include "About.bi"

function UrlProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim rect as RECT
	dim buffer as zstring*128


	select case uMsg
		case WM_MOUSEMOVE
			' Set the hand cursor
			SetCursor(LoadCursor(NULL,IDC_HAND))
			' Check if mouse is captured
			if GetCapture<>hWin then
				' Mouse is not captured and is over the control
				fMouseOver=TRUE
				SetCapture(hWin)
				SendMessage(hWin,WM_SETFONT,Cast(integer,hUrlFontU),TRUE)
			else
				' Mouse is captured
				' Check if mouse has left the control
				GetClientRect(hWin,@rect)
				if loword(lParam)>rect.right or hiword(lParam)>rect.bottom then
					' Mouse has left the control
					fMouseOver=FALSE
					ReleaseCapture
					SendMessage(hWin,WM_SETFONT,Cast(integer,hUrlFont),TRUE)
				endif
			endif
			'
		case WM_LBUTTONUP
			' Url was clicked
			fMouseOver=FALSE
			ReleaseCapture
			SendMessage(hWin,WM_SETFONT,Cast(integer,hUrlFont),TRUE)
			GetWindowText(hWin,@buffer,sizeof(buffer))
			ShellExecute(hWin,StrPtr("Open"),@buffer,NULL,NULL,SW_SHOWNORMAL)
			'
	end select
	return CallWindowProc(OldUrlProc,hWin,uMsg,wParam,lParam)

end function

function AboutDlgProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim as long id,event
	dim lf as LOGFONT

	select case uMsg
		case WM_INITDIALOG
			' Subclass the control
			OldUrlProc=Cast(any ptr,SetWindowLong(GetDlgItem(hWin,IDC_URL),GWL_WNDPROC,Cast(integer,@UrlProc)))
			' Get dialogs font
			hUrlFont=Cast(HFONT,SendMessage(hWin,WM_GETFONT,0,0))
			GetObject(hUrlFont,sizeof(LOGFONT),@lf)
			' Create an underlined font
			lf.lfUnderline=TRUE
			hUrlFontU=CreateFontIndirect(@lf)
			' Create a back brush
			hUrlBrush=CreateSolidBrush(GetSysColor(COLOR_3DFACE))
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			if event=BN_CLICKED then
				if id=IDOK then
					SendMessage(hWin,WM_CLOSE,NULL,NULL)
				endif
			endif
			'
		case WM_CTLCOLORSTATIC
			if GetDlgItem(hWin,IDC_URL)=lParam then
				' Set Url control colors
				if fMouseOver then
					SetTextColor(Cast(HDC,wParam),&HFF0000)
				else
					SetTextColor(Cast(HDC,wParam),0)
				endif
				SetBkMode(Cast(HDC,wParam),TRANSPARENT)
				return Cast(integer,hUrlBrush)
			endif
			return 0
		case WM_CLOSE
			' Delete font
			DeleteObject(hUrlFontU)
			' Delete brush
			DeleteObject(hUrlBrush)
			EndDialog(hWin,0)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	DialogBoxParam(GetModuleHandle(NULL),Cast(zstring ptr,IDD_DLGABOUT),NULL,@AboutDlgProc,NULL)
	''
	'' Program has ended
	''

	ExitProcess(0)
	end

'''
''' Program end
'''
