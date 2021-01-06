
Function DlgProc( ByVal hDlg As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As Integer

	Dim As Long wmid, wmevent, i, zz, MatchLb, wt, twt
	Dim As ZString * 32 buff
	Dim As NMHDR ptr lpNMHDR
	Dim As MYDEBUGINF ptr lpDBGINF
	Dim As MYDEBUGMEM ptr lpDBGMEM
	Dim As COPYDATASTRUCT ptr lpCDS
	Dim As LVITEM lvi
	Dim As RECT rc1, rc2

	Select Case uMsg
		Case WM_INITDIALOG
			SetWindowPos( hDlg, NULL, dock1.nPos.left, dock1.nPos.top, dock1.nPos.right, dock1.nPos.bottom, SWP_NOZORDER )
			hTabs(TAB_0)=CreateDialogParam(hInstance, Cast(ZString ptr, IDD_TAB00), hDlg, @TabProc, NULL )
			hTabs(TAB_1)=CreateDialogParam(hInstance, Cast(ZString ptr, IDD_TAB01), hDlg, @TabProc, NULL )
			hTabs(TAB_2)=CreateDialogParam(hInstance, Cast(ZString ptr, IDD_TAB02), hDlg, @TabProc, NULL )
			hTabs(TAB_3)=CreateDialogParam(hInstance, Cast(ZString ptr, IDD_TAB03), hDlg, @TabProc, NULL )
			hTabs(TAB_4)=CreateDialogParam(hInstance, Cast(ZString ptr, IDD_TAB04), hDlg, @TabProc, NULL )
			hTabs(TAB_5)=CreateDialogParam(hInstance, Cast(ZString ptr, IDD_TAB05), hDlg, @TabProc, NULL )
			hTabs(TAB_6)=CreateDialogParam(hInstance, Cast(ZString ptr, IDD_TAB06), hDlg, @TabProc, NULL )
			hTabs(TAB_7)=CreateDialogParam(hInstance, Cast(ZString ptr, IDD_TAB07), hDlg, @SelProc, NULL )
			'tab output
			SetParent(lpHandles->hout,hTabs(TAB_0))
			SetWindowPos(lpHandles->hout,0,dock1.nPos.left,dock1.nPos.top,dock1.nPos.right,dock1.nPos.bottom,SWP_SHOWWINDOW)
			SetParent(lpHandles->himm,hTabs(TAB_0))
			'tab var
			hList(LSV_1)=GetDlgItem(hTabs(TAB_1),IDC_LSV01)
			InsertColumn( hList(LSV_1), 0,   0, GetString( 9000, "Line" ) )
			InsertColumn( hList(LSV_1), 1,   0, GetString( 9001, "Function" ) )
			InsertColumn( hList(LSV_1), 2,   0, GetString( 9002, "Path" ) )
			InsertColumn( hList(LSV_1), 3,   0, GetString( 9003, "File" ) )
			InsertColumn( hList(LSV_1), 4, 180, GetString( 1100, "Name" ) )
			InsertColumn( hList(LSV_1), 5, 100, GetString( 1101, "Signed" ) )
			InsertColumn( hList(LSV_1), 6, 100, GetString( 1102, "Unsigned" ) )
			InsertColumn( hList(LSV_1), 7, 100, GetString( 1103, "Hex" ) )
			InsertColumn( hList(LSV_1), 8,  90, GetString( 1104, "Char" ) )
			InsertColumn( hList(LSV_1), 9, 250, GetString( 1105, "Bin" ) )
			wmId = SendMessage( hList(LSV_1), LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0 )
			SendMessage( hList(LSV_1), LVM_SETEXTENDEDLISTVIEWSTYLE, 0, wmId Or LVS_EX_FULLROWSELECT )
			'tab float
			hList(LSV_2)=GetDlgItem(hTabs(TAB_2),IDC_LSV02)
			InsertColumn( hList(LSV_2), 0,   0, GetString( 9000, "Line" ) )
			InsertColumn( hList(LSV_2), 1,   0, GetString( 9001, "Function" ) )
			InsertColumn( hList(LSV_2), 2,   0, GetString( 9002, "Path" ) )
			InsertColumn( hList(LSV_2), 3,   0, GetString( 9003, "File" ) )
			InsertColumn( hList(LSV_2), 4, 180, GetString( 1200, "Name" ) )
			InsertColumn( hList(LSV_2), 5, 600, GetString( 1201, "Result" ) )
			wmId = SendMessage( hList(LSV_2), LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0 )
			SendMessage( hList(LSV_2), LVM_SETEXTENDEDLISTVIEWSTYLE, 0, wmId Or LVS_EX_FULLROWSELECT )
			'tab string
			hList(LSV_3)=GetDlgItem(hTabs(TAB_3),IDC_LSV03)
			InsertColumn( hList(LSV_3), 0,   0, GetString( 9000, "Line" ) )
			InsertColumn( hList(LSV_3), 1,   0, GetString( 9001, "Function" ) )
			InsertColumn( hList(LSV_3), 2,   0, GetString( 9002, "Path" ) )
			InsertColumn( hList(LSV_3), 3,   0, GetString( 9003, "File" ) )
			InsertColumn( hList(LSV_3), 4, 180, GetString( 1300, "Name" ) )
			InsertColumn( hList(LSV_3), 5,  80, GetString( 1301, "Len" ) )
			InsertColumn( hList(LSV_3), 6, 560, GetString( 1302, "Content" ) )
			wmId = SendMessage( hList(LSV_3), LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0 )
			SendMessage( hList(LSV_3), LVM_SETEXTENDEDLISTVIEWSTYLE, 0, wmId Or LVS_EX_FULLROWSELECT )
			'tab memory
			hList(LSV_4)=GetDlgItem(hTabs(TAB_4),IDC_LSV04)
			InsertColumn( hList(LSV_4), 0,   0, GetString( 9000, "Line" ) )
			InsertColumn( hList(LSV_4), 1,   0, GetString( 9001, "Function" ) )
			InsertColumn( hList(LSV_4), 2,   0, GetString( 9002, "Path" ) )
			InsertColumn( hList(LSV_4), 3,   0, GetString( 9003, "File" ) )
			InsertColumn( hList(LSV_4), 4, 180, GetString( 1400, "Name" ) )
			InsertColumn( hList(LSV_4), 5, 100, GetString( 1401, "Address" ) )
			InsertColumn( hList(LSV_4), 6, 370, GetString( 1402, "Dump" ) )
			InsertColumn( hList(LSV_4), 7, 130, GetString( 1403, "Ascii" ) )
			wmId = SendMessage( hList(LSV_4), LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0 )
			SendMessage( hList(LSV_4), LVM_SETEXTENDEDLISTVIEWSTYLE, 0, wmId Or LVS_EX_FULLROWSELECT )
			'tab disassembler
			hList(LSV_5)=GetDlgItem(hTabs(TAB_5),IDC_LSV05)
			InsertColumn( hList(LSV_5), 0,   0, GetString( 9000, "Line" ) )
			InsertColumn( hList(LSV_5), 1,   0, GetString( 9001, "Function" ) )
			InsertColumn( hList(LSV_5), 2,   0, GetString( 9002, "Path" ) )
			InsertColumn( hList(LSV_5), 3,   0, GetString( 9003, "File" ) )
			InsertColumn( hList(LSV_5), 4, 180, GetString( 1500, "Name" ) )
			InsertColumn( hList(LSV_5), 5, 100, GetString( 1501, "Address" ) )
			InsertColumn( hList(LSV_5), 6, 200, GetString( 1502, "Hex" ) )
			InsertColumn( hList(LSV_5), 7, 300, GetString( 1503, "Assembler" ) )
			wmId = SendMessage( hList(LSV_5), LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0 )
			SendMessage( hList(LSV_5), LVM_SETEXTENDEDLISTVIEWSTYLE, 0, wmId Or LVS_EX_FULLROWSELECT )
			'tab logs
			hList(LSV_6)=GetDlgItem(hTabs(TAB_6),IDC_LSV06)
			InsertColumn( hList(LSV_6), 0,   0, GetString( 9000, "Line" ) )
			InsertColumn( hList(LSV_6), 1,   0, GetString( 9001, "Function" ) )
			InsertColumn( hList(LSV_6), 2,   0, GetString( 9002, "Path" ) )
			InsertColumn( hList(LSV_6), 3,   0, GetString( 9003, "File" ) )
			InsertColumn( hList(LSV_6), 4, 210, GetString( 1600, "Time" ) )
			InsertColumn( hList(LSV_6), 5,  90, GetString( 1601, "Ticks" ) )
'			InsertColumn( hList(LSV_6), 6,  90, "Last" )
'			InsertColumn( hList(LSV_6), 7, 370, "Show" )
			InsertColumn( hList(LSV_6), 6, 480, GetString( 1602, "Show" ) )
			wmId = SendMessage( hList(LSV_6), LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0 )
			SendMessage( hList(LSV_6), LVM_SETEXTENDEDLISTVIEWSTYLE, 0, wmId Or LVS_EX_FULLROWSELECT )
			'select initial tab
			SendMessage(hDlg,DBG_SELECT,dock1.nActualTab+IDC_RBN00,0)
			Set_Dock(hDlg,dock1.fDocked)
			If lpData->lpWINPOS->fview And VIEW_OUTPUT Then
				ShowWindow(hDlg,SW_SHOW)
			Else
				ShowWindow(hDlg,SW_HIDE)
			EndIf
			Return FALSE
			'
		Case WM_COPYDATA
			lpCDS = Cast( COPYDATASTRUCT ptr, lParam )
			SendMessage( hDlg, lpCDS->dwData, wParam, Cast( LPARAM, lpCDS->lpData ) )
			'
		Case WM_CLOSE
			lpFunctions->ShowOutput(FALSE)
			'
		Case WM_NCLBUTTONDBLCLK
			dock1.fDocked Xor= 1
			Set_Dock(hDlg,dock1.fDocked)
			'
		Case WM_SIZE
			If dock1.fDocked = FALSE Then
				GetWindowRect(hDlg,@rc1)
				dock1.nPos.left = rc1.left
				dock1.nPos.top = rc1.top
				dock1.nPos.right = rc1.right-rc1.left
				dock1.nPos.bottom = rc1.bottom-rc1.top
				If dock1.nPos.right<360 Then dock1.nPos.right=360
				If dock1.nPos.bottom<140 Then	dock1.nPos.bottom=140
				If dock1.nPos.bottom>630 Then dock1.nPos.bottom=630
				MoveWindow(hDlg,dock1.nPos.left,dock1.nPos.top,dock1.nPos.right,dock1.nPos.bottom,TRUE)
				GetClientRect(hDlg,@rc2)
				MoveWindow(hTabs(TAB_0),0,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hTabs(TAB_1),0,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hTabs(TAB_2),0,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hTabs(TAB_3),0,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hTabs(TAB_4),0,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hTabs(TAB_5),0,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hTabs(TAB_6),0,0,rc2.right,rc2.bottom,TRUE)
				rc2.right-=13
				rc2.bottom+=2
				MoveWindow(hList(LSV_1),15,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hList(LSV_2),15,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hList(LSV_3),15,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hList(LSV_4),15,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hList(LSV_5),15,0,rc2.right,rc2.bottom,TRUE)
				MoveWindow(hList(LSV_6),15,0,rc2.right,rc2.bottom,TRUE)
				rc2.right+=1
				rc2.bottom+=2
				MoveWindow(lpHandles->hout,15,-1,rc2.right,rc2.bottom,TRUE)
			Else
				GetclientRect(lpHandles->hwnd,@rc1)
				twt=lpData->lpWINPOS->wtpro
				If (lpData->lpWINPOS->fview And (VIEW_PROJECT Or VIEW_PROPERTY))=0 Then
					twt=0
				EndIf
				wt=rc1.right-twt
				MoveWindow(hTabs(TAB_0),0,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hTabs(TAB_1),0,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hTabs(TAB_2),0,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hTabs(TAB_3),0,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hTabs(TAB_4),0,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hTabs(TAB_5),0,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hTabs(TAB_6),0,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				wt-=13
				MoveWindow(hList(LSV_1),15,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hList(LSV_2),15,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hList(LSV_3),15,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hList(LSV_4),15,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hList(LSV_5),15,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				MoveWindow(hList(LSV_6),15,0,wt,lpData->lpWINPOS->htout-3,TRUE)
				wt+=1
				Select Case lpData->lpWINPOS->fview And (VIEW_OUTPUT Or VIEW_IMMEDIATE)
					Case VIEW_OUTPUT
						MoveWindow(lpHandles->hout,15,-1,wt,lpData->lpWINPOS->htout-3,TRUE)
						ShowWindow(lpHandles->hout,SW_SHOWNA)
						ShowWindow(lpHandles->himm,SW_HIDE)
					Case VIEW_IMMEDIATE
						MoveWindow(lpHandles->himm,15,-1,wt,lpData->lpWINPOS->htout-3,TRUE)
						ShowWindow(lpHandles->himm,SW_SHOWNA)
						ShowWindow(lpHandles->hout,SW_HIDE)
					Case VIEW_OUTPUT Or VIEW_IMMEDIATE
						MoveWindow(lpHandles->hout,15,-1,wt\2,lpData->lpWINPOS->htout-3,TRUE)
						MoveWindow(lpHandles->himm,15+wt\2,-1,wt-wt\2,lpData->lpWINPOS->htout-3,TRUE)
						ShowWindow(lpHandles->hout,SW_SHOWNA)
						ShowWindow(lpHandles->himm,SW_SHOWNA)
				End Select
			EndIf
			'
		Case DBG_VAR
			wmId = wParam
			lpDBGINF = Cast( MYDEBUGINF ptr, lParam )
			lvi.pszText = @buff
			lvi.iSubItem = 4
			lvi.cchTextMax = SizeOf( buff )
			'
			For i = 0 To nItems( wmId ) - 1
				SendMessage( hList( wmId ), LVM_GETITEMTEXT, i, Cast( LPARAM, @lvi ) )
				If buff = lpDBGINF->dLabel Then
					lpDBGINF->iUpd = i
					Select Case wmId
						Case TYP_INTEGER
							dbgInt( lpDBGINF, 1 )
						Case TYP_DOUBLE
							dbgFlt( lpDBGINF, 1 )
						Case TYP_STRING
							dbgStr( lpDBGINF, 1 )
					End Select
					MatchLb = 1
					Exit For
				EndIf
			Next
			'
			If matchlb = 0 Then
				Select Case wmId
					Case TYP_INTEGER
						dbgInt( lpDBGINF, 0 )
					Case TYP_DOUBLE
						dbgFlt( lpDBGINF, 0 )
					Case TYP_STRING
						dbgStr( lpDBGINF, 0 )
				End Select
			EndIf
			'
		Case DBG_LOG
			If nItems( LSV_6 ) < 5000 Then
				Select Case wParam
					Case TYP_INTEGER
						logInt( Cast( MYDEBUGINF ptr, lParam ) )
					Case TYP_DOUBLE
						logFlt( Cast( MYDEBUGINF ptr, lParam )  )
					Case TYP_STRING
						logStr( Cast( MYDEBUGINF ptr, lParam )  )
				End Select
			Else
				If MessageBox( hDlg, GetString( 3000, "Clear?" ), GetString( 3001, "Too much register" ), MB_YESNO ) = IDYES Then SendMessage( hDlg, DBG_CLEAR, CLR_6, 0 )
			EndIf
			'
		Case DBG_MEM
			wmId = IIf( wParam > 512, 512, wParam )
			lpDBGMEM = Cast( MYDEBUGMEM ptr, lParam )
			lvi.pszText = @buff
			lvi.iSubItem = 4
			lvi.cchTextMax = SizeOf( buff )
			'
			For i = 0 To nItems( LSV_4 ) - 1
				SendMessage( hList( LSV_4 ), LVM_GETITEMTEXT, i, Cast( LPARAM, @lvi ) )
				If buff = lpDBGMEM->dLabel Then
					SendMessage( hList( LSV_4 ), WM_SETREDRAW, FALSE, 0 )
					For zz = 0 To wmId - 1
						lpDBGMEM->iUpd = zz
						dbgMem( lpDBGMEM, zz * 16, 1 )
						lpDBGMEM->dAddress += 16
					Next
					SendMessage( hList( LSV_4 ), WM_SETREDRAW, TRUE, 0 )
					UpdateWindow( hList( LSV_4 ) )
					MatchLb = 1
					Exit For
				EndIf
			Next
			'
			If matchlb = 0 Then
				SendMessage( hList( LSV_4 ), WM_SETREDRAW, FALSE, 0 )
				For zz = 0 To wmId - 1
					lpDBGMEM->iUpd = zz
					dbgMem( lpDBGMEM, zz * 16, 0 )
					lpDBGMEM->dAddress += 16
				Next
				SendMessage( hList( LSV_4 ), WM_SETREDRAW, TRUE, 0 )
				UpdateWindow( hList( LSV_4 ) )
			EndIf
			'
		Case DBG_DIS
			wmId = IIf( wParam > 8192, 8192, wParam )
			lpDBGMEM = Cast( MYDEBUGMEM ptr, lParam )
			SendMessage( hList( LSV_5 ), WM_SETREDRAW, FALSE, 0 )
			dbgAsm( lpDBGMEM, wmId, 0 )
			SendMessage( hList( LSV_5 ), WM_SETREDRAW, TRUE, 0 )
			UpdateWindow( hList( LSV_5 ) )
			'
		Case DBG_STATE
			lpFunctions->ShowOutput(wParam)
			'
		Case DBG_CLEAR
			wmId = wParam
			If (wmId And CLR_0) = CLR_0 Then
				SendMessage(lpHandles->hout,WM_SETTEXT,0,Cast(Integer,StrPtr("")))
			End If
			If (wmId And CLR_1) = CLR_1 Then
				nItems( LSV_1 ) = 0
				SendMessage( hList( LSV_1 ), LVM_DELETEALLITEMS, 0, 0 )
			End If
			If (wmId And CLR_2) = CLR_2 Then
				nItems( LSV_2 ) = 0
				SendMessage( hList( LSV_2 ), LVM_DELETEALLITEMS, 0, 0 )
			End If
			If (wmId And CLR_3) = CLR_3 Then
				nItems( LSV_3 ) = 0
				SendMessage( hList( LSV_3 ), LVM_DELETEALLITEMS, 0, 0 )
			End If
			If (wmId And CLR_4) = CLR_4 Then
				nItems( LSV_4 ) = 0
				SendMessage( hList( LSV_4 ), LVM_DELETEALLITEMS, 0, 0 )
			End If
			If (wmId And CLR_5) = CLR_5 Then
				nItems( LSV_5 ) = 0
				SendMessage( hList( LSV_5 ), LVM_DELETEALLITEMS, 0, 0 )
			End If
			If (wmId And CLR_6) = CLR_6 Then
				nItems( LSV_6 ) = 0
				SendMessage( hList( LSV_6 ), LVM_DELETEALLITEMS, 0, 0 )
			End If
			'
		Case DBG_SELECT
			SendMessage( hTabs( TAB_7 ), WM_COMMAND,((BN_CLICKED Shl 16) Or wParam), 0 )
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function

Function SelProc( ByVal hDlg As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As Integer

	Select Case uMsg
		Case WM_COMMAND
			Select Case HiWord(wParam)
				Case BN_CLICKED
				Select Case LoWord(wParam)
					Case IDC_RBN00,IDC_RBN01,IDC_RBN02,IDC_RBN03,IDC_RBN04,IDC_RBN05,IDC_RBN06
						dock1.nLastTab = dock1.nActualTab
						dock1.nActualTab = LoWord(wParam)-IDC_RBN00
						ShowWindow(hTabs(dock1.nLastTab),SW_HIDE)
						SendMessage(GetDlgItem(hDlg,dock1.nLastTab+IDC_RBN00),BM_SETCHECK,BST_UNCHECKED,0)
						ShowWindow(hTabs(dock1.nActualTab),SW_SHOW)
						SendMessage(GetDlgItem(hDlg,dock1.nActualTab+IDC_RBN00),BM_SETCHECK,BST_CHECKED,0)
						ShowWindow(hDlg,SW_HIDE)
						bTabSelect=TRUE
				End Select
			End Select
			'
		Case Else
			Return FALSE
	End Select
	Return TRUE

End function

Function TabProc( ByVal hDlg As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As Integer

	Dim As Integer nLine
	Dim As NMLISTVIEW ptr lvnm
	Dim As LVITEM lvi
	Dim As CHARRANGE chrg
	Dim As POINT pt
	Dim As ZString * 260 buff, txt

	Select Case uMsg
		Case WM_MOUSEMOVE
			If bTabSelect=FALSE Then
				If LoWord(lParam)<11 Then
					SetWindowPos(hTabs(TAB_7),HWND_TOP,0,0,0,0,SWP_NOMOVE Or SWP_NOSIZE Or SWP_SHOWWINDOW)
					SetTimer(hTabs(TAB_7),100,dock1.tDelay,Cast(Any ptr,@myTimer))
				Else
					ShowWindow(hTabs(TAB_7),SW_HIDE)
				End If
			Else
				If LoWord(lParam)>10 Then bTabSelect=FALSE
			EndIf
			'
'		Case WM_LBUTTONDBLCLK
'			dock1.fDocked Xor= 1
'			Set_Dock(hDbgWin,dock1.fDocked)
'			'
		Case WM_NOTIFY
			lvnm = Cast( NMLISTVIEW ptr, lParam )
			lvi.pszText = @buff
			lvi.cchTextMax = SizeOf( buff )
			Select Case lvnm->hdr.idFrom
				Case IDC_LSV01,IDC_LSV02,IDC_LSV03,IDC_LSV04,IDC_LSV05,IDC_LSV06
					If lvnm->hdr.code = NM_RCLICK Then
						GetCursorPos(@pt)
						TrackPopupMenu(hMenu,TPM_LEFTALIGN Or TPM_RIGHTBUTTON,pt.x,pt.y,0,lpHandles->hwnd,0)
					ElseIf lvnm->hdr.code = NM_CLICK Then
						lvi.iSubItem = 0
						SendMessage( lvnm->hdr.hwndFrom, LVM_GETITEMTEXT, lvnm->iItem, Cast( LPARAM, @lvi ) )
						If Len( buff ) = 0 Then Return FALSE
						txt = GetString( 2000, " Line: " ) + buff
						lvi.iSubItem = 1
						SendMessage( lvnm->hdr.hwndFrom, LVM_GETITEMTEXT, lvnm->iItem, Cast( LPARAM, @lvi ) )
						txt += GetString( 2001, "     Function: " ) + buff
						lvi.iSubItem = 3
						SendMessage( lvnm->hdr.hwndFrom, LVM_GETITEMTEXT, lvnm->iItem, Cast( LPARAM, @lvi ) )
						txt += GetString( 2002, "     File: " ) + buff
						SendMessage( lpHandles->hsbr,SB_SETTEXT, 3, Cast( LPARAM, @txt ) )
					ElseIf lvnm->hdr.code = NM_DBLCLK Then
						lvi.iSubItem = 3
						SendMessage( lvnm->hdr.hwndFrom, LVM_GETITEMTEXT, lvnm->iItem, Cast( LPARAM, @lvi ) )
						If Len( buff ) = 0 Then Return FALSE
						GetFileNamePart(@buff,@txt)
						lvi.iSubItem = 2
						SendMessage( lvnm->hdr.hwndFrom, LVM_GETITEMTEXT, lvnm->iItem, Cast( LPARAM, @lvi ) )
						buff += "\" + txt
						ChangeSeparator(@buff)
						lpFunctions->OpenTheFile(buff,FALSE)
						lvi.iSubItem = 0
						SendMessage( lvnm->hdr.hwndFrom, LVM_GETITEMTEXT, lvnm->iItem, Cast( LPARAM, @lvi ) )
						nLine = Val( buff ) - 1
						If SendMessage(lpHandles->hred,EM_GETLINECOUNT,0,0)>nLine And nLine>=0 Then
							' Setup CHARRANGE and set selection
							chrg.cpMin=SendMessage(lpHandles->hred,EM_LINEINDEX,nLine,0)
							chrg.cpMax=chrg.cpMin
							SendMessage(lpHandles->hred,EM_EXSETSEL,0,Cast(Integer,@chrg))
							' Scroll the caret into view
							SendMessage(lpHandles->hred,EM_SCROLLCARET,0,0)
						Else
							' Line number too big
							MessageBeep(MB_ICONASTERISK)
						EndIf
					EndIf
			End Select
			'
		Case Else
			Return FALSE
	End Select
	Return TRUE

End Function

Function FBEProc( ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM ) As Integer

	Dim As Long twt, hgt
	Dim As RECT rc1, rc2, rc3

   Select Case uMsg
		Case WM_SIZE
			If lpHandles->hfullscreen=0 Then
				' Size the FbEdit control to fill the dialogs client area
				twt=lpData->lpWINPOS->wtpro
				If (lpData->lpWINPOS->fview And (VIEW_PROJECT Or VIEW_PROPERTY))=0 Then
					twt=0
				EndIf
				hgt=6
				hgt+=IIf(lpData->lpWINPOS->fview And VIEW_TOOLBAR,nSize.nToolbar,0)
				hgt+=IIf(lpData->lpWINPOS->fview And VIEW_TABSELECT,nSize.nTabselect,0)
				CallWindowProc(lpOldMain,hWin,uMsg,wParam,lParam)
				' Size the Output
				If lpData->lpWINPOS->fview And (VIEW_OUTPUT Or VIEW_IMMEDIATE) Then
					GetWindowRect(lpHandles->hshp,@rc3)
					ScreenToClient(hWin,Cast(Point Ptr,@rc3.right))
					If dock1.fDocked = TRUE Then
						GetClientRect(hWin,@rc2)
						GetWindowRect(lpHandles->hout,@rc1)
						If GetParent(lpHandles->hout)=lpHandles->hwnd Then
							ScreenToClient(lpHandles->hwnd,Cast(POINT Ptr,@rc1))
						Else
							ScreenToClient(hDbgWin,Cast(POINT Ptr,@rc1))
						EndIf
						SetWindowPos(hDbgWin,HWND_TOP,0,rc3.bottom+3,rc2.right-twt,lpData->lpWINPOS->htout-4,SWP_SHOWWINDOW)
'						SetWindowPos(hDbgWin,HWND_TOP,0,rc1.bottom-rc2.bottom-lpData->lpWINPOS->htout+2,rc1.right-twt,lpData->lpWINPOS->htout-2,SWP_SHOWWINDOW)
					EndIf
					SendMessage(hDbgWin,WM_SIZE,0,0)
				Else
					ShowWindow(hDbgWin,SW_HIDE)
				EndIf
			EndIf
			Return FALSE
			'
   End Select
   Return CallWindowProc( lpOldMain, hWin, uMsg, wParam, lParam )

End Function
