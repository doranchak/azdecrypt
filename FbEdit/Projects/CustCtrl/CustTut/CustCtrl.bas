/'	Custom control tutorial
	-----------------------

	To be able to create a custom control you need to fully understand:

	1. Binary and hex. Bits and bytes
	2. Pointers
	3. How to hack a project file
	4. Windows api's
	5. Window classes
	6. How a WndProc works

	Project file hack:
	Since access to DllMain is needed to create a Custom Control
	a project hack is needed. The main source file is added as a module and the resource script
	is added as the main source file.
	It is done this way instead of introducing link as a possible command in FbEdit.

	To use the custom control in design mode, copy the dll to C:\Windows\System or to FbEdit root.
	Then use Options / Dialog Editor to add it to FbEdit custom controls.
'/

#include once "windows.bi"
#include once "crt.bi"

#include "custctrl.bi"

' This sub rotates a bitmap 0, 90, 180 or 270 deg
sub Rotate(byval hBmpDest as HBITMAP,byval hBmpSrc as HBITMAP,byval x as Integer,byval y as Integer,byval nRotate as Integer)
	dim bmd as BITMAP
	dim nbitsd as Integer
	dim hmemd as HGLOBAL
	dim bms as BITMAP
	dim nbitss as Integer
	dim hmems as HGLOBAL
	dim xx as Integer
	dim yy as Integer
	dim xt as Integer
	dim yt as Integer
	dim pms as integer
	dim pmd as integer

	' Get info on destination bitmap
	GetObject(hBmpDest,sizeof(BITMAP),@bmd)
	nbitsd=bmd.bmWidthBytes*bmd.bmHeight
	' Allocate memory for destination bitmap bits
	hmemd=GlobalAlloc(GMEM_FIXED,nbitsd)
	' Get the destination bitmap bits
	GetBitmapBits(hBmpDest,nbitsd,hmemd)
	' Get info on source bitmap
	GetObject(hBmpSrc,sizeof(BITMAP),@bms)
	nbitss=bms.bmWidthBytes*bms.bmHeight
	' Allocate memory for source bitmap bits
	hmems=GlobalAlloc(GMEM_FIXED,nbitss)
	' Get the source bitmap bits
	GetBitmapBits(hBmpSrc,nbitss,hmems)
	' Copy the pixels, pixel by pixel
	yy=0
	while yy<bms.bmHeight
		xx=0
		while xx<bms.bmWidth
			pms=Cast(Integer,hmems)+yy*bms.bmWidthBytes+(xx*bms.bmBitsPixel)/8
			select case nRotate
				Case 0
					' Rotate 0 deg
					xt=xx
					yt=yy
				Case 1
					' Rotate 90 deg
					xt=bms.bmHeight-yy
					yt=xx
				case 2
					' Rotate 180 deg
					xt=bms.bmWidth-xx
					yt=bms.bmHeight-yy
				case 3
					' Rotate 270 deg
					xt=yy
					yt=bms.bmWidth-xx
			End Select
			xt=xt+x
			yt=yt+y
			if xt<bmd.bmWidth and yt<bmd.bmHeight then
				' Copy the pixel
				pmd=Cast(Integer,hmemd)+yt*bmd.bmWidthBytes+(xt*bmd.bmBitsPixel)/8
				RtlMoveMemory(Cast(any ptr,pmd),Cast(any ptr,pms),bms.bmBitsPixel/8)
			endif
			xx=xx+1
		wend
		yy=yy+1
	wend
	' Copy back the destination bitmap bits
	SetBitmapBits(hBmpDest,nbitsd,hmemd)
	' Free allocated memory
	GlobalFree(hmems)
	GlobalFree(hmemd)

end sub

