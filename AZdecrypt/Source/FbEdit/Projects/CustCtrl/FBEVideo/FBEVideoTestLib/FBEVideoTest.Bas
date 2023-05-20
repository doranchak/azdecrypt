/'
	Dialog Example, by fsw

	compile with:	fbc -s gui dialog.rc dialog.bas

'/

'option explicit

#include once "windows.bi"
#include once "win/commdlg.bi"
#include once "win/mmsystem.bi"

#include "..\FBEVideo.bi"
#include "FBEVideoTest.bi"
#inclib "FBEVideo"

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

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
	end

'''
''' Program end
'''
function DlgProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim rect as RECT
	dim st as Integer
	dim ofn as OPENFILENAME
	dim hMCIWnd as HWND

	select case uMsg
		case WM_INITDIALOG
			'
		case WM_ACTIVATE
			if fActivated=FALSE then
				sFile="http://www.blitzbasement.net/bank/aliensong.mpeg"
				fActivated=TRUE
				SendMessage(GetDlgItem(hWin,IDC_VID1),FBEVID_PLAY,0,Cast(LPARAM,@sFile))
			endif
			'
		case WM_CLOSE
			EndDialog(hWin, 0)
			'
		case WM_COMMAND
			select case loword(wParam)
				case IDM_FILE_EXIT
					EndDialog(hWin, 0)
					'
				case IDM_FILE_OPEN
					ofn.lStructSize=sizeof(OPENFILENAME)
					ofn.hwndOwner=hWin
					ofn.hInstance=GetModuleHandle(NULL)
					sFile=string(260,0)
					ofn.lpstrFile=@sFile
					ofn.nMaxFile=260
					ofn.lpstrFilter=0
					ofn.lpstrTitle=StrPtr("Video File")
					ofn.Flags=OFN_PATHMUSTEXIST or OFN_HIDEREADONLY or OFN_FILEMUSTEXIST or OFN_EXPLORER
					if GetOpenFileName(@ofn) then
						fRepeat=0
						SendMessage(GetDlgItem(hWin,IDC_VID1),FBEVID_PLAY,0,Cast(LPARAM,@sFile))
					endif
					'
				case IDM_VIEW_BAR
					hMCIWnd=Cast(HWND,SendMessage(GetDlgItem(hWin,IDC_VID1),FBEVID_GETMCIWND,0,0))
					if hMCIWnd then
						fRepeat=0
						st=SendMessage(hMCIWnd,MCIWNDM_GETPOSITION,0,0)
						SendMessage(GetDlgItem(hWin,IDC_VID1),FBEVID_STOP,0,0)
						SetWindowLong(GetDlgItem(hWin,IDC_VID1),GWL_STYLE,GetWindowLong(GetDlgItem(hWin,IDC_VID1),GWL_STYLE)xor STYLE_PLAYBAR)
						SendMessage(GetDlgItem(hWin,IDC_VID1),FBEVID_PLAY,0,Cast(LPARAM,@sFile))
						hMCIWnd=Cast(HWND,SendMessage(GetDlgItem(hWin,IDC_VID1),FBEVID_GETMCIWND,0,0))
						SendMessage(hMCIWnd,MCIWNDM_PLAYFROM,0,st)
					else
						SetWindowLong(GetDlgItem(hWin,IDC_VID1),GWL_STYLE,GetWindowLong(GetDlgItem(hWin,IDC_VID1),GWL_STYLE)xor STYLE_PLAYBAR)
					endif
					'
				case IDM_VIEW_ASPECT
					SetWindowLong(GetDlgItem(hWin,IDC_VID1),GWL_STYLE,GetWindowLong(GetDlgItem(hWin,IDC_VID1),GWL_STYLE)xor STYLE_KEEPASPECT)
					'
				case IDM_VIEW_REPEAT
					fRepeat=fRepeat xor 1
					'
				case IDM_VIEW_STOP
					fRepeat=0
					SendMessage(GetDlgItem(hWin,IDC_VID1),FBEVID_STOP,0,0)
					'
			end select
		case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(GetDlgItem(hWin,IDC_VID1),0,0,rect.right,rect.bottom,TRUE)
			'
		case MCIWNDM_NOTIFYMODE
			if lParam=MCI_MODE_STOP then
				if fRepeat then
					SendMessage(GetDlgItem(hWin,IDC_VID1),FBEVID_PLAY,0,Cast(LPARAM,@sFile))
				endif
			endif
			'
		case MCIWNDM_NOTIFYPOS
			'MessageBeep(MB_OK)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
