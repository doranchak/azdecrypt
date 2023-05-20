#include once "windows.bi"
#include once "win/commctrl.bi"

#include "..\..\FbEdit\Inc\Addins.bi"

#include "HelpAddin.bi"

' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
function InstallDll CDECL alias "InstallDll" (byval hWin as HWND,byval hInst as HINSTANCE) as ADDINHOOKS ptr EXPORT

	' Dll's instance
	hInstance=hInst
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	' Messages this addin will hook into
	hooks.hook1=HOOK_COMMAND
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT
	dim wrd as zstring*512

	select case uMsg
		case AIM_COMMAND
			' Did user press F1?
			if loword(wParam)=IDM_HELPF1 then
				' Is there an open edit window?
				if lpHandles->hred<>0 and lpHandles->hred<>lpHandles->hres then
					' Get word under caret.
					SendMessage(lpHandles->hred,REM_GETWORD,SizeOf(wrd),Cast(LPARAM,@wrd))
					' Is word in the fb keyword list?
					if instr(fbwords," " & lcase(wrd) & " ") then
						' Show fb.chm
						SendMessage(lpHandles->hwnd,WM_COMMAND,IDM_HELPCTRLF1,0)
						' Prevent FbEdit from showing Win32.hlp
						return TRUE
					endif
				endif
			endif
			'
	end select
	return FALSE

end function

