
/' File Tab Styler, by krcko

	Addin for FBEdit
	
	Adds some options to file tab control.

'/


#include once "windows.bi"
#include once "win/commctrl.bi"

#include "\FbEdit\Inc\Addins.bi"

#define IDB_TABICONS 100

#define TAB_STYLE_BASE     TCS_FOCUSNEVER Or WS_CHILD Or WS_CLIPCHILDREN Or WS_CLIPSIBLINGS Or WS_TABSTOP Or WS_VISIBLE Or TCS_FORCEICONLEFT Or TCS_FORCELABELLEFT

'' tab styles
#Define TAB_STYLE_DEFAULT  TCS_TABS
#Define TAB_STYLE_BUTTONS  TCS_BUTTONS' Or TCS_BOTTOM
#Define TAB_STYLE_FLAT     TAB_STYLE_BUTTONS Or TCS_FLATBUTTONS Or TCS_HOTTRACK 

#Define TAB_STYLE_ID_DEFAULT   0
#Define TAB_STYLE_ID_BUTTONS   1
#Define TAB_STYLE_ID_FLAT      2


Dim Shared lpHandles	As ADDINHANDLES Pointer
Dim Shared lpFunctions 	As ADDINFUNCTIONS Pointer
Dim Shared lpData As ADDINDATA ptr

Dim Shared CurTabStyle 	As Byte
Dim Shared FixedWidth   As Byte
Dim Shared MultiLine    As Byte
Dim Shared ModIndicator	As Byte

Dim Shared mnuTabStyle	As HMENU
Dim Shared mnuModType	As HMENU
Dim Shared mnuDefault	As Integer
Dim Shared mnuButtons	As Integer
Dim Shared mnuFlat		As Integer
Dim Shared mnuMultiline	As Integer
Dim Shared mnuFixed		As Integer
Dim Shared mnuModPic	   As Integer
Dim Shared mnuModTxt	   As Integer
Dim Shared mnuModOff	   As Integer
Dim Shared nTabRows	   As Integer

Sub SetTabStyle
	Dim As Integer TabStyle = TAB_STYLE_DEFAULT
	
	If CurTabStyle = TAB_STYLE_ID_BUTTONS Then
		TabStyle = TAB_STYLE_BUTTONS
	ElseIf CurTabStyle = TAB_STYLE_ID_FLAT Then
		TabStyle = TAB_STYLE_FLAT
	End If
	If FixedWidth Then
		TabStyle Or= TCS_FIXEDWIDTH
	End If
	If MultiLine Then
		TabStyle Or= TCS_MULTILINE
	End If
	SetWindowLong lpHandles->htabtool, GWL_STYLE, TAB_STYLE_BASE Or TabStyle
	
End Sub

#macro Check(_menu_, _item_, _condition_)
mmi.fState = Iif(_condition_, MFS_CHECKED, MFS_UNCHECKED)
SetMenuItemInfo _menu_, _item_, FALSE, VarPtr(mmi)
#endmacro

Sub UpdateMenu
	Dim mmi As MENUITEMINFO
	
	mmi.cbSize = SizeOf(MMI)
	mmi.fMask = MIIM_STATE
	Check(mnuTabStyle, mnuDefault, CurTabStyle = TAB_STYLE_ID_DEFAULT)
	Check(mnuTabStyle, mnuButtons, CurTabStyle = TAB_STYLE_ID_BUTTONS)
	Check(mnuTabStyle, mnuFlat, CurTabStyle = TAB_STYLE_ID_FLAT)
	Check(mnuTabStyle, mnuFixed, FixedWidth)
	Check(mnuTabStyle, mnuMultiLine, MultiLine)
	Check(mnuModType, mnuModPic, ModIndicator And TCIF_IMAGE)
	Check(mnuModType, mnuModTxt, ModIndicator And TCIF_TEXT)
	Check(mnuModType, mnuModOff, ModIndicator = 0)		

End Sub


Function GetTabInfo(index As Integer, ByRef image As Integer, remAsterisk As Byte = 1) As String
	Dim item	As TC_ITEM
	Dim buffer	As String = String(100, 0)
	
	item.mask = TCIF_TEXT Or TCIF_IMAGE
	item.pszText = StrPtr(buffer)
	item.cchTextMax = 100
	SendMessage lpHandles->htabtool, TCM_GETITEM, index, Cast(LPARAM,VarPtr(item))
  	buffer = Left(buffer, InStr(buffer, !"\0") - 1)
	If (Right(buffer, 2) = " *") And remAsterisk Then buffer = Left(buffer, Len(buffer) - 2)
	image = item.iImage
	Return buffer

End Function

