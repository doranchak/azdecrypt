#Include Once "windows.bi"
#Include Once "win/commctrl.bi"

#Include "..\..\FbEdit\Inc\Addins.bi"

#Include "TortoiseSVN.bi"

Sub AddMenuSep
	dim hMnu as HMENU

	hMnu=GetSubMenu(lpHandles->hcontextmenu,1)
	AppendMenu(hMnu,MF_SEPARATOR,0,0)

End Sub

Sub AddToMenu(byval id as Integer,ByVal lpText As ZString ptr)
	dim hMnu as HMENU
	
	hMnu=GetSubMenu(lpHandles->hcontextmenu,1)
	AppendMenu(hMnu,MF_STRING,id,lpText)

end Sub

Sub EnableMenu(ByVal iEnable As Integer)
	dim hMnu as HMENU

	hMnu=GetSubMenu(lpHandles->hcontextmenu,1)
	EnableMenuItem(hMnu,idlog,iEnable)
	EnableMenuItem(hMnu,idupdate,iEnable)
	EnableMenuItem(hMnu,idcommit,iEnable)

End Sub

Function GetString(ByVal id As Integer) As String

	Return lpFunctions->FindString(lpData->hLangMem,"TortoiseSVN",Str(id))

End Function

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll Cdecl Alias "InstallDll" (ByVal hWin As HWND,ByVal hInst As HINSTANCE) As ADDINHOOKS ptr Export
	Dim buff As ZString*260
	Dim hReg As HANDLE
	Dim lpdwDisp As Integer
	Dim lpcbData As Integer
	Dim lpType As Integer

	' The dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	hooks.hook1=0
	RegCreateKeyEx(HKEY_LOCAL_MACHINE,StrPtr("SOFTWARE\Classes\svn\DefaultIcon\"),0,StrPtr("REG_SZ"),0,KEY_READ,0,@hReg,@lpdwDisp)
	If lpdwDisp=REG_OPENED_EXISTING_KEY Then
		lpcbData=260
		RegQueryValueEx(hReg,StrPtr(""),0,@lpType,@buff,@lpcbData)
		RegCloseKey(hReg)
		szapp="""" & buff & """"
		AddMenuSep
		idlog=SendMessage(hWin,AIM_GETMENUID,0,0)
		buff=GetString(10000)
		If buff="" Then
			buff="SVN Log"
		EndIf
		AddToMenu(idlog,StrPtr(buff))
		idupdate=SendMessage(hWin,AIM_GETMENUID,0,0)
		buff=GetString(10001)
		If buff="" Then
			buff="SVN Update"
		EndIf
		AddToMenu(idupdate,StrPtr(buff))
		idcommit=SendMessage(hWin,AIM_GETMENUID,0,0)
		buff=GetString(10002)
		If buff="" Then
			buff="SVN Commit"
		EndIf
		AddToMenu(idcommit,StrPtr(buff))
		EnableMenu(MF_GRAYED Or MF_BYCOMMAND)
		' Messages this addin will hook into
		hooks.hook1=HOOK_COMMAND Or HOOK_PROJECTOPEN Or HOOK_PROJECTCLOSE
	EndIf
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	Return @hooks

End Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction Cdecl Alias "DllFunction" (ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As bool Export
	Dim buff As ZString*260

	Select Case uMsg
		Case AIM_COMMAND
			Select Case wParam
				Case idlog
					buff=szApp & " /command:log /path:" & lpData->ProjectPath & " /notempfile /closeonend"
					WinExec(@buff,SW_SHOWNORMAL)
					'
				Case idupdate
					buff=szApp & " /command:update /path:" & lpData->ProjectPath & " /notempfile /closeonend"
					WinExec(@buff,SW_SHOWNORMAL)
					'
				Case idcommit
					buff=szApp & " /command:commit /path:" & lpData->ProjectPath & " /notempfile /closeonend"
					WinExec(@buff,SW_SHOWNORMAL)
					'
			End Select
			'
		Case AIM_CLOSE
			'
		Case AIM_PROJECTOPEN
			lstrcpy(@buff,lpData->ProjectPath)
			buff=buff & "\.svn"
			If GetFileAttributes(@buff)<>-1 Then
				EnableMenu(MF_ENABLED Or MF_BYCOMMAND)
			EndIf
			'
		Case AIM_PROJECTCLOSE
			EnableMenu(MF_GRAYED Or MF_BYCOMMAND)
			'
	End Select
	Return FALSE

End Function
