#Include Once "windows.bi"
#Include Once "win/richedit.bi"
#Include Once "win/commctrl.bi"

#Include "..\..\FbEdit\Inc\RAEdit.bi"
#Include "..\..\FbEdit\Inc\Addins.bi"

#Include "AdvEdit.bi"

Sub AddToMenu(ByVal id As Integer,ByVal sMenu As String)

	AppendMenu(hSubMnu,MF_STRING,id,sMenu)

End Sub

Sub UpdateMenu(ByVal id As Integer,ByVal sMenu As String)
	Dim mii As MENUITEMINFO

	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_TYPE
	mii.fType=MFT_STRING
	mii.dwTypeData=@sMenu
	SetMenuItemInfo(lpHandles->hmenu,id,FALSE,@mii)

End Sub

Sub AddAccelerator(ByVal fvirt As Integer,ByVal akey As Integer,ByVal id As Integer)
	Dim nAccel As Integer
	Dim acl(500) As ACCEL
	Dim i As Integer

	nAccel=CopyAcceleratorTable(lpHandles->haccel,NULL,0)
	CopyAcceleratorTable(lpHandles->haccel,@acl(0),nAccel)
	DestroyAcceleratorTable(lpHandles->haccel)
	' Check if id exist
	For i=0 To nAccel-1
		If acl(i).cmd=id Then
			' id exist, update accelerator
			acl(i).fVirt=fvirt
			acl(i).key=akey
			GoTo Ex
		EndIf
	Next i
	' Check if accelerator exist
	For i=0 To nAccel-1
		If acl(i).fVirt=fvirt And acl(i).key=akey Then
			' Accelerator exist, update id
			acl(i).cmd=id
			GoTo Ex
		EndIf
	Next i
	' Add new accelerator
	acl(nAccel).fVirt=fvirt
	acl(nAccel).key=akey
	acl(nAccel).cmd=id
	nAccel=nAccel+1
Ex:
	lpHandles->haccel=CreateAcceleratorTable(@acl(0),nAccel)

End Sub

Sub AddToolbarButton(ByVal id As Integer,ByVal idbmp As Integer)
	Dim tbab As TBADDBITMAP
	Dim tbbtn As TBBUTTON

	tbab.hInst=hInstance
	tbab.nID=idbmp
	tbbtn.iBitmap=SendMessage(lpHandles->htoolbar,TB_ADDBITMAP,1,Cast(LPARAM,@tbab))

	tbbtn.idCommand=id
	tbbtn.fsState=TBSTATE_ENABLED
	tbbtn.fsStyle=TBSTYLE_BUTTON
	SendMessage(lpHandles->htoolbar,TB_BUTTONSTRUCTSIZE,SizeOf(TBBUTTON),0)
	SendMessage(lpHandles->htoolbar,TB_INSERTBUTTON,-1,Cast(LPARAM,@tbbtn))
	lpData->tbwt=lpData->tbwt+24

End Sub

Function GetString(ByVal id As Integer) As String
'	Dim buff As ZString*256

'	buff=
	Return lpFunctions->FindString(lpData->hLangMem,"AdvEdit",Str(id))

