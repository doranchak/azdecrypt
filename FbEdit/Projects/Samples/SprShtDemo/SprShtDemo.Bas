''
'' Spread sheet example
''

#Include Once "windows.bi"
#Include Once "win/shellapi.bi"

#Include "SprShtDemo.bi"
#Include "..\..\..\Inc\SpreadSheet.bi"

Dim Shared hInst As HMODULE
Dim Shared hWnd As HWND
Dim Shared hSpr As HWND
Dim hLib As HMODULE
Dim msg As MSG


Sub Grid_Setup(ByVal hDlg As HWND)
	Dim gfmt As GLOBAL
	Dim spri As SPR_ITEM
	Dim nnum As Integer
	Dim d As Double
	Dim s As Single

	hSpr=GetDlgItem(hDlg,IDC_SPR1)

	SendMessage(hSpr,SPRM_SETROWCOUNT,4,0)
	SendMessage(hSpr,SPRM_SETCOLCOUNT,2,0)

	spri.flag=SPRIF_TEXTALIGN Or SPRIF_DATA Or SPRIF_WIDTH Or SPRIF_HEIGHT
	spri.col=1
	spri.row=0
	spri.fmt.txtal=FMTA_CENTER Or FMTA_MIDDLE
	spri.wt=200
	spri.ht=25
	spri.lpdta=StrPtr(" Col1 ")
	SendMessage(hSpr,SPRM_SETCELLDATA,0,Cast(LPARAM,@spri))

'	nnum=-12
	s=23.45
	spri.flag=SPRIF_DATA Or SPRIF_TYPE Or SPRIF_SINGLE
	spri.col=2
	spri.row=1
	spri.fmt.tpe=TPE_FLOAT
	spri.lpdta=@s
	SendMessage(hSpr,SPRM_SETCELLDATA,0,Cast(LPARAM,@spri))

	' Test converting from double to extended double (80 bit)
	d=1.23
	spri.flag=SPRIF_DATA Or SPRIF_TYPE Or SPRIF_DOUBLE
	spri.col=1
	spri.row=1
	spri.fmt.tpe=TPE_FLOAT
	spri.lpdta=@d
	SendMessage(hSpr,SPRM_SETCELLDATA,0,Cast(LPARAM,@spri))

	spri.flag=SPRIF_TEXTALIGN Or SPRIF_DATA Or SPRIF_TYPE
	spri.col=1
	spri.row=2
	spri.fmt.txtal=FMTA_LEFT Or FMTA_MIDDLE
	spri.fmt.tpe=TPE_BUTTON Or TPE_TEXT
	spri.lpdta=StrPtr("Hello")
	SendMessage(hSpr,SPRM_SETCELLDATA,0,Cast(LPARAM,@spri))

	spri.flag=SPRIF_STATE Or SPRIF_TEXTALIGN Or SPRIF_DATA Or SPRIF_TYPE Or SPRIF_HEIGHT
	spri.col=1
	spri.row=3
	spri.ht=50
	spri.state=STATE_LOCKED
	spri.fmt.txtal=FMTA_CENTER Or FMTA_MIDDLE
	spri.fmt.tpe=TPE_HYPERLINK
	spri.lpdta=StrPtr("http://fbedit.freebasic.net/")
	SendMessage(hSpr,SPRM_SETCELLDATA,0,Cast(LPARAM,@spri))

	nnum=1
	spri.flag=SPRIF_STATE Or SPRIF_DATA Or SPRIF_TYPE Or SPRIF_HEIGHT
	spri.col=2
	spri.row=3
	spri.ht=50
	spri.state=STATE_LOCKED
	spri.fmt.tpe=TPE_OWNERDRAWINTEGER
	spri.lpdta=@nnum
	SendMessage(hSpr,SPRM_SETCELLDATA,0,Cast(LPARAM,@spri))

	spri.flag=SPRIF_STATE Or SPRIF_TEXTALIGN Or SPRIF_DATA Or SPRIF_TYPE Or SPRIF_HEIGHT
	spri.col=1
	spri.row=4
	spri.ht=50
	spri.state=STATE_LOCKED
	spri.fmt.txtal=FMTA_CENTER Or FMTA_MIDDLE
	spri.fmt.tpe=TPE_HYPERLINK
	spri.lpdta=StrPtr("http://www.radasm.com/")
	SendMessage(hSpr,SPRM_SETCELLDATA,0,Cast(LPARAM,@spri))

	nnum=2
	spri.flag=SPRIF_STATE Or SPRIF_DATA Or SPRIF_TYPE Or SPRIF_HEIGHT
	spri.col=2
	spri.row=4
	spri.ht=50
	spri.state=STATE_LOCKED
	spri.fmt.txtal=FMTA_RIGHT Or FMTA_MIDDLE
	spri.fmt.tpe=TPE_OWNERDRAWINTEGER
	spri.lpdta=@nnum
	SendMessage(hSpr,SPRM_SETCELLDATA,0,Cast(LPARAM,@spri))

