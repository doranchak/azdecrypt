#include once "windows.bi"
#Include Once "win/commctrl.bi"
#Include Once "win/commdlg.bi"
#Include Once "win/shellapi.bi"
#Include Once "win/richedit.bi"
#Include "RAEdit.bi"
#Include "RAEditTest.bi"

#Include "FileIO.bas"
#Include "Misc.bas"

Function WndProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim rect As RECT
	Dim buff As ZString*260
	Dim bm As Integer

	Select Case uMsg
		Case WM_INITDIALOG
			hWnd=hWin
			hREd=GetDlgItem(hWin,IDC_RAEDIT)
			SetFonts(hREd)
			SetColors(hREd)
			SetCharTab(hREd)
			SetBlocks(hREd)
			SetHighlightWords(hREd)
			SetFocus(hREd)
			'
		Case WM_COMMAND
			Select Case HiWord(wParam)
				Case BN_CLICKED,1
					Select Case LoWord(wParam)
						Case IDM_FILE_OPEN
							If WantToSave(hREd) Then
								OpenAFile(hREd)
							EndIf
							SetFocus(hREd)
							'
						Case IDM_FILE_SAVE
							SaveAFile(hREd,@szFileName)
							SetFocus(hREd)
							'
						Case IDM_FILE_NEW
							If WantToSave(hREd) Then
								' Clear current text
								SendMessage(hREd,WM_SETTEXT,0,Cast(LPARAM,StrPtr("")))
								' Set modified to FALSE
								SendMessage(hREd,EM_SETMODIFY,FALSE,0)
								szFileName=""
							EndIf
							SetFocus(hREd)
							'
						Case IDM_FILE_EXIT
							SendMessage(hWin,WM_CLOSE,0,0)
							'
						Case IDM_HELP_ABOUT
							ShellAbout(hWin,@AppName,@AboutMsg,NULL)
							SetFocus(hREd)
							'
					End Select
					'
			End Select
			'
		Case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(GetDlgItem(hWin,IDC_SBR1),0,0,0,0,TRUE)
			MoveWindow(hREd,0,0,rect.right,rect.bottom-21,TRUE)
			'
		Case WM_NOTIFY
			If Cast(NMHDR Ptr,lParam)->hwndFrom=hREd Then
				If Cast(RASELCHANGE Ptr,lParam)->seltyp=SEL_OBJECT Then
					' Bookmark clicked
					bm=SendMessage(hREd,REM_GETBOOKMARK,Cast(RASELCHANGE Ptr,lParam)->Line,0)
					If bm=1 Then
						' Collapse
						SendMessage(hREd,REM_COLLAPSE,Cast(RASELCHANGE Ptr,lParam)->Line,0)
					ElseIf bm=2 Then
						' Expand
						SendMessage(hREd,REM_EXPAND,Cast(RASELCHANGE Ptr,lParam)->Line,0)
					EndIf
				Else
					' Selection changed
					buff="Ln: " & Str(Cast(RASELCHANGE Ptr,lParam)->Line+1) & " Pos: " & Str(Cast(RASELCHANGE Ptr,lParam)->chrg.cpMin-Cast(RASELCHANGE Ptr,lParam)->cpLine+1)
					SendDlgItemMessage(hWin,IDC_SBR1,SB_SETTEXT,0,Cast(LPARAM,@buff))
					If Cast(RASELCHANGE Ptr,lParam)->fchanged Then
						' Update comment blocks
						SendMessage(hREd,REM_SETCOMMENTBLOCKS,Cast(WPARAM,StrPtr("/'")),Cast(LPARAM,StrPtr("'/")))
						' Update block bookmarks
						SendMessage(hREd,REM_SETBLOCKS,0,0)
					EndIf
				EndIf
			EndIf
		Case WM_CLOSE
			DestroyWindow(hWin)
			'
		Case WM_DESTROY
			PostQuitMessage(NULL)
			'
		Case Else
			Return DefWindowProc(hWin,uMsg,wParam,lParam)
			'
	End Select
	Return 0

End Function

Function WinMain(ByVal hInst As HINSTANCE,ByVal hPrevInst As HINSTANCE,ByVal CmdLine As ZString ptr,ByVal CmdShow As Integer) As Integer
	Dim wc As WNDCLASSEX
	Dim msg As MSG

	' Setup and register class for dialog
	wc.cbSize=SizeOf(WNDCLASSEX)
	wc.style=CS_HREDRAW or CS_VREDRAW
	wc.lpfnWndProc=@WndProc
	wc.cbClsExtra=0
	wc.cbWndExtra=DLGWINDOWEXTRA
	wc.hInstance=hInst
	wc.hbrBackground=Cast(HBRUSH,COLOR_BTNFACE+1)
	wc.lpszMenuName=Cast(ZString Ptr,IDM_MENU)
	wc.lpszClassName=@ClassName
	wc.hIcon=LoadIcon(NULL,IDI_APPLICATION)
	wc.hIconSm=wc.hIcon
	wc.hCursor=LoadCursor(NULL,IDC_ARROW)
	RegisterClassEx(@wc)
	' Create and show the dialog
	CreateDialogParam(hInstance,Cast(ZString Ptr,IDD_DIALOG),NULL,@WndProc,NULL)
	ShowWindow(hWnd,SW_SHOWNORMAL)
	UpdateWindow(hWnd)
	' Message loop
	Do While GetMessage(@msg,NULL,0,0)
		TranslateMessage(@msg)
		DispatchMessage(@msg)
	Loop
	Return msg.wParam

End Function

' Program start
hInstance=GetModuleHandle(NULL)
CommandLine=GetCommandLine
InitCommonControls
hLib=LoadLibrary(@szLib)
If hLib Then
	WinMain(hInstance,NULL,CommandLine,SW_SHOWDEFAULT)
	FreeLibrary(hLib)
Else
	MessageBox(0,"RAEdit.dll not found",@AppName,MB_OK)
EndIf
ExitProcess(0)

End
