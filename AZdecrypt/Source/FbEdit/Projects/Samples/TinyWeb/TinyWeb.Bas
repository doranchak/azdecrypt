
#Include once "windows.bi"

#include "TinyWeb.bi"

function DlgProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim rect as RECT
	Dim i As Integer
	Dim wUrl As WString*260

	select case uMsg
		case WM_INITDIALOG
			hWeb=CreateWindowEx(WS_EX_CLIENTEDGE,"AtlAxWin","http://www.radasm.com/fbedit/",WS_CHILD Or WS_VISIBLE Or WS_VSCROLL Or WS_HSCROLL,0,0,100,100,hWin,0,hInstance,0)
			' Get the IUnknown interface
			AtlAxGetControl(hWeb,pIUnknown)
			IUnknown=Cast(IUnknown ptr,*pIUnknown)
			i=IUnknown->AddRef(pIUnknown)
			' Get the IWebBrowser interface
			i=IUnknown->QueryInterface(pIUnknown,@IID_IWebBrowser,@pIWebBrowser)
			IWebBrowser=Cast(IWebBrowser ptr,*pIWebBrowser)
			i=IWebBrowser->AddRef(pIWebBrowser)
			i=IUnknown->Release(pIUnknown)
			'
		case WM_COMMAND
			Select Case LoWord(wParam)
				Case IDM_FILE_GOTO1
					MultiByteToWideChar(CP_ACP,0,StrPtr("http://www.radasm.com/"),-1,@wUrl,260)
					i=IWebBrowser->Navigate(pIWebBrowser,@wUrl,NULL,NULL,NULL,NULL)
					'
				Case IDM_FILE_BACK
					i=IWebBrowser->GoBack(pIWebBrowser)
					'
				Case IDM_FILE_FORWARD
					i=IWebBrowser->GoForward(pIWebBrowser)
					'
				Case IDM_FILE_EXIT
					i=IWebBrowser->Release(pIWebBrowser)
					EndDialog(hWin,0)
					'
			End Select
		case WM_CLOSE
			EndDialog(hWin, 0)
			'
		case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(hWeb,0,0,rect.right,rect.bottom,TRUE)
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

	hInstance=GetModuleHandle(NULL)
	hDll=LoadLibrary("atl.dll")
	If hDll Then
		AtlAxWinInit=Cast(Any ptr,GetProcAddress(hDll,"AtlAxWinInit"))
		AtlAxGetControl=Cast(Any ptr,GetProcAddress(hDll,"AtlAxGetControl"))
		If AtlAxWinInit() Then
			DialogBoxParam(hInstance,Cast(zstring ptr,IDD_DLG1),NULL,@DlgProc,NULL)
		EndIf
		FreeLibrary(hDll)
	EndIf
	''
	'' Program has ended
	''

	ExitProcess(0)
	end

'''
''' Program end
'''
