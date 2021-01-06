#include once "windows.bi"
#Include Once "win/commctrl.bi"

#include "..\..\Inc\Addins.bi"

#include "ControlDefs.bi"

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
function InstallDll CDECL alias "InstallDll" (byval hWin as HWND,byval hInst as HINSTANCE) as ADDINHOOKS ptr EXPORT

	' The dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	' Messages this addin will hook into
	hooks.hook1=HOOK_CTLDBLCLK
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT
	Dim lpCTLDBLCLICK As CTLDBLCLICK ptr
	Dim lpDlgMem As DIALOG Ptr
	Dim i As Integer
	Dim s As ZString*1024
	
	select case uMsg
		case AIM_CTLDBLCLK
			lpCTLDBLCLICK=Cast(CTLDBLCLICK Ptr,lParam)
			If lpCTLDBLCLICK->nmhdr.code=NM_DBLCLK Then
				' Dialog or control double clicked
				lpDlgMem=lpCTLDBLCLICK->lpDlgMem
				' The returned pointer, lpDlgMem, points to the dialog.
				' To find the actual control loop thru the DIALOG UDT's and test for control Name / ID
				While TRUE
					If lstrlen(lpDlgMem->idname) Then
						If lstrcmp(lpDlgMem->idname,lpCTLDBLCLICK->lpCtlName)=0 Then
							Exit While
						EndIf
					ElseIf lpDlgMem->id Then
						If lpDlgMem->id=lpCTLDBLCLICK->nCtlId Then
							Exit While
						EndIf
					EndIf
					' The following line does not work
					'lpDlgMem=lpDlgMem+SizeOf(DIALOG)
					' Use this instead
					i=Cast(Integer,lpDlgMem)
					i=i+SizeOf(DIALOG)
					lpDlgMem=Cast(DIALOG Ptr,i)
				Wend
				' Report some control properties
				s="Name: " & lpDlgMem->idname & Chr(13)
				s=s & "ID: " & Str(lpDlgMem->id) & Chr(13)
				s=s & "Size: " &  Str(lpDlgMem->duccx) & ", " & Str( lpDlgMem->duccy)
				MessageBox(lpHandles->hwnd,@s,"Resource editor",MB_OK)
			ElseIf lpCTLDBLCLICK->nmhdr.code=NM_CLICK Then
				' Menu item selected
			EndIf
			'
	end select
	return FALSE

end function
