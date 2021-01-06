#include once "windows.bi"
#include once "win/commctrl.bi"
#include once "win/commdlg.bi"

#include "..\..\FbEdit\Inc\Addins.bi"

#include "Toolbar.bi"

sub ShowToolbar(byval hWin as HWND)
	dim hTbr as HWND
	dim tbb as TBBUTTON
	dim hMem as HGLOBAL
	dim nInx as integer
	dim buff as zstring*32
	dim nval as integer

	hTbr=GetDlgItem(hWin,IDC_TBR1)
	while SendMessage(hTbr,TB_BUTTONCOUNT,0,0)
		SendMessage(hTbr,TB_DELETEBUTTON,0,0)
	wend
	while TRUE
		if SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETTEXT,nInx,Cast(LPARAM,@buff))=LB_ERR then
			exit while
		endif
		nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,nInx,0)
		if buff="-" then
			tbb.iBitmap=0
			tbb.idCommand=0
			tbb.fsStyle=TBSTYLE_SEP
		else
			tbb.iBitmap=(nval shr 16) and &HFF
			tbb.idCommand=nInx+4000
			tbb.fsState=TBSTATE_ENABLED
			tbb.fsStyle=0
			if (nval shr 24) and 1 then
				tbb.fsStyle=tbb.fsStyle or TBSTYLE_CHECK
			endif
			if (nval shr 25) and 1 then
				tbb.fsStyle=tbb.fsStyle or TBSTYLE_GROUP
			endif
		endif
		SendMessage(hTbr,TB_ADDBUTTONS,1,Cast(LPARAM,@tbb))
		nInx=nInx+1
	wend
end sub

sub SetImageList(byval hWin as HWND)
	dim hMem as HGLOBAL
	dim lpTBMEM as TBMEM ptr
	dim lpTBR as TBR ptr
	dim hBmp as HBITMAP
	dim hTbr1 as HWND
	dim hTbr2 as HWND
	Dim tbab As TBADDBITMAP

	hMem=Cast(HGLOBAL,GetWindowLong(hWin,GWL_USERDATA))
	lpTBMEM=hMem
	lpTBR=hMem+SizeOf(TBMEM)
	hTbr1=GetDlgItem(hWin,IDC_TBR1)
	hTbr2=GetDlgItem(hWin,IDC_STCBTN)
	hTbr2=GetDlgItem(hTbr2,IDC_TBR2)
	SendMessage(hTbr1,TB_SETIMAGELIST,0,NULL)
	SendMessage(hTbr2,TB_SETIMAGELIST,0,NULL)
	if lpTBMEM->hIml then
		ImageList_Destroy(lpTBMEM->hIml)
	endif
	lpTBMEM->hIml=ImageList_Create(lpTBR->nBtnSize,lpTBR->nBtnSize,ILC_COLOR24 or ILC_MASK,80,0)
	if lstrlen(@lpTBR->szBmpFile) then
		hBmp=LoadImage(0,@lpTBR->szBmpFile,IMAGE_BITMAP,0,0,LR_LOADFROMFILE or LR_LOADMAP3DCOLORS)
		ImageList_AddMasked(lpTBMEM->hIml,hBmp,&HC0C0C0)
		DeleteObject(hBmp)
	else
		tbab.hInst=HINST_COMMCTRL
		tbab.nID=IDB_STD_SMALL_COLOR
		SendMessage(hTbr1,TB_ADDBITMAP,15,Cast(LPARAM,@tbab))
		lpTBMEM->hIml=Cast(HIMAGELIST,SendMessage(hTbr1,TB_GETIMAGELIST,0,0))
	endif
	SendMessage(hTbr1,TB_SETIMAGELIST,0,Cast(LPARAM,lpTBMEM->hIml))
	SendMessage(hTbr2,TB_SETIMAGELIST,0,Cast(LPARAM,lpTBMEM->hIml))
	SendMessage(hTbr1,TB_AUTOSIZE,0,0)
	SendMessage(hTbr2,TB_AUTOSIZE,0,0)

end sub

