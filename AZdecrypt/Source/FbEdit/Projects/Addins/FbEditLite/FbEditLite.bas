#Include Once "windows.bi"
#Include Once "win/commctrl.bi"

#Include "..\..\..\..\..\Inc\Addins.bi"

#Include "FbEditLite.bi"

Sub DeleteFromMenu()
	Dim hMnu As HMENU
	Dim mii As MENUITEMINFO
	
	hMnu=lpHandles->hmenu
	DeleteMenu(hMnu,IDM_FILE_NEW_RESOURCE,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_FILE_OPEN_HEX,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_FORMAT,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_VIEW_DIALOG,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_VIEW_SPLITSCREEN,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_VIEW_FULLSCREEN,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_VIEW_DUALPANE,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_RESOURCE,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_MAKE_RUNDEBUG,MF_BYCOMMAND)

	DeleteMenu(hMnu,IDM_TOOLS,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_OPTIONS_DIALOG,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_OPTIONS_DEBUG,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_OPTIONS_EXTERNALFILES,MF_BYCOMMAND)
	DeleteMenu(hMnu,IDM_OPTIONS_TOOLS,MF_BYCOMMAND)

	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_SUBMENU
	GetMenuItemInfo(lpHANDLES->hmenu,IDM_MAKE,FALSE,@mii)
	DeleteMenu(mii.hSubMenu,3,MF_BYPOSITION)

	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_SUBMENU
	GetMenuItemInfo(lpHANDLES->hmenu,IDM_VIEW,FALSE,@mii)
	DeleteMenu(mii.hSubMenu,7,MF_BYPOSITION)

	DrawMenuBar(lpHandles->hwnd)

End Sub

Sub Activate()
	Dim n As Integer
	
	n=GetPrivateProfileInt("Win","Lite",-1,lpData->IniFile)
	If n=-1 Then
		n=MessageBox(lpHandles->hwnd,@Install,@Caption,MB_YESNOCANCEL Or MB_ICONQUESTION)
		If n=IDYES Then
			WritePrivateProfileSection("Addins",@Addins,lpData->IniFile)
			WritePrivateProfileString("Win","Lite","1",lpData->IniFile)
			End
		ElseIf n=IDNO Then
			WritePrivateProfileString("Win","Lite","0",lpData->IniFile)
		EndIf
	ElseIf n=1 Then
		DeleteFromMenu
	EndIf

End Sub

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll Cdecl Alias "InstallDll" (ByVal hWin As HWND,ByVal hInst As HINSTANCE) As ADDINHOOKS Ptr Export

	' The dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES Ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA Ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS Ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	' Messages this addin will hook into
	hooks.hook1=HOOK_ADDINSLOADED
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	Return @hooks

End Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction Cdecl Alias "DllFunction" (ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As bool Export

	Select Case uMsg
		Case AIM_ADDINSLOADED
			Activate
			'
	End Select
	Return FALSE

End Function
