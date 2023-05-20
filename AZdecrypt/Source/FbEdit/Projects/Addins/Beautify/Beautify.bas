#Include Once "windows.bi"
#Include Once "win/commctrl.bi"

#Include "..\..\FbEdit\Inc\Addins.bi"

#Include "Beautify.bi"

' Update toolbar imagelists
Sub Toolbar
	Dim nOld As Integer
	Dim nNew As Integer
	Dim hOldIml As HIMAGELIST
	Dim hDC As HDC
	Dim mDC As HDC
	Dim hBmp As HBITMAP
	Dim hOldBmp As HBITMAP
	Dim hBr As HBRUSH
	Dim rect As RECT
	Dim i As Integer
	Dim x As Integer
	Dim y As Integer
	Dim c As Integer

	' Destroy old imagelist
	hOldIml=Cast(HIMAGELIST,SendMessage(lpHANDLES->htoolbar,TB_GETIMAGELIST,0,0))
	nOld=ImageList_GetImageCount(hOldIml)
	SendMessage(lpHANDLES->htoolbar,TB_SETIMAGELIST,0,NULL)
	' Create a new imagelist
	hIml=ImageList_LoadImage(hInstance,Cast(ZString Ptr,IDB_TOOLBAR),16,29,&HC0C0C0,IMAGE_BITMAP,LR_CREATEDIBSECTION)
	nNew=ImageList_GetImageCount(hIml)
	hDC=GetDC(NULL)
	mDC=CreateCompatibleDC(hDC)
	hBr=CreateSolidBrush(&HC0C0C0)
	hBmp=CreateCompatibleBitmap(hDC,16,16)
	rect.left=0
	rect.top=0
	rect.right=16
	rect.bottom=16
	While nNew<nOld
		hOldBmp=SelectObject(mDC,hBmp)
		FillRect(mDC,@rect,hBR)
		ImageList_Draw(hOldIml,nNew,mDC,0,0,ILD_TRANSPARENT)
		SelectObject(mDC,hOldBmp)
		ImageList_AddMasked(hIml,hBmp,&HC0C0C0)
		nNew=nNew+1
	Wend
	DeleteObject(hBmp)
	ImageList_Destroy(hOldIml)
	' Create a grayed bitmap
	rect.left=0
	rect.top=0
	rect.right=nOld*16
	rect.bottom=16
	hBmp=CreateCompatibleBitmap(hDC,rect.right,rect.bottom)
	ReleaseDC(NULL,hDC)
	hOldBmp=SelectObject(mDC,hBmp)
	FillRect(mDC,@rect,hBr)
	DeleteObject(hBr)
	i=0
	While i<nOld
		ImageList_Draw(hIml,i,mDC,rect.left,0,ILD_TRANSPARENT)
		rect.left=rect.left+16
		i=i+1
	Wend
	y=0
	While y<16
		x=0
		While x<rect.right
			c=GetPixel(mDC,x,y)
			If c<>&HC0C0C0 Then
				Asm
					mov		eax,[c]
					bswap		eax
					Shr		eax,8
					'movzx		ecx,al			' red
					Xor		ecx,ecx
					mov		cl,al
					imul		ecx,ecx,66
					'movzx		edx,ah			' green
					Xor		edx,edx
					mov		dl,ah
					imul		edx,edx,129
					add		edx,ecx
					Shr		eax,16			' blue
					imul		eax,eax,25
					add		eax,edx
					add		eax,128
					Shr		eax,8
					add		eax,16
					imul		eax,eax,&H010101
					And		eax,&HFCFCFC
					Shr		eax,2
					Or			eax,&H808080
					mov		[c],eax
				End Asm
				SetPixel(mDC,x,y,c)
			EndIf
			x=x+1
		Wend
		y=y+1
	Wend
	SelectObject(mDC,hOldBmp)
	DeleteDC(mDC)
	' Create a grayed imagelist
	hGrayIml=ImageList_Create(16,16,ILC_MASK Or ILC_COLOR24,nOld,0)
	ImageList_AddMasked(hGrayIml,hBmp,&HC0C0C0)
	DeleteObject(hBmp)
	' Set the new imagelists to the toolbar
	SendMessage(lpHANDLES->htoolbar,TB_SETIMAGELIST,0,Cast(LPARAM,hIml))
	SendMessage(lpHANDLES->htoolbar,TB_SETDISABLEDIMAGELIST,0,Cast(LPARAM,hGrayIml))
	hBmp=LoadBitmap(hInstance,Cast(ZString Ptr,IDB_MENUCHECK))
	nCheck=ImageList_AddMasked(hIml,hBmp,&HC0C0C0)
	DeleteObject(hBmp)

