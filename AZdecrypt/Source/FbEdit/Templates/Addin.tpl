MyAddin
Addin template
[*BEGINPRO*]
[*BEGINDEF*]
[Project]
Version=2
Api=fb (FreeBASIC),win (Windows)
[Make]
Module=Module Build,fbc -c
Recompile=0
Current=1
1=Windows dll,fbc -s gui -dll -export
Output=
Run=
[*ENDDEF*]
[*BEGINTXT*]
[*PRONAME*].bas
#include once "windows.bi"

#include "..\..\Inc\Addins.bi"

#include "[*PRONAME*].bi"

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
	hooks.hook1=HOOK_COMMAND
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT

	select case uMsg
		case AIM_COMMAND
			'
		case AIM_CLOSE
			'
	end select
	return FALSE

end function
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].bi

dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpFunctions as ADDINFUNCTIONS ptr
dim SHARED lpData as ADDINDATA ptr
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].txt
"a description of the addin"
[*ENDTXT*]
[*ENDPRO*]
