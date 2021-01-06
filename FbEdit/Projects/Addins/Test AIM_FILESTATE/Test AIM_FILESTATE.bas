#include once "windows.bi"
#include once "win/commctrl.bi"

#include "..\..\FbEdit\Inc\Addins.bi"

dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpFunctions as ADDINFUNCTIONS ptr
dim SHARED lpData as ADDINDATA ptr

type TABMEM
	hedit				as HWND
	filename			as zstring*260
	profileinx		as integer
	filestate		as Integer
end type

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
	hooks.hook1=HOOK_FILESTATE Or HOOK_MAKEBEGIN Or HOOK_MAKEDONE
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT
	dim lpTABMEM as TABMEM ptr
	dim s as String

	select case uMsg
		case AIM_FILESTATE
			lpTABMEM=Cast(TABMEM ptr,lParam)
			if lpTABMEM->filestate and 1 then
				s="changed."
			else
				s="saved."
			endif
			lpFUNCTIONS->TextToOutput("Tabindex " & Str(wParam) & " is " & s)
			'
		case AIM_MAKEBEGIN
			MessageBox(hWin,wParam,lParam,MB_OK)
		case AIM_MAKEDONE
			MessageBox(hWin,wParam,lParam,MB_OK)
	end select
	return FALSE

end function