End Sub

' FbEdit main window callback
Function WndProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim lpMEASUREITEMSTRUCT As MEASUREITEMSTRUCT Ptr
	Dim lpDRAWITEMSTRUCT As DRAWITEMSTRUCT Ptr
	Dim lpMNUITEM As MNUITEM Ptr
	Dim mDC As HDC
	Dim rect As RECT
	Dim rect1 As RECT
	Dim hBmp As HBITMAP
	Dim hOldBmp As HBITMAP
	Dim hOldFont As HFONT
	Dim hBr As HBRUSH
	Dim hBr1 As HBRUSH
	Dim hPen As HPEN
	Dim hOldPen As HPEN

	Select Case uMsg
		Case WM_MEASUREITEM
			lpMEASUREITEMSTRUCT=Cast( MEASUREITEMSTRUCT Ptr,lParam)
			If lpMEASUREITEMSTRUCT->CtlType=ODT_MENU And hMem<>0 Then
				lpMNUITEM=Cast(MNUITEM Ptr,lpMEASUREITEMSTRUCT->itemData)
				lpMEASUREITEMSTRUCT->itemWidth=lpMNUITEM->wdt
				lpMEASUREITEMSTRUCT->itemHeight=lpMNUITEM->hgt
				Return TRUE
			EndIf
			'
		Case WM_DRAWITEM
			lpDRAWITEMSTRUCT=Cast(DRAWITEMSTRUCT Ptr,lParam)
			If lpDRAWITEMSTRUCT->CtlType=ODT_MENU And hMem<>0 Then
				mDC=CreateCompatibleDC(lpDRAWITEMSTRUCT->hdc)
				rect.left=0
				rect.top=0
				rect.right=lpDRAWITEMSTRUCT->rcItem.right-lpDRAWITEMSTRUCT->rcItem.left
				rect.bottom=lpDRAWITEMSTRUCT->rcItem.bottom-lpDRAWITEMSTRUCT->rcItem.top
				hBmp=CreateCompatibleBitmap(lpDRAWITEMSTRUCT->hdc,rect.right,rect.bottom)
				hOldBmp=SelectObject(mDC,hBmp)
				hOldFont=SelectObject(mDC,hMnuFont)
				lpMNUITEM=Cast(MNUITEM Ptr,lpDRAWITEMSTRUCT->itemData)
				If lpMNUITEM->ntype=2 Then
					hPen=CreatePen(PS_SOLID,1,&HF5BE9F)
					hOldPen=SelectObject(mDC,hPen)
					FillRect(mDC,@rect,hMenuBrush)
					MoveToEx(mDC,rect.left+20,rect.top+5,NULL)
					LineTo(mDC,rect.right,rect.top+5)
					SelectObject(mDC,hOldPen)
					DeleteObject(hPen)
				Else
					SetBkMode(mDC,TRANSPARENT)
					SetTextColor(mDC,GetSysColor(COLOR_MENUTEXT))
					If (lpDRAWITEMSTRUCT->itemState And ODS_GRAYED)=0 Then
						If lpDRAWITEMSTRUCT->itemState And ODS_SELECTED Then
							hBr=CreateSolidBrush(&HF5BE9F)
							FillRect(mDC,@rect,hBr)
							If lpMNUITEM->ntype=1 Then
								' Menu bar
								hPen=CreatePen(PS_SOLID,1,&H800000)
								hOldPen=SelectObject(mDC,hPen)
								MoveToEx(mDC,rect.left,rect.bottom-1,NULL)
								LineTo(mDC,rect.left,rect.top)
								LineTo(mDC,rect.right-1,rect.top)
								LineTo(mDC,rect.right-1,rect.bottom)
								SelectObject(mDC,hOldPen)
								DeleteObject(hPen)
							Else
								hBr1=CreateSolidBrush(&H800000)
								FrameRect(mDC,@rect,hBr1)
								DeleteObject(hBr1)
							EndIf
							DeleteObject(hBr)
						Else
							If lpMNUITEM->ntype=1 Then
								' Menu bar
								FillRect(mDC,@rect,GetSysColorBrush(COLOR_MENU))
							Else
								FillRect(mDC,@rect,hMenuBrush)
								If lpDRAWITEMSTRUCT->itemState And ODS_CHECKED Then
									rect1.left=0
									rect1.right=18
									rect1.top=(rect.bottom-18)/2
									rect1.bottom=rect1.top+18
									DrawEdge(mDC,@rect1,BDR_SUNKENINNER,BF_RECT)
								EndIf
							EndIf
						EndIf
					Else
						FillRect(mDC,@rect,hMenuBrush)
					EndIf
					If lpDRAWITEMSTRUCT->itemState And ODS_GRAYED Then
						SetTextColor(mDC,GetSysColor(COLOR_GRAYTEXT))
						If lpMNUITEM->img Then
							ImageList_Draw(hGrayIml,lpMNUITEM->img-1,mDC,rect.left+1,rect.top+1,ILD_NORMAL)
						ElseIf lpDRAWITEMSTRUCT->itemState And ODS_CHECKED Then
							ImageList_Draw(hIml,nCheck,mDC,rect.left+1,rect.top+1,ILD_NORMAL)
						EndIf
					Else
						If lpMNUITEM->img Then
							ImageList_Draw(hIml,lpMNUITEM->img-1,mDC,rect.left+1,rect.top+1,ILD_NORMAL)
						ElseIf lpDRAWITEMSTRUCT->itemState And ODS_CHECKED Then
							ImageList_Draw(hIml,nCheck,mDC,rect.left+1,rect.top+1,ILD_NORMAL)
						EndIf
					EndIf
					If lpMNUITEM->ntype=1 Then
						rect.left=rect.left+8
					Else
						rect.left=rect.left+21
					EndIf
					rect.right=rect.right-4
					DrawText(mDC,@lpMNUITEM->txt,lstrlen(@lpMNUITEM->txt),@rect,DT_SINGLELINE Or DT_VCENTER)
					DrawText(mDC,@lpMNUITEM->acl,lstrlen(@lpMNUITEM->acl),@rect,DT_SINGLELINE Or DT_RIGHT Or DT_VCENTER)
				EndIf
				BitBlt(lpDRAWITEMSTRUCT->hdc,lpDRAWITEMSTRUCT->rcItem.left,lpDRAWITEMSTRUCT->rcItem.top,lpDRAWITEMSTRUCT->rcItem.right-lpDRAWITEMSTRUCT->rcItem.left,lpDRAWITEMSTRUCT->rcItem.bottom-lpDRAWITEMSTRUCT->rcItem.top,mDC,0,0,SRCCOPY)
				SelectObject(mDC,hOldFont)
				SelectObject(mDC,hOldBmp)
				DeleteObject(hBmp)
				DeleteDC(mDC)
				Return TRUE
			EndIf
			'
	End Select
	Return CallWindowProc(lpOldWndProc,hWin,uMsg,wParam,lParam)