Sub ClearIndicators
	Dim TabCount	As Integer
	Dim TabText		As String
	Dim TabImage	As Integer
	Dim TabItem		As TC_ITEM
	
	ModIndicator = 0
	TabCount = SendMessage(lpHandles->htabtool, TCM_GETITEMCOUNT, 0, 0)
	For TabIndex As Integer = 0 To TabCount - 1
		TabText = GetTabInfo(TabIndex, TabImage, 0)
		TabItem.mask = 0
		If Right(TabText, 2) = " *" Then
			TabText = Left(TabText, Len(TabText) - 2)
			TabItem.mask = TCIF_TEXT
			TabItem.pszText = StrPtr(TabText)
		End If
		If TabImage > 7 Then
			TabItem.mask Or= TCIF_IMAGE
			TabItem.iImage = TabImage - 8
		End If
		SendMessage lpHandles->htabtool, TCM_SETITEM, TabIndex, Cast(LPARAM,VarPtr(TabItem))
	Next

End Sub

Sub UpdateTab(ByRef theTab As TABMEM, index As Integer)
	Dim changed	As Byte
	Dim item 	As TC_ITEM
	Dim text 	As ZString * 260
	Dim image	As Integer
	
	changed = theTab.filestate And 1
	If ModIndicator Then
		item.mask = ModIndicator
		text = GetTabInfo(index, image)
		If item.mask And TCIF_TEXT Then 
			If changed Then text += " *"
			item.pszText = StrPtr(text)
		End If
		If item.mask And TCIF_IMAGE Then
			If changed Then 
				image += 8
			Else
				image -= 8
			End If
			item.iImage = image
		
		End If
		SendMessage lpHandles->htabtool, TCM_SETITEM, index, Cast(LPARAM,VarPtr(item))
	End If

End Sub

Function GetString(ByVal id As Integer) As String

	Return lpFunctions->FindString(lpData->hLangMem,"FileTabStyle",Str(id))

