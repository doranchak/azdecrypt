
Sub InsertColumn( ByVal _hLvw As HWND, ByVal _iorder As Integer, ByVal _cx As Integer, ByRef _text As String )

	Dim As ZString * 260 buff
	Dim As LVCOLUMN lvc

	lvc.mask = LVCF_FMT Or LVCF_TEXT Or LVCF_SUBITEM Or LVCF_WIDTH
	lvc.fmt = LVCFMT_LEFT
	lvc.pszText = @buff
	lvc.iOrder = _iorder
	lvc.cx = _cx
	buff = _text
	SendMessage( _hLvw, LVM_INSERTCOLUMN, _iorder, Cast( LPARAM, @lvc ) )

End sub

Function DumpLine( ByVal Address As Integer, ByVal bAscii As Integer ) As String

	Dim As UByte ptr pbyte
	Dim As Integer i, tmpbyte
	Dim As ZString * 80 buff

	buff=""
	pbyte=Cast( UByte ptr, Address )

	If bAscii=0 Then
		For i=0 To 15
			buff += Hex ( pbyte[i], 2 ) + " "
		Next
	Else
		For i = 0 To 15
			tmpbyte = pbyte[i]
			buff += Chr ( IIf ( ( tmpbyte>31 And tmpbyte<128 ), tmpbyte, 46 ) )
		Next
		'
		'buff[11] = 45
		'buff[23] = 45
		'buff[35] = 45
		'
	EndIf

	Function = buff

End Function

Sub myTimer()

	ShowWindow(hTabs(TAB_7),SW_HIDE)
	bTabSelect=TRUE
	KillTimer(hTabs(TAB_7),100)
	
End Sub

#Define POPUP_STYLES   (WS_POPUP Or WS_CLIPCHILDREN Or WS_CLIPSIBLINGS Or WS_SYSMENU Or WS_CAPTION Or WS_THICKFRAME)
#define POPUP_EXSTYLES (WS_EX_TOOLWINDOW Or WS_EX_WINDOWEDGE)
#define CHILD_STYLES   (WS_CHILD Or WS_CLIPCHILDREN Or WS_CLIPSIBLINGS)
#define CHILD_EXSTYLES (0)

Sub Set_Dock(ByVal hDlg As HWND, ByVal bDock As Integer)

	Dim As RECT rc
	Dim As Long dwStyle   = GetWindowLong(hDlg, GWL_STYLE)
	Dim As Long dwExStyle = GetWindowLong(hDlg, GWL_EXSTYLE)

	ShowWindow(hDlg,SW_HIDE)
	If bDock = FALSE Then
		SetWindowLong(hDlg, GWL_STYLE,   (dwStyle   And Not CHILD_STYLES)   Or  POPUP_STYLES)
		SetWindowLong(hDlg, GWL_EXSTYLE, (dwExStyle And Not CHILD_EXSTYLES) Or  POPUP_EXSTYLES)
		SetParent(hDlg, NULL)
		MoveWindow(hDlg,dock1.nPos.left,dock1.nPos.top,dock1.nPos.right,dock1.nPos.bottom,TRUE)
	Else
		GetWindowRect(hDlg, @rc)
		dock1.nPos.left = rc.left
		dock1.nPos.top = rc.top
		dock1.nPos.right = rc.right - rc.left
		dock1.nPos.bottom = rc.bottom - rc.top
		SetWindowLong(hDlg, GWL_STYLE,   (dwStyle   And Not POPUP_STYLES)   Or CHILD_STYLES)
		SetWindowLong(hDlg, GWL_EXSTYLE, (dwExStyle And Not POPUP_EXSTYLES) Or CHILD_EXSTYLES)
		SetParent(hDlg, lpHandles->hwnd)
	EndIf
	SetWindowPos(hDlg, 0, 0, 0, 0, 0, _
		SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_FRAMECHANGED)
	SendMessage(lpHandles->hwnd,WM_SIZE,0,0)
	ShowWindow(hDlg,SW_SHOW)

End Sub

Function GetString( ByVal id As Integer, ByRef txt As String ) As String

	Dim As String buff

	buff = lpFunctions->FindString(lpData->hLangMem,"ShowVars",Str(id))
	If Len(buff) = 0 Then
		Return txt
	Else
		Return buff
	EndIf

End Function

Sub GetFileNamePart( ByVal lpsrc As ZString Ptr, ByVal lpdst As ZString Ptr )

	Dim As UByte Ptr p
	Dim As Integer i
	
	p=lpsrc
	i=Len(*lpsrc)
	
	While i<>-1
		If *(p+i)=Asc("/") Or *(p+i)=Asc("\") Then Exit While
		i-=1
	Wend
	*lpdst=*(lpsrc+i+1)
	
End Sub

Sub ChangeSeparator( ByVal txt As ZString Ptr )

	Dim As UByte Ptr p
	
	p=txt
	
	While *p
		If *p=Asc("/") Then *p=Asc("\")
		p+=1
	Wend
	
End Sub

Sub GetViewSizes( ByVal v As VIEWS Ptr )
	
	Dim As RECT rc
	
	GetClientRect(lpHandles->htoolbar,@rc)
	v->nToolbar=rc.bottom+3
	GetClientRect(lpHandles->htabtool,@rc)
	v->nTabselect=rc.bottom+4
	GetClientRect(lpHandles->hsbr,@rc)
	v->nStatusbar=rc.bottom
	
End Sub