' This function is the custom controls WndProc
function WndProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as LRESULT
	dim ps as PAINTSTRUCT
	dim rect1 as RECT
	dim rect2 as RECT
	dim dDC as HDC
	dim sDC as HDC
	dim hBmp1 as HBITMAP
	dim hBmp2 as HBITMAP
	dim hBmpOld1 as HBITMAP
	dim hBmpOld2 as HBITMAP
	dim hFontOld as HFONT
	dim buffer as zstring*256
	dim st as Integer
	dim bc as Integer
	dim bb as HBRUSH
	dim tlen as Integer
	dim x as Integer
	dim y as Integer

	select case uMsg
		case WM_PAINT
			GetClientRect(hWin,@rect1)
			if rect1.right<>0 and rect1.bottom<>0 then
				BeginPaint(hWin,@ps)
				' Create a memory DC for the destination
				dDC=CreateCompatibleDC(ps.hdc)
				' Create the destination bitmap
				hBmp1=CreateCompatibleBitmap(ps.hdc,rect1.right,rect1.bottom)
				' and select it into the DC
				hBmpOld1=SelectObject(dDC,hBmp1)
				' Set destination background color
				st=GetWindowLong(hWin,GWL_STYLE)
				select case st and 12
					Case 0
						' Red
						bc=&HFF
					case 4
						' Green
						bc=&HFF00
					case 8
						' Blue
						bc=&HFF0000
					case else
						' White
						bc=&HFFFFFF
				End Select
				' Create back brush
				bb=CreateSolidBrush(bc)
				' Fill rectangle using the back brush
				FillRect(dDC,@rect1,bb)
				' Delete back brush
				DeleteObject(bb)
				' Get the caption text lenght
				tlen=GetWindowTextLength(hWin)
				if tlen then
					' Create a memory DC for the source
					sDC=CreateCompatibleDC(ps.hdc)
					' Set back color
					SetBkColor(sDC,bc)
					' Get size of text to draw
					rect2.left=0
					rect2.top=0
					rect2.right=0
					rect2.bottom=0
					GetWindowText(hWin,@buffer,sizeof(buffer))
					' Select font
					hFontOld=SelectObject(sDC,Cast(HFONT,GetWindowLong(hWin,0)))
					' Get text size
					DrawText(sDC,@buffer,-1,@rect2,DT_CALCRECT or DT_SINGLELINE or DT_LEFT or DT_TOP)
					'Create a bitmap for the text
					hBmp2=CreateCompatibleBitmap(ps.hdc,rect2.right,rect2.bottom)
					' and select it into source DC
					hBmpOld2=SelectObject(sDC,hBmp2)
					' Draw the text
					DrawText(sDC,@buffer,-1,@rect2,DT_SINGLELINE or DT_LEFT or DT_TOP)
					' Rotate the bitmap
					x=0
					y=0
					if st and STYLE_CENTER then
						select case st and 3
							Case 0,2
								x=(rect1.right-rect2.right)/2
								y=(rect1.bottom-rect2.bottom)/2
							case 1,3
								x=(rect1.right-rect2.bottom)/2
								y=(rect1.bottom-rect2.right)/2
						End Select
					endif
					Rotate(hBmp1,hBmp2,x,y,st and 3)
					' Restore old bitmap
					SelectObject(sDC,hBmpOld2)
					' Delete created source bitmap
					DeleteObject(hBmp2)
					' Restore old font
					SelectObject(sDC,hFontOld)
					' Delete source DC
					DeleteDC(sDC)
				endif
				' Blit the destination bitmap onto window bitmap
				BitBlt(ps.hdc,rect1.left,rect1.top,rect1.right,rect1.bottom,dDC,0,0,SRCCOPY)
				' Restore old destination bitmap
				SelectObject(dDC,hBmpOld1)
				' and delete created destination bitmap
				DeleteObject(hBmp1)
				' Delete destination DC
				DeleteDC(dDC)
				EndPaint(hWin,@ps)
			endif
			return 0
		case WM_SETFONT
			' Save the font handle
			SetWindowLong(hWin,0,wParam)
			if lParam then
				InvalidateRect(hWin,NULL,TRUE)
			endif
		case WM_SETTEXT
			InvalidateRect(hWin,NULL,TRUE)
	end select
	return DefWindowProc(hWin,uMsg,wParam,lParam)

end function

' This sub registers a windowclass for the custom control 
sub CreateClass
	dim wc as WNDCLASSEX

	' Create a windowclass for the custom control
	wc.cbSize=sizeof(WNDCLASSEX)
	wc.style=CS_HREDRAW or CS_VREDRAW or CS_GLOBALCLASS or CS_PARENTDC or CS_DBLCLKS
	wc.lpfnWndProc=@WndProc
	wc.cbClsExtra=0
	' Holds the font
	wc.cbWndExtra=4
	wc.hInstance=hInstance
	wc.hbrBackground=NULL
	wc.lpszMenuName=NULL
	wc.lpszClassName=StrPtr(szClassName)
	wc.hIcon=NULL
	wc.hIconSm=NULL
	wc.hCursor=LoadCursor(NULL,IDC_ARROW)
	RegisterClassEx(@wc)

end sub

' Windows calls this function when the dll is loaded.
function DllMain alias "DllMain" (byval hModule as HMODULE,byval reason as Integer,byval lpReserved as LPVOID) as BOOL

   select case reason
	   case DLL_PROCESS_ATTACH
	   	hInstance=hModule
	   	CreateClass
			'
		case DLL_PROCESS_DETACH
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
