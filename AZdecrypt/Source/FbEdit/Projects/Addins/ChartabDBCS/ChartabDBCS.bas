#Include Once "windows.bi"
#Include Once "win/commctrl.bi"
#Include Once "win/richedit.bi"

#Include "..\..\Inc\RAEdit.bi"
#Include "..\..\Inc\Addins.bi"

#Include "ChartabDBCS.bi"

Sub SetupCharTab
	Dim hDC As HDC
	Dim tm As TEXTMETRIC
	Dim hOld As HGDIOBJ
	Dim i As Integer
	
	hFont=lpHandles->rafnt.hFont
	hDC=GetDC(lpHandles->hout)
	hOld=SelectObject(hDC,lpHandles->rafnt.hFont)
	GetTextMetrics(hDC,@tm)
	' SHIFTJIS_CHARSET		equ 128
	' HANGEUL_CHARSET			equ 129
	' GB2312_CHARSET			equ 134
	' CHINESEBIG5_CHARSET	equ 136
	If tm.tmCharSet=128 Or tm.tmCharSet=129 Or tm.tmCharSet=134 Or tm.tmCharSet=136 Then
		For i=&H81 To &HFF
			SendMessage(lpHandles->hout,REM_SETCHARTAB,i,CT_CHAR)
		Next
	EndIf
	SelectObject(hDC,hOld)
	ReleaseDC(lpHandles->hout,hDC)

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
	SetupCharTab()
	' Messages this addin will hook into
	hooks.hook1=HOOK_COMMAND
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	Return @hooks

End Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction Cdecl Alias "DllFunction" (ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As bool Export

	Select Case uMsg
		Case AIM_COMMAND
			If hFont<>lpHandles->rafnt.hFont Then
				SetupCharTab()
			EndIf
			'
		Case AIM_CLOSE
			'
	End Select
	Return FALSE

End Function