sub NewToolbar(byval hWin as HWND)
	dim hMem as HGLOBAL
	dim lpTBMEM as TBMEM ptr
	dim lpTBR as TBR ptr
	dim hTbr as HWND
	dim tbs as integer

	hMem=Cast(HGLOBAL,GetWindowLong(hWin,GWL_USERDATA))
	lpTBMEM=hMem
	lpTBR=hMem+SizeOf(TBMEM)
	hTbr=GetDlgItem(hWin,IDC_TBR1)
	tbs=WS_CHILD or WS_VISIBLE
	if lpTBR->nStyle and 1 then
		tbs=tbs or TBSTYLE_FLAT
	endif
	if lpTBR->nStyle and 2 then
		tbs=tbs or TBSTYLE_WRAPABLE
	endif
	if lpTBR->nStyle and 4 then
		tbs=tbs or CCS_NODIVIDER
	endif
	if lpTBR->nStyle and 8 then
		tbs=tbs or TBSTYLE_TOOLTIPS
	endif
	if lpTBR->nStyle and 16 then
		tbs=tbs or TBSTYLE_LIST
	endif
	DestroyWindow(hTbr)
	hTbr=CreateWindowEx(0,"ToolbarWindow32",0,tbs,0,0,0,0,hWin,Cast(HMENU,IDC_TBR1),hInstance,0)
	SetImageList(hWin)
	ShowToolbar(hWin)

end sub

sub SaveToolbar(byval hWin as HWND)
	dim hFile as HANDLE
	dim hMem as HGLOBAL
	dim nSize as integer
	dim lpTBMEM as TBMEM ptr
	dim lpTBR as TBR ptr
	dim lpTBRBTN as TBRBTN ptr
	dim i as integer
	dim x as integer
	dim nval as integer

	hMem=Cast(HGLOBAL,GetWindowLong(hWin,GWL_USERDATA))
	lpTBMEM=hMem
	lpTBR=hMem+SizeOf(TBMEM)
	hFile=CreateFile(@lpTBMEM->szTbrFile,GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL)
	if hFile<>INVALID_HANDLE_VALUE then
		x=Cast(integer,lpTBR)
		x=x+SizeOf(TBR)
		lpTBRBTN=Cast(TBRBTN ptr,x)
		i=0
		while i<lpTBR->nBtn
			SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETTEXT,i,Cast(LPARAM,@lpTBRBTN->szBtnName))
			nval=lpTBRBTN->nBtnID+(lpTBRBTN->nBmp SHL 16)+(lpTBRBTN->nStyle SHL 24)
			nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
			lpTBRBTN->nBtnID=nval and &HFFFF
			lpTBRBTN->nBmp=(nval shr 16) and &HFF
			lpTBRBTN->nStyle=nval shr 24
			x=Cast(integer,lpTBRBTN)
			x=x+SizeOf(TBRBTN)
			lpTBRBTN=Cast(TBRBTN ptr,x)
			i=i+1
		wend
		nSize=SizeOf(TBR)+SizeOf(TBRBTN)*lpTBR->nBtn
		WriteFile(hFile,hMem+SizeOf(TBMEM),nSize,@nSize,NULL)
		CloseHandle(hFile)
		lpTBMEM->fChanged=FALSE
	endif

end sub