End Function

' Check if menu item exists in array
Function FindMnuPos(ByVal pMem As MNUITEM Ptr,ByVal hMnu As HMENU,ByVal wid As Integer) As MNUITEM Ptr
	Dim i As Integer

	While TRUE
		If (pMem->wid=wid And pMem->hmnu=hMnu) Or pMem->hmnu=0 Then
			Exit While
		EndIf
		i=Cast(Integer,pMem)
		i=i+SizeOf(MNUITEM)
		pMem=Cast(MNUITEM Ptr,i)
	Wend
	Return pMem

End Function

' Make menu items ownerdrawn
Sub GetMenuItems(ByVal hMnu As HMENU,ByVal nPos As Integer)
	Dim mii As MENUITEMINFO
	Dim buffer As ZString*260
	Dim i As Integer
	Dim hDC As HDC
	Dim mDC As HDC
	Dim rect As RECT
	Dim hOldFont As HFONT
	Dim pMem As MNUITEM Ptr

	hDC=GetDC(NULL)
	mDC=CreateCompatibleDC(hDC)
	ReleaseDC(NULL,hDC)
	hOldFont=SelectObject(mDC,hMnuFont)
NextMnu:
	mii.cbSize=SizeOf(MENUITEMINFO)
	mii.fMask=MIIM_DATA Or MIIM_ID Or MIIM_SUBMENU Or MIIM_TYPE
	mii.dwTypeData=@buffer
	mii.cch=SizeOf(buffer)
	If GetMenuItemInfo(hMnu,nPos,TRUE,@mii) Then
		If (mii.fType And MFT_OWNERDRAW)=0 Then
			pMem=FindMnuPos(hMem,hMnu,mii.wID)
			pMem->hmnu=hMnu
			pMem->wid=mii.wID
			mii.fType=mii.fType Or MFT_OWNERDRAW
			mii.dwItemData=Cast(Integer,pMem)
			If (mii.fType And MFT_SEPARATOR)=0 Then
				i=InStr(buffer,Chr(VK_TAB))
				If i Then
					lstrcpyn(@pMem->txt,@buffer,i)
					pMem->acl=Mid(buffer,i+1)
				Else
					lstrcpy(@pMem->txt,@buffer)
				EndIf
				DrawText(mDC,@pMem->txt,lstrlen(@pMem->txt),@rect,DT_CALCRECT Or DT_SINGLELINE)
				pMem->wdt=rect.right
				If lstrlen(@pMem->acl) Then
					DrawText(mDC,@pMem->acl,lstrlen(@pMem->acl),@rect,DT_CALCRECT Or DT_SINGLELINE)
					pMem->wdt=pMem->wdt+8+rect.right
				EndIf
				If hMnu=hMenu Then
					' Menu bar
					pMem->ntype=1
					pMem->wdt=pMem->wdt+4
				Else
					' Menu item
					pMem->ntype=3
					pMem->wdt=pMem->wdt+22
					If SendMessage(lpHANDLES->htoolbar,TB_COMMANDTOINDEX,mii.wID,0)>=0 Then
						pMem->img=SendMessage(lpHANDLES->htoolbar,TB_GETBITMAP,mii.wID,0)+1
					EndIf
				EndIf
				pMem->hgt=MnuFontHt
			Else
				' Separator
				pMem->ntype=2
				pMem->hgt=10
			EndIf
			If pMem->ntype<>1 Then
				SetMenuItemInfo(hMnu,nPos,TRUE,@mii)
			EndIf
		EndIf
		If mii.hSubMenu Then
			GetMenuItems(mii.hSubMenu,0)
		EndIf
		nPos=nPos+1
		GoTo	NextMnu
	EndIf
	SelectObject(mDC,hOldFont)
	DeleteDC(mDC)

