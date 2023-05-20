''
'' Multimodule Example by KetilO
''
'' IMPORTANT:
'' Modules MUST be added to the project with Project/Add New/Module or with Project/Add Existing/Modules
''
'' compile module1 with:	fbc -c module1.bas
'' compile module2 with:	fbc -c module2.bas
'' compile module3 with:	fbc -c module3.bas
'' compile main with:		fbc -s gui multimodule.rc multimodule.bas module1.o module2.o module3.o
''
'option explicit

#include once "windows.bi"
#include once "win/shlwapi.bi"

#include "MultiModule.bi"

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
' Declares for sub's in the modules
declare sub Module1(byval hWnd as HWND)
declare sub Module2(byval hWnd as HWND)
declare sub Module3(byval hWnd as HWND)

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	DialogBoxParam(GetModuleHandle(NULL), Cast(zstring ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''
	ExitProcess(0)
	end

'''
''' Program end
'''
function DlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
	dim as long id, event, x, y
	dim hBtn as HWND
	dim rect as RECT

	select case uMsg
		case WM_INITDIALOG
			SetDlgItemText(hDlg,IDC_EDT1,PathGetArgs(GetCommandLine()))
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
				case 1002
					Module1(hDlg)
					'
				case 1003
					Module2(hDlg)
					'
				case 1004
					Module3(hDlg)
					'
			end select
		case WM_SIZE
			GetClientRect(hDlg,@rect)
			hBtn=GetDlgItem(hDlg,IDC_BTN1)
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