End Sub

''' Start DlgProc
Function DlgProc(ByVal hDlg As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
	Dim rect As RECT
	Dim lpDRAWITEMSTRUCT As DRAWITEMSTRUCT ptr
	Dim hIcon As HICON
	Dim lpSPR_ITEM As SPR_ITEM ptr
	Dim lpSPR_HYPERLINK As SPR_HYPERLINK ptr
	Dim spri As SPR_ITEM

	Select Case uMsg
		Case WM_INITDIALOG
			Grid_Setup(hDlg)
			'
		Case WM_COMMAND
			Select Case LoWord(wParam)
				Case IDC_BTN1
					' Test converting from integer or extended double (80 bit) to double
					spri.flag=SPRIF_DOUBLE
					spri.col=1
					spri.row=1
					SendMessage(hSpr,SPRM_GETCELLDATA,0,Cast(LPARAM,@spri))
					MessageBox(hDlg,Str(*Cast(Double ptr,spri.lpdta)),"Double",MB_OK)
					' Test converting from integer or extended double (80 bit) to single
					spri.flag=SPRIF_SINGLE
					spri.col=2
					spri.row=1
					SendMessage(hSpr,SPRM_GETCELLDATA,0,Cast(LPARAM,@spri))
					MessageBox(hDlg,Str(*Cast(Single ptr,spri.lpdta)),"Single",MB_OK)
					'
			End Select
		Case WM_CLOSE
			DestroyWindow(hDlg)
			'
		Case WM_DESTROY
			PostQuitMessage(0)
			'
		Case WM_SIZE
			GetClientRect(hDlg,@rect)
			MoveWindow(hSpr,rect.left,rect.top,rect.right,rect.bottom-40,TRUE)
			MoveWindow(GetDlgItem(hDlg,IDC_BTN1),rect.right-100,rect.bottom-35,90,30,TRUE)
			'
		Case WM_DRAWITEM
			' Get a pointer to the DRAWITEMSTRUCT
			lpDRAWITEMSTRUCT=Cast(DRAWITEMSTRUCT ptr,lParam)
			' Center the icon in the cell
			lpDRAWITEMSTRUCT->rcItem.left=lpDRAWITEMSTRUCT->rcItem.left+(lpDRAWITEMSTRUCT->rcItem.right-lpDRAWITEMSTRUCT->rcItem.left-32)/2
			lpDRAWITEMSTRUCT->rcItem.top=lpDRAWITEMSTRUCT->rcItem.top+(lpDRAWITEMSTRUCT->rcItem.bottom-lpDRAWITEMSTRUCT->rcItem.top-32)/2
			' Get a pointer to the SPR_ITEM
			lpSPR_ITEM=Cast(SPR_ITEM ptr,lpDRAWITEMSTRUCT->itemData)
			' Load the icon. The icon ID is the cells integer value.
			hIcon=LoadIcon(hInst,Cast(ZString ptr,*Cast(Integer ptr,lpSPR_ITEM->lpdta)))
			' Draw the icon
			DrawIcon(lpDRAWITEMSTRUCT->hdc,lpDRAWITEMSTRUCT->rcItem.left,lpDRAWITEMSTRUCT->rcItem.top,hIcon)
			'
		Case WM_NOTIFY
			' Get a pointer to the SPR_HYPERLINK
			lpSPR_HYPERLINK=Cast(SPR_HYPERLINK Ptr,lParam)
			' Check if notification is from the spread sheet control.
			If lpSPR_HYPERLINK->hdr.hwndFrom=hSpr Then
				' Check if it is a click on a hyperlink.
				If lpSPR_HYPERLINK->hdr.code=SPRN_HYPERLINKCLICK Then
					' Get a pointer to the SPR_ITEM.
					lpSPR_ITEM=lpSPR_HYPERLINK->lpspri
					' Let windows open the link.
					ShellExecute(hDlg,StrPtr("Open"),Cast(ZString ptr,lpSPR_ITEM->lpdta),NULL,NULL,SW_SHOWDEFAULT)
				EndIf
			EndIf
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function

''' end DlgProc


'''
''' Program start
'''

hInst=GetModuleHandle(NULL)

hLib=LoadLibrary("SprSht.dll")

If hLib Then
	'' Create the Dialog
	hWnd=CreateDialogParam(hInst,Cast(ZString ptr,IDD_DLG1), NULL, @DlgProc, NULL)
	Do While GetMessage(@msg,NULL,0,0)
		TranslateMessage(@msg)
		DispatchMessage(@msg)
	Loop
Else
	MessageBox(NULL,StrPtr("Could not find sprsht.dll"),StrPtr("SpreadSheet control"),MB_OK Or MB_ICONERROR)
EndIf


''
'' Program has ended
''
ExitProcess(0)
End

'''
''' Program end
'''