End Sub

' Create a bitmap for the menu back brush
Function MakeBitMap(ByVal barwidth As Integer,ByVal barcolor As Integer,ByVal bodycolor As Integer) As HBITMAP
	Dim hBmp As HBITMAP
	Dim hOldBmp As HBITMAP
	Dim hDC As HDC
	Dim mDC As HDC
	Dim hDeskTop As HWND
	Dim As Integer x,y,bc

	hDeskTop=GetDesktopWindow
	hDC=GetDC(hDeskTop)
	mDC=CreateCompatibleDC(hDC)
	hBmp=CreateCompatibleBitmap(hDC,600,8)
	ReleaseDC(hDeskTop,hDC)
	hOldBmp=SelectObject(mDC,hBmp)
	y=0
	While y<8
		x=0
		bc=barcolor
		While x<barwidth
			SetPixel(mDC,x,y,bc)
			bc=bc-&h040404
			x=x+1
		Wend
		While x<600
			SetPixel(mDC,x,y,bodycolor)
			x=x+1
		Wend
		y=y+1
	Wend
	SelectObject(mDC,hOldBmp)
	DeleteDC(mDC)
	Return hBmp

End Function

' Let the menu look cool
Sub CoolMenu(ByVal hMenu As HMENU,ByVal barcolor As Integer,ByVal bodycolor As Integer)
	Dim MInfo As MENUINFO
	Dim i As Integer
	Dim hMnu As HMENU
	Dim hBmp As HBITMAP
	Dim hBr As HBRUSH

	hBmp=MakeBitMap(22,BarColor,BodyColor)
	hBr=CreatePatternBrush(hBmp)
	DeleteObject(hBmp)
	MInfo.hbrBack=hBr
	MInfo.cbSize=SizeOf(MENUINFO)
	MInfo.fmask=MIM_BACKGROUND Or MIM_APPLYTOSUBMENUS
	i=0
  Nxt:
	hMnu=GetSubMenu(hMenu,i)
	If hMnu Then
		SetMenuInfo(hMnu,@MInfo)
		i=i+1
		GoTo Nxt
	EndIf

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
	' Messages this addin will hook into
	hooks.hook1=HOOK_CLOSE Or HOOK_ADDINSLOADED Or HOOK_MENUREFRESH
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	Return @hooks

