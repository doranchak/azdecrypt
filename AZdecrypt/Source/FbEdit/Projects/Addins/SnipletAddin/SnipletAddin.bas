#include once "windows.bi"
#include once "win/richedit.bi"
#include once "win/commctrl.bi"

#include "..\..\FbEdit\Inc\RAFile.bi"
#include "..\..\FbEdit\Inc\RAEdit.bi"
#include "..\..\FbEdit\Inc\Addins.bi"

#include "SnipletAddin.bi"

sub AddToMenu(byval id as integer)
	Dim mii As MENUITEMINFO
	Dim buff As ZString*256

	' Get handle to 'Tools' popup
	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_SUBMENU
	GetMenuItemInfo(lpHANDLES->hmenu,10151,FALSE,@mii)
	' Add our menu item to Tools menu
	buff=lpFunctions->FindString(lpData->hLangMem,"SnipletAddin","10000")
	If buff="" Then
		buff="Code &Sniplets	F11"
	EndIf
	AppendMenu(mii.hSubMenu,MF_STRING,id,@buff)

end sub

sub AddToAccelerator(byval fvirt as integer,byval akey as integer,byval id as integer)
	dim nAccel as integer
	dim acl(500) as ACCEL

	nAccel=CopyAcceleratorTable(lpHandles->haccel,NULL,0)
	CopyAcceleratorTable(lpHandles->haccel,@acl(0),nAccel)
	DestroyAcceleratorTable(lpHandles->haccel)
	acl(nAccel).fVirt=fvirt
	acl(nAccel).key=akey
	acl(nAccel).cmd=id
	nAccel=nAccel+1
	lpHandles->haccel=CreateAcceleratorTable(@acl(0),nAccel)

end sub

function StreamIn(byval hFile as HANDLE,byval pBuffer as zstring ptr,byval NumBytes as long,byval pBytesRead as long ptr) as boolean

	return ReadFile(hFile,pBuffer,NumBytes,pBytesRead,0) xor 1

end function

function SnipletProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim rect as RECT
	dim buff as zstring*260
	dim lpFBNOTIFY as FBNOTIFY ptr
	dim editstream as EDITSTREAM
	dim hFile as HANDLE
	dim hMem as HGLOBAL
	dim chrg as CHARRANGE
	dim nSize as integer

	select case uMsg
		case WM_INITDIALOG
			lpFunctions->TranslateAddinDialog(hWin,"SnipletAddin")
			' Restore pos & size
			MoveWindow(hWin,winsize.left,winsize.top,winsize.right-winsize.left,winsize.bottom-winsize.top,FALSE)
			' Setup file browser
			buff=lpDATA->AppPath & "\Sniplets"
			SendDlgItemMessage(hWin,IDC_FILEBROWSER,FBM_SETPATH,TRUE,Cast(LPARAM,@buff))
			SendDlgItemMessage(hWin,IDC_FILEBROWSER,FBM_SETFILTERSTRING,FALSE,Cast(LPARAM,StrPtr(".bas.bi.")))
			SendDlgItemMessage(hWin,IDC_FILEBROWSER,FBM_SETFILTER,TRUE,TRUE)
			' Setup RAEdit
			SendDlgItemMessage(hWin,IDC_RAEDIT,REM_SETFONT,0,Cast(LPARAM,@lpHandles->rafnt))
			SendDlgItemMessage(hWin,IDC_RAEDIT,REM_SETCOLOR,0,Cast(LPARAM,lpData->lpFBCOLOR))
			'
		case WM_CLOSE
			' Save current pos & size
			GetWindowRect(hWin,@winsize)
			EndDialog(hWin, 0)
			'
		case WM_COMMAND
			select case loword(wParam)
				case IDCANCEL
					SendMessage(hWin,WM_CLOSE,0,0)
					'
				case IDOK
					if lpHandles->hred<>0 and lpHandles->hred<>lpHandles->hres then
						SendDlgItemMessage(hWin,IDC_RAEDIT,EM_EXGETSEL,0,Cast(LPARAM,@chrg))
						if chrg.cpMin=chrg.cpMax then
							nSize=SendDlgItemMessage(hWin,IDC_RAEDIT,WM_GETTEXTLENGTH,0,0)+1
							hMem=GlobalAlloc(GMEM_FIXED or GMEM_ZEROINIT,nSize)
							SendDlgItemMessage(hWin,IDC_RAEDIT,WM_GETTEXT,nSize,Cast(LPARAM,hMem))
						else
							nSize=chrg.cpMax-chrg.cpMin+1
							hMem=GlobalAlloc(GMEM_FIXED or GMEM_ZEROINIT,nSize)
							SendDlgItemMessage(hWin,IDC_RAEDIT,EM_GETSELTEXT,0,Cast(LPARAM,hMem))
						endif
						SendMessage(lpHandles->hred,EM_REPLACESEL,TRUE,Cast(LPARAM,hMem))
					endif
					SendMessage(hWin,WM_CLOSE,0,0)
					'
			end select
		case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(GetDlgItem(hWin,IDC_FILEBROWSER),0,0,rect.right/4+50,rect.bottom-30,TRUE)
			MoveWindow(GetDlgItem(hWin,IDC_RAEDIT),rect.right/4+50,0,rect.right-rect.right/4-50,rect.bottom-30,TRUE)
			MoveWindow(GetDlgItem(hWin,2),rect.right-80,rect.bottom-27,75,25,TRUE)
			MoveWindow(GetDlgItem(hWin,1),rect.right-160,rect.bottom-27,75,25,TRUE)
			'
		case WM_NOTIFY
			lpFBNOTIFY=Cast(FBNOTIFY ptr,lParam)
			if lpFBNOTIFY->nmhdr.code=FBN_DBLCLICK  and lpFBNOTIFY->nmhdr.idFrom=IDC_FILEBROWSER then
				' File dblclicked
				lstrcpy(@buff,lpFBNOTIFY->lpfile)
				hFile=CreateFile(buff,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0)
				if hFile<>INVALID_HANDLE_VALUE then
					' Open the file
					editstream.dwCookie=hFile
					editstream.pfnCallback=Cast(any ptr,@StreamIn)
					SendDlgItemMessage(hWin,IDC_RAEDIT,WM_SETTEXT,0,Cast(LPARAM,StrPtr("")))
					SendDlgItemMessage(hWin,IDC_RAEDIT,EM_STREAMIN,SF_TEXT,Cast(LPARAM,@editstream))
					CloseHandle(hFile)
					SendDlgItemMessage(hWin,IDC_RAEDIT,REM_SETBLOCKS,0,0)
					SendDlgItemMessage(hWin,IDC_RAEDIT,REM_SETCOMMENTBLOCKS,Cast(WPARAM,StrPtr("/'")),Cast(LPARAM,StrPtr("'/")))
				endif
			endif
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function

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
	' Get a menu ID
	IDM_SNIPLETS=SendMessage(hWin,AIM_GETMENUID,0,0)
	AddToMenu(IDM_SNIPLETS)
	AddToAccelerator(FVIRTKEY or FNOINVERT,VK_F11,IDM_SNIPLETS)
	lpFunctions->LoadFromIni("Sniplet","WinPos","4444",@winsize,FALSE)
	' Messages this addin will hook into
	hooks.hook1=HOOK_COMMAND or HOOK_CLOSE
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT
dim s as string
	select case uMsg
		case AIM_COMMAND
			if loword(wParam)=IDM_SNIPLETS then
				' Our menu item has been selected. Show the sniplets dialog
				DialogBoxParam(hInstance,Cast(zstring ptr,IDD_DLGSNIPLET),hWin,@SnipletProc,NULL)
			endif
			'
		case AIM_CLOSE
			' Save pos & size to FbEdit.ini
			lpFunctions->SaveToIni("Sniplet","WinPos","4444",@winsize,FALSE)
			'
	end select
	return FALSE

end function
