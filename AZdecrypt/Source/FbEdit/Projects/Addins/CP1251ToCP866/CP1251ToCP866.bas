#Include Once "windows.bi"
#Include Once "win/commctrl.bi"
#Include Once "win/richedit.bi"

#Include "Addins.bi"

#Include "CP1251ToCP866.bi"

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
Function InstallDll Cdecl Alias "InstallDll" (ByVal hWin As HWND,ByVal hInst As HINSTANCE) As ADDINHOOKS Ptr Export
	Dim i As Integer

	' The dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES Ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA Ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS Ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	' Init convertion tables
	For i=0 To 255
		CP1251[i]=i
		CP866[i]=i
	Next
	' Change the tables here
	' Just to test convert A to B on read
	'CP1251[65]=66
	' Just to test convert B to A on write
	'CP866[66]=65

	' Messages this addin will hook into
	hooks.hook1=HOOK_CREATEEDIT
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	Return @hooks

End Function

Function CheckBuffer(ByVal pBuffer As ZString Ptr) As Integer
	Dim szTest As ZString*8
	Dim i As Integer

	For i=0 To 5
		szTest[i]=pBuffer[i]
	Next
	If szTest="'CP866" Then
		Return TRUE
	EndIf
	Return FALSE

End Function

Function StreamIn(ByVal hFile As HANDLE,ByVal pBuffer As ZString Ptr,ByVal NumBytes As Long,ByVal pBytesRead As Long Ptr) As Integer
	Dim bRet As Integer
	Dim i As Integer
	Dim b As Byte
	
	bRet=ReadFile(hFile,pBuffer,NumBytes,pBytesRead,0) Xor 1
	If bFirst Then
		If *pBytesRead>=6 Then
			' Check if first bytes are 'CP866
			bConvert=CheckBuffer(pBuffer)
		EndIf
		bFirst=FALSE
	EndIf
	If bConvert Then
		' Convert the buffer to CP1251
		For i=0 To *pBytesRead-1
			b=pBuffer[i]
			b=CP1251[b]
			pBuffer[i]=b
		Next
	EndIf
	Return bRet

End Function

Function StreamOut(ByVal hFile As HANDLE,ByVal pBuffer As ZString Ptr,ByVal NumBytes As Long,ByVal pBytesWritten As Long Ptr) As Integer
	Dim i As Integer
	Dim b As Byte

	If bFirst Then
		bFirst=FALSE
		If NumBytes>=6 Then
			' Check if first bytes are 'CP866
			bConvert=CheckBuffer(pBuffer)
		EndIf
	EndIf
	If bConvert Then
		' Convert the buffer to CP866
		For i=0 To NumBytes-1
			b=pBuffer[i]
			b=CP866[b]
			pBuffer[i]=b
		Next
	EndIf
	Return WriteFile(hFile,pBuffer,NumBytes,pBytesWritten,0) Xor 1

End Function

Function EditProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer

	Select Case uMsg
		Case EM_STREAMIN
			bFirst=TRUE
			Cast(EDITSTREAM Ptr,lParam)->pfnCallback=Cast(Any Ptr,@StreamIn)
			'
		Case EM_STREAMOUT
			bFirst=TRUE
			Cast(EDITSTREAM Ptr,lParam)->pfnCallback=Cast(Any Ptr,@StreamOut)
			'
	End Select
	Return CallWindowProc(lpOldEditProc,hWin,uMsg,wParam,lParam)

End Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction Cdecl Alias "DllFunction" (ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As bool Export

	Select Case uMsg
		Case AIM_CREATEEDIT
			' Subclass the edit control
			lpOldEditProc=Cast(Any Ptr,SetWindowLong(Cast(HWND,wParam),GWL_WNDPROC,Cast(Integer,@EditProc)))
			'
	End Select
	Return FALSE

End Function