End Function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
Function DllFunction Cdecl Alias "DllFunction" (ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As bool Export
	Dim hBmp As HBITMAP
	Dim ncm As NONCLIENTMETRICS

	Select Case uMsg
		Case AIM_CLOSE
			' FbEdit is closing
			DeleteObject(hMnuFont)
			DeleteObject(hMenuBrush)
			GlobalFree(hMem)
			hMem=0
			'
		Case AIM_ADDINSLOADED
			' Beautify toolbar
			Toolbar
			' Beautify menu arrows
			ImageList_Destroy(lpHANDLES->hmnuiml)
			lpHANDLES->hmnuiml=ImageList_Create(16,16,ILC_COLOR24 Or ILC_MASK,4,0)
			hBmp=LoadBitmap(hInstance,Cast(ZString Ptr,IDB_MNUARROW))
			ImageList_AddMasked(lpHANDLES->hmnuiml,hBmp,&HC0C0C0)
			DeleteObject(hBmp)
			' Get menu font
			ncm.cbSize=SizeOf(NONCLIENTMETRICS)
			SystemParametersInfo(SPI_GETNONCLIENTMETRICS,SizeOf(NONCLIENTMETRICS),@ncm,0)
			hMnuFont=CreateFontIndirect(@ncm.lfMenuFont)
			MnuFontHt=Abs(ncm.lfMenuFont.lfHeight)+6
			If MnuFontHt<18 Then
				MnuFontHt=18
			EndIf
			'Create back brush for menu items
			hBmp=MakeBitMap(19,&HFFCEBE,&HFFFFFF)
			hMenuBrush=CreatePatternBrush(hBmp)
			DeleteObject(hBmp)
			' Let the menus look cool
			CoolMenu(lpHANDLES->hmenu,&HFFCEBE,&HFFFFFF)
			CoolMenu(lpHANDLES->hcontextmenu,&HFFCEBE,&HFFFFFF)
			' Subclass FbEdit main window
			lpOldWndProc=Cast(Any Ptr,SetWindowLong(lpHANDLES->hwnd,GWL_WNDPROC,Cast(Integer,@WndProc)))
			' Allocate memory for menu items
			hMem=GlobalAlloc(GMEM_FIXED Or GMEM_ZEROINIT,1024*64)
			' Make menu items ownerdrawn
			hMenu=lpHANDLES->hmenu
			GetMenuItems(hMenu,0)
			hMenu=lpHANDLES->hcontextmenu
			GetMenuItems(hMenu,0)
			'
		Case AIM_MENUREFRESH
			' Make menu items ownerdrawn (only new or updated menu items)
			hMenu=lpHANDLES->hmenu
			GetMenuItems(hMenu,0)
			hMenu=lpHANDLES->hcontextmenu
			GetMenuItems(hMenu,0)
			'
	End Select
	Return FALSE

End Function