sub ExportToolbar(byval hWin as HWND)
	dim sLine as string
	dim st as string
	dim i as integer
	dim n as integer
	dim buff as zstring*32
	dim nval as integer
	Dim bDef As Boolean

	lpFUNCTIONS->ShowOutput(TRUE)
	SetWindowText(lpHANDLES->hout,NULL)
	n=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCOUNT,0,0)
	i=0
	while i<n
		SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETTEXT,i,Cast(LPARAM,@buff))
		nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0) And 65535
		if buff<>"-" And nVal<>0 Then
			sLine="#Define " & buff & " " & Str(nval)
			lpFUNCTIONS->TextToOutput(sLine)
			bDef=TRUE
		endif
		i=i+1
	Wend
	If bDef Then
		sLine=""
		lpFUNCTIONS->TextToOutput(sLine)
	EndIf
	sLine="sub DoToolbar(byval hTbr as HWND,byval hInst as HINSTANCE)"
	lpFUNCTIONS->TextToOutput(sLine)
	sLine="	dim tbab as TBADDBITMAP"
	lpFUNCTIONS->TextToOutput(sLine)
	i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCOUNT,0,0)
	n=i
	while i
		SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETTEXT,i-1,Cast(LPARAM,@buff))
		nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i-1,0)
		if buff="-" then
			sLine="	dim tbrbtn" & Str(i) & " as TBBUTTON=(0,0,TBSTATE_ENABLED,TBSTYLE_SEP,{0,0},0)"
		else
			st="TBSTYLE_BUTTON"
			if (nval shr 24) and 1 then
				st=st & " or TBSTYLE_CHECK"
			endif
			if (nval shr 25) and 1 then
				st=st & " or TBSTYLE_GROUP"
			endif
			sLine="	dim tbrbtn" & Str(i) & " as TBBUTTON=(" & Str((nval shr 16) and &HFF) & "," & buff & ",TBSTATE_ENABLED," & st & ",{0,0},0)"
		endif
		lpFUNCTIONS->TextToOutput(sLine)
		i=i-1
	wend
	sLine=""
	lpFUNCTIONS->TextToOutput(sLine)

	sLine="	'Set toolbar struct size"
	lpFUNCTIONS->TextToOutput(sLine)
	sLine="	SendMessage(hTbr,TB_BUTTONSTRUCTSIZE,SizeOf(TBBUTTON),0)"
	lpFUNCTIONS->TextToOutput(sLine)
	sLine="	'Set toolbar bitmap"
	lpFUNCTIONS->TextToOutput(sLine)
	sLine="	tbab.hInst=hInst"
	lpFUNCTIONS->TextToOutput(sLine)
	GetDlgItemText(hWin,IDC_EDTBMPNAME,@buff,SizeOf(buff))
	sLine="	tbab.nID=" & buff
	lpFUNCTIONS->TextToOutput(sLine)
	GetDlgItemText(hWin,IDC_EDTBMPNBR,@buff,SizeOf(buff))
	sLine="	SendMessage(hTbr,TB_ADDBITMAP," & buff & ",Cast(LPARAM,@tbab))"
	lpFUNCTIONS->TextToOutput(sLine)
	sLine="	'Set toolbar buttons"
	lpFUNCTIONS->TextToOutput(sLine)
	sLine="	SendMessage(hTbr,TB_ADDBUTTONS," & Str(n) & ",Cast(LPARAM,@tbrbtn1))"
	lpFUNCTIONS->TextToOutput(sLine)

	sLine=""
	lpFUNCTIONS->TextToOutput(sLine)
	sLine="end sub"
	lpFUNCTIONS->TextToOutput(sLine)

end sub

