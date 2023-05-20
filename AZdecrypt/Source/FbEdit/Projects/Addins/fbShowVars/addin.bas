/' ShowVars, by Denise Amiga

	Addin for FBEdit
	
	Mini Debug.

'/

#Include "fbshowvars.bi"

#Include "addinfunc.bas"
#Include "functions.bas"
#Include "callbacks.bas"
#Include "misc.bas"

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll Cdecl Alias "InstallDll" ( ByVal hWin As HWND, ByVal hInst As HINSTANCE ) As ADDINHOOKS ptr Export
	Dim mii As MENUITEMINFO

	hInstance = hInst
	lpData = Cast( ADDINDATA ptr, SendMessage( hWin, AIM_GETDATA, 0, 0 ) )
	lpHandles = Cast( ADDINHANDLES ptr, SendMessage( hWin, AIM_GETHANDLES, 0, 0 ) )
	lpFunctions = Cast( ADDINFUNCTIONS ptr, SendMessage( hWin, AIM_GETFUNCTIONS, 0, 0 ) )
	lpOldMain = Cast( Any ptr, SetWindowLong( lpHandles->hwnd, GWL_WNDPROC, Cast( Integer, @FBEProc ) ) )

	hMenu = CreatePopupMenu( )
	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_SUBMENU
	GetMenuItemInfo(lpHANDLES->hmenu,10021,FALSE,@mii)
	AppendMenu( mii.hSubMenu, MF_STRING Or MF_POPUP, Cast( Integer,hMenu ), GetString( 999, "ShowVars" ) )
	IDM_SHOWVARS_HIDE = SendMessage( hWin, AIM_GETMENUID, 0, 0 )
	IDM_SHOWVARS_NEXT = SendMessage( hWin, AIM_GETMENUID, 0, 0 )
	IDM_SHOWVARS_PREV = SendMessage( hWin, AIM_GETMENUID, 0, 0 )
	IDM_SHOWVARS_CLEAR = SendMessage( hWin, AIM_GETMENUID, 0, 0 )
	AppendMenu( hMenu, MF_STRING, IDM_SHOWVARS_HIDE, GetString( 1000, "Hide" ) )
	AppendMenu( hMenu, MF_STRING, IDM_SHOWVARS_NEXT, GetString( 1001, "Next Tab	Ctrl+F6" ) )
	AppendMenu( hMenu, MF_STRING, IDM_SHOWVARS_PREV, GetString( 1002, "Prev Tab	Shift+Ctrl+F6" ) )
	AppendMenu( hMenu, MF_STRING, IDM_SHOWVARS_CLEAR, GetString( 1003, "Clear Tab" ) )
	AddAccelerator( FVIRTKEY Or FNOINVERT Or FCONTROL, VK_F6, IDM_SHOWVARS_NEXT )
	AddAccelerator( FVIRTKEY Or FNOINVERT Or FSHIFT Or FCONTROL, VK_F6, IDM_SHOWVARS_PREV )

	hooks.hook1 = HOOK_COMMAND Or HOOK_ADDINSLOADED Or HOOK_CLOSE
	hooks.hook2 = 0
	hooks.hook3 = 0
	hooks.hook4 = 0
	Return @hooks

End Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction Cdecl Alias "DllFunction" ( ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer Export

	Dim As RECT rc1

	Select Case uMsg
		Case AIM_ADDINSLOADED
			lpFunctions->LoadFromIni( "ShowVars", "Dock", "444444444", @dock1, FALSE )
			lpData->bExtOutput=TRUE
			GetViewSizes(@nSize)
			hDbgWin = CreateDialogParam( hInstance, Cast( ZString ptr, IDD_DLG00 ), NULL, @DlgProc, NULL )
			'
		Case AIM_COMMAND
			Select Case LoWord( wParam )
				Case IDM_SHOWVARS_HIDE
					SendMessage( hDbgWin, DBG_STATE, FALSE, 0 )
					If (lpHandles->hred<>0) And (lpHandles->hred<>lpHandles->hres) Then SetFocus( lpHandles->hred )
					'
				Case IDM_SHOWVARS_NEXT
					If dock1.nActualTab >= TAB_6 Then Return 0
					SendMessage( hDbgWin, DBG_SELECT, dock1.nActualTab+1301, 0 )
					'
				Case IDM_SHOWVARS_PREV
					If dock1.nActualTab <= TAB_0 Then Return 0
					SendMessage( hDbgWin, DBG_SELECT, dock1.nActualTab+1299, 0 )
					'
				Case IDM_SHOWVARS_CLEAR
					SendMessage( hDbgWin, DBG_CLEAR, (1 Shl dock1.nActualTab), 0 )
					'
				Case IDM_VIEW_OUTPUT
					lpData->lpWINPOS->fview Xor= VIEW_OUTPUT
					ShowWindow( hDbgWin, lpData->lpWINPOS->fview And (VIEW_OUTPUT Or VIEW_IMMEDIATE) )
					SendMessage(lpHandles->htoolbar,TB_CHECKBUTTON,IDM_VIEW_OUTPUT,lpData->lpWINPOS->fview And VIEW_OUTPUT)
					CheckMenuItem(lpHandles->hmenu,IDM_VIEW_OUTPUT,IIf(lpData->lpWINPOS->fview And VIEW_OUTPUT,MF_CHECKED,MF_UNCHECKED))
					SendMessage(hWin,WM_SIZE,0,0)
					If ((lpData->lpWINPOS->fview And VIEW_OUTPUT)=FALSE) And (lpHandles->hred<>0) And (lpHandles->hred<>lpHandles->hres) Then SetFocus( lpHandles->hred )
					Return TRUE
				Case IDM_VIEW_IMMEDIATE
					lpData->lpWINPOS->fview Xor= VIEW_IMMEDIATE
					ShowWindow( hDbgWin, lpData->lpWINPOS->fview And (VIEW_OUTPUT Or VIEW_IMMEDIATE) )
					SendMessage(lpHandles->htoolbar,TB_CHECKBUTTON,IDM_VIEW_IMMEDIATE,lpData->lpWINPOS->fview And VIEW_IMMEDIATE)
					CheckMenuItem(lpHandles->hmenu,IDM_VIEW_IMMEDIATE,IIf(lpData->lpWINPOS->fview And VIEW_IMMEDIATE,MF_CHECKED,MF_UNCHECKED))
					SendMessage(hWin,WM_SIZE,0,0)
					If ((lpData->lpWINPOS->fview And VIEW_IMMEDIATE)=FALSE) And (lpHandles->hred<>0) And (lpHandles->hred<>lpHandles->hres) Then SetFocus( lpHandles->hred )
					Return TRUE
					'
			End Select
			'
		Case AIM_CLOSE
			If dock1.fDocked = FALSE Then
				GetWindowRect(hDbgWin,@rc1)
				dock1.nPos.left = rc1.left
				dock1.nPos.top = rc1.top
				dock1.nPos.right = rc1.right - rc1.left
				dock1.nPos.bottom = rc1.bottom - rc1.top
			EndIf
			lpFunctions->SaveToIni( "ShowVars", "Dock", "444444444", @dock1, FALSE )
			lpData->bExtOutput=FALSE
			DestroyWindow( hDbgWin )
			DestroyMenu( hMenu )
			'
	End Select
	Return FALSE

End Function