End Function

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll Cdecl Alias "InstallDll" (ByVal hWin As HWND,ByVal hInst As HINSTANCE) As ADDINHOOKS ptr Export
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
	' Add "Advanced" sub menu to "Edit" menu.
	hSubMnu=CreatePopupMenu
	buff=GetString(10000)
	If buff="" Then
		buff="Advanced Edit"
	EndIf
	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_SUBMENU
	GetMenuItemInfo(lpHANDLES->hmenu,10021,FALSE,@mii)
	AppendMenu(mii.hSubMenu,MF_STRING Or MF_POPUP,Cast(Integer,hSubMnu),buff)

	' Add menu items to "Advanced" sub menu
	' Word commands
	IdSelectWord=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10001)
	If buff="" Then
		buff="Select Word	Shift+Ctrl+W"
	EndIf
	AddToMenu(IdSelectWord,buff)
	AddAccelerator(FVIRTKEY Or FNOINVERT Or FSHIFT Or FCONTROL,Asc("W"),IdSelectWord)
	IdCopyWord=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10002)
	If buff="" Then
		buff="Copy Word	Shift+Ctrl+C"
	EndIf
	AddToMenu(IdCopyWord,buff)
	AddAccelerator(FVIRTKEY Or FNOINVERT Or FSHIFT Or FCONTROL,Asc("C"),IdCopyWord)
	IdCutWord=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10003)
	If buff="" Then
		buff="Cut Word	Shift+Ctrl+X"
	EndIf
	AddToMenu(IdCutWord,buff)
	AddAccelerator(FVIRTKEY Or FNOINVERT Or FSHIFT Or FCONTROL,Asc("X"),IdCutWord)
	IdDeleteWord=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10004)
	If buff="" Then
		buff="Delete Word"
	EndIf
	AddToMenu(IdDeleteWord,buff)
	' Line commands
	IdSelectLine=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10005)
	If buff="" Then
		buff="Select Line	Shift+Ctrl+L"
	EndIf
	AddToMenu(IdSelectLine,buff)
	AddAccelerator(FVIRTKEY Or FNOINVERT Or FSHIFT Or FCONTROL,Asc("L"),IdSelectLine)
	IdCopyLine=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10006)
	If buff="" Then
		buff="Copy Line	Alt+Ctrl+C"
	EndIf
	AddToMenu(IdCopyLine,buff)
	AddAccelerator(FVIRTKEY Or FNOINVERT Or FALT Or FCONTROL,Asc("C"),IdCopyLine)
	IdCutLine=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10007)
	If buff="" Then
		buff="Cut Line	Alt+Ctrl+X"
	EndIf
	AddToMenu(IdCutLine,buff)
	AddAccelerator(FVIRTKEY Or FNOINVERT Or FALT Or FCONTROL,Asc("X"),IdCutLine)
	IdDeleteLine=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10008)
	If buff="" Then
		buff="Delete Line"
	EndIf
	AddToMenu(IdDeleteLine,buff)
	IdDuplicateLine=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=GetString(10010)
	If buff="" Then
		buff="Duplicate Line	Ctrl+D"
	EndIf
	AddToMenu(IdDuplicateLine,buff)
	AddAccelerator(FVIRTKEY Or FNOINVERT Or FCONTROL,Asc("D"),IdDuplicateLine)


/'	' Change accelerator for an existing command
	#define IDM_EDIT_REDO						10023
	' Update the accelerator
	AddAccelerator(FVIRTKEY or FNOINVERT or FSHIFT or FCONTROL,Asc("Z"),IDM_EDIT_REDO)
	' Update the menu
	UpdateMenu(IDM_EDIT_REDO,"&Redo	Shift+Ctrl+Z")
'/

	' Add quick run button to toolbar
	AddToolbarButton(IDM_MAKE_QUICKRUN,100)
	' Get toolbar button tooltip
	szQuickRun=GetString(10009)
	If szQuickRun="" Then
		szQuickRun="Quick run"
	EndIf

	' Messages this addin will hook into
	hooks.hook1=HOOK_COMMAND Or HOOK_GETTOOLTIP Or HOOK_MENUENABLE
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	Return @hooks

End Function

Sub SelectWord
	Dim chrg As CHARRANGE

	SendMessage(lpHandles->hred,EM_EXGETSEL,0,Cast(LPARAM,@chrg))
	chrg.cpMin=SendMessage(lpHandles->hred,EM_FINDWORDBREAK,WB_MOVEWORDLEFT,chrg.cpMin)
	chrg.cpMax=SendMessage(lpHandles->hred,EM_FINDWORDBREAK,WB_MOVEWORDRIGHT,chrg.cpMin)
	SendMessage(lpHandles->hred,EM_EXSETSEL,0,Cast(LPARAM,@chrg))

End Sub

Sub CopyWord

	SelectWord
	SendMessage(lpHandles->hred,WM_COPY,0,0)

End Sub

Sub CutWord

	SelectWord
	SendMessage(lpHandles->hred,WM_CUT,0,0)

End Sub

Sub DeleteWord

	SelectWord
	SendMessage(lpHandles->hred,WM_CLEAR,0,0)

End Sub