function ToolbarProc(byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as integer
	dim rect as RECT
	dim buff as zstring*260
	dim hFile as HANDLE
	dim hMem as HGLOBAL
	dim nSize as integer
	dim lpTBMEM as TBMEM ptr
	dim lpTBR as TBR ptr
	dim lpTBRBTN as TBRBTN ptr
	dim i as integer
	dim x as integer
	dim nval as integer
	dim hTbr as HWND
	dim tbb as TBBUTTON
	dim tbab as TBADDBITMAP
	dim ofn as OPENFILENAME
	dim hBmp as HBITMAP
	dim hIml as HIMAGELIST

	select case uMsg
		case WM_INITDIALOG
			lpFunctions->TranslateAddinDialog(hWin,"Toolbar")
			hWnd=hWin
			' Restore pos
			SetWindowPos(hWin,0,winsize.left,winsize.top,0,0,SWP_NOSIZE or SWP_NOZORDER)
			'MoveWindow(hWin,winsize.left,winsize.top,winsize.right-winsize.left,winsize.bottom-winsize.top,FALSE)
			hMem=GlobalAlloc(GMEM_FIXED or GMEM_ZEROINIT,8192)
			SetWindowLong(hWin,GWL_USERDATA,Cast(integer,hMem))
			lpTBMEM=Cast(TBMEM ptr,hMem)
			lpTBR=hMem+SizeOf(TBMEM)
			SendDlgItemMessage(hWin,IDC_EDTTBRNAME,EM_LIMITTEXT,31,0)
			SendDlgItemMessage(hWin,IDC_EDTTBRID,EM_LIMITTEXT,5,0)
			SendDlgItemMessage(hWin,IDC_EDTBTNNAME,EM_LIMITTEXT,31,0)
			SendDlgItemMessage(hWin,IDC_EDTBTNID,EM_LIMITTEXT,5,0)
			SendDlgItemMessage(hWin,IDC_EDTBMPNAME,EM_LIMITTEXT,31,0)
			SendDlgItemMessage(hWin,IDC_EDTBMPNBR,EM_LIMITTEXT,2,0)
			SendMessage(GetDlgItem(hWin,IDC_TBR2),TB_BUTTONSTRUCTSIZE,SizeOf(TBBUTTON),0)
			hTbr=GetDlgItem(hWin,IDC_TBR2)
			SetParent(hTbr,GetDlgItem(hWin,IDC_STCBTN))
			hFile=CreateFile(Cast(zstring ptr,lParam),GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL)
			if hFile<>INVALID_HANDLE_VALUE then
				lstrcpy(lpTBMEM->szTbrFile,Cast(zstring ptr,lParam))
				ReadFile(hFile,hMem+SizeOf(TBMEM),8192-SizeOf(TBMEM),@nSize,NULL)
				CloseHandle(hFile)
			endif
			SetDlgItemText(hWin,IDC_EDTTBRNAME,@lpTBR->szTbrName)
			SetDlgItemInt(hWin,IDC_EDTTBRID,lpTBR->nTbrID,FALSE)
			If lstrlen(@lpTBR->szBmpName) Then
				SetDlgItemText(hWin,IDC_EDTBMPNAME,@lpTBR->szBmpName)
				SetDlgItemInt(hWin,IDC_EDTBMPNBR,lpTBR->nBmp,FALSE)
			Else
				SetDlgItemText(hWin,IDC_EDTBMPNAME,@szSTD)
				SetDlgItemInt(hWin,IDC_EDTBMPNBR,15,FALSE)
			EndIf
			if lpTBR->nBtnSize<16 then
				lpTBR->nBtnSize=16
			endif
			SendDlgItemMessage(hWin,IDC_UDNSIZE,UDM_SETRANGE,0,&H00100030)				' Set range
			SendDlgItemMessage(hWin,IDC_UDNSIZE,UDM_SETPOS,0,lpTBR->nBtnSize)			' Set default value
			SetDlgItemText(hWin,IDC_EDTBMPFILE,@lpTBR->szBmpFile)
			SetImageList(hWin)
			i=0
			while i<80
				tbb.idCommand=i+3000
				tbb.iBitmap=i
				tbb.fsState=TBSTATE_ENABLED
				SendMessage(hTbr,TB_ADDBUTTONS,1,Cast(LPARAM,@tbb))
				i=i+1
			wend
			SendMessage(hTbr,TB_AUTOSIZE,0,0)
			if lpTBR->nStyle and 1 then
				CheckDlgButton(hWin,IDC_CHKTBRFLAT,BST_CHECKED)
			endif
			if lpTBR->nStyle and 2 then
				CheckDlgButton(hWin,IDC_CHKTBRWRAP,BST_CHECKED)
			endif
			if lpTBR->nStyle and 4 then
				CheckDlgButton(hWin,IDC_CHKTBRDIVIDER,BST_CHECKED)
			endif
			if lpTBR->nStyle and 8 then
				CheckDlgButton(hWin,IDC_CHKTBRTIP,BST_CHECKED)
			endif
			if lpTBR->nStyle and 16 then
				CheckDlgButton(hWin,IDC_CHKTBRLIST,BST_CHECKED)
			endif
			x=Cast(integer,lpTBR)
			x=x+SizeOf(TBR)
			lpTBRBTN=Cast(TBRBTN ptr,x)
			i=0
			while i<lpTBR->nBtn
				SendDlgItemMessage(hWin,IDC_LSTBTN,LB_ADDSTRING,0,Cast(LPARAM,@lpTBRBTN->szBtnName))
				nval=lpTBRBTN->nBtnID+(lpTBRBTN->nBmp SHL 16)+(lpTBRBTN->nStyle SHL 24)
				SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETITEMDATA,i,nval)
				x=Cast(integer,lpTBRBTN)
				x=x+SizeOf(TBRBTN)
				lpTBRBTN=Cast(TBRBTN ptr,x)
				i=i+1
			wend
			SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,0,0)
			SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
			hBmp=LoadBitmap(hInstance,Cast(zstring ptr,IDB_ARROW))
			hIml=ImageList_Create(16,16,ILC_COLOR8,4,0)
			ImageList_Add(hIml,hBmp,NULL)
			DeleteObject(hBmp)
			SendDlgItemMessage(hWin,IDC_BTNUP,BM_SETIMAGE,IMAGE_ICON,Cast(LPARAM,ImageList_GetIcon(lpHANDLES->hmnuiml,2,ILD_NORMAL)))
			SendDlgItemMessage(hWin,IDC_BTNDN,BM_SETIMAGE,IMAGE_ICON,Cast(LPARAM,ImageList_GetIcon(lpHANDLES->hmnuiml,3,ILD_NORMAL)))
			ImageList_Destroy(hIml)
			NewToolbar(hWin)
			lpTBMEM->fChanged=FALSE
			GetWindowText(hWin,@buff,SizeOf(buff))
			buff=buff & " - "
			lstrcat(@buff,Cast(zstring ptr,lParam))
			SetWindowText(hWin,buff)
			'
		case WM_CLOSE
			hMem=Cast(HGLOBAL,GetWindowLong(hWin,GWL_USERDATA))
			lpTBMEM=hMem
			if lpTBMEM->fChanged=TRUE then
				x=MessageBox(hWin,"Save changes?","Toolbar Creator",MB_YESNOCANCEL or MB_ICONQUESTION)
				if x=IDYES then
					SaveToolbar(hWin)
				elseif x=IDCANCEL then
					return TRUE
				endif
			endif
			' Save current pos & size
			GetWindowRect(hWin,@winsize)
			hMem=Cast(HGLOBAL,GetWindowLong(hWin,GWL_USERDATA))
			lpTBMEM=hMem
			ImageList_Destroy(lpTBMEM->hIml)
			GlobalFree(hMem)
			hWnd=0
			DestroyWindow(hWin)
			SetFocus(lpHANDLES->hwnd)
			'
		case WM_COMMAND
			hMem=Cast(HGLOBAL,GetWindowLong(hWin,GWL_USERDATA))
			lpTBMEM=hMem
			lpTBR=hMem+SizeOf(TBMEM)
			if hMem then
				select case hiword(wParam)
					case BN_CLICKED
						select case loword(wParam)
							case IDCANCEL
								SendMessage(hWin,WM_CLOSE,0,0)
								'
							case IDOK
								SaveToolbar(hWin)
								'
							case IDC_BTNEXPORT
								ExportToolbar(hWin)
								'
							case IDC_BTNUP
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i>0 then
									nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETTEXT,i,Cast(LPARAM,@buff))
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_DELETESTRING,i,0)
									i=i-1
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_INSERTSTRING,i,Cast(LPARAM,@buff))
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETITEMDATA,i,nval)
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i,0)
									SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
									ShowToolbar(hWin)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case IDC_BTNADDBTN
								buff="IDC_TBB"
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_ADDSTRING,0,Cast(LPARAM,@buff))
								SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i,0)
								SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
								lpTBR->nBtn=lpTBR->nBtn+1
								ShowToolbar(hWin)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_BTNINSBTN
								buff="IDC_TBB"
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i<>LB_ERR then
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_INSERTSTRING,i,Cast(LPARAM,@buff))
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i,0)
									SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
									lpTBR->nBtn=lpTBR->nBtn+1
									ShowToolbar(hWin)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case IDC_BTNADDSEP
								buff="-"
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_ADDSTRING,0,Cast(LPARAM,@buff))
								SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i,0)
								SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
								lpTBR->nBtn=lpTBR->nBtn+1
								ShowToolbar(hWin)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_BTNINSSEP
								buff="-"
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i<>LB_ERR then
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_INSERTSTRING,i,Cast(LPARAM,@buff))
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i,0)
									SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
									lpTBR->nBtn=lpTBR->nBtn+1
									ShowToolbar(hWin)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case IDC_BTNDEL
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i<>LB_ERR then
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_DELETESTRING,i,0)
									if SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i,0)=LB_ERR then
										SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i-1,0)
									endif
									SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
									lpTBR->nBtn=lpTBR->nBtn-1
									ShowToolbar(hWin)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case IDC_BTNDN
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i<>LB_ERR then
									x=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCOUNT,0,0)
									if i<x-1 then
										nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
										SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETTEXT,i,Cast(LPARAM,@buff))
										SendDlgItemMessage(hWin,IDC_LSTBTN,LB_DELETESTRING,i,0)
										i=i+1
										SendDlgItemMessage(hWin,IDC_LSTBTN,LB_INSERTSTRING,i,Cast(LPARAM,@buff))
										SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETITEMDATA,i,nval)
										SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i,0)
										SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
										ShowToolbar(hWin)
										lpTBMEM->fChanged=TRUE
									endif
								endif
								'
							case IDC_CHKTBRFLAT
								x=0
								if IsDlgButtonChecked(hWin,IDC_CHKTBRFLAT) then
									x=1
								endif
								lpTBR->nStyle=(lpTBR->nStyle and (-1 xor 1)) or x
								NewToolbar(hWin)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_CHKTBRWRAP
								x=0
								if IsDlgButtonChecked(hWin,IDC_CHKTBRWRAP) then
									x=2
								endif
								lpTBR->nStyle=(lpTBR->nStyle and (-1 xor 2)) or x
								NewToolbar(hWin)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_CHKTBRDIVIDER
								x=0
								if IsDlgButtonChecked(hWin,IDC_CHKTBRDIVIDER) then
									x=4
								endif
								lpTBR->nStyle=(lpTBR->nStyle and (-1 xor 4)) or x
								NewToolbar(hWin)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_CHKTBRTIP
								x=0
								if IsDlgButtonChecked(hWin,IDC_CHKTBRTIP) then
									x=8
								endif
								lpTBR->nStyle=(lpTBR->nStyle and (-1 xor 8)) or x
								NewToolbar(hWin)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_CHKTBRLIST
								x=0
								if IsDlgButtonChecked(hWin,IDC_CHKTBRLIST) then
									x=16
								endif
								lpTBR->nStyle=(lpTBR->nStyle and (-1 xor 16)) or x
								NewToolbar(hWin)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_CHKBTNCHECK
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i<>LB_ERR then
									nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
									nval=nval and (-1 xor 2^24)
									if IsDlgButtonChecked(hWin,IDC_CHKBTNCHECK) then
										nval=nval or 2^24
									endif
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETITEMDATA,i,nval)
									ShowToolbar(hWin)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case IDC_CHKBTNGROUP
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i<>LB_ERR then
									nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
									nval=nval and (-1 xor 2^25)
									if IsDlgButtonChecked(hWin,IDC_CHKBTNGROUP) then
										nval=nval or 2^25
									endif
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETITEMDATA,i,nval)
									ShowToolbar(hWin)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case IDC_BTNBMP
								ofn.lStructSize=sizeof(OPENFILENAME)
								ofn.hwndOwner=hWin
								ofn.hInstance=hInstance
								ofn.lpstrFile=@buff
								ofn.nMaxFile=SizeOf(buff)
								ofn.lpstrFilter=StrPtr(BMPFilterString)
								ofn.Flags=OFN_FILEMUSTEXIST or OFN_HIDEREADONLY or OFN_PATHMUSTEXIST or OFN_EXPLORER
								if GetOpenFileName(@ofn) then
									SetDlgItemText(hWin,IDC_EDTBMPFILE,@buff)
									lstrcpy(@lpTBR->szBmpFile,@buff)
									SetImageList(hWin)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case else
								if loword(wParam)>=4000 then
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,loword(wParam)-4000,0)
									SendMessage(hWin,WM_COMMAND,(LBN_SELCHANGE shl 16) or IDC_LSTBTN,0)
								elseif loword(wParam)>=3000 then
									i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
									if i<>LB_ERR then
										nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
										nval=nval and &HFF00FFFF
										nval=nval or ((loword(wParam)-3000) shl 16)
										SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETITEMDATA,i,nval)
										ShowToolbar(hWin)
										lpTBMEM->fChanged=TRUE
									endif
								endif
								'
						end select
						'
					case EN_CHANGE
						select case loword(wParam)
							case IDC_EDTTBRNAME
								GetDlgItemText(hWin,IDC_EDTTBRNAME,@lpTBR->szTbrName,32)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_EDTTBRID
								lpTBR->nTbrID=GetDlgItemInt(hWin,IDC_EDTTBRID,NULL,FALSE)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_EDTBMPFILE
								GetDlgItemText(hWin,IDC_EDTBMPFILE,@lpTBR->szBmpFile,260)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_EDTBMPNAME
								GetDlgItemText(hWin,IDC_EDTBMPNAME,@lpTBR->szBmpName,32)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_EDTBMPNBR
								lpTBR->nBmp=GetDlgItemInt(hWin,IDC_EDTBMPNBR,NULL,FALSE)
								lpTBMEM->fChanged=TRUE
								'
							case IDC_EDTBTNNAME
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i<>LB_ERR then
									GetDlgItemText(hWin,IDC_EDTBTNNAME,@buff,32)
									nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_DELETESTRING,i,0)
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_INSERTSTRING,i,Cast(LPARAM,@buff))
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETITEMDATA,i,nval)
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETCURSEL,i,0)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case IDC_EDTBTNID
								i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
								if i<>LB_ERR then
									nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
									x=GetDlgItemInt(hWin,IDC_EDTBTNID,NULL,FALSE)
									nval=(nval and &HFFFF0000) or x
									SendDlgItemMessage(hWin,IDC_LSTBTN,LB_SETITEMDATA,i,nval)
									lpTBMEM->fChanged=TRUE
								endif
								'
							case IDC_EDTSIZE
								lpTBR->nBtnSize=GetDlgItemInt(hWin,IDC_EDTSIZE,NULL,FALSE)
								SetImageList(hWin)
								lpTBMEM->fChanged=TRUE
								'
						end select
						'
					case LBN_SELCHANGE
						i=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETCURSEL,0,0)
						if i<>LB_ERR then
							SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETTEXT,i,Cast(LPARAM,@buff))
							nval=SendDlgItemMessage(hWin,IDC_LSTBTN,LB_GETITEMDATA,i,0)
							SetDlgItemText(hWin,IDC_EDTBTNNAME,@buff)
							SetDlgItemInt(hWin,IDC_EDTBTNID,nval and &HFFFF,FALSE)
							if nval and 2^24 then
								x=BST_CHECKED
							else
								x=BST_UNCHECKED
							endif
							CheckDlgButton(hWin,IDC_CHKBTNCHECK,x)
							if nval and 2^25 then
								x=BST_CHECKED
							else
								x=BST_UNCHECKED
							endif
							CheckDlgButton(hWin,IDC_CHKBTNGROUP,x)
						else
							SetDlgItemText(hWin,IDC_EDTBTNNAME,StrPtr(""))
							SetDlgItemText(hWin,IDC_EDTBTNID,StrPtr(""))
						endif
						'
				end select
			endif
			'
		case WM_SIZE
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
	' Get pos & size from ini
	lpFunctions->LoadFromIni("Toolbar","WinPos","4444",@winsize,FALSE)
	' Messages this addin will hook into
	hooks.hook1=HOOK_CLOSE or HOOK_FILEOPEN
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT
	dim buff as zstring*260
	dim hMem as HGLOBAL
	dim lpTBMEM as TBMEM ptr

	select case uMsg
		case AIM_CLOSE
			' Save pos & size to FbEdit.ini
			lpFunctions->SaveToIni("Toolbar","WinPos","4444",@winsize,FALSE)
			'
		case AIM_FILEOPEN
			lstrcpy(@buff,Cast(zstring ptr,lParam))
			if right(LCase(buff),4)=".tbr" then
				if hWnd then
					hMem=Cast(HGLOBAL,GetWindowLong(hWnd,GWL_USERDATA))
					lpTBMEM=hMem
					if lstrcmpi(@lpTBMEM->szTbrFile,Cast(zstring ptr,lParam)) then
						DestroyWindow(hWnd)
						CreateDialogParam(hInstance,Cast(zstring ptr,IDD_DLGTOOLBAR),lpHANDLES->hwnd,@ToolbarProc,Cast(LPARAM,@buff))
					else
						SetFocus(hWnd)
					endif
				else
					CreateDialogParam(hInstance,Cast(zstring ptr,IDD_DLGTOOLBAR),lpHANDLES->hwnd,@ToolbarProc,Cast(LPARAM,@buff))
				endif
				' Prevent FbEdit from opening the file.
				return TRUE
			endif
			'
	end select
	return FALSE

end function
