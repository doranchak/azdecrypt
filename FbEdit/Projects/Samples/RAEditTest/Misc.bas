
Sub SetColors(ByVal hWin As HWND)
	Dim col As RACOLOR

	' Get current colors
	SendMessage(hWin,REM_GETCOLOR,0,Cast(LPARAM,@col))
	' Change some colors
	col.cmntback=col.bckcol
	col.strback=col.bckcol
	col.numback=col.bckcol
	col.oprback=col.bckcol
	' Update colors
	SendMessage(hWin,REM_SETCOLOR,0,Cast(LPARAM,@col))

End Sub

Sub SetFonts(ByVal hWin As HWND)
	Dim lfnt As LOGFONT
	Dim fnt As RAFONT

	lfnt.lfHeight=-12
	lfnt.lfCharSet=0
	lfnt.lfWeight=0
	lfnt.lfItalic=0
	lfnt.lfFaceName="Courier New"
	fnt.hFont=CreateFontIndirect(@lfnt)
	lfnt.lfItalic=1
	fnt.hIFont=CreateFontIndirect(@lfnt)
	lfnt.lfHeight=-10
	lfnt.lfItalic=0
	fnt.hLnrFont=CreateFontIndirect(@lfnt)
	SendMessage(hWin,REM_SETFONT,0,Cast(LPARAM,@fnt))
	
End Sub

Sub SetCharTab(ByVal hWin As HWND)

	' Change the comment character from ; to '
	SendMessage(hWin,REM_SETCHARTAB,Asc(";"),CT_OPER)
	SendMessage(hWin,REM_SETCHARTAB,Asc("'"),CT_CMNTCHAR)
	SendMessage(hWin,REM_SETCHARTAB,Asc("/"),CT_CMNTINITCHAR)

End Sub

Sub SetBlocks(ByVal hWin As HWND)
	Dim i As Integer

	SendMessage(hWin,REM_SETCOMMENTBLOCKS,Cast(WPARAM,StrPtr("/'")),Cast(LPARAM,StrPtr("'/")))
	For i=0 To 9
		If bd(i).lpszStart Then
			SendMessage(hWin,REM_ADDBLOCKDEF,0,Cast(LPARAM,@bd(i)))
		EndIf
	Next

End Sub

Sub SetHighlightWords(ByVal hWin As HWND)

	' Set words to highlight
	SendMessage(hWin,REM_SETHILITEWORDS,&HFF,Cast(LPARAM,@szHighlight1))
	SendMessage(hWin,REM_SETHILITEWORDS,&HFF0000,Cast(LPARAM,@szHighlight2))
	
End Sub
