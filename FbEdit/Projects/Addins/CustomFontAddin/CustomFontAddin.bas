#Include once "windows.bi"
#include once "win/commctrl.bi"
#Include Once "win/commdlg.bi"

#include "..\..\FbEdit\Inc\Addins.bi"
#Include "CustomFontAddin.bi"

dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpFunctions as ADDINFUNCTIONS ptr
dim SHARED lpData as ADDINDATA ptr
Declare Function DlgProc(ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer

function InstallDll CDECL alias "InstallDll" (byval hWin as HWND,byval hInst as HINSTANCE) as ADDINHOOKS ptr EXPORT
	Dim buff As ZString*256
	Dim mii As MENUITEMINFO

	' The dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	
	' Get handle to 'Options' popup
	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_SUBMENU
	GetMenuItemInfo(lpHANDLES->hmenu,10161,FALSE,@mii)
	' Add our menu item to Options menu
	IDM_CUSTOMFONT=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=lpFunctions->FindString(lpData->hLangMem,"CustomFontAddin","10000")
	If buff="" Then
		buff="Custom Font"
	EndIf
	AppendMenu(mii.hSubMenu,MF_STRING,IDM_CUSTOMFONT,StrPtr(buff))	
	
	' Messages this addin will hook into
	hooks.hook1=HOOK_ADDINSLOADED Or HOOK_CLOSE Or HOOK_COMMAND
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool Export
	Dim path As String = ExePath & "\AddIns\CustomFontAddin.ini"
	Select Case uMsg
		Case AIM_COMMAND
			if loword(wParam)=IDM_CUSTOMFONT then
				DialogBoxParam(hInstance,Cast(zstring ptr,IDD_DLG1),hWin,@DlgProc,NULL)
			EndIf
		Case AIM_ADDINSLOADED
			Open path For Input As #1
			Input #1,oldFontName
			Close #1
			AddFontResource(Cast(Zstring ptr,@oldFontName))
			newFontName = oldFontName
		Case AIM_CLOSE
			RemoveFontResource(Cast(Zstring ptr,@newFontName))
	End Select
	Return FALSE
end Function

Function OpenFontFile(ByVal hWin As HWND) As String
	Dim ofn As OPENFILENAME
	Dim buff As ZString*260
	Dim buff2 As ZString*260
	Dim path As String = ExePath

	ofn.lStructSize=SizeOf(OPENFILENAME)
	ofn.hwndOwner=hWin
	ofn.hInstance=hInstance
	ofn.lpstrInitialDir=StrPtr(path)
	buff=String(260,0)
	ofn.lpstrFile=@buff
	ofn.nMaxFile=260
	ofn.lpstrFilter=StrPtr(szFilter)
	buff2=lpFunctions->FindString(lpData->hLangMem,"CustomFontAddin","10001")
	If buff2="" Then
		buff2="Add New Font"
	EndIf
	ofn.lpstrTitle=StrPtr(buff2)
	ofn.Flags=OFN_PATHMUSTEXIST Or OFN_HIDEREADONLY Or OFN_EXPLORER
	If GetOpenFileName(@ofn) Then
		Return buff
	EndIf

End Function

Function DlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As integer
	Dim As long id, Event, x, y
	Dim hBtn As HWND
	Dim rect As RECT
	Dim buff As ZString*260
	Dim path As String = ExePath & "\AddIns\CustomFontAddin.ini"

	Select Case uMsg
		Case WM_INITDIALOG
			lpFunctions->TranslateAddinDialog(hWin,"CustomFontAddin")
			SetDlgItemText(hWin,IDC_EDT1,@oldFontName)
			'
		Case WM_CLOSE
			EndDialog(hWin, 0)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case id
				Case IDC_BROWSE
					buff=OpenFontFile(hWin)
					SetDlgItemText(hWin,IDC_EDT1,@buff)
					'
				Case IDC_OK
					RemoveFontResource(Cast(Zstring ptr,@oldFontName))
					AddFontResource(Cast(Zstring ptr,@newFontName))
					GetDlgItemText(hWin,IDC_EDT1,@newFontName,260)
					Open path For Output As #1
					Print #1, newFontName
					Close #1
					oldFontName = newFontName
					EndDialog(hWin,0)
				Case IDC_CANCEL
					EndDialog(hWin,0)
			End Select

		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function