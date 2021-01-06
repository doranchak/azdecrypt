
Sub dbgInt( ByVal lpDBGINF As MYDEBUGINF ptr, ByVal bUpd As Integer ) 'debug variables

	Dim As Integer i, tmpbyte, updpos, datav
	Dim As ZString * 260 buff
	Dim As UByte ptr pbyte
	Dim As LVITEM lvi

	datav = lpDBGINF->dInteger
	updpos = lpDBGINF->iUpd
	lvi.pszText = @buff
	lvi.iItem = nItems( LSV_1 )
	lvi.lParam = nItems( LSV_1 )
	lvi.iSubItem = 0
	buff = Str( lpDBGINF->_Line )
	If bUpd = 0 Then
		lvi.mask = LVIF_TEXT Or LVIF_PARAM Or LVIF_STATE
		SendMessage( hList( LSV_1 ), LVM_INSERTITEM, 0, Cast( LPARAM, @lvi ) )
		nItems( LSV_1 ) += 1
		lvi.mask = LVIF_TEXT
		lvi.iSubItem = 1
		buff = lpDBGINF->_Func
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGINF->_Path
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGINF->_File
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		buff = lpDBGINF->dLabel
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Str( datav )
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 6
		buff = Str( Cast ( UInteger, datav ) )
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 7
		buff = "&H" + Hex ( datav )
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 8
		buff = ""
		pbyte = Cast( UByte ptr, VarPtr( datav ) )
		'
		For i = 0 To 3
			tmpbyte = pbyte[i]
			buff += Chr ( IIf ( ( tmpbyte>31 And tmpbyte<128 ), tmpbyte, 46 ) )
		Next
		'
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 9
		buff = Bin( datav )
		SendMessage( hList( LSV_1 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	Else
		lvi.mask = LVIF_TEXT
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 1
		buff = lpDBGINF->_Func
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGINF->_Path
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGINF->_File
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		buff = lpDBGINF->dLabel
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Str( datav )
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 6
		buff = Str( Cast ( UInteger, datav ) )
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 7
		buff = "&H" + Hex ( datav )
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 8
		buff = ""
		pbyte = Cast( UByte ptr, VarPtr( datav ) )
		'
		For i = 0 To 3
			tmpbyte = pbyte[i]
			buff += Chr ( IIf ( ( tmpbyte>31 And tmpbyte<128 ), tmpbyte, 46 ) )
		Next
		'
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 9
		buff = Bin( datav )
		SendMessage( hList( LSV_1 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
	EndIf

End Sub

Sub dbgFlt( ByVal lpDBGINF As MYDEBUGINF ptr, ByVal bUpd As Integer ) 'debug floats

	Dim As Integer updpos
	Dim As ZString*260 buff
	Dim As LVITEM lvi

	updpos = lpDBGINF->iUpd
	lvi.pszText = @buff
	lvi.iItem = nItems( LSV_2 )
	lvi.lParam = nItems( LSV_2 )
	lvi.iSubItem = 0
	buff = Str( lpDBGINF->_Line )
	If bUpd = 0 Then
		lvi.mask = LVIF_TEXT Or LVIF_PARAM Or LVIF_STATE
		SendMessage( hList( LSV_2 ), LVM_INSERTITEM, 0, Cast( LPARAM, @lvi ) )
		nItems( LSV_2 ) += 1
		lvi.mask = LVIF_TEXT
		lvi.iSubItem = 1
		buff = lpDBGINF->_Func
		SendMessage( hList( LSV_2 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGINF->_Path
		SendMessage( hList( LSV_2 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGINF->_File
		SendMessage( hList( LSV_2 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		buff = lpDBGINF->dLabel
		SendMessage( hList( LSV_2 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Str( lpDBGINF->dFloat )
		SendMessage( hList( LSV_2 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	Else
		lvi.mask = LVIF_TEXT
		SendMessage( hList( LSV_2 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 1
		buff = lpDBGINF->_Func
		SendMessage( hList( LSV_2 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGINF->_Path
		SendMessage( hList( LSV_2 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGINF->_File
		SendMessage( hList( LSV_2 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		buff = lpDBGINF->dLabel
		SendMessage( hList( LSV_2 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Str( lpDBGINF->dFloat )
		SendMessage( hList( LSV_2 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
	EndIf

End Sub

Sub dbgStr( ByVal lpDBGINF As MYDEBUGINF ptr, ByVal bUpd As Integer ) 'debug string

	Dim As Integer updpos
	Dim As ZString*260 buff
	Dim As LVITEM lvi

	updpos = lpDBGINF->iUpd
	lvi.pszText = @buff
	lvi.iItem = nItems( LSV_3 )
	lvi.lParam = nItems( LSV_3 )
	lvi.iSubItem = 0
	buff = Str( lpDBGINF->_Line )
	If bUpd = 0 Then
		lvi.mask = LVIF_TEXT Or LVIF_PARAM Or LVIF_STATE
		SendMessage( hList( LSV_3 ), LVM_INSERTITEM, 0, Cast( LPARAM, @lvi ) )
		nItems( LSV_3 ) += 1
		lvi.mask = LVIF_TEXT
		lvi.iSubItem = 1
		buff = lpDBGINF->_Func
		SendMessage( hList( LSV_3 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGINF->_Path
		SendMessage( hList( LSV_3 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGINF->_File
		SendMessage( hList( LSV_3 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		buff = lpDBGINF->dLabel
		SendMessage( hList( LSV_3 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Str( Len( lpDBGINF->dString ) )
		SendMessage( hList( LSV_3 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 6
		buff = lpDBGINF->dString
		SendMessage( hList( LSV_3 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	Else
		lvi.mask = LVIF_TEXT
		SendMessage( hList( LSV_3 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 1
		buff = lpDBGINF->_Func
		SendMessage( hList( LSV_3 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGINF->_Path
		SendMessage( hList( LSV_3 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGINF->_File
		SendMessage( hList( LSV_3 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		buff = lpDBGINF->dLabel
		SendMessage( hList( LSV_3 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Str( Len( lpDBGINF->dString ) )
		SendMessage( hList( LSV_3 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 6
		buff = lpDBGINF->dString
		SendMessage( hList( LSV_3 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
	EndIf

End Sub

Sub logInt( ByVal lpDBGINF As MYDEBUGINF ptr ) 'log ( varibles )

	Dim As ZString*260 buff
	Dim As LVITEM lvi
	Dim As SYSTEMTIME st

	GetLocalTime( @st )
	lvi.pszText = @buff
	lvi.iItem = nItems( LSV_6 )
	lvi.lParam = nItems( LSV_6 )
	lvi.mask = LVIF_TEXT Or LVIF_PARAM Or LVIF_STATE
	lvi.iSubItem = 0
	buff = Str( lpDBGINF->_Line )
	SendMessage( hList( LSV_6 ), LVM_INSERTITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.mask = LVIF_TEXT
	lvi.iSubItem = 1
	buff = lpDBGINF->_Func
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 2
	buff = lpDBGINF->_Path
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 3
	buff = lpDBGINF->_File
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 4
	wsprintf( @buff, "%04d-%02d-%02d %02d:%02d:%02d ( %04d )", st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond, st.wMilliseconds )
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 5
	buff = Str( GetTickCount( ) )
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 6
	buff = Str( lpDBGINF->dInteger )
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	nItems( LSV_6 ) += 1

End Sub

Sub logFlt( ByVal lpDBGINF As MYDEBUGINF ptr ) 'log ( floats )

	Dim As ZString*260 buff
	Dim As LVITEM lvi
	Dim As SYSTEMTIME st

	GetLocalTime( @st )
	lvi.pszText = @buff
	lvi.iItem = nItems( LSV_6 )
	lvi.lParam = nItems( LSV_6 )
	lvi.mask = LVIF_TEXT Or LVIF_PARAM Or LVIF_STATE
	lvi.iSubItem = 0
	buff = Str( lpDBGINF->_Line )
	SendMessage( hList( LSV_6 ), LVM_INSERTITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.mask = LVIF_TEXT
	lvi.iSubItem = 1
	buff = lpDBGINF->_Func
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 2
	buff = lpDBGINF->_Path
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 3
	buff = lpDBGINF->_File
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 4
	wsprintf( @buff, "%04d-%02d-%02d %02d:%02d:%02d ( %04d )", st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond, st.wMilliseconds )
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 5
	buff = Str( GetTickCount( ) )
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 6
	buff = Str( lpDBGINF->dFloat )
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	nItems( LSV_6 ) += 1

End Sub

Sub logStr( ByVal lpDBGINF As MYDEBUGINF ptr ) 'log ( strings )

	Dim As ZString*260 buff
	Dim As LVITEM lvi
	Dim As SYSTEMTIME st

	GetLocalTime( @st )
	lvi.pszText = @buff
	lvi.iItem = nItems( LSV_6 )
	lvi.lParam = nItems( LSV_6 )
	lvi.mask = LVIF_TEXT Or LVIF_PARAM Or LVIF_STATE
	lvi.iSubItem = 0
	buff = Str( lpDBGINF->_Line )
	SendMessage( hList( LSV_6 ), LVM_INSERTITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.mask = LVIF_TEXT
	lvi.iSubItem = 1
	buff = lpDBGINF->_Func
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 2
	buff = lpDBGINF->_Path
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 3
	buff = lpDBGINF->_File
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 4
	wsprintf( @buff, "%04d-%02d-%02d %02d:%02d:%02d ( %04d )", st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond, st.wMilliseconds )
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 5
	buff = Str( GetTickCount( ) )
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	lvi.iSubItem = 6
	buff = lpDBGINF->dString
	SendMessage( hList( LSV_6 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	nItems( LSV_6 ) += 1

End Sub

Sub dbgMem( ByVal lpDBGMEM As MYDEBUGMEM ptr, ByVal iPos As Integer, ByVal bUpd As Integer ) 'dump

	Dim As Integer i, updpos, datav
	Dim As ZString*260 buff
	Dim As UByte ptr pbyte
	Dim As LVITEM lvi

	updpos = lpDBGMEM->iUpd
	datav = Cast( Integer, @lpDBGMEM->iData( iPos ) )
	lvi.pszText = @buff
	lvi.iItem = nItems( LSV_4 )
	lvi.lParam = nItems( LSV_4 )
	lvi.iSubItem = 0
	buff = Str( lpDBGMEM->_Line )
	If bUpd = 0 Then
		lvi.mask = LVIF_TEXT Or LVIF_PARAM Or LVIF_STATE
		SendMessage( hList( LSV_4 ), LVM_INSERTITEM, 0, Cast( LPARAM, @lvi ) )
		nItems( LSV_4 ) += 1
		lvi.mask = LVIF_TEXT
		lvi.iSubItem = 1
		buff = lpDBGMEM->_Func
		SendMessage( hList( LSV_4 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGMEM->_Path
		SendMessage( hList( LSV_4 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGMEM->_File
		SendMessage( hList( LSV_4 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		If updpos = 0 Then
			buff = lpDBGMEM->dLabel
		Else
			buff = ""
		EndIf
		SendMessage( hList( LSV_4 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Hex( lpDBGMEM->dAddress, 8 )
		SendMessage( hList( LSV_4 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 6
		buff = DumpLine( datav, 0 )
		SendMessage( hList( LSV_4 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 7
		buff = DumpLine( datav, 1 )
		SendMessage( hList( LSV_4 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
	Else
		lvi.mask = LVIF_TEXT
		SendMessage( hList( LSV_4 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 1
		buff = lpDBGMEM->_Func
		SendMessage( hList( LSV_4 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGMEM->_Path
		SendMessage( hList( LSV_4 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGMEM->_File
		SendMessage( hList( LSV_4 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		If updpos = 0 Then
			buff = lpDBGMEM->dLabel
		Else
			buff = ""
		EndIf
		SendMessage( hList( LSV_4 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Hex( lpDBGMEM->dAddress, 8 )
		SendMessage( hList( LSV_4 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 6
		buff = DumpLine( datav, 0 )
		SendMessage( hList( LSV_4 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 7
		buff = DumpLine( datav, 1 )
		SendMessage( hList( LSV_4 ), LVM_SETITEMTEXT, updpos, Cast( LPARAM, @lvi ) )
	EndIf

End Sub

Sub dbgAsm( ByVal lpDBGMEM As MYDEBUGMEM ptr, ByVal iPos As Integer, ByVal bUpd As Integer ) 'Asm

	Dim As Integer nxt, idx, bOnlyone, disp
	Dim As ZString*260 buff
	Dim As LVITEM lvi
	Dim As _dis_data ddata

	lvi.pszText = @buff

	While iPos > 0
		nxt = _disasm( @lpDBGMEM->iData( idx ), @ddata )
		If nxt = 0 Then
			MessageBox( 0, GetString( 3002, "Internal error" ), "DisAsm", MB_OK )
			Exit While
		End If
		lvi.iItem = nItems( LSV_5 )
		lvi.lParam = nItems( LSV_5 )
		lvi.iSubItem = 0
		buff = Str( lpDBGMEM->_Line )
		lvi.mask = LVIF_TEXT Or LVIF_PARAM Or LVIF_STATE
		SendMessage( hList( LSV_5 ), LVM_INSERTITEM, 0, Cast( LPARAM, @lvi ) )
		nItems( LSV_5 ) += 1
		lvi.mask = LVIF_TEXT
		lvi.iSubItem = 1
		buff = lpDBGMEM->_Func
		SendMessage( hList( LSV_5 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 2
		buff = lpDBGMEM->_Path
		SendMessage( hList( LSV_5 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 3
		buff = lpDBGMEM->_File
		SendMessage( hList( LSV_5 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 4
		If bOnlyone = 0 Then
			bOnlyone = 1
			buff = lpDBGMEM->dLabel
		Else
			buff = ""
		EndIf
		SendMessage( hList( LSV_5 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 5
		buff = Hex( lpDBGMEM->dAddress + idx, 8 )
		SendMessage( hList( LSV_5 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 6
		buff = ddata._instr_dump
		SendMessage( hList( LSV_5 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		lvi.iSubItem = 7
		buff = ddata._instr_out
		If Left( buff, 9 ) = "CALL $+0x" Then
			disp = Val( "&h" + Mid( buff, 10 ) )
			buff = "CALL 0x" & Hex( disp + 5 + lpDBGMEM->dAddress + idx, 8 )
		EndIf
		SendMessage( hList( LSV_5 ), LVM_SETITEM, 0, Cast( LPARAM, @lvi ) )
		idx += nxt
		iPos -= nxt
	Wend

End Sub
