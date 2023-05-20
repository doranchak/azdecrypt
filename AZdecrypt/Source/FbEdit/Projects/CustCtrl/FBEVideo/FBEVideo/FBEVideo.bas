
' Comment the following line when compiling the library. It will save some 1K on the executables size.
#define DEFDLL

#include once "windows.bi"
#include once "crt.bi"
#include once "win/mmsystem.bi"

#include "..\FBEVideo.bi"
#include "Data.bi"

function MCIWndProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as Integer
	dim ps as PAINTSTRUCT

	select case uMsg
		case WM_LBUTTONDOWN
		case WM_ERASEBKGND
			return 0
		case WM_PAINT
			BeginPaint(hWin,@ps)
			FillRect(ps.hdc,@ps.rcPaint,GetStockObject(BLACK_BRUSH))
			EndPaint(hWin,@ps)
		case else
			return CallWindowProc(lpOldMCIWndProc,hWin,uMsg,wParam,lParam)
	end select
	return 0

end function

sub SizeIt(byval hWin as HWND)
	dim lpFBEVID as FBEVID ptr
	dim rect as RECT
	dim rect1 as RECT

	lpFBEVID=Cast(FBEVID ptr,GetWindowLong(hWin,0))
	if lpFBEVID->hMCIWnd then
		GetClientRect(hWin,@rect)
		if lpFBEVID->Style and STYLE_KEEPASPECT then
			SendMessage(lpFBEVID->hMCIWnd,MCIWNDM_GET_SOURCE,0,Cast(LPARAM,@rect1))
			if (lpFBEVID->MCIStyle and MCIWNDF_NOPLAYBAR)=0 then
				rect.bottom=rect.bottom-28
			endif
			if rect.bottom/rect1.bottom>rect.right/rect1.right then
				rect1.bottom=rect1.bottom*(rect.right/rect1.right)
				rect1.right=rect1.right*(rect.right/rect1.right)
			else
				rect1.right=rect1.right*(rect.bottom/rect1.bottom)
				rect1.bottom=rect1.bottom*(rect.bottom/rect1.bottom)
			endif
			rect1.left=(rect.right-rect1.right)/2
			rect1.top=(rect.bottom-rect1.bottom)/2
			if (lpFBEVID->MCIStyle and MCIWNDF_NOPLAYBAR)=0 then
				rect.bottom=rect.bottom+28
				rect1.right=rect1.right+rect1.left
				rect1.bottom=rect1.bottom+rect1.top
				MoveWindow(lpFBEVID->hMCIWnd,0,0,rect.right,rect.bottom,TRUE)
				SendMessage(lpFBEVID->hMCIWnd,MCIWNDM_PUT_DEST,0,Cast(LPARAM,@rect1))
			else
				MoveWindow(lpFBEVID->hMCIWnd,rect1.left,rect1.top,rect1.right,rect1.bottom,TRUE)
			endif
		else
			MoveWindow(lpFBEVID->hMCIWnd,0,0,rect.right,rect.bottom,TRUE)
			if (lpFBEVID->MCIStyle and MCIWNDF_NOPLAYBAR)=0 then
				rect.bottom=rect.bottom-28
			endif
			SendMessage(lpFBEVID->hMCIWnd,MCIWNDM_PUT_DEST,0,Cast(LPARAM,@rect))
		endif
	endif

end sub

function WndProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as LRESULT
	dim lpFBEVID as FBEVID ptr

	select case uMsg
		case WM_CREATE
			lpFBEVID=GlobalAlloc(GMEM_FIXED or GMEM_ZEROINIT,sizeof(FBEVID))
			SetWindowLong(hWin,0,Cast(Integer,lpFBEVID))
			lpFBEVID->hParent=GetParent(hWin)
			lpFBEVID->Style=GetWindowLong(hWin,GWL_STYLE)
			'
		case WM_SIZE
			lpFBEVID=Cast(FBEVID ptr,GetWindowLong(hWin,0))
			SizeIt(hWin)
			'
		case WM_STYLECHANGED
			lpFBEVID=Cast(FBEVID ptr,GetWindowLong(hWin,0))
			lpFBEVID->Style=GetWindowLong(hWin,GWL_STYLE)
			SizeIt(hWin)
			'
		case FBEVID_PLAY
			lpFBEVID=Cast(FBEVID ptr,GetWindowLong(hWin,0))
			if lpFBEVID->hMCIWnd then
				SendMessage(lpFBEVID->hMCIWnd,MCI_STOP,0,0)
				DestroyWindow(lpFBEVID->hMCIWnd)
				lpFBEVID->hMCIWnd=0
			endif
			if MCIWndCreate then
				lpFBEVID->MCIStyle=MCIWNDF_NOERRORDLG or MCIWNDF_NOAUTOSIZEMOVIE or MCIWNDF_NOMENU or MCIWNDF_NOPLAYBAR or MCIWNDF_NOTIFYMODE or MCIWNDF_NOTIFYPOS
				if lpFBEVID->Style and STYLE_PLAYBAR then
					lpFBEVID->MCIStyle=lpFBEVID->MCIStyle xor MCIWNDF_NOPLAYBAR
				else
					lpFBEVID->MCIStyle=lpFBEVID->MCIStyle xor MCIWNDF_NOAUTOSIZEMOVIE
				endif
				lpFBEVID->hMCIWnd=MCIWndCreate(hWin,hInstance,lpFBEVID->MCIStyle,Cast(zstring ptr,lParam))
				if lpFBEVID->hMCIWnd then
					lpOldMCIWndProc=Cast(any ptr,SetWindowLong(lpFBEVID->hMCIWnd,GWL_WNDPROC,Cast(Integer,@MCIWndProc)))
					SizeIt(hWin)
					SendMessage(lpFBEVID->hMCIWnd,MCI_PLAY,0,0)
				endif
			endif
			return 0
			'
		case FBEVID_STOP
			lpFBEVID=Cast(FBEVID ptr,GetWindowLong(hWin,0))
			if lpFBEVID->hMCIWnd then
				SendMessage(lpFBEVID->hMCIWnd,MCI_STOP,0,0)
				DestroyWindow(lpFBEVID->hMCIWnd)
				lpFBEVID->hMCIWnd=0
			endif
			return 0
			'
		case FBEVID_GETMCIWND
			lpFBEVID=Cast(FBEVID ptr,GetWindowLong(hWin,0))
			return Cast(LRESULT,lpFBEVID->hMCIWnd)
			'
		case MCIWNDM_NOTIFYMODE
			lpFBEVID=Cast(FBEVID ptr,GetWindowLong(hWin,0))
			if lpFBEVID->Style and STYLE_NOTIFY then
				SendMessage(lpFBEVID->hParent,MCIWNDM_NOTIFYMODE,Cast(WPARAM,lpFBEVID->hMCIWnd),lParam)
			endif
			if lParam=MCI_MODE_STOP then
				if SendMessage(lpFBEVID->hMCIWnd,MCIWNDM_GETPOSITION,0,0)>=SendMessage(lpFBEVID->hMCIWnd,MCIWNDM_GETLENGTH,0,0) then
					DestroyWindow(lpFBEVID->hMCIWnd)
					lpFBEVID->hMCIWnd=0
				endif
			endif
			return 0
			'
		case MCIWNDM_NOTIFYPOS
			lpFBEVID=Cast(FBEVID ptr,GetWindowLong(hWin,0))
			if lpFBEVID->Style and STYLE_NOTIFY then
				SendMessage(lpFBEVID->hParent,MCIWNDM_NOTIFYPOS,Cast(WPARAM,lpFBEVID->hMCIWnd),lParam)
			endif
			return 0
			'
	end select
	return DefWindowProc(hWin,uMsg,wParam,lParam)

end function

' This sub registers a windowclass for the custom control 
function CreateClass(byval hModule as HMODULE,byval fGlobal as Boolean) as Integer
	dim wc as WNDCLASSEX

	hInstance=hModule
	hLib=LoadLibrary("msvfw32.dll")
	if hLib then
		MCIWndCreate=Cast(any ptr,GetProcAddress(hLib,StrPtr("MCIWndCreate")))
	endif
	' Create a windowclass for the custom control
	wc.cbSize=sizeof(WNDCLASSEX)
	if fGlobal then
		wc.style=CS_HREDRAW or CS_VREDRAW or CS_GLOBALCLASS or CS_PARENTDC or CS_DBLCLKS
	else
		wc.style=CS_HREDRAW or CS_VREDRAW or CS_PARENTDC or CS_DBLCLKS
	endif
	wc.lpfnWndProc=@WndProc
	wc.cbClsExtra=0
	' Holds the font
	wc.cbWndExtra=4
	wc.hInstance=hInstance
	wc.hbrBackground=GetStockObject(BLACK_BRUSH)
	wc.lpszMenuName=NULL
	wc.lpszClassName=StrPtr(szClassName)
	wc.hIcon=NULL
	wc.hIconSm=NULL
	wc.hCursor=LoadCursor(NULL,IDC_ARROW)
	return RegisterClassEx(@wc)

end function

#ifdef DEFDLL
' Windows calls this function when the dll is loaded.
function DllMain alias "DllMain" (byval hModule as HMODULE,byval reason as Integer,byval lpReserved as LPVOID) as BOOL

   select case reason
	   case DLL_PROCESS_ATTACH
	   	CreateClass(hModule,TRUE)
			'
		case DLL_PROCESS_DETACH
			if hLib then
				FreeLibrary(hLib)
				hLib=0
			endif
			'
	end select 
	return TRUE 

end function 

' FbEdit calls this function to get the controls definitions.
function GetDefEx CDECL alias "GetDefEx" (ByVal nInx as Integer) as CCDEFEX ptr export

	if nInx=0 then
		' Get the toolbox bitmap
		ccdefex.hbmp=LoadBitmap(hInstance,Cast(zstring ptr,IDB_BMP))
		' Return pointer to inited struct
		return @ccdefex
	else
		return 0
	endif

end function
#endif
