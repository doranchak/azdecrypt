DialogAsMain
Dialog as main window
[*BEGINPRO*]
[*BEGINDEF*]
[Project]
Version=2
Description=Dialog as main window
Api=fb (FreeBASIC),win (Windows)
Grouping=1
AddMainFiles=1
ResExport=
[Make]
Current=1
1=Windows GUI,fbc -s gui
Recompile=2
Module=Module Build,fbc -c
Output=
Run=
[*ENDDEF*]
[*BEGINTXT*]
[*PRONAME*].bas
#include once "windows.bi"
#Include Once "win/commctrl.bi"
#Include Once "win/commdlg.bi"
#Include Once "win/shellapi.bi"
#Include "[*PRONAME*].bi"

Function WndProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer

	Select Case uMsg
		Case WM_INITDIALOG
			hWnd=hWin
			'
		Case WM_COMMAND
			Select Case HiWord(wParam)
				Case BN_CLICKED,1
					Select Case LoWord(wParam)
						Case IDM_FILE_EXIT
							SendMessage(hWin,WM_CLOSE,0,0)
							'
						Case IDM_HELP_ABOUT
							ShellAbout(hWin,@AppName,@AboutMsg,NULL)
							'
					End Select
					'
			End Select
			'
		Case WM_SIZE
			'
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
WinMain(hInstance,NULL,CommandLine,SW_SHOWDEFAULT)
ExitProcess(0)

End
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].rc
#define IDD_DIALOG 1000
#define IDR_MENU 10000
#define IDM_FILE_EXIT 10001
#define IDM_HELP_ABOUT 10101
IDD_DIALOG DIALOGEX 6,6,194,102
CAPTION "Dialog As Main"
FONT 8,"MS Sans Serif",0,0
CLASS "DLGCLASS"
MENU IDR_MENU
STYLE 0x10CF0000
BEGIN
END
IDR_MENU MENU
BEGIN
  POPUP "&File"
  BEGIN
    MENUITEM "&Exit",IDM_FILE_EXIT
  END
  POPUP "&Help"
  BEGIN
    MENUITEM "&About",IDM_HELP_ABOUT
  END
END
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].bi
#Define IDD_DIALOG			1000

#Define IDM_MENU				10000
#Define IDM_FILE_EXIT		10001
#Define IDM_HELP_ABOUT		10101

Dim Shared hInstance As HMODULE
Dim Shared CommandLine As ZString Ptr
Dim Shared hWnd As HWND

Const ClassName="DLGCLASS"
Const AppName="Dialog as main"
Const AboutMsg=!"FbEdit Dialog as main\13\10Copyright © FbEdit 2007"
[*ENDTXT*]
[*ENDPRO*]