End Function

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll CDecl Alias "InstallDll" (ByVal hWin As HWND, ByVal hInst As HINSTANCE) As ADDINHOOKS Pointer Export
	Dim hooks 	As ADDINHOOKS
	Dim mnuView	As HMENU
	Dim hBmp	As HBITMAP
	Dim buff As ZString*256
	Dim mii As MENUITEMINFO

	' Get pointer to ADDINHANDLES
	lpHandles = Cast(ADDINHANDLES Pointer, SendMessage(hWin, AIM_GETHANDLES, 0, 0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions = Cast(ADDINFUNCTIONS Pointer, SendMessage(hWin, AIM_GETFUNCTIONS, 0, 0))
	' add images to image list
	hBmp = LoadBitmap(hInst, Cast(ZString Pointer, IDB_TABICONS)) 
	ImageList_AddMasked lpHandles->himl, hBmp, &HFF00FF
	DeleteObject hBmp
	' get from ini and restore last used style
	lpFunctions->LoadFromIni("FileTabStyler", "Style", "1", VarPtr(CurTabStyle), FALSE)
	lpFunctions->LoadFromIni("FileTabStyler", "Fixed", "1", VarPtr(FixedWidth), FALSE)
	lpFunctions->LoadFromIni("FileTabStyler", "MultiLine", "1", VarPtr(MultiLine), FALSE)
	lpFunctions->LoadFromIni("FileTabStyler", "ModStyle", "1", VarPtr(ModIndicator), FALSE)
	SetTabStyle
	' create new menus
	mnuTabStyle = CreateMenu
	mnuModType = CreateMenu
	' get View menu
	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_SUBMENU
	GetMenuItemInfo(lpHANDLES->hmenu,10091,FALSE,@mii)
	mnuView = mii.hSubMenu
	' add menu item to View menu
	buff=GetString(10000)
	If buff="" Then
		buff="File tab style"
	EndIf
	AppendMenu mnuView, MF_STRING Or MF_POPUP, Cast(Integer,mnuTabStyle), StrPtr(buff)
	' get menu ids
	mnuDefault = SendMessage(hWin, AIM_GETMENUID, 0, 0)
	mnuButtons = SendMessage(hWin, AIM_GETMENUID, 0, 0)
	mnuFlat = SendMessage(hWin, AIM_GETMENUID, 0, 0)
	mnuFixed = SendMessage(hWin, AIM_GETMENUID, 0, 0)
	mnuMultiline = SendMessage(hWin, AIM_GETMENUID, 0, 0)
	mnuModPic = SendMessage(hWin, AIM_GETMENUID, 0, 0)
	mnuModTxt = SendMessage(hWin, AIM_GETMENUID, 0, 0)
	mnuModOff = SendMessage(hWin, AIM_GETMENUID, 0, 0)
	' add menu items
	buff=GetString(10001)
	If buff="" Then
		buff="Default"
	EndIf
	AppendMenu mnuTabStyle, MF_STRING, mnuDefault, StrPtr(buff)
	buff=GetString(10002)
	If buff="" Then
		buff="Buttons"
	EndIf
	AppendMenu mnuTabStyle, MF_STRING, mnuButtons, StrPtr(buff)
	buff=GetString(10003)
	If buff="" Then
		buff="Flat"
	EndIf
	AppendMenu mnuTabStyle, MF_STRING, mnuFlat, StrPtr(buff)
	buff=GetString(10009)
	If buff="" Then
		buff="Multiline"
	EndIf
	AppendMenu mnuTabStyle, MF_STRING, mnuMultiline, StrPtr(buff)
	AppendMenu mnuTabStyle, MF_SEPARATOR, 0, 0
	buff=GetString(10004)
	If buff="" Then
		buff="Modified state indicator"
	EndIf
	AppendMenu mnuTabStyle, MF_STRING Or MF_POPUP, Cast(Integer,mnuModType), StrPtr(buff)
	buff=GetString(10005)
	If buff="" Then
		buff="Fixed width"
	EndIf
	AppendMenu mnuTabStyle, MF_STRING, mnuFixed, StrPtr(buff)
	buff=GetString(10006)
	If buff="" Then
		buff="Highlight icon"
	EndIf
	AppendMenu mnuModType, MF_STRING, mnuModPic, StrPtr(buff)
	buff=GetString(10007)
	If buff="" Then
		buff="Asterisk character"
	EndIf
	AppendMenu mnuModType, MF_STRING, mnuModTxt, StrPtr(buff)
	buff=GetString(10008)
	If buff="" Then
		buff="No indicator"
	EndIf
	AppendMenu mnuModType, MF_STRING, mnuModOff, StrPtr(buff)
	UpdateMenu
	' Messages this addin will hook into
	hooks.hook1 = HOOK_COMMAND Or HOOK_FILESTATE Or HOOK_CLOSE Or HOOK_MENUENABLE
	hooks.hook2 = 0
	hooks.hook3 = 0
	hooks.hook4 = 0
	
	Return VarPtr(hooks)

End Function

Sub SetTabHeight()
	Dim i As Integer
	Dim rect As RECT
	
	i=SendMessage(lpHandles->htabtool,TCM_GETROWCOUNT,0,0)
	If i=0 Then i=1
	If i<>nTabRows Then
		nTabRows=i
		GetWindowRect(lpHandles->htabtool,@rect)
		ScreenToClient(lpHandles->hwnd,Cast(Point Ptr,@rect.left))
		ScreenToClient(lpHandles->hwnd,Cast(Point Ptr,@rect.right))
		rect.bottom=nTabRows*24
		MoveWindow(lpHandles->htabtool,rect.left,rect.top,rect.right,rect.bottom,TRUE)
		SendMessage(lpHandles->hwnd,WM_SIZE,0,0)
	EndIf

End Sub

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction CDecl Alias "DllFunction" (ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As bool Export

	If uMsg = AIM_COMMAND Then		
		Select Case LoWord(wParam)
			Case mnuDefault
				CurTabStyle = TAB_STYLE_ID_DEFAULT
			Case mnuButtons
				CurTabStyle = TAB_STYLE_ID_BUTTONS
			Case mnuFlat
				CurTabStyle = TAB_STYLE_ID_FLAT
			Case mnuFixed
				FixedWidth = Not FixedWidth
			Case mnuMultiline
				MultiLine = Not MultiLine
			Case mnuModPic
				If ModIndicator And TCIF_IMAGE Then
					ModIndicator And= Not TCIF_IMAGE
				Else
					ModIndicator Or= TCIF_IMAGE
				End If
			Case mnuModTxt
				If ModIndicator And TCIF_TEXT Then
					ModIndicator And= Not TCIF_TEXT
				Else
					ModIndicator Or= TCIF_TEXT
				End If			
			Case mnuModOff
				ClearIndicators
			Case Else
				Return False
		End Select
		SetTabStyle
		UpdateMenu
		SetTabHeight
		Return True
	ElseIf uMsg = AIM_FILESTATE Then
		UpdateTab *Cast(TABMEM Pointer, lParam), wParam
	ElseIf uMsg = AIM_MENUENABLE Then
		SetTabHeight
	ElseIf uMsg = AIM_CLOSE Then
		lpFunctions->SaveToIni("FileTabStyler", "Style", "1", VarPtr(CurTabStyle), FALSE)
		lpFunctions->SaveToIni("FileTabStyler", "Fixed", "1", VarPtr(FixedWidth), FALSE)
		lpFunctions->SaveToIni("FileTabStyler", "MultiLine", "1", VarPtr(MultiLine), FALSE)
		lpFunctions->SaveToIni("FileTabStyler", "ModStyle", "1", VarPtr(ModIndicator), FALSE)
		DestroyMenu mnuTabStyle
		DestroyMenu mnuModType	
	End If
	Return FALSE

End Function