Sub SelectLine
	Dim chrg As CHARRANGE
	Dim nLn As Integer

	SendMessage(lpHandles->hred,EM_EXGETSEL,0,Cast(LPARAM,@chrg))
	nLn=SendMessage(lpHandles->hred,EM_LINEFROMCHAR,chrg.cpMin,0)
	chrg.cpMin=SendMessage(lpHandles->hred,EM_LINEINDEX,nLn,0)
	chrg.cpMax=chrg.cpMin+SendMessage(lpHandles->hred,EM_LINELENGTH,chrg.cpMin,0)+1
	SendMessage(lpHandles->hred,EM_EXSETSEL,0,Cast(LPARAM,@chrg))

End Sub

Sub CopyLine

	SelectLine
	SendMessage(lpHandles->hred,WM_COPY,0,0)

End Sub

Sub CutLine

	SelectLine
	SendMessage(lpHandles->hred,WM_CUT,0,0)

End Sub

Sub DeleteLine

	SelectLine
	SendMessage(lpHandles->hred,WM_CLEAR,0,0)

End Sub

Sub DuplicateLine
	Dim chrg As CHARRANGE
	Dim nLn As Integer
	Dim buff As ZString*8192

	SendMessage(lpHandles->hred,EM_EXGETSEL,0,Cast(LPARAM,@chrg))
	nLn=SendMessage(lpHandles->hred,EM_LINEFROMCHAR,chrg.cpMin,0)
	chrg.cpMin=SendMessage(lpHandles->hred,EM_LINEINDEX,nLn,0)
	chrg.cpMax=chrg.cpMin+SendMessage(lpHandles->hred,EM_LINELENGTH,chrg.cpMin,0)+1
	SendMessage(lpHandles->hred,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
	SendMessage(lpHandles->hred,EM_GETSELTEXT,0,Cast(LPARAM,@buff))
	nLn=lstrlen(buff)
	If buff[nLn-1]<>13 Then
		buff[nLn]=13
	EndIf
	chrg.cpMax=chrg.cpMin
	SendMessage(lpHandles->hred,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
	SendMessage(lpHandles->hred,EM_REPLACESEL,TRUE,Cast(LPARAM,@buff))

End Sub

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction Cdecl Alias "DllFunction" (ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer Export
	Dim en As Integer

	Select Case uMsg
		Case AIM_COMMAND
			If lpHandles->hred<>0 And lpHandles->hred<>lpHandles->hres Then
				Select Case LoWord(wParam)
					Case IdSelectWord
						SelectWord
						'
					Case IdCopyWord
						CopyWord
						'
					Case IdCutWord
						CutWord
						'
					Case IdDeleteWord
						DeleteWord
						'
					Case IdSelectLine
						SelectLine
						'
					Case IdCopyLine
						CopyLine
						'
					Case IdCutLine
						CutLine
						'
					Case IdDeleteLine
						DeleteLine
						'
					Case IdDuplicateLine
						DuplicateLine
						'
				End Select
			EndIf
			'
		Case AIM_GETTOOLTIP
			If wParam=IDM_MAKE_QUICKRUN Then
				Return Cast(Integer,@szQuickRun)
			EndIf
			'
		Case AIM_MENUENABLE
			en=MF_BYCOMMAND Or MF_GRAYED
			If lpHandles->hred<>0 And lpHandles->hred<>lpHandles->hres Then
				If GetWindowLong(lpHandles->hred,GWL_ID)<>IDC_HEXED Then
					en=MF_BYCOMMAND Or MF_ENABLED
				EndIf
			EndIf
			EnableMenuItem(hSubMnu,IdSelectWord,en)
			EnableMenuItem(hSubMnu,IdCopyWord,en)
			EnableMenuItem(hSubMnu,IdCutWord,en)
			EnableMenuItem(hSubMnu,IdDeleteWord,en)
			EnableMenuItem(hSubMnu,IdSelectLine,en)
			EnableMenuItem(hSubMnu,IdCopyLine,en)
			EnableMenuItem(hSubMnu,IdCutLine,en)
			EnableMenuItem(hSubMnu,IdDeleteLine,en)
			EnableMenuItem(hSubMnu,IdDuplicateLine,en)
			'
	End Select
	Return FALSE

End Function
